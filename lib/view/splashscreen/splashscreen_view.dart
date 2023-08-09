import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:privacy_screen/privacy_screen.dart';

import 'package:tirtekna/common/pages/bottomnavigator_page.dart';
import 'package:tirtekna/common/pages/failed_pages.dart';
import 'package:tirtekna/utils/application.dart';
import 'package:tirtekna/view/login/login_view.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Apps apps = Apps();

  bool isWaiting = true;

  @override
  void initState() {
    super.initState();
    initialize();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          systemNavigationBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.dark),
    );
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                "asset/image/splashScreen-background.png",
              ),
              scale: 1.8,
              fit: BoxFit.cover,
            ),
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 100.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    "asset/icon/tirtekna-icon.png",
                    height: 150,
                    width: 150,
                  ),
                  const Text("Version 5.1"),
                  const SizedBox(
                    height: 80.0,
                  ),
                  Visibility(
                    visible: isWaiting,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: const [
                        CircularProgressIndicator(
                          color: Colors.blue,
                          strokeWidth: 4.0,
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        Text("Please Wait"),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  //initialize
  void initialize() async {
    await apps.initialize();
    secureBgScreen();

    final result = await apps.user.getCKEY();

    print("ini$result");

    if (result.isEmpty) {
      Future.delayed(const Duration(milliseconds: 600), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const FailedPages(),
          ),
        );
      });
    } else {
      final isLogin = await apps.user.isLogin();
      postGetVersion();
      setState(() {
        isWaiting = false;
      });

      Future.delayed(
        const Duration(seconds: 2),
        () {
          Navigator.pushReplacement(context, _createRoute(isLogin));
        },
      );
    }
  }

  void secureBgScreen() async {
    await PrivacyScreen.instance.enable(
      iosOptions: const PrivacyIosOptions(
        enablePrivacy: true,
        privacyImageName: "LaunchImage",
        lockTrigger: IosLockTrigger.didEnterBackground,
      ),
      androidOptions: const PrivacyAndroidOptions(
        enableSecure: true,
      ),
      backgroundColor: Colors.white.withOpacity(0),
    );
  }

  Future postGetVersion() async {
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

    print("ini ${result.code}");

    if (result.code != "12004") {
      if (datawilayah.isEmpty) {
        List<List<dynamic>> unit =
            List<List<dynamic>>.from(result.data!['wilayah']);

        await apps.db.insertBatchList("unit", unit);
      }
    } else {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const SplashScreen(),
          ),
          (route) => false);
    }

    return result.code;
  }

  Route _createRoute(bool isLogin) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) {
        return isLogin == true
            ? const BottomNavigatorPage()
            : const LoginView();
      },
      transitionDuration: const Duration(milliseconds: 700),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.ease;

        final tween = Tween(begin: begin, end: end);
        final curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: curve,
        );

        return SlideTransition(
          position: tween.animate(curvedAnimation),
          child: child,
        );
      },
    );
  }
}
