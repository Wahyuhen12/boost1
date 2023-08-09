import 'package:flutter/material.dart';
import 'package:tirtekna/common/ui/app_button_login.dart';

class AppBottomSheetFailed {
  static show(BuildContext context, String message, String? code) {
    showModalBottomSheet(
        enableDrag: false,
        context: context,
        builder: (_) {
          return WillPopScope(
            onWillPop: () async {
              return false;
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              height: MediaQuery.of(context).size.height * 0.5,
              color: Colors.white,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      "asset/image/error-image.png",
                      width: MediaQuery.of(context).size.height * 0.5,
                      height: MediaQuery.of(context).size.width * 0.5,
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.width / 14,
                    ),
                    const Text(
                      "Maaf yaa, sepertinya terjadi kesalahan",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0,
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 40,
                    ),
                    Text(
                      message,
                      overflow: TextOverflow.clip,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 16.0,
                      ),
                    ),
                    Text(
                      code!,
                      style: const TextStyle(
                        fontSize: 14.0,
                        color: Color(0xffB8B8B8),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 40,
                    ),
                    AppButton(
                      text: "Got It",
                      color: Colors.orange,
                      ontap: () {
                        Navigator.pop(context);
                      },
                      height: 42.0,
                      width: MediaQuery.of(context).size.width * 0.8,
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  static showErorWithVariable({
    BuildContext? context,
    String? message,
    String? code,
    String? assetimage,
    String? errorTitle,
  }) {
    showModalBottomSheet(
        enableDrag: false,
        context: context!,
        builder: (_) {
          return WillPopScope(
            onWillPop: () async {
              return false;
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              height: MediaQuery.of(context).size.height * 0.5,
              color: Colors.white,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      assetimage!,
                      width: MediaQuery.of(context).size.height * 0.5,
                      height: MediaQuery.of(context).size.width * 0.5,
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.width / 14,
                    ),
                    Text(
                      errorTitle!,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 40,
                    ),
                    Text(
                      message!,
                      overflow: TextOverflow.clip,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 16.0,
                      ),
                    ),
                    Text(
                      code!,
                      style: const TextStyle(
                        fontSize: 14.0,
                        color: Color(0xffB8B8B8),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 40,
                    ),
                    AppButton(
                      text: "Got It",
                      color: Colors.orange,
                      ontap: () {
                        Navigator.pop(context);
                      },
                      height: 42.0,
                      width: MediaQuery.of(context).size.width * 0.8,
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
