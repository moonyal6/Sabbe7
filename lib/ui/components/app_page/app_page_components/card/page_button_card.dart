import 'package:flutter/material.dart';

class PageButtonCard extends StatelessWidget {
  const PageButtonCard({required this.text, required this.onPressed, this.textColor});

  final String text;
  final Function() onPressed;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onPressed,//todo
      color: Color(0xff1c1a1a),
      minWidth: double.infinity,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 18),
        child: Text(text,
          style: TextStyle(
            fontSize: 18,
            color: textColor
          ),
        ),
      ),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18)
      ),
    );
  }
}
