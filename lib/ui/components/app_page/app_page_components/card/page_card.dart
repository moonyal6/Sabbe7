import 'package:flutter/material.dart';

class PageCard extends StatelessWidget {
  const PageCard({required this.children, this.padding});

  final List<Widget> children;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        children: children,
      ),
      padding: padding ?? EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 16,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: Color(0xff1c1a1a),
      ),
    );
  }
}
