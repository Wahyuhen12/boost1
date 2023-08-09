import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';

class AppDialog {
  static showLoadingLogin(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async {
            return false;
          },
          child: const Dialog(
            elevation: 0,
            backgroundColor: Colors.transparent,
            child: Padding(
              padding: EdgeInsets.all(75.0),
              child: LoadingIndicator(
                strokeWidth: 5,
                indicatorType: Indicator.ballClipRotatePulse,
                colors: [
                  Colors.red,
                  Colors.orange,
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  static showLoadingScan(
    BuildContext context,
    bool pop,
    Widget child,
  ) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        if (pop == true) {
          Future.delayed(const Duration(seconds: 3), () {
            Navigator.pop(context);
          });
        }

        return WillPopScope(
          onWillPop: () async {
            return false;
          },
          child: Dialog(
            child: child,
          ),
        );
      },
    );
  }

  static showDialogBox(
    BuildContext context,
    bool pop,
    Widget child,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        if (pop == true) {
          Future.delayed(const Duration(seconds: 3), () {
            Navigator.pop(context);
          });
        }

        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: child,
        );
      },
    );
  }
}
