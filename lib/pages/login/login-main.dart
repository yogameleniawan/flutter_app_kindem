import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF007251),
      body: SingleChildScrollView(
        child: Container(
            child: Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 40, bottom: 20),
                child: Text("Login Page",
                    style: TextStyle(color: Colors.white, fontSize: 20)),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 40),
                child: Text(
                  "STULISH",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 40,
                      fontWeight: FontWeight.bold),
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
                        labelText: 'Email',
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
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0.0, 16.0, 0.0, 0.0),
                child: Text(
                  _errorMessage,
                  style: TextStyle(color: Colors.red),
                ),
              ),
              InkWell(
                onTap: () async {
                  setState(() {
                    _errorMessage = "";
                  });
                  bool result =
                      await Provider.of<AuthProvider>(context, listen: false)
                          .login(emailController.text, passwordController.text);
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
                      color: Color(0xFFFFD900),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 15, bottom: 15, left: 30, right: 30),
                      child: Text(
                        "Login",
                        style: TextStyle(
                            color: Color(0xFF007251),
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        )),
      ),
    );
  }
}
