import 'package:flutter/material.dart';

import '../../../core/utils/color_manager.dart';

class VideoRow extends StatelessWidget {
  String title;
  VoidCallback onPressed;

  VideoRow({super.key,required this.title,required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return
      Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
              color: ColorsManager.darkGrey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 3,
              offset: const Offset(0, 0)),
        ],
        color: Colors.white,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: ListTile(
        title: Text(title),
        // trailing:
        // IconButton(icon: Icon(Icons.,color: Colors.redAccent,), onPressed: onPressed),
      ),
    );
  }
}
