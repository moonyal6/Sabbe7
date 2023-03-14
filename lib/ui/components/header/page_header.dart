import 'package:flutter/material.dart';

import 'header_components/header_back_button.dart';
import 'header_components/header_title.dart';

class PageHeader extends StatelessWidget {
  PageHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        HeaderBackButton(),
        HeaderTitle(title),
      ],
    );
  }
}
