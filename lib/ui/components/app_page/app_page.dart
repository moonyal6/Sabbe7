import 'package:flutter/material.dart';

import 'app_page_components/header/page_header.dart';

class AppPage extends StatelessWidget {
  AppPage({required this.child, required this.title, this.headerPadding = true});

  final Widget child;
  final String title;
  final bool headerPadding;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              PageHeader(
                title: title,
                bottomPadding: headerPadding? null: 0,
              ),
              Expanded(
                child: child,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
