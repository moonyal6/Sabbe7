import 'package:flutter/material.dart';

class PageCard extends StatelessWidget {
  const PageCard({required this.children, this.padding, this.title});

  final List<Widget> children;
  final EdgeInsets? padding;
  final String? title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          title != null?
          Container(
            width: double.infinity,
            padding: EdgeInsets.only(bottom: 6, left: 5),
            child: Text(title!,
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w400
              ),
            ),
          ): SizedBox(),
          Container(
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
          ),
        ],
      ),
    );
  }
}
