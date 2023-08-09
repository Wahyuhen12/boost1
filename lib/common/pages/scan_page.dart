import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:tirtekna/common/ui/app_alert.dart';
import 'package:tirtekna/utils/application.dart';
import 'package:tirtekna/common/ui/app_animation_scan.dart';
import 'package:tirtekna/view/login/login_view.dart';

class ScanPage extends StatefulWidget {
  const ScanPage({Key? key}) : super(key: key);

  @override
  _ScanPageState createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage>
    with SingleTickerProviderStateMixin {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  String? datascan;
  Barcode? result;
  bool pop = false;
  QRViewController? controller;
  late AnimationController _animationController;
  Apps apps = Apps();

  @override
  void initState() {
    _animationController =
        AnimationController(duration: const Duration(seconds: 1), vsync: this);

    animateScanAnimation(true);
    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        animateScanAnimation(true);
      } else if (status == AnimationStatus.dismissed) {
        animateScanAnimation(false);
      }
    });

    initialize();
    super.initState();
  }

  void initialize() async {
    await apps.initialize();
    Future.delayed(
      const Duration(milliseconds: 500),
      () async {
        await controller!.resumeCamera();
      },
    );
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
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: <Widget>[
            Expanded(
              flex: 5,
              child: Stack(
                children: <Widget>[
                  QRView(
                      key: qrKey,
                      onQRViewCreated: _onQRViewCreated,
                      onPermissionSet: (ctrl, p) {
                        _onPermissionSet(context, ctrl, p);
                      }),
                  AnimationScanner(MediaQuery.of(context).size.width,
                      animation: _animationController),
                  Positioned(
                    top: 20,
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            InkWell(
                              child: Container(
                                width: 30,
                                height: 30,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(30)),
                                child: const Icon(
                                  Icons.arrow_back_rounded,
                                  color: Colors.black,
                                ),
                              ),
                              onTap: () {
                                Navigator.pop(context);
                              },
                            ),
                            InkWell(
                              child: Container(
                                  width: 30,
                                  height: 30,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(30)),
                                  child:
                                      Image.asset('asset/icon/flash-icon.png')),
                              onTap: () {
                                controller!.toggleFlash();
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const <Widget>[
                    SizedBox(
                      width: 4,
                    ),
                    Text(
                      'Scan QR Code Untuk Melanjutkan',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void animateScanAnimation(bool reverse) {
    if (reverse) {
      _animationController.reverse(from: 1.0);
    } else {
      _animationController.forward(from: 0.0);
    }
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });

    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
        if (result!.code!.isNotEmpty) {
          datascan = result!.code;
          postRequest();
          controller.pauseCamera();
        }
      });
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }

  void postRequest() async {
    final result = await apps.request.post(
      "default",
      body: {"data": datascan},
      password: "-",
      context: context,
      showLoading: true,
      platform: "Scan",
    );

    print(result.code);
    print(result.data);
    print(result.edata);
    print(result.message);

    if (result.code != '0000') {
      AppAlert.showAlert(
        context,
        "Alert",
        result.message,
        () {
          Navigator.pop(context);
          controller!.resumeCamera();
        },
        "Oke",
        subtitle: result.code.toString(),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const LoginView(),
        ),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    _animationController.dispose();
    super.dispose();
  }
}
