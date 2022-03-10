import 'package:bouncing_widget/bouncing_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_stulish/helpers/sizes_helpers.dart';
import 'package:flutter_app_stulish/models/user.dart';
import 'package:flutter_app_stulish/services/auth.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

class ProfileSetting extends StatefulWidget {
  const ProfileSetting({Key? key}) : super(key: key);
  @override
  _ProfileSettingState createState() => _ProfileSettingState();
}

class _ProfileSettingState extends State<ProfileSetting> {
  PageController pageController = new PageController();
  TextEditingController usernameController = new TextEditingController();
  User user = new User();

  @override
  void initState() {
    super.initState();
    pageController = PageController(viewportFraction: 6.0);
    getUser();
  }

  void getUser() async {
    final String uri = "https://stulish-rest-api.herokuapp.com/api/v1/user";
    String? token =
        await Provider.of<AuthProvider>(context, listen: false).getToken();
    http.Response result = await http.get(Uri.parse(uri), headers: {
      'Authorization': 'Bearer $token',
    });
    if (result.statusCode == HttpStatus.ok) {
      final jsonResponse = json.decode(result.body);
      var users = User.toString(jsonResponse);
      setState(() {
        user = users;
      });
    }
  }

  Widget build(BuildContext context) {
    usernameController.text = user.name;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Color(0xFF0074CD),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 25, vertical: 50),
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(bottom: 55),
                  child: Row(
                    children: [
                      CircleAvatar(
                        maxRadius:
                            MediaQuery.of(context).size.height * 0.1 / 1.8,
                        backgroundColor: Colors.white,
                        // backgroundColor: Color(color),
                        child: Container(
                          height: 100,
                          child: Image(
                            width: 100,
                            // color: Colors.white,
                            image: AssetImage("assets/images/kindem-logo.png"),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.only(left: 20),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  user.name,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 25.0,
                                  ),
                                ),
                                Text(
                                  "CITIZEN/RAKYAT BIASA (LVL1)",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 15.0,
                                  ),
                                ),
                              ]),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 15.0),
                  width: displayWidth(context) * 40,
                  height: displayHeight(context) * 0.65,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20.0),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          offset: Offset(0, 9),
                          blurRadius: 20,
                          spreadRadius: 1),
                    ],
                  ),
                  child: Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: 18.0,
                    ),
                    padding: EdgeInsets.symmetric(vertical: 35.0),
                    // color: Colors.red,
                    child: Column(
                      children: [
                        ResultDetail(),
                        // Container(
                        //   child: ResultDetail(),
                        // ),

                        Container(
                          margin: EdgeInsets.only(top: 27),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                            color: Colors.grey[400],
                          ),
                          child: TextFormField(
                            // controller: ,
                            obscureText: true,
                            enabled: false,
                            decoration: InputDecoration(
                              hintText: '123456789',
                              hintStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 1.0, horizontal: 1.0),
                              prefixIcon: Icon(Icons.person_outline,
                                  color: Colors.black),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                // borderSide: ,
                              ),
                            ),
                          ),
                        ),

                        Container(
                          margin: EdgeInsets.only(top: 17),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Color(0xFFF5A720),
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: TextFormField(
                            // controller: ,
                            controller: usernameController,
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),

                            decoration: InputDecoration(
                              hintText: 'Nama User',
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 1.0, horizontal: 1.0),
                              hintStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                              prefixIcon:
                                  Icon(Icons.text_fields, color: Colors.black),
                              suffixIcon: Icon(Icons.edit, color: Colors.black),
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    width: 1, color: Color(0xFFF5A720)),
                                borderRadius: BorderRadius.circular(6.0),
                                // borderSide: ,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    width: 1, color: Colors.red),
                                borderRadius: BorderRadius.circular(6.0),
                              ),
                            ),
                          ),
                        ),

                        //button
                        Container(
                          margin: EdgeInsets.only(top: 33),
                          child: Button(),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget ResultDetail() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          width: displayWidth(context) * 0.35,
          height: displayHeight(context) * 0.19,
          padding: EdgeInsets.symmetric(
              horizontal: displayWidth(context) * 0.04,
              vertical: displayHeight(context) * 0.01),
          decoration: BoxDecoration(
            color: Color(0xFFF5A720),
            borderRadius: BorderRadius.circular(10.0),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.09),
                  offset: Offset(0, 9),
                  blurRadius: 8,
                  spreadRadius: 1),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "12",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 36.2,
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: displayHeight(context) * 0.015),
                child: Text(
                  "Materi yang diselesaikan",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    // fontWeight: FontWeight.bold,
                    // fontSize: 36.4,
                  ),
                ),
              ),
            ],
          ),
          // Text("25"),
        ),
        Container(
          width: displayWidth(context) * 0.35,
          height: displayHeight(context) * 0.19,
          padding: EdgeInsets.symmetric(
              horizontal: displayWidth(context) * 0.04,
              vertical: displayHeight(context) * 0.01),
          decoration: BoxDecoration(
            color: Color(0xFFF5A720),
            borderRadius: BorderRadius.circular(10.0),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.09),
                  offset: Offset(0, 9),
                  blurRadius: 8,
                  spreadRadius: 1),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "40",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 36.2,
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: displayHeight(context) * 0.015),
                child: Text(
                  "Exp yang didapatkan",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    // fontWeight: FontWeight.bold,
                    // fontSize: 36.4,
                  ),
                ),
              ),
            ],
          ),
          // Text("25"),
        ),
      ],
    );
  }

  Widget Button() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        BouncingWidget(
          duration: Duration(milliseconds: 90),
          scaleFactor: 2.0,
          onPressed: () {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return Dialog(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0)),
                    child: Container(
                      constraints: BoxConstraints(
                          maxHeight: displayHeight(context) * 0.4),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: displayWidth(context) * 0.06),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              child: TextFormField(
                                // controller: ,
                                obscureText: true,
                                decoration: InputDecoration(
                                  labelText: 'Password Lama',
                                  hintText: 'Password Lama',
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 1.0, horizontal: 10.0),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0),

                                    // borderSide: ,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 20),
                              child: TextFormField(
                                // controller: ,
                                obscureText: true,
                                decoration: InputDecoration(
                                  labelText: 'Password Baru',
                                  hintText: 'Password Baru',
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 1.0, horizontal: 10.0),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0),

                                    // borderSide: ,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 30),
                              width: displayWidth(context) * 0.33,
                              padding: EdgeInsets.symmetric(
                                  vertical: displayHeight(context) * 0.02),
                              // height: displayHeight(context) * 0.04,
                              // padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                              // margin: EdgeInsets.symmetric(horizontal: 6),
                              decoration: BoxDecoration(
                                color: Color(0xFFF5A720),
                                borderRadius: BorderRadius.circular(15.0),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.black.withOpacity(0.20),
                                      offset: Offset(2, 6),
                                      blurRadius: 7,
                                      spreadRadius: 2),
                                ],
                              ),
                              child: Text(
                                "UBAH",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                });
          },
          child: Container(
            width: displayWidth(context) * 0.35,
            padding:
                EdgeInsets.symmetric(vertical: displayHeight(context) * 0.02),
            // height: displayHeight(context) * 0.04,
            // padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
            // margin: EdgeInsets.symmetric(horizontal: 6),
            decoration: BoxDecoration(
              color: Color(0xFFF5A720),
              borderRadius: BorderRadius.circular(15.0),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.20),
                    offset: Offset(2, 6),
                    blurRadius: 7,
                    spreadRadius: 2),
              ],
            ),
            child: Text(
              "UBAH PASSWORD",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        BouncingWidget(
          duration: Duration(milliseconds: 90),
          scaleFactor: 2.0,
          onPressed: () {},
          child: Container(
            width: displayWidth(context) * 0.35,
            // margin: EdgeInsets.symmetric(horizontal: 6),
            padding:
                EdgeInsets.symmetric(vertical: displayHeight(context) * 0.02),
            decoration: BoxDecoration(
              color: Color(0xFFF5A720),
              borderRadius: BorderRadius.circular(15.0),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.20),
                    offset: Offset(2, 6),
                    blurRadius: 7,
                    spreadRadius: 2),
              ],
            ),
            child: Text(
              "GANTI FOTO",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
