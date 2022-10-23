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
import 'package:scanning_world/services/permission_service.dart';
import 'package:scanning_world/theme/theme.dart';
import 'package:scanning_world/widgets/common/custom_progress_indicator.dart';
import 'package:scanning_world/widgets/common/error_dialog.dart';

import '../data/remote/models/user/place.dart';
import '../data/remote/providers/auth_provider.dart';
import '../widgets/common/loading_dialog.dart';

class ScanQrCodeScreen extends StatefulWidget {
  const ScanQrCodeScreen({Key? key}) : super(key: key);

  static const routeName = '/scan-qr-code';

  @override
  State<ScanQrCodeScreen> createState() => _ScanQrCodeScreenState();
}

class _ScanQrCodeScreenState extends State<ScanQrCodeScreen> {
  //control for QR scanner
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  // control start/stop scanning
  var _isQrCodeScanned = false;

  // resume camera
  void _resumeCamera() {
    if (controller != null) {
      controller!.resumeCamera();
      setState(() {
        _isQrCodeScanned = false;
      });
    }
  }

  // check if user has permissions to use camera and location and if qr code is good
  Future<void> _checkQRCode(String code) async {
    final authProvider = context.read<AuthProvider>();
    setState(() {
      _isQrCodeScanned = true;
    });

    try {
      showPlatformDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) => const LoadingDialog());

      final position = await _getPosition();
      final Place place = await authProvider.scanPlace(code, position);
      //close loading dialog
      if (!mounted) return;
      Navigator.of(context).pop();
      //show success dialog
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
                    onPressed: () => Navigator.of(context)
                      ..pop()
                      ..pop(),
                  ),
                ],
              ));
      //http server error
    } on HttpError catch (e) {
      if (!mounted) return;
      Navigator.of(context).pop();
      await showPlatformDialog(
        context: context,
        builder: (c) => ErrorDialog(message: e.message),
      );
      _resumeCamera();
      //location permission denied permanently
    } on PermissionDeniedException catch (e) {
      if (!mounted) return;
      Navigator.of(context).pop();
      await showPlatformDialog(
        context: context,
        builder: (c) => ErrorDialog(
            message: e.message ?? 'Włącz uprawnienia do lokalizacji',
            buttonText: 'Ustawienia',
            onPressed: () => openAppSettings()),
      );
      _resumeCamera();
    } catch (e) {
      //other errors
      if (!mounted) return;
      Navigator.of(context).pop();
      await showPlatformDialog(
          context: context, builder: (c) => ErrorDialog(message: e.toString()));
      _resumeCamera();
    }
  }

  //get user current position
  Future<Position> _getPosition() async {
    await PermissionService.checkLocationPermission();
    final Position position = await Geolocator.getCurrentPosition();
    return position;
  }

  //qr code scanner bug fix
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  //dispose controller
  @override
  void dispose() {
    if (controller != null) {
      if (Platform.isIOS) controller!.pauseCamera();
      controller!.dispose();
    }
    super.dispose();
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

  // check if user has permissions to use camera
  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    if (!p) {
      showPlatformDialog(
          context: context,
          builder: (_) => ErrorDialog(
                message: 'Musisz udzielić uprawnień do aparatu',
                buttonText: 'Ustawienia',
                onPressed: () {
                  openAppSettings();
                },
              ));
    }
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
}
