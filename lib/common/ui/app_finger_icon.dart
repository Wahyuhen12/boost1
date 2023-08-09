import 'package:flutter/material.dart';

import 'app_colors.dart';

class FingerPrintButton extends StatelessWidget {
  const FingerPrintButton({Key? key, this.onTap}) : super(key: key);

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(left: 10),
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            width: 1,
            color: AppColors.buttonPrimaryColor,
          ),
        ),
        child: Icon(
          Icons.fingerprint,
          color: AppColors.buttonPrimaryColor,
          size: 32,
        ),
      ),
    );
  }
}
