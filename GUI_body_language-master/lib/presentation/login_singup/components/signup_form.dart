import 'dart:convert';

import 'package:gui/core/utils/app_assets.dart';
import 'package:gui/core/utils/constants.dart';
import 'package:gui/core/utils/enums.dart';
import 'package:gui/core/utils/responsive.dart';
import 'package:gui/data/datasource/databasehelper.dart';
import 'package:gui/presentation/dashboard/MenuAppController.dart';
import 'package:gui/presentation/dashboard/dashboard_screen.dart';
import 'package:gui/presentation/login_singup/components/edit_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gui/presentation/login_singup/screens/login_screen.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class SingupForm extends StatelessWidget {
  final String loginType;
  // final TextEditingController _nameController = new TextEditingController();
  // final TextEditingController _emailController = new TextEditingController();
  // final TextEditingController _passwordController = new TextEditingController();
  const SingupForm({Key? key, required this.loginType}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        key: context.read<MenuAppControll>().scaffoldKey,
        child:Stack(
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: SvgPicture.asset(
            AppAssets.upCircle,
            fit: BoxFit.fill,
            height: MediaQuery.of(context).size.height / 8,
          ),
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: SvgPicture.asset(
            AppAssets.bottomCircle,
            fit: BoxFit.fill,
            height: MediaQuery.of(context).size.height / 8,
          ),
        ),


        Container(
          padding: EdgeInsets.symmetric(
              vertical: 40, horizontal: Responsive.isMobile(context) ? 16 : 48),
          child: Column(

            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SizedBox(height: 100,),
              if (Responsive.isMobile(context)) ...{
                Image.asset("assets/logo/logo_bc.jpg",
                  // AppAssets.handfolded,
                  height: MediaQuery.of(context).size.height / 5,
                  width: MediaQuery.of(context).size.width / 1,
                ),
                // Constants.verticalSpaceMedium(),
              },
              Constants.verticalSpaceLarge(),
              Text(loginType,
                  style: Theme.of(context)
                      .textTheme
                      .displaySmall!
                      .copyWith(fontSize: 32)),
              Constants.verticalSpaceMedium(),
              EditTextField(
                  label: 'Name',
                  hint: 'Enter your name',
                  width: Responsive.isMobile(context)
                      ? MediaQuery.of(context).size.width
                      : MediaQuery.of(context).size.width / 4,
                  controller: TextEditingController(),
                  type: TextInputType.name,
                onChanged: (value) {
                  DatabaseHelper.name=value;
                },
              ),
              EditTextField(
                  label: 'Email',
                  hint: 'Enter your email',
                  width: Responsive.isMobile(context)
                      ? MediaQuery.of(context).size.width
                      : MediaQuery.of(context).size.width / 4,
                  controller: TextEditingController(),
                  type: TextInputType.name,
                onChanged: (value) {
                  DatabaseHelper.email=value;
                },),
              Constants.verticalSpaceMedium(),
              EditTextField(
                label: 'Password',
                hint: 'Enter password',
                width: Responsive.isMobile(context)
                    ? MediaQuery.of(context).size.width
                    : MediaQuery.of(context).size.width / 4,
                controller: TextEditingController(),
                type: TextInputType.visiblePassword,
                onChanged: (value) {
                  DatabaseHelper.password=value;
                },
              ),
              Constants.verticalSpaceLarge(),
              MaterialButton(
                  padding:
                      EdgeInsets.all(Responsive.isMobile(context) ? 10 : 20),
                  minWidth: Responsive.isMobile(context)
                      ? MediaQuery.of(context).size.width / 2
                      : MediaQuery.of(context).size.width / 4,
                  color: Theme.of(context).primaryColor,
                  shape: Constants.kFilledButton,
                  child: Text(loginType,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            color: Colors.white,
                          )),
                  onPressed: () async {
                    print('k');
                    await DatabaseHelper.registerData();
                    await DatabaseHelper.loginData();
                    if (DatabaseHelper.status) {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => MultiProvider(
                          providers: [
                            ChangeNotifierProvider(
                              create: (context) => MenuAppController(),
                            ),
                          ],
                          child: DashboardScreen(),
                        ),
                      ));
                    }
                  }
                  ),
            ],
          ),
        ),
      ],
    ));
  }
}


// import 'package:flutter/material.dart';

class MenuAppControll extends ChangeNotifier {
  final GlobalKey<ScaffoldState> _scaffoldK = GlobalKey<ScaffoldState>();

  GlobalKey<ScaffoldState> get scaffoldKey => _scaffoldK;

  void controlMenu() {
    if (!_scaffoldK.currentState!.isDrawerOpen) {
      _scaffoldK.currentState!.openDrawer();
    }
  }
}
