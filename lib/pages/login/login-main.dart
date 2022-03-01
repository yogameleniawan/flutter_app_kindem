import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_stulish/helpers/sizes_helpers.dart';
import 'package:flutter_app_stulish/services/auth.dart';
import 'package:provider/provider.dart';

class LoginMain extends StatefulWidget {
  LoginMain({Key? key}) : super(key: key);

  @override
  _LoginMainState createState() => _LoginMainState();
}

class _LoginMainState extends State<LoginMain> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  String _errorMessage = "";
  bool _isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0074CD),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              margin: EdgeInsets.only(
                bottom: displayHeight(context) * 0.01,
                top: displayHeight(context) * 0.23,
                left: displayWidth(context) * 0.1,
                right: displayWidth(context) * 0.1,
              ),
              padding: EdgeInsets.only(top: 50),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20.0),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        offset: Offset(0, 9),
                        blurRadius: 20,
                        spreadRadius: 1)
                  ]),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      top: displayHeight(context) * 0.08,
                      bottom: displayHeight(context) * 0.03,
                    ),
                    child: Text(
                      "LOGIN",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 30,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 10, bottom: 10, right: 20, left: 20),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        child: TextFormField(
                          controller: emailController,
                          decoration: InputDecoration(
                            labelText: 'Username',
                            prefixIcon:
                                Icon(Icons.person_outline, color: Colors.black),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 10, bottom: 10, right: 20, left: 20),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        child: TextFormField(
                          controller: passwordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            prefixIcon:
                                Icon(Icons.lock_outline, color: Colors.black),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                        0.0, displayHeight(context) * 0.02, 0.0, 0.0),
                    child: Text(
                      _errorMessage,
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                  _isLoading == false
                      ? Padding(
                          padding: EdgeInsets.only(
                              bottom: displayHeight(context) * 0.1),
                          child: InkWell(
                            onTap: () async {
                              setState(() {
                                _errorMessage = "";
                                _isLoading = !_isLoading;
                              });
                              bool result = await Provider.of<AuthProvider>(
                                      context,
                                      listen: false)
                                  .login(emailController.text,
                                      passwordController.text);
                              if (result == false) {
                                setState(() {
                                  _errorMessage = 'Email or Password Wrong';
                                });
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 10, bottom: 10, right: 20, left: 20),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Color(0xFFF5A720),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 15, bottom: 15, left: 30, right: 30),
                                  child: Text(
                                    "Login",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                      : Padding(
                          padding: EdgeInsets.only(
                              bottom: displayHeight(context) * 0.1),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Color(0xFFF5A720),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 15, bottom: 15, left: 30, right: 30),
                              child: CircularProgressIndicator(
                                  color: Colors.white),
                            ),
                          ),
                        ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  top: displayHeight(context) * 0.1,
                  left: displayWidth(context) * 0.25),
              child: Image(
                width: displayWidth(context) * 0.5,
                image: AssetImage("assets/images/kindem-logo.png"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
