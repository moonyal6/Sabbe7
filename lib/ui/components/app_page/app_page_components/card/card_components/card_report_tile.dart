import 'package:flutter/material.dart';

import '../../../../../../shared/constants/style_constants/text_style_constants.dart';

class CardReportTile extends StatelessWidget {
  CardReportTile({required this.counterText, this.countText});

  final String counterText;
  final countText;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Text(counterText,
        style: kReport,
      ),
      trailing: Text(countText,
        style: kReport,
      ),
    );
  }
}