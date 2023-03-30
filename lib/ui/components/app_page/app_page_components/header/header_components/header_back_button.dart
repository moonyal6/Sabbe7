import 'package:flutter/material.dart';

class HeaderBackButton extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      height: 50,
      minWidth: 40,
      color: Color(0xff1c1a1a),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16)
      ),
      child: Icon(Icons.arrow_back_ios_new_sharp),
      onPressed: () => Navigator.pop(context),
    );
  }
}
