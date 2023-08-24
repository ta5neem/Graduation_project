import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
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
import 'package:gui/data/models/modelhelper.dart';



class LoginForm extends StatelessWidget {
  final String loginType;
  const LoginForm({Key? key, required this.loginType}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return  SingleChildScrollView(
      key: context.read<MenuAppControl>().scaffoldKey,
      child: Stack(
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
              vertical: 30, horizontal: Responsive.isMobile(context) ? 16 : 48),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 100,),
              if (Responsive.isMobile(context)) ...{
                Image.asset("assets/logo/logo_bc.jpg",
                  // AppAssets.handfolded,
                  height: MediaQuery.of(context).size.height / 4,
                  width: MediaQuery.of(context).size.width / 1,
                ),
                // Constants.verticalSpaceMedium(),
              },
              Constants.verticalSpaceLarge(),
              Text(loginType,
                  style:
                  Theme.of(context).textTheme.displaySmall!.copyWith(fontSize: 32)),
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
                  padding: EdgeInsets.all(Responsive.isMobile(context) ? 10 : 20),
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
                    DatabaseHelper databaseHelper = new DatabaseHelper();
                    await DatabaseHelper.loginData();
                    await model.video_count();
                    if (DatabaseHelper.status) {
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
                    }
                  }
              ),
              SizedBox(
                height: 10,
              ),
        //       StreamBuilder<RemoteMessage>(
        // //prints the messages to the screen0
        // stream: FirebaseMessaging.onMessage,
        // builder: (context, snapshot) {
        //   print(snapshot.connectionState);
        // if (snapshot.connectionState == ConnectionState.waiting) {
        // return
        // CircularProgressIndicator();
        //
        // }
        // else if (snapshot.connectionState ==
        // ConnectionState.active) {
        // if (snapshot.hasError) {
        // return const Text('Error');
        // } else if (snapshot.hasData) {
        //   CircularProgressIndicator();
        //
        //
        // return Text('${snapshot.data?.notification?.body??'empty'} ${snapshot.data?.sentTime??''}');
        // /// }));
        // } else {
        // return const Text('Empty data');
        // }
        // }
        // else {
        // return Text('State: ${snapshot.connectionState}');
        // }
        // })
            ],
          ),
        ),
      ],
    ),);

  }
}



class MenuAppControl extends ChangeNotifier {
  final GlobalKey<ScaffoldState> _scaffoldKe = GlobalKey<ScaffoldState>();

  GlobalKey<ScaffoldState> get scaffoldKey => _scaffoldKe;

  void controlMenu() {
    if (!_scaffoldKe.currentState!.isDrawerOpen) {
      _scaffoldKe.currentState!.openDrawer();
    }
  }
}
