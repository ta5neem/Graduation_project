import 'package:gui/core/utils/app_assets.dart';
import 'package:gui/core/utils/color_manager.dart';
import 'package:gui/core/utils/constants.dart';
import 'package:gui/core/utils/enums.dart';
import 'package:gui/core/utils/responsive.dart';
import 'package:gui/data/datasource/databasehelper.dart';
import 'package:gui/presentation/dashboard/MenuAppController.dart';
import 'package:gui/presentation/dashboard/dashboard_screen.dart';
import 'package:gui/presentation/login_singup/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class WelcomeForm extends StatelessWidget {
  const WelcomeForm({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child:
      Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        if (Responsive.isDesktop(context)) ...{
          Text('Be confident', style: Theme.of(context).textTheme.displayMedium),
          Constants.verticalSpaceLarge(),
        },


        if (Responsive.isMobile(context)) ...{
          Image.asset("assets/logo/ph.jpg",
            // AppAssets.handfolded,
            height: MediaQuery.of(context).size.height / 1.5,
            width: MediaQuery.of(context).size.width / 1,
          ),
          // Constants.verticalSpaceMedium(),
        },

        Constants.verticalSpaceLarge(),
        MaterialButton(
          padding: EdgeInsets.all(Responsive.isMobile(context) ? 10 : 20),
          minWidth: Responsive.isMobile(context)
              ? MediaQuery.of(context).size.width / 2
              : MediaQuery.of(context).size.width / 4,
          color: Theme.of(context).primaryColor,
          shape: Constants.kFilledButton,
          child: Text(
            "Login",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  color: Colors.white,
                ),
          ),
          onPressed: ()
          => Navigator.of(context).push(MaterialPageRoute(
              builder: (context) =>
                  LoginScreen(loginType: LoginType.signIn)
          )),


        ),
        Constants.verticalSpaceMedium(),
        MaterialButton(
          padding: EdgeInsets.all(Responsive.isMobile(context) ? 10 : 20),
          minWidth: Responsive.isMobile(context)
              ? MediaQuery.of(context).size.width / 2
              : MediaQuery.of(context).size.width / 4,
          color: Colors.white,
          shape: Constants.kOutlinedButton,
          child: Text(
            "Sign up",
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .titleLarge!
                .copyWith(color: ColorsManager.darkTeal),
          ),
          onPressed: ()
          => Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => LoginScreen(loginType: LoginType.signUp),
              // builder: (context) => DatabaseHelper.token==null ?LoginScreen(loginType: LoginType.signUp) : DashboardScreen(),
          )),
        ),
      ],
      )
    );
  }
}



