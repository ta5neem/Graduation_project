import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gui/core/utils/color_manager.dart';
import 'package:gui/data/models/modelhelper.dart';

import 'header.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'تقييم الحركات',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: EvalScreen(),
    );
  }
}

class EvalScreen extends StatelessWidget {
  // Map<String, dynamic> data=model.data;
  Future<dynamic> data=model.get_evaluation();



  //    String data=model.data;
  // final Map<String, dynamic> data = {
  //   "total_eval": 3.999999999999999,
  //   "notes": [
  //     "STRAIGHT_DOWN: Count=5.60: Note: Don't keep your hands at your sides This conveys a sense of stress or uneasiness. Try to gently ease this movement, and let your hands loosen up a bit to allow yourself to express naturally.",
  //     "ON_SIDE: Count=6.64: Note: You lean to the side, return your body to the audience When you lean in too much, it may show unease or distrust of the current situation. It's a good idea to turn towards the audience and maintain eye contact",
  //     "VIBRATING_MOTION: Count=3.84: Note: Don't shake too much This indicates that you are nervous. Try to think about the content of the show and communicate with the audience to calm yourself down"
  //   ],
  // };


  @override
  Widget build(BuildContext context) {
    double totalEval=5;
    List<String> notes=[];
//     data.then((dynamic value) {
//       if (value is String) {
//         // تمثل value نصًا
//         String textData = value;
//         Map<String, dynamic> parsedData = json.decode(textData);
//
// // استخراج القيم المرادة
//         model.totalEval = parsedData['total_eval'];
//         model.set_totalEval(parsedData['total_eval']);
//         List<String> notes = List<String>.from(parsedData['notes']);
//         model.set_note(notes);
//
// // طباعة القيم
//         print("total_eval: $totalEval");
//         print("notes: $notes");
//         print("نص المعلومات: $textData");
//
//         // يمكنك فعل أي شيء آخر تريده مع النص
//       } else {
//         print("القيمة المسترجعة ليست نصًا.");
//       }
//     }).catchError((error) {
//       print("حدث خطأ أثناء الحصول على المعلومات: $error");
//     });



    // Map<String, dynamic> data =model.data;

    // String result = data.substring(1, data.length - 1);
    // Map<String, dynamic> dat = json.decode(data);
    // double totalEval = dat['total_eval: '];
    // Map<String, dynamic> dat={result} ;
    // return Scaffold(
    //   appBar: AppBar(flexibleSpace: Header(s:"Evaluation"),backgroundColor: ColorsManager.darkTeal),
    //   body: Text("model"),
    // );

    // List<String> notes = List<String>.from(data['notes']);
    //
    return Scaffold(
      appBar: AppBar(
          flexibleSpace: Header(s: "Evaluation"),backgroundColor: ColorsManager.darkTeal
      ),
      body: ListView.builder(
        itemCount: model.notes.length + 1, // Add 1 for the extra text at the end
        itemBuilder: (context, index) {
          if (index < model.notes.length) {
            String note = model.notes[index];
            List<String> parts = note.split(': ');

            String movement = parts[0];
            String countPart = parts[1];
            List<String> countP =parts[1].split(', ');

            // String noteText = parts.sublist(2).join(': ');
            print("mov"+movement);
            print("countPart"+countPart);
            // print("noteText"+noteText);

            double count;
            // if(countPart=='0.0'){
            //   count=1;
            //   print('0000000000000000000000000000000000000000');
            // }
             count = double.parse(countP[0].split('=')[1]);
            // if (count==0){count=1;}
            if (count==0){print("ppppppppppppppppppppppppppppppppppppppppppppppp");};
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            movement,
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.blue,
                            ),
                            child: Text(
                              // "11",
                              count.toString(),
                              style:
                              TextStyle(fontSize: 16, color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Text(
                  // "kjhc",
                      //   noteText,
                        parts[2],
                        style: TextStyle(fontSize: 14),
                      ),
                      Divider(),
                    ],
                  ),
                ),
              ],
            );
          } else {
            return Container(
              width: 200,
                // color: Colors.blue,
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blue),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                'This your final assessment : '+'${model.totalEval}'+'/10 ',
                style: TextStyle(fontSize: 18),
              ),
            );
          }
        },
      ),
    );
  }
}
