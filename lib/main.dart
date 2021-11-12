import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_app_stulish/pages/categories/categories-main.dart';
import 'package:flutter_app_stulish/pages/home/home-main.dart';
import 'package:flutter_app_stulish/pages/login/login-main.dart';
import 'package:flutter_app_stulish/services/auth.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(ChangeNotifierProvider(
    create: (BuildContext context) => AuthProvider(),
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Splash Screen',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: Center(child: Consumer<AuthProvider>(
        builder: (context, auth, child) {
          switch (auth.isAuthenticated) {
            case true:
              return HomeMain();
            default:
              return LoginMain();
          }
        },
      )),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    Timer(
        Duration(seconds: 3),
        () => Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => HomeMain())));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        child: FlutterLogo(size: MediaQuery.of(context).size.height));
  }
}
