import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
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
          context: context,
          builder: (context) => PlatformAlertDialog(
                content: Row(
                  children: const [
                    Center(child: CustomProgressIndicator()),
                    SizedBox(width: 10),
                    Text('Loading...'),
                  ],
                ),
              ));
      final Place place = await authProvider.scanPlace(code);
      if (!mounted) return;
      Navigator.of(context).pop();
      await showPlatformDialog(
          barrierDismissible: false,
          context: context,
          builder: (_) => PlatformAlertDialog(
                title: Text('Udało się!'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Udało się zeskanować kod QR.'),
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
                    onPressed: () => Navigator.of(context).popUntil((route) =>
                        route.settings.name == HomeWrapper.routeName),
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
                title: Text('Error'),
                content: Text('Musisz udzielić uprawnień do aparatu'),
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
    controller?.dispose();
    super.dispose();
  }
}
