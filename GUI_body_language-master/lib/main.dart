import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:gui/core/utils/enums.dart';
import 'package:gui/core/utils/styles.dart';
import 'package:gui/presentation/dashboard/MenuAppController.dart';
import 'package:gui/presentation/dashboard/dashboard_screen.dart';
import 'package:gui/presentation/login_singup/components/login_form.dart';
import 'package:gui/presentation/login_singup/components/signup_form.dart';
import 'package:gui/presentation/login_singup/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:gui/presentation/welcom/welcome_screen.dart';
import 'package:provider/provider.dart';
import 'package:gui/data/datasource/databasehelper.dart';

import 'firebase_options.dart';
final messaging = FirebaseMessaging.instance;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
   await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  String? token = await messaging.getToken();

  if (kDebugMode) {
    print('Registration Token=$token');
  }

  runApp( MyApp());
}

class MyApp extends StatelessWidget {
   MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {


    return MultiProvider(providers: [
      // Provider<HomeProvider>(create: (_)=>HomeProvider()),

      // ListenableProvider<MenuAppContr>(create: (_) => MenuAppContr()),
      ChangeNotifierProvider(create: (context)=> MenuAppControl()),
      ChangeNotifierProvider(create: (context)=> MenuAppControll()),
      ChangeNotifierProvider(create: (context)=> MenuAppControlle())
      // ListenableProvider<MenuAppControlle>(create: (_) => MenuAppControlle()),
      // ListenableProvider<MenuAppControll>(create: (_) => MenuAppControll()),

    ],

//     child:  ChangeNotifierProvider<MenuAppControl>.value(
//     value: Provider.of<MenuAppControl>(context),
//     child: Consumer<MenuAppControl>(
//     builder: (_,value,child){
//     return  MaterialApp(
// debugShowCheckedModeBanner: false,
//     title: 'Be confident',
//     theme: Styles.themeData(false, context),
//
//     home: WelcomeScreen(),);}
//     ),));


        child: MaterialApp(
debugShowCheckedModeBanner: false,
    title: 'Flutter Demo',
    theme: Styles.themeData(false, context),

    home: WelcomeScreen(),
 // LoginScreen(loginType: LoginType.signIn),
        ),);


  }


//
//     return MaterialApp(
// debugShowCheckedModeBanner: false,
// title: 'Flutter Demo',
// theme: Styles.themeData(false, context),
//
// home: WelcomeScreen(),
// //  LoginScreen(loginType: LoginType.signIn),
// );

  }







