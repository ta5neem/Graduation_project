import 'package:flutter/material.dart';

import 'dimensions.dart';

class Responsive extends StatelessWidget {
  final Widget mobileBody;
  final Widget desktopBody;

  const Responsive({super.key, required this.mobileBody, required this.desktopBody});

  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < mobileWidth;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= mobileWidth;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < mobileWidth) {
          return mobileBody;
        } else {
          return desktopBody;
        }
      },
    );
  }
}
