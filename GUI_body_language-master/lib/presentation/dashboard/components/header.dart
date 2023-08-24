import 'package:gui/core/utils/color_manager.dart';
import 'package:gui/core/utils/constants.dart';
import 'package:gui/core/utils/responsive.dart';
import 'package:gui/presentation/dashboard/MenuAppController.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Header extends StatelessWidget {

   Header({required this.s,
       Key? key,});
   final String s;


  @override
  Widget build(BuildContext context) {

    return
      Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
        SizedBox(height: 35,),
    Row(
    children: [
    SizedBox(height: 40),
    if (!Responsive.isDesktop(context)) ...{
      SizedBox(width: 5,),
    IconButton(
    icon: const Icon(
    Icons.menu,
    color: ColorsManager.darkTeal,
    ),
    onPressed: context.read<MenuAppController>().controlMenu,
    )
    },
    if (Responsive.isMobile(context)) ...{
    Text(
    s,
    style: Theme.of(context)
        .textTheme
        .titleLarge!
        .copyWith(color: Colors.white),
    )
    },
    if (Responsive.isMobile(context)) ...{
    Divider(
    thickness: 1,
    height: 1,
    )
    },
    Constants.verticalSpaceMedium()
    ],
    )
      ],);

  }
}
