import 'package:flutter/material.dart';

class CardTile extends StatelessWidget {
  const CardTile({this.title, this.subtitle, this.trailing});

  final String? title;
  final Widget? subtitle;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title!),
      subtitle: subtitle,
      trailing: trailing,
    );
  }
}
