import 'package:gui/core/utils/app_assets.dart';
import 'package:gui/core/utils/app_strings.dart';
import 'package:gui/core/utils/color_manager.dart';
import 'package:gui/core/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gui/presentation/dashboard/MenuAppController.dart';
import 'package:gui/presentation/dashboard/dashboard_screen.dart';
import 'package:gui/presentation/profile/profile_screen.dart';
import 'package:gui/presentation/rating/rating_screen.dart';
import 'package:gui/presentation/welcom/welcome_screen.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:gui/data/datasource/databasehelper.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: ColorsManager.darkTeal,
      width: Responsive.isMobile(context)
          ? MediaQuery.of(context).size.width / 1.5
          : MediaQuery.of(context).size.width,
      child: ListView(
        shrinkWrap: true,
        children: [
          DrawerListTile(
            title: "Dashboard",
            svgSrc: AppAssets.dashboardIcon,
            press: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => MultiProvider(
                    providers: [
                      ChangeNotifierProvider(
                        create: (context) => MenuAppController(),
                      ),
                    ],
                    child: // LoginScreen(loginType: LoginType.signIn),
                    DashboardScreen(),
                  ),
                )
                );
            },
          ),
          DrawerListTile(
            title: "Profile",
            svgSrc: AppAssets.profileIcon,
            press: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const ProfileScreen())),
          ),
          // DrawerListTile(
          //   title: AppStrings.rating,
          //   svgSrc: AppAssets.rateIcon,
          //   press: () {
          //     Alert(
          //         context: context,
          //         title: AppStrings.rating,
          //         style: const AlertStyle(overlayColor: Colors.black38),
          //         content: const Text(AppStrings.ratingQuestion),
          //         buttons: [
          //           // DialogButton(
          //           //   onPressed: () => Navigator.push(
          //           //       context,
          //           //       MaterialPageRoute(
          //           //           builder: (context) =>  RatingScreen())),
          //           //   child: const Text(
          //           //     AppStrings.confirm,
          //           //     style: TextStyle(color: Colors.white, fontSize: 20),
          //           //   ),
          //           // ),
          //           DialogButton(
          //             onPressed: () => Navigator.pop(context),
          //             child: const Text(
          //               AppStrings.cancel,
          //               style: TextStyle(color: Colors.white, fontSize: 20),
          //             ),
          //           )
          //         ]).show();
          //   },
          // ),
          DrawerListTile(
              title: "Logout",
              svgSrc: AppAssets.logoutIcon,
              press: () async {
                print(DatabaseHelper.token);
                // DatabaseHelper databaseHelper = new DatabaseHelper();
                await DatabaseHelper.logout(DatabaseHelper.token);
                print('asssssss');
                if (DatabaseHelper.status) {
                  print('tasssssss');
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => MultiProvider(
                      providers: [
                        ChangeNotifierProvider(
                          create: (context) => MenuAppController(),
                        ),
                      ],
                      child: WelcomeScreen(),
                    ),
                  ));
                }
              }),
        ],
      ),
    );
  }
}

class DrawerListTile extends StatelessWidget {
  const DrawerListTile({
    Key? key,
    // For selecting those three line once press "Command+D"
    required this.title,
    required this.svgSrc,
    required this.press,
  }) : super(key: key);

  final String title, svgSrc;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: press,
      horizontalTitleGap: 0.0,
      leading: SvgPicture.asset(
        svgSrc,
        colorFilter: const ColorFilter.mode(Colors.white70, BlendMode.srcIn),
        height: 24,
      ),
      title: Text(
        title,
        style:
            const TextStyle(color: Colors.white70, fontWeight: FontWeight.w700),
      ),
    );
  }
}
