import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gui/URL.dart';
import 'package:http/http.dart' as http;
import 'package:gui/core/utils/app_assets.dart';

import 'package:socket_io_client/socket_io_client.dart' as IO;




// class Model {
//
//   static start() {
//     pro().change_name("ramaq");
//     IO.Socket socket = IO.io('http://192.168.1.102:8080/', <String, dynamic>{
//       'transports': ['websocket'],
//       'autoConnect': false,});
//
//     socket.onConnect((_) {
//       print('connected');
//       socket.emit('test', 'connect from flutter');
//     });
//     // Timer.periodic(Duration(seconds: 1), (timer) {
//     //   socket.emit('test', 'Hello from Dart');
//     // });
//     socket.on('test', (data) {
//       // AsyncSnapshot.waiting();
//       // sleep(1 as Duration);
//       // socket.emit('test', 'hello');
//       print(data);
//       pro().change_name(data);
//
//       //pro().change_name(data);
//     });
//     socket.onDisconnect((_) => print('disconnect'));
//     // TextToSpeech().speak("${pro}");
//     socket.connect();
//   }
// }


class pro extends ChangeNotifier {
  String name_b = "Let's Go";
  String commint="Let's Go";
  String ima= "ok";
  int co = 0;

  get getname => name_b;
  get getcommint => commint;
  get getco => co;
  get getima =>ima;

  change_name() {
    print("change_name");
    if(co==0){
      name_b = "Stop";
      co=1;
    }
    else{
      name_b = "Let's Go";
      co=0;
    }

    notifyListeners(); // this function that can rebuild Consumer that lisean to this class
  }

  change_comment(data){
    // String note = data;
    List<String> parts = data.split(':');
    // List<String> dat=data;
    // dat
    print("]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]");
    print(data);
    print(data);
    // data = data.split(':');
    print(parts[0]);
    print(parts[1]);
    commint=parts[0];
    ima=parts[1];
    notifyListeners();

  }
}


 class model {

  static int count=0;
  static String data = "";
  static double totalEval=0;
  static int num=0;
  static List<String> notes=[];


  static video_count() async{
    String myUrl = "http://"+URL().geturl()+":8000/api/get_videos/";
    final myUrl_ = Uri.parse(myUrl);
    final response = await  http.post(myUrl_,
        body: {
        } ) ;
    print(response.body);
    List<String> parts = response.body.split(': ');

    String co = parts[1][0];
    print(co);
    print(response.statusCode);

    if (response.statusCode == 200) {
      print('تم ');
    }else if(response.statusCode == 400){
      print('حدث خطأ');
    }
    count =int.parse(co) ;
  }

  static set_totalEval(num){
    totalEval=num;
    print("hhhhhhhhhhh");
  }

  static set_note(note){
    notes=note;
  }

  static set_num(index){
    num=index;
  }


  static get_evaluation() async{
    String myUrl = "http://"+URL().geturl()+":8000/api/show_evals/";
    final myUrl_ = Uri.parse(myUrl);
    final response = await  http.post(myUrl_,
        // body: {
        // }
        ) ;
    print("eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee"+response.body);
    data = response.body ;
    print(data);
    if (data!=null) {
      // تمثل value نصًا
      String textData = data as dynamic;
      Map<String, dynamic> parsedData = json.decode(textData);

// استخراج القيم المرادة
      model.totalEval = parsedData['total_eval'];
      model.set_totalEval(parsedData['total_eval']);
      List<String> notes = List<String>.from(parsedData['notes']);
      model.set_note(notes);

// طباعة القيم
      print("total_eval: $totalEval");
      print("notes: $notes");
      print("نص المعلومات: $textData");
      print("bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb");
      // يمكنك فعل أي شيء آخر تريده مع النص
    }


    // List<String> parts = response.body.split(': ');
    // print(parts[0]);
    print(response.statusCode);

    if (response.statusCode == 201) {
      print('تم ');
      print(response.statusCode);
    }else if(response.statusCode == 400){
      print('حدث خطأ');
    }
    // count =double.parse(co) ;
    return response.body;
 }

  static get_eval() async{
    // num=1;
    print("ppppppppppppppppppppppppppppppppppppppppp");
    print(num);
    String myUrl = "http://"+URL().geturl()+":8000/api/get_video_information/";
    final myUrl_ = Uri.parse(myUrl);
    final response = await  http.post(myUrl_,
        body: {
          "video_index" :  '${num}'
        } ) ;
    print("ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo");
    print(response.body);
    // List<String> parts = response.body.split(': ');
    // print(parts[0]);
    print(response.statusCode);

    if (response.statusCode == 200) {
      print('تم ');
    }else if(response.statusCode == 400){
      print('حدث خطأ');
    }
    // count =double.parse(co) ;
    return response.body;
  }
}