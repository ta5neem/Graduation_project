import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_svg/svg.dart';
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
import 'package:flutter/material.dart';
import 'package:gui/presentation/dashboard/dashboard_screen.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:provider/provider.dart';
import 'package:text_to_speech/text_to_speech.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:gui/data/models/modelhelper.dart';
import 'package:http/http.dart' as http;

import 'components/evaluation.dart';

class DashboardDetailsScreen extends StatefulWidget {
  /// Default Constructor
  // final List<CameraDescription>? cameras;

  DashboardDetailsScreen({
    Key? key,
    // required this.cameras
  }) : super(key: key);

  @override
  State<DashboardDetailsScreen> createState() => _DashboardDetailsScreenState();
}

class _DashboardDetailsScreenState extends State<DashboardDetailsScreen> {
  // late CameraController controller;

  int _minutes = 0;
  int _seconds = 0;
  int _hour = 0;
  String _duration = "00:00:00";
  FlutterTts flutterTts = FlutterTts();
  final List<String> notes = [
    "note 1: This is a test tip, This is a test note",
    "note 2: This is a very very big test note, This is a very long test note,please read it.bla bla bla, This is a very long test note",
    "note 3: This is a small test note",
    "note 4: use high quality microphone",
  ];
  late IO.Socket socket;

