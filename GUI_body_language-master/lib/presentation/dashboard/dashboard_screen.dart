import 'package:gui/URL.dart';
import 'package:gui/core/utils/app_assets.dart';
import 'package:gui/core/utils/color_manager.dart';
import 'package:gui/core/utils/constants.dart';
import 'package:gui/core/utils/responsive.dart';
import 'package:gui/data/models/modelhelper.dart';
import 'package:gui/presentation/dashboard/MenuAppController.dart';
import 'package:gui/presentation/dashboard/components/header.dart';
import 'package:gui/presentation/dashboard/components/side_menu.dart';
import 'package:gui/presentation/dashboard/components/tip_row.dart';
import 'package:gui/presentation/dashboard/components/video_row.dart';
import 'package:gui/presentation/dashboard/dashboard_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:gui/presentation/dashboard/timersc.dart';
import 'package:provider/provider.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:http/http.dart' as http;
import 'dart:math';

import '../rating/rating_screen.dart';
import 'components/Eval1.dart';
import 'components/evaluation.dart';




class DashboardScreen extends StatelessWidget {
  DashboardScreen({Key? key}) : super(key: key);

  final List<String> tips = [
    "tip 1: Keep your hands moving and open to build audience's trust and show that you have nothing to hide",
    "tip 2: when you don't know what to do , drop your hands to your sides for a moment",
    "tip 3: Keep your body straight and confident so that the audience feels that you are in control of the situation",
    "tip 4: Use hand motions to point at the screen or graphs to make the points you are making",
    "tip 5: Avoid exaggerated hand movements that may distract the audience",
    "tip 6: Turn toward the audience and make light gestures to encourage participation",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // key: context.read<MenuAppController>().scaffoldKey,
      appBar: AppBar(flexibleSpace: Header(s:"Dashbord"),backgroundColor: ColorsManager.darkTeal),
      drawer: const SideMenu(),
      body:
      // SingleChildScrollView(child:
             Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // const Header(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Tips:",
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge!
                          .copyWith(fontWeight: FontWeight.w600),
                    ),
                  ),
                  Constants.verticalSpaceSmall(),
                  CarouselSlider(
                    options: CarouselOptions(
                      // height: MediaQuery.of(context).size.height / 4,
                        aspectRatio: 19 / 6,
                        clipBehavior: Clip.antiAlias,
                        enlargeCenterPage: true,
                        scrollDirection: Axis.vertical,
                        viewportFraction: 0.75,
                        autoPlay: true,
                        disableCenter: true),
                    items: tips
                        .map((e) => TipRow(title: e, icon: AppAssets.tipIcon))
                        .toList(),
                  ),
                  Constants.verticalSpaceLarge(),
                  // SizedBox(
                    // height: 300,
                    // child:
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Your presentation:",
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge!
                          .copyWith(fontWeight: FontWeight.w600),
                    ),
                  ),
                  // model.video_count(),
                  if(model.count>0)...{
                    Container(
                      height: 180,
                      child:  ListView.builder(
                        itemCount: model.count,
                        itemBuilder: (context, index) {
                          return InkWell(
                              onTap: (){print(
                                 "mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm"+ '${index+1}');
                                   // model.get_eval(index);
                                model.set_num(index);
                                model.get_eval();
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => MultiProvider(
                                  providers: [
                                    ChangeNotifierProvider(
                                      create: (context) => MenuAppController(),
                                    ),
                                  ],
                                  child: //TimerPage()
                                  Eval1(index),
                                ),
                              ),
                              );
                                },
                              child: VideoRow(title: "  "+'${index+1}'+". your video ",
                              onPressed: () {}
                              ));
                        },
                      ),
                    ),
                  },
                  if(model.count==0)...{
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "You don't  have any presentation yet",
                        style: Theme.of(context)
                            .textTheme
                            .titleSmall!
                            .copyWith(fontWeight: FontWeight.w600),
                      ),
                    ),
                  },



                    // ListView(
                    //   shrinkWrap: true,
                    //   children: [
                    //     VideoRow(title: "1. your video 1",onPressed: () {
                    //       Navigator.of(context).push(MaterialPageRoute(
                    //         builder: (context) => MultiProvider(
                    //           providers: [
                    //             ChangeNotifierProvider(
                    //               create: (context) => MenuAppController(),
                    //             ),
                    //           ],
                    //           child: EvalScreen(),
                    //         ),
                    //       )
                    //         ,
                    //       );
                    //     },),
                    //     VideoRow(title: "2. your video 2",onPressed: () {}),
                    //   ],
                    // ),
                  // ),

                  Constants.verticalSpaceLarge(),
                  Constants.verticalSpaceMedium(),
                  Align(
                    alignment: Alignment.topCenter,
                    child: Center(
                      child: MaterialButton(
                          padding: EdgeInsets.all(
                              Responsive.isMobile(context) ? 10 : 20),
                          minWidth: Responsive.isMobile(context)
                              ? MediaQuery.of(context).size.width / 4
                              : MediaQuery.of(context).size.width / 6,
                          height: MediaQuery.of(context).size.height / 10,
                          color: ColorsManager.darkTeal,
                          shape: Constants.kFilledButton,
                          child: Text("Start new presentation",
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              )),
                          onPressed: () {
                            // model.get_enaluation();



                            ///////////////////////////////////////
                              final response = http.post(
                                Uri.parse("http://"+URL().geturl()+":8000/api/runcode/soket/") // تغيير الرابط إلى العنوان الصحيح
                              );



                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => MultiProvider(
                            providers: [
                              ChangeNotifierProvider(
                                create: (context) => MenuAppController(),
                              ),
                            ],
                            child: //TimerPage()
                            DashboardDetailsScreen(),
                          ),
                        ),
                      );
                          }),
                    ),
                  ),
                ],
              ),

      // ),
    );
  }
}


// rror: Could not find the correct Provider<MenuAppController> above this DashboardScreen Widget: