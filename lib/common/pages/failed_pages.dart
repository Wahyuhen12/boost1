import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tirtekna/common/ui/app_button_login.dart';
import 'package:tirtekna/utils/application.dart';

class FailedPages extends StatefulWidget {
  const FailedPages({Key? key}) : super(key: key);

  @override
  State<FailedPages> createState() => _FailedPagesState();
}

class _FailedPagesState extends State<FailedPages> {
  String deviceinfo = "Hardware ID";
  Apps apps = Apps();

  @override
  void initState() {
    getDeviceinfo();
    super.initState();
  }

  void getDeviceinfo() async {
    setState(() {
      deviceinfo = apps.device.getHardwareID();
    });
  }

  void initialize() async {
    await apps.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(height: MediaQuery.of(context).size.height / 14),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset("asset/image/no-acces.png"),
                  const Text(
                    "Device belum terverifikasi",
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        deviceinfo,
                        style: const TextStyle(
                          fontSize: 14.0,
                        ),
                      ),
                      IconButton(
                        splashRadius: 20,
                        onPressed: () {
                          Clipboard.setData(
                            ClipboardData(text: "Tirtekna\n$deviceinfo"),
                          );
                        },
                        icon: const Icon(
                          Icons.content_copy_outlined,
                          size: 20,
                        ),
                      )
                    ],
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  AppButton(
                    height: 42.0,
                    width: 125.0,
                    text: "Keluar",
                    color: Colors.orange,
                    ontap: () {},
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  AppButton(
                    height: 42.0,
                    width: 125.0,
                    text: "Scan QR",
                    color: Colors.green,
                    ontap: () {
                      requestpermisi();
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void requestpermisi() async {
    var statuspermisi = await Permission.camera.request();
    if (statuspermisi.isGranted) {
      // Navigator.push(
      //     context, MaterialPageRoute(builder: (_) => const ScanPage()));
    } else if (statuspermisi.isDenied) {
      requestpermisi();
    } else if (statuspermisi.isPermanentlyDenied) {
      openAppSettings();
    }
  }
}
