import 'package:flutter/material.dart';

class HeaderTitle extends StatelessWidget {
  const HeaderTitle(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 18),
      child: Text(
        title,
        style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w500
        ),
      ),
    );
  }
}
