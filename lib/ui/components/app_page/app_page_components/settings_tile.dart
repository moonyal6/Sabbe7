import 'package:flutter/material.dart';

class SettingsTile extends StatelessWidget {
  SettingsTile({required this.title, required this.icon, this.trailing, this.onTap});

  final String title;
  final IconData icon;
  final Widget? trailing;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
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
