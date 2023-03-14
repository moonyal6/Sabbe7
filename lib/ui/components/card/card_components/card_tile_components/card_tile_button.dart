import 'package:flutter/material.dart';

class CardTileButton extends StatelessWidget {
  const CardTileButton({required this.text, required this.onPressed});

  final String text;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      child: Text(text),
      onPressed: onPressed,
      color: Color(0xff303030),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8)
      ),
    );
  }
}
