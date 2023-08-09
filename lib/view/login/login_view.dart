// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:tirtekna/common/pages/bottomnavigator_page.dart';
import 'package:tirtekna/common/ui/app_button_login.dart';
import 'package:tirtekna/common/ui/app_colors.dart';
import 'package:tirtekna/utils/application.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tirtekna/common/ui/app_finger_icon.dart';
import 'package:tirtekna/common/ui/app_alert.dart';
import 'package:tirtekna/common/ui/app_bottomsheet_failed.dart';

class LoginView extends StatefulWidget {
  const LoginView({
    Key? key,
  }) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  String deviceinfo = "Hardware ID";
  String namapetugas = "Username";
  String namapdam = "-";
  bool? _canCheckFingerPrint;

  Apps apps = Apps();
  LocalAuthentication auth = LocalAuthentication();
  TextEditingController pasww = TextEditingController();

  @override
  void initState() {
    super.initState();
    initialize();
    cekPassword();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void initialize() async {
    await apps.initialize();
    final nama = await apps.user.getNama();
    final namapdam = await apps.user.getPDAMNAME();

    setToState(nama, namapdam);
  }

  void setToState(nama, namaPdam) {
    setState(() {
      namapetugas = nama;
      namapdam = namaPdam;
      deviceinfo = apps.device.getHardwareID();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
          image: AssetImage("asset/image/login-background.png"),
          scale: 1.8,
          fit: BoxFit.cover,
        )),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
          child: SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 50.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Image.asset(
                          "asset/image/pdam-logo.png",
                          height: 40,
                          width: 40,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            namapdam,
                            style: GoogleFonts.bebasNeue(
                              fontSize: 25,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 150,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          alignment: Alignment.center,
                          margin: const EdgeInsets.all(20),
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: AppColors.greyColor.withOpacity(0.5),
                                width: 1),
                            shape: BoxShape.circle,
                            image: const DecorationImage(
                                image: AssetImage(
                                  "asset/icon/profile-icon.png",
                                ),
                                fit: BoxFit.fitHeight),
                          ),
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        Text(
                          namapetugas,
                          style: const TextStyle(
                            fontSize: 25.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Container(
                            height: 100,
                            width: 350,
                            decoration: BoxDecoration(
                              color: const Color(0xFFFEFEFE),
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 0.5,
                                ),
                              ],
                            ),
                            child: Column(
                              children: <Widget>[
                                Container(
                                  height: 50,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20.0),
                                  child: Row(
                                    children: [
                                      Image.asset(
                                        'asset/icon/mobile-phone-icon.png',
                                        width: 25,
                                        height: 25,
                                      ),
                                      const SizedBox(
                                        width: 18,
                                      ),
                                      Expanded(
                                        child: Text(
                                          deviceinfo,
                                          style: const TextStyle(
                                            fontSize: 16.0,
                                            color: Color(0xffB8B8B8),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const Divider(
                                  height: 0,
                                  thickness: 1,
                                  indent: 60,
                                  endIndent: 40,
                                ),
                                Container(
                                  height: 50,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20.0),
                                  child: Row(
                                    children: [
                                      Image.asset(
                                        'asset/icon/lock-icon.png',
                                        width: 25,
                                        height: 25,
                                      ),
                                      const SizedBox(
                                        width: 18,
                                      ),
                                      Expanded(
                                        child: TextFormField(
                                          controller: pasww,
                                          obscureText: true,
                                          style: const TextStyle(
                                            fontSize: 18,
                                            color: Color(0xFF090909),
                                            fontWeight: FontWeight.w400,
                                          ),
                                          textCapitalization:
                                              TextCapitalization.sentences,
                                          decoration:
                                              const InputDecoration.collapsed(
                                            hintText: 'Password',
                                            hintStyle: TextStyle(
                                              fontSize: 16.0,
                                              color: Color(0xFF808080),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        //BUTTON
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 20, left: 10, right: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Expanded(
                                child: AppButton(
                                  height: 42.0,
                                  width: MediaQuery.of(context).size.width,
                                  ontap: () {
                                    postRequestPasword(pasww.text);
                                  },
                                  text: 'Login',
                                  color: AppColors.buttonPrimaryColor,
                                ),
                              ),
                              _canCheckFingerPrint == true
                                  ? FingerPrintButton(
                                      onTap: () async {
                                        _authenticate();
                                        // final service = FlutterBackgroundService();
                                        // service.sendData(
                                        //   {"action": "stopService"},
                                        // );
                                      },
                                    )
                                  : const SizedBox(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future postRequestPasword(String password) async {
    if (password.toString().isEmpty) {
      AppAlert.showAlert(
        context,
        "Alert",
        "Password tidak boleh kosong",
        () {
          Navigator.pop(context);
        },
        "Oke",
      );
      return null;
    }

    final isNeedLogin = await apps.user.isNeedLogin();

    if (isNeedLogin == false) {
      final checkPassword = await apps.user.getPassword(password);
      if (checkPassword == "ok") {
        //GET VERSION
        await postGetVersion(context);

        return null;
      } else if (checkPassword == "wrong") {
        AppAlert.showAlert(
          context,
          "Alert",
          "Password yang anda masukan salah",
          () {
            Navigator.pop(context);
          },
          "Oke",
        );
        return null;
      }
    }

    var result = await apps.request.post(
      "auth",
      body: {"data": "get"},
      context: context,
      showLoading: true,
      password: password,
    );

    if (result.code != "0000") {
      AppBottomSheetFailed.show(context, result.message, result.code);
    } else {
      //SET PASSWORD TO DB
      apps.user.setPassword(password);

      //GET VERSION
      await postGetVersion(context);
    }
  }

  void cekPassword() async {
    final isNeedLogin = await apps.user.isNeedLogin();

    if (isNeedLogin == true) {
      return null;
    } else {
      final checkPassword = await apps.user.getPassword("1");
      if (checkPassword == "empty") {
        return null;
      } else if (checkPassword == "wrong") {
        setState(() {
          _canCheckFingerPrint = true;
        });
        return _authenticate();
      }
    }
  }

  Future postGetVersion(BuildContext context) async {
    //GET VERSION
    final dataversion = await apps.user.getDATAVERSION();
    final datawilayah = await apps.db.getData("unit");

    final body =
        await apps.user.bodyEncrypt('version', {'version': dataversion});
    final result = await apps.request.post(
      "request",
      body: body,
      bearer: true,
    );

    if (datawilayah.isEmpty) {
      List<List<dynamic>> unit =
          List<List<dynamic>>.from(result.data!['wilayah']);

      await apps.db.insertBatchList("unit", unit);
    }

    if (result.code != "0000") {
      AppBottomSheetFailed.show(context, result.message, result.code);
    } else {
      apps.user.setLogin();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const BottomNavigatorPage(),
        ),
      );
    }
  }

  Future<void> _authenticate() async {
    bool authenticated = false;

    try {
      authenticated = await auth.authenticate(
        localizedReason: 'Scan your finger print to authemticate',
        useErrorDialogs: false,
        stickyAuth: true,
        biometricOnly: true,
      );
    } on PlatformException catch (e) {
      print(e);
    }

    if (!mounted) return;

    setState(() {
      if (authenticated == true) {
        Future.delayed(const Duration(milliseconds: 20), () async {
          await postGetVersion(context);
        });
      }
    });
  }
}
