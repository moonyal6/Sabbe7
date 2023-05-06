import 'package:flutter/material.dart';

import 'header_components/header_back_button.dart';
import 'header_components/header_title.dart';

class PageHeader extends StatelessWidget {
  PageHeader({required this.title, this.bottomPadding});

  final String title;
  final double? bottomPadding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: bottomPadding ?? 48.0),
      child: Row(
        children: [
          HeaderBackButton(),
          HeaderTitle(title),
        ],
      ),
    );
  }
}
