import 'package:flutter/material.dart';

import '../../../main.dart';
import '../../../shared/constants/text_constants/turkish_text_constants.dart';

class TextFields extends StatelessWidget {
  TextFields({required this.text, required this.icon, required this.obscureText, this.onChanged});

  final String text;
  final Icon icon;
  final bool obscureText;
  final Function(String)? onChanged;

  static TextFields email(BuildContext context,{onChanged}){
    return TextFields(
      onChanged: onChanged,
      obscureText: false,
      text: appLang['@auth_pages']['email'],
      icon: Icon(Icons.email_outlined),
    );
  }

  static TextFields password(BuildContext context,{onChanged, obscureText}){
    return TextFields(
      obscureText: obscureText,
      onChanged: onChanged,
      text: appLang['@auth_pages']['password'],
      icon: Icon(Icons.lock_outline),
    );
  }


  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> _pageText = appLang;

    return TextField(
        onChanged: onChanged,
        obscureText: obscureText,
        decoration: InputDecoration(
            icon: icon,
            label: Text(text),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8.0)),

            )
        )
    );
  }
}