import 'package:gui/core/utils/color_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TipRow extends StatelessWidget {
  final String title;
  final String icon;

  const TipRow({Key? key, required this.title, required this.icon}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
              color: ColorsManager.darkTeal.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 3,
              offset: const Offset(0, 0)),
        ],
        color: Colors.white,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      margin: const EdgeInsets.all(8),
      child: ListTile(
        leading: SvgPicture.asset(
          // color: Colors.amberAccent.shade700,
          icon,
          width: 48,
          height: 48,
        ),
        horizontalTitleGap: 8,
        minVerticalPadding: 8,
        title: Text(
          title,
          style: const TextStyle(fontSize: 14),
          overflow: TextOverflow.fade,
        ),
      ),
    );
  }
}
