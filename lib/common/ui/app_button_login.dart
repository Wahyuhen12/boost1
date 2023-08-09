import 'package:flutter/material.dart';

class AppButton extends StatefulWidget {
  const AppButton(
      {Key? key,
      this.text,
      this.color,
      this.ontap,
      this.height,
      this.width,
      this.radius = 10.0})
      : super(key: key);
  final VoidCallback? ontap;
  final String? text;
  final double? radius;
  final double? height;
  final double? width;
  final Color? color;
  @override
  _AppButtonState createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.ontap,
      child: Container(
        height: widget.height,
        width: widget.width,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(widget.radius!)),
            color: widget.color),
        child: Center(
          child: Text(
            widget.text!,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              fontFamily: "Sofia",
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
