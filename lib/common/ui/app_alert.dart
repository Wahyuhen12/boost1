import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppAlert {
  static showAlert(BuildContext context, String title, String keterangan,
      VoidCallback onpress, String buttontitle,
      {String? subtitle}) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (_) {
          return WillPopScope(
            onWillPop: () async {
              return false;
            },
            child: CupertinoAlertDialog(
              title: Row(
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  const Icon(
                    Icons.warning_amber_rounded,
                    color: Colors.orange,
                    size: 24,
                  )
                ],
              ),
              content: Column(
                children: [
                  Text(
                    keterangan,
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  // Text(
                  //   subtitle!,
                  //   style: const TextStyle(
                  //     fontSize: 10.0,
                  //     color: Color(0xffB8B8B8),
                  //   ),
                  // ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: onpress,
                  child: Text(buttontitle),
                ),
              ],
            ),
          );
        });
  }
}

void appAlert(
    {BuildContext? context,
    String? title,
    String? keterangan,
    VoidCallback? onpress,
    String? buttontitle,
    String? subtitle}) {
  showDialog(
    barrierDismissible: false,
    context: context!,
    builder: (_) {
      return WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: CupertinoAlertDialog(
          title: Row(
            children: [
              Text(
                title!,
                style: const TextStyle(
                  fontSize: 18,
                ),
              ),
              const SizedBox(
                width: 5,
              ),
              const Icon(
                Icons.warning_amber_rounded,
                color: Colors.orange,
                size: 24,
              )
            ],
          ),
          content: Column(
            children: [
              Text(
                keterangan!,
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
              const SizedBox(
                height: 10.0,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: onpress,
              child: Text(buttontitle!),
            ),
          ],
        ),
      );
    },
  );
}

Widget alertDialogWithAction(
    {BuildContext? context,
    String? title,
    String? keterangan,
    String? status,
    VoidCallback? onpress,
    String? buttontitle,
    String? subtitle}) {
  return CupertinoAlertDialog(
    title: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          title!,
          style: const TextStyle(
            fontSize: 18,
          ),
        ),
        const SizedBox(
          width: 10.0,
        ),
        Icon(
          status == "warning" ? Icons.warning_amber_rounded : Icons.adb_rounded,
          color: Colors.orange,
          size: 20,
        )
      ],
    ),
    content: SizedBox(
      height: 50,
      width: 50,
      child: Center(
        child: Text(
          keterangan!,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
    ),
    actions: [
      TextButton(
        onPressed: onpress,
        child: const Text(
          'Oke',
          style: TextStyle(color: Colors.black),
        ),
      ),
    ],
  );
}

Widget alertDialog(
    {BuildContext? context,
    String? title,
    String? keterangan,
    String? status}) {
  return AlertDialog(
    title: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          title!,
          style: const TextStyle(
            fontSize: 18,
          ),
        ),
        const SizedBox(
          width: 10.0,
        ),
        Icon(
          status == "warning" ? Icons.warning_amber_rounded : Icons.adb_rounded,
          color: Colors.orange,
          size: 20,
        )
      ],
    ),
    content: SizedBox(
      height: 50,
      width: 50,
      child: Center(
        child: Text(
          keterangan!,
          style: const TextStyle(
            fontSize: 18,
          ),
        ),
      ),
    ),
  );
}