  @override
  void initState() {
    super.initState();
    socket = IO.io("http://" + URL().geturl() + ":8080/", <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });
    socket.connect();
    print("initState");
  }

  @override
  Widget build(BuildContext context) {
    print("duration-- ${_duration}");
    // TextToSpeech().speak("duration");
    // _speakText('String text');
    return ChangeNotifierProvider(
      create: (context) => pro(),
      child: Scaffold(
        appBar: AppBar(flexibleSpace: Header(s:"Presentation"),backgroundColor: ColorsManager.darkTeal),
        // key: context.read<MenuAppController>().scaffoldKey,
        drawer: const SideMenu(),
        body: SafeArea(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (Responsive.isDesktop(context)) ...{
                const Expanded(flex: 1, child: SideMenu())
              },
              Expanded(
                flex: 5,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // const Header(),
                      // Center(
                      //     child: Text(
                      //   _duration,
                      //   style: const TextStyle(
                      //       fontSize: 100, color: ColorsManager.darkGrey),
                      // )),
                      Constants.verticalSpaceMedium(),
                      // Center(
                      //   child: MaterialButton(
                      //       padding: EdgeIn
                      //       sets.all(
                      //           Responsive.isMobile(context) ? 10 : 20),
                      //       minWidth: Responsive.isMobile(context)
                      //           ? MediaQuery.of(context).size.width / 4
                      //           : MediaQuery.of(context).size.width / 5,
                      //       height: MediaQuery.of(context).size.height / 20,
                      //       color: ColorsManager.darkTeal,
                      //       shape: Constants.kFilledButton,
                      //       child: Text("Enter duration",
                      //           textAlign: TextAlign.center,
                      //           style: Theme.of(context)
                      //               .textTheme
                      //               .titleMedium!
                      //               .copyWith(
                      //                 color: Colors.white,
                      //                 fontWeight: FontWeight.w600,
                      //               )),
                      //       onPressed: () async {
                      //         String? res = await durationDialog();
                      //         setState(() {
                      //           _duration = res ?? "00:00:00";
                      //         });
                      //       }),
                      // ),
                       Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Notes:",
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge!
                              .copyWith(fontWeight: FontWeight.w600),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Body Language:",
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall!
                              .copyWith(fontWeight: FontWeight.w600),
                        ),
                      ),

                      // TipRow(title: notes[0], icon: AppAssets.noteIcon),
                      Consumer<pro>(builder: (context, pro, child) {
                        return TipRow(
                            title: pro.commint, icon: AppAssets.noteIcon);
                      }),
                      Consumer<pro>(builder: (context, pro, child) {
                        return Center(
                          child:Image.asset(
                            "assets/motion/"+pro.getima+".png",
                            // AppAssets.,
                            height: MediaQuery.of(context).size.height / 4,
                            width: MediaQuery.of(context).size.width / 2,
                          ),
                        );
                      }),
                      if (Responsive.isMobile(context)) ...{

                        Constants.verticalSpaceMedium(),
                      },


                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Voice:",
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall!
                              .copyWith(fontWeight: FontWeight.w600),
                        ),
                      ),
                      StreamBuilder<RemoteMessage>(
                        //prints the messages to the screen0
                          stream: FirebaseMessaging.onMessage,
                          builder: (context, snapshot) {
                            print(snapshot.connectionState);
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return
                                // CircularProgressIndicator();
                                TipRow(
                                    title: "natural", icon: AppAssets.noteIcon);
                            }
                            else if (snapshot.connectionState ==
                                ConnectionState.active) {
                              if (snapshot.hasError) {
                                return const Text('Error');
                              } else if (snapshot.hasData) {
                                CircularProgressIndicator();
                                String time='${snapshot.data?.notification?.body??'empty'} ${snapshot.data?.sentTime??''}';
                                return TipRow(
                                    title: '${snapshot.data?.notification?.body??'empty'}', icon: AppAssets.noteIcon);
                                  // Text('${snapshot.data?.notification?.body??'empty'}');
                                /// }));
                              } else {
                                return const Text('Empty data');
                              }
                            }
                            else {
                              return Text('State: ${snapshot.connectionState}');
                            }
                          }),

                      Constants.verticalSpaceLarge(),
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            MaterialButton(
                                padding: EdgeInsets.all(
                                    Responsive.isMobile(context) ? 10 : 20),
                                minWidth: Responsive.isMobile(context)
                                    ? MediaQuery.of(context).size.width / 4
                                    : MediaQuery.of(context).size.width / 5,
                                height: MediaQuery.of(context).size.height / 10,
                                color: Colors.redAccent,
                                shape: Constants.kFilledButton,
                                child: Text("Cancel",
                                    textAlign: TextAlign.center,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge!
                                        .copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                        )),
                                onPressed: () async {
                                  // try{}
                                  // catch{
                                  //
                                  // }
                                  socket.disconnect();
                                  final response = await http.post(
                                      Uri.parse("http://" +
                                          URL().geturl() +
                                          ":8000/api/runcode/disoket/") // تغيير الرابط إلى العنوان الصحيح
                                      );
                                  print("st");
                                  print(response.statusCode);

                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => MultiProvider(
                                        providers: [
                                          ChangeNotifierProvider(
                                            create: (context) =>
                                                MenuAppController(),
                                          ),
                                        ],
                                        child: DashboardScreen(),
                                      ),
                                    ),
                                  );
                                }),
                            Consumer<pro>(builder: (context, pro, child) {
                              return MaterialButton(
                                  padding: EdgeInsets.all(
                                      Responsive.isMobile(context) ? 10 : 20),
                                  minWidth: Responsive.isMobile(context)
                                      ? MediaQuery.of(context).size.width / 4
                                      : MediaQuery.of(context).size.width / 5,
                                  height:
                                      MediaQuery.of(context).size.height / 10,
                                  color: ColorsManager.darkTeal,
                                  shape: Constants.kFilledButton,
                                  child: Text(pro.getname,
                                      textAlign: TextAlign.center,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge!
                                          .copyWith(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                          )),
                                  onPressed: () async {
                                    if(pro.getco==0){
                                      _speakText(pro.getcommint);
                                      pro.change_name();
                                      print("1");
                                      socket.emit('test', 'connect from flutter');
                                      // socket.onConnect((_) {
                                      //     print('connected');
                                      //
                                      //   });
                                      print('2');
                                      // print()
                                      socket.on('test', (data) {
                                        // AsyncSnapshot.waiting();
                                        // sleep(1 as Duration);
                                        // socket.emit('test', 'hello');
                                        print('connected');
                                        List<String> parts = data.split(':');
                                        // List<String> dat=data;
                                        // dat
                                        print("]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]");
                                        print(data);
                                        print(data);
                                        // data = data.split(':');
                                        print(parts[0]);
                                        print(parts[1]);
                                        _speakText(parts[0]);
                                        // TextToSpeech().speak(data.toString());
                                        print(data);
                                        print("///////////////////////////////////////////////////////");
                                        pro.change_comment(data);

                                        //pro().change_name(data);
                                      });

                                      //    // await http.post(Uri.parse("http://192.168.1.103:8000/api/runcode/soket/")
                                      //    //    // headers: {
                                      //    //    //   'Accept':'application/json'
                                      //    //    // },
                                      //    //     ) ;
                                      //
                                      //   // pro.change_name("ramaq");
                                      //   socket = IO.io(
                                      //       'http://192.168.137:8080/',
                                      //       <String, dynamic>{
                                      //         'transports': ['websocket'],
                                      //         'autoConnect': false,
                                      //       });
                                      //   print(socket.active);
                                      //   print('donee');
                                      //   socket.onConnect((_) {
                                      //     print('connected');
                                      //     // socket.emit('connect', 'connect from flutter');
                                      //   });
                                      //   // Timer.periodic(Duration(seconds: 1), (timer) {
                                      //   //   socket.emit('test', 'Hello from Dart');
                                      //   // });
                                      //   socket.on('connect', (data) {
                                      //     // AsyncSnapshot.waiting();
                                      //     // sleep(1 as Duration);
                                      //     // socket.emit('test', 'hello');
                                      //     print(data);
                                      //     // pro.change_name(data);
                                      //
                                      //     //pro().change_name(data);
                                      //   });
                                      //   socket
                                      //       .onDisconnect((_) => print('disconnect'));
                                      //   socket.connect();
                                      // });
                                      // // {
                                      //   //   // if(pro.getco==0){
                                      //   //     pro.change_name();
                                      //   //     print('00');
                                      //   //
                                      //   //     print('done');
                                      //   //     // pro.change_name("ramaq");
                                      //   //     IO.Socket socket = IO.io(
                                      //   //         'http://192.168.43.156:8083/',
                                      //   //         <String, dynamic>{
                                      //   //           'transports': ['websocket'],
                                      //   //           'autoConnect': false,
                                      //   //         });
                                      //   //     socket.onConnect((_){
                                      //   //       print('connected');
                                      //   //       // socket.emit('test', 'connect from flutter');
                                      //   //     });
                                      //   //     // Timer.periodic(Duration(seconds: 1), (timer) {
                                      //   //     //   socket.emit('test', 'Hello from Dart');
                                      //   //     // });
                                      //   //     socket.on('test', (data) {
                                      //   //       print('daaaaaaaaaaaaaaaaaataaaaaaaaaaaaaaaaaaa');
                                      //   //       // AsyncSnapshot.waiting();
                                      //   //       // sleep(1 as Duration);
                                      //   //       // socket.emit('test', 'hello');
                                      //   //       print(data);
                                      //   //       _speakText(data);
                                      //   //       TextToSpeech().speak(data);
                                      //   //       // pro.change_comment(data);
                                      //   //
                                      //   //       //pro().change_name(data);
                                      //   //     });
                                      //   //     socket.onDisconnect(
                                      //   //             (_) => print('disconnect'));
                                      //   //     socket.connect();
                                      //   //   }
                                    }
                                    else{
                                      socket.disconnect();
                                      final response = await http.post(
                                          Uri.parse("http://" +
                                              URL().geturl() +
                                              ":8000/api/runcode/disoket/") // تغيير الرابط إلى العنوان الصحيح
                                      );
                                      // model.get_evaluation();
                                      print("st");
                                      print(response.statusCode);

                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) => MultiProvider(
                                            providers: [
                                              ChangeNotifierProvider(
                                                create: (context) =>
                                                    MenuAppController(),
                                              ),
                                            ],
                                            child: EvalScreen(),
                                          ),
                                        ),
                                      );
                                    }

                                  });
                            }),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<String?> durationDialog() => showDialog<String>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Pickup duration"),
            content: StatefulBuilder(
              builder: (context, setState) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        NumberPicker(
                          value: _hour,
                          minValue: 0,
                          maxValue: 100,
                          itemWidth: 70,
                          onChanged: (value) => setState(() => _hour = value),
                        ),
                        const Text(":", style: TextStyle(fontSize: 42)),
                        NumberPicker(
                            value: _minutes,
                            minValue: 0,
                            maxValue: 60,
                            itemWidth: 70,
                            onChanged: (value) {
                              setState(() {
                                _minutes = value;
                              });
                            }),
                        const Text(":", style: TextStyle(fontSize: 42)),
                        NumberPicker(
                            value: _seconds,
                            itemWidth: 50,
                            minValue: 0,
                            maxValue: 60,
                            onChanged: (value) {
                              setState(() {
                                _seconds = value;
                              });
                            })
                      ],
                    ),
                    MaterialButton(
                        padding: EdgeInsets.all(
                            Responsive.isMobile(context) ? 10 : 20),
                        minWidth: Responsive.isMobile(context)
                            ? MediaQuery.of(context).size.width / 4
                            : MediaQuery.of(context).size.width / 5,
                        height: MediaQuery.of(context).size.height / 20,
                        color: ColorsManager.darkTeal,
                        shape: Constants.kFilledButton,
                        child: Text("Set duration",
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                )),
                        onPressed: () {
                          String hour = _hour < 10 ? "0$_hour" : "$_hour";
                          String min =
                              _minutes < 10 ? "0$_minutes" : "$_minutes";
                          String sec =
                              _seconds < 10 ? "0$_seconds" : "$_seconds";
                          String duration = "$hour:$min:$sec";
                          Navigator.of(context).pop(duration);
                          // Navigator.pop(context);
                        })
                  ],
                );
              },
            ),
          );
        },
      );
  Future<void> _speakText(String text) async {
    await flutterTts.setLanguage('en-US');
    await flutterTts.setPitch(9.0);
    // flutterTts.set
    await flutterTts.speak(text);
  }
}
