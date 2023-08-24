
import 'dart:async';

import 'package:flutter/material.dart';

class TimerPage extends StatefulWidget {
  @override
  _TimerPageState createState() => _TimerPageState();
}

class _TimerPageState extends State<TimerPage> {
  int timeInSeconds = 0;
  bool isCounting = false;
  Timer? timer;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel(); // إيقاف تشغيل التايمر عند إغلاق الصفحة
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Timer Example")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {
                  timeInSeconds = int.tryParse(value) ?? 0;
                });
              },
              decoration: InputDecoration(
                labelText: "Enter Time in Seconds",
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (timeInSeconds > 0 && !isCounting) {
                  startCountdown();
                }
              },
              child: Text("Start Countdown"),
            ),
            SizedBox(height: 20),
            Text(
              isCounting ? "Time left: $timeInSeconds seconds" : "",
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }

  void startCountdown() {
    timer = Timer.periodic(Duration(seconds: 1), (Timer t) {
      if (timeInSeconds == 0) {
        timer?.cancel(); // إيقاف تشغيل التايمر عند انتهاء الوقت
        setState(() {
          isCounting = false;
        });
      } else {
        setState(() {
          timeInSeconds--;
          isCounting = true;
        });
      }
    });
  }
}
