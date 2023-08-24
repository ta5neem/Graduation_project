import 'package:http/http.dart' as http;
import 'package:gui/URL.dart';
import 'dart:convert';
// import 'package:shared_preferences/shared_preferences.dart';

class DatabaseHelper{

  static final String serverUrl = "http://"+URL().geturl()+":8000/api";
  static bool status=false ;
  static var token =null ;
  static var name;
  static var email;
  static var password;


  static loginData() async{
    String myUrl = "$serverUrl/login/";
    final myUrl_ = Uri.parse(myUrl);
    final response = await  http.post(myUrl_,
        // headers: {
        //   'Accept':'application/json'
        // },
        body: {
          "user_id": "$name",
          "password" : "$password"
        } ) ;
    // status = response.body.contains('error');
    print(response.body);
    print(response.statusCode);
    // status = response.body.contains('error');

    if (response.statusCode == 200) {
      // تمت عملية تسجيل الدخول بنجاح
      print('تم تسجيل الدخول بنجاح');
      status =true;
    }else if(response.statusCode == 400){
      print('حدث خطأ في تسجيل الدخول');
      status=false;
    }
    else {
      // حدث خطأ في تسجيل الدخول
      print('حدث خطأ ');
      status =false;
    }
    print(status);
    var data = json.decode(response.body);

    if(status){
      print('data : ${data["token"]}');
      token= data["token"];
    }

  }

  static registerData() async{
    String myUrl = "$serverUrl/addUser/";
    final myUrl_ = Uri.parse(myUrl);
    print("dddd");
    final response = await  http.post(myUrl_,
        // headers: {
        //   'Accept':'application/json'
        // },
        body: {
          "username": "$name",
          "email": "$email",
          "password" : "$password"
        } ).timeout(Duration(minutes: 1)).onError((error, stackTrace) { print(error);
          return http.Response(error.toString(), 404);});
    print("jjjj");

    // print(response.body);
    // print(response.statusCode);
    // status = response.body.contains('error');

    if (response.statusCode == 201) {
      // تمت عملية تسجيل الدخول بنجاح
      print('تم تسجيل الدخول بنجاح');
      status =true;
    }else if(response.statusCode == 400){
      print('حدث خطأ في تسجيل الدخول');
      status=false;
    }
    else {
      // حدث خطأ في تسجيل الدخول
      print('حدث خطأ');
      status =false;
    }
    // print(status);

  }

  static logout( String token) async{

    String myUrl = "$serverUrl/logout/";
    final myUrl_ = Uri.parse(myUrl);
    final response = await  http.post(myUrl_,
        // headers: {
        //   'Accept':'application/json'
        // },
        body: {
          "token": "$token",
        } ) ;
    // status = response.body.contains('error');
    print(response.body);
    print(response.statusCode);
    // status = response.body.contains('error');

    if (response.statusCode == 200) {
      // تمت عملية تسجيل الدخول بنجاح
      print('تسجيل الخروج بنجاح');
      status =true;
    }else if(response.statusCode == 400){
      print('خطأ في تسجيل الخروج');
      status=false;
    }
    else {
      // حدث خطأ في تسجيل الدخول
      print('خطأ');
      status =false;
    }
    print(status);
    var data = json.decode(response.body);

  }
}