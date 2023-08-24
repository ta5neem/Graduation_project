import 'package:gui/core/utils/app_assets.dart';
import 'package:gui/core/utils/enums.dart';
import 'package:gui/core/utils/responsive.dart';
import 'package:gui/presentation/dashboard/MenuAppController.dart';
import 'package:gui/presentation/login_singup/components/login_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gui/presentation/login_singup/components/signup_form.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  LoginType loginType;

  LoginScreen({Key? key, required this.loginType}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: context.read<MenuAppControlle>().scaffoldKey,
      body: Responsive(
        mobileBody: loginType==LoginType.signIn ?LoginForm(loginType: loginType.getTypeName) : SingupForm(loginType: loginType.getTypeName),
        desktopBody: Row(
          children: [
            SvgPicture.asset(AppAssets.talking,
                fit: BoxFit.fitHeight, width: MediaQuery.of(context).size.width / 2),
            Expanded(child: LoginForm(loginType: loginType.getTypeName)),
          ],
        ),
      ),
    );
  }
}


// import 'package:flutter/material.dart';
class MenuAppControlle extends ChangeNotifier {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  GlobalKey<ScaffoldState> get scaffoldKey => _scaffoldKey;

  void controlMenu() {
    if (!_scaffoldKey.currentState!.isDrawerOpen) {
      _scaffoldKey.currentState!.openDrawer();
    }
  }
}
