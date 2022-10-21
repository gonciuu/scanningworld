import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:scanning_world/data/remote/http/http_exception.dart';
import 'package:scanning_world/data/remote/providers/coupons_provider.dart';
import 'package:scanning_world/data/remote/providers/places_provider.dart';
import 'package:scanning_world/screens/wrappers/home_wrapper.dart';
import 'package:scanning_world/theme/theme.dart';
import 'package:scanning_world/widgets/common/custom_progress_indicator.dart';
import 'package:scanning_world/widgets/common/error_dialog.dart';

import '../data/remote/models/user/place.dart';
import '../data/remote/providers/auth_provider.dart';

class ScanQrCodeScreen extends StatefulWidget {
  const ScanQrCodeScreen({Key? key}) : super(key: key);

  static const routeName = '/scan-qr-code';

  @override
  State<ScanQrCodeScreen> createState() => _ScanQrCodeScreenState();
}

class _ScanQrCodeScreenState extends State<ScanQrCodeScreen> {
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  var _isQrCodeScanned = false;

  void _resumeCamera() {
    if (controller != null) {
      controller!.resumeCamera();
      setState(() {
        _isQrCodeScanned = false;
      });
    }
  }

  Future<void> _checkQRCode(String code) async {
    setState(() {
      _isQrCodeScanned = true;
    });
    final authProvider = context.read<AuthProvider>();
    try {
      showPlatformDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) => PlatformAlertDialog(
                content: Row(
                  children: const [
                    CustomProgressIndicator(),
                    SizedBox(width: 10),
                    Text('Loading...'),
                  ],
                ),
              ));
      //final canScan = await _checkLocation();
      final position = await _getPosition();
      final Place place = await authProvider.scanPlace(code, position);
      if (!mounted) return;
      Navigator.of(context).pop();
      await showPlatformDialog(
          barrierDismissible: false,
          context: context,
          builder: (_) => PlatformAlertDialog(
                title: const Text('Udało się!'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Udało się zeskanować kod QR.'),
                    const SizedBox(height: 10),
                    Text(
                      'Otrzymałeś ${place.points} punktów.',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                actions: [
                  PlatformDialogAction(
                    child: Text(
                      'OK',
                      style: TextStyle(color: primary[700]),
                    ),
                    onPressed: () => Navigator.of(context)..pop()..pop(),
                  ),
                ],
              ));
    } on HttpError catch (e) {
      if (!mounted) return;
      Navigator.of(context).pop();
      await showPlatformDialog(
        context: context,
        builder: (c) => ErrorDialog(message: e.message),
        barrierDismissible: false,
      );
      _resumeCamera();
    } catch (e) {
      if (!mounted) return;
      Navigator.of(context).pop();
      await showPlatformDialog(
          context: context, builder: (c) => ErrorDialog(message: e.toString()));
      _resumeCamera();
    }
  }

  Future<Position> _getPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        throw const PermissionDeniedException('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    final Position position = await Geolocator.getCurrentPosition();


    return position;
  }

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
        appBar: PlatformAppBar(
          title: const Text('Skanuj kod QR'),
          cupertino: (_, __) => CupertinoNavigationBarData(
              transitionBetweenRoutes: false,
              heroTag: 'Skanuj kod QR',
              previousPageTitle: 'Home'),
        ),
        body: _buildQrView(context));
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      if (!_isQrCodeScanned && scanData.code != null) {
        _checkQRCode(scanData.code!);
      } else {
        controller.pauseCamera();
      }
    });
    if (Platform.isAndroid) {
      controller.pauseCamera();
      controller.resumeCamera();
    }
  }

  Widget _buildQrView(BuildContext context) {
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 250.0
        : 400.0;
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: primary[700]!,
          borderRadius: 10,
          borderLength: 40,
          borderWidth: 8,
          overlayColor: Colors.black.withOpacity(0.85),
          cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    if (!p) {
      showPlatformDialog(
          context: context,
          builder: (_) => PlatformAlertDialog(
                title: const Text('Error'),
                content: const Text('Musisz udzielić uprawnień do aparatu'),
                actions: [
                  PlatformDialogAction(
                    child: Text(
                      'Ustawienia',
                      style: TextStyle(color: primary[600]),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                      openAppSettings();
                    },
                  ),
                ],
              ));
    }
  }

  @override
  void dispose() {
    if (controller != null) {
      if (Platform.isIOS) controller!.pauseCamera();
      controller!.dispose();
    }
    super.dispose();
  }
}
