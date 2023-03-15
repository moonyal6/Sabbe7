import 'package:flutter/material.dart';

import '../../../shared/constants/style_constants/images_constants.dart';


class SabbehButton extends StatelessWidget {
  const SabbehButton(this.onTap, {this.child});
  final void Function()? onTap;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: GestureDetector(
        child: child ?? Image.asset(kSabbehButtonImage,
          scale: 3.5,
          color: Colors.white,
        ),
        onTap: onTap,

      ),
    );
  }
}