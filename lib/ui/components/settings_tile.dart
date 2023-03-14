import 'package:flutter/material.dart';

class SettingsTile extends StatelessWidget {
  SettingsTile({required this.title, required this.icon, this.trailing});

  final String title;
  final IconData icon;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title,
        style: TextStyle(fontSize: 18),
      ),
      leading: Icon(icon,
        size: 30,
      ),
      trailing: trailing,
    );
  }
}
