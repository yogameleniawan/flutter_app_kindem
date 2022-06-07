import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:kindem_app/pages/home/home-main.dart';
import 'package:kindem_app/pages/login/login-main.dart';
import 'package:kindem_app/services/auth.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

String? finalToken;

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    getValidationData();
  }

  Future getValidationData() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    var obtainedToken = sharedPreferences.getString('token');
    setState(() {
      finalToken = obtainedToken;
    });
    print(finalToken);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedSplashScreen(
        splash: Image(image: AssetImage("assets/images/logo-text.png")),
        // nextScreen: LoginMain(),
        nextScreen: Center(
          child:
              // finalToken == null ? LoginMain() : HomeMain(),
              Consumer<AuthProvider>(
            builder: (context, auth, child) {
              switch (auth.isAuthenticated || finalToken != null) {
                case true:
                  return HomeMain();
                default:
                  return LoginMain();
              }
            },
          ),
        ),
        backgroundColor: Colors.white,
        splashTransition: SplashTransition.scaleTransition,
        duration: 3000,
        splashIconSize: 420,
      ),
    );
  }
}
