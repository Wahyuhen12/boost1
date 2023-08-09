import 'package:flutter/material.dart';

class LoadingDialog extends StatefulWidget {
  const LoadingDialog({Key? key}) : super(key: key);

  @override
  State<LoadingDialog> createState() => _LoadingDialogState();
}

class _LoadingDialogState extends State<LoadingDialog> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      child: Row(
        children: <Widget>[
          CircularProgressIndicator(
            color: Colors.blue[300],
            strokeWidth: 3.5,
          ),
          const SizedBox(
            width: 20,
          ),
          const Text(
            "Please wait ...",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w400,
              fontSize: 18.0,
            ),
          ),
        ],
      ),
    );
  }
}
