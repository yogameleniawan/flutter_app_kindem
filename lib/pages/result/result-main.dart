import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';
import 'package:kindem_app/helpers/sizes_helpers.dart';
import 'package:kindem_app/models/score.dart';
import 'package:kindem_app/models/user.dart';
import 'package:kindem_app/pages/components/perloader-page.dart';
import 'package:kindem_app/pages/home/home-main.dart';
import 'package:kindem_app/pages/result/components/dialog-level.dart';
import 'package:kindem_app/services/auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';

class ResultMain extends StatefulWidget {
  ResultMain({
    Key? key,
    required this.id_sub_category,
  }) : super(key: key);
  final String id_sub_category;
  @override
  _ResultMainState createState() => _ResultMainState();
}

class _ResultMainState extends State<ResultMain> {
  Score score = new Score();
  User user = new User();
  var user_level;
  var next_level;
  var next_point_level;
  var total_score;
  var user_photo;
  bool is_done = false;
  AssetImage getBorder(String level) {
    if (level == "Emperor") {
      return AssetImage("assets/images/1-emperor.png");
    } else if (level == "King") {
      return AssetImage("assets/images/2-king.png");
    } else if (level == "Duke") {
      return AssetImage("assets/images/3-duke.png");
    } else if (level == "Prince") {
      return AssetImage("assets/images/4-prince.png");
    } else if (level == "Knight") {
      return AssetImage("assets/images/5-knight.png");
    } else {
      return AssetImage("assets/images/6-citizen.png");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUser();
    getScore();
  }

  void getUser() async {
    final String uri = dotenv.get('API_URL') + "/api/v1/user";
    String? token =
        await Provider.of<AuthProvider>(context, listen: false).getToken();
    http.Response result = await http.get(Uri.parse(uri), headers: {
      'Authorization': 'Bearer $token',
    });
    if (result.statusCode == HttpStatus.ok) {
      final jsonResponse = json.decode(result.body);
      var users = User.toString(jsonResponse);
      setState(() {
        user_photo = jsonResponse['profile_photo_path'];
      });
    }
  }

  Future getScore() async {
    final String uri = dotenv.get('API_URL') +
        "/api/v1/getScore?sub_category_id=" +
        widget.id_sub_category;
    String? token =
        await Provider.of<AuthProvider>(context, listen: false).getToken();
    http.Response result = await http.get(Uri.parse(uri), headers: {
      'Authorization': 'Bearer $token',
    });
    if (result.statusCode == HttpStatus.ok) {
      final jsonResponse = json.decode(result.body);
      var scores = Score.getScore(jsonResponse);
      setState(() {
        score = scores;
        user_level = jsonResponse['user_level'];
        next_level = jsonResponse['next_level'];
        next_point_level = jsonResponse['next_point_level'];
        total_score = jsonResponse['total_score'];
        is_done = true;
      });
      if (jsonResponse['level_up'] == true) {
        showAlertDialog(context);
      }
    }
  }

  Future reloadTest() async {
    final String uri = dotenv.get('API_URL') +
        "/api/v1/reloadTest?sub_category_id=" +
        widget.id_sub_category;
    String? token =
        await Provider.of<AuthProvider>(context, listen: false).getToken();
    http.Response result = await http.get(Uri.parse(uri), headers: {
      'Authorization': 'Bearer $token',
    });
    if (result.statusCode == HttpStatus.ok) {
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return is_done
        ? MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(
              backgroundColor: Color(0xFF0067B6),
              body: Container(
                  child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: displayWidth(context) * 0.1,
                  vertical: displayHeight(context) * 0.02,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Image(
                    //   width: displayWidth(context) * 1,
                    //   image: AssetImage("assets/images/user_icon_big.png"),
                    // ),
                    Container(
                      margin:
                          EdgeInsets.only(top: displayHeight(context) * 0.1),
                      child: Stack(
                        children: [
                          Container(
                            alignment: Alignment.center,
                            padding: EdgeInsets.only(
                                top: displayHeight(context) * 0.051),
                            child: CircleAvatar(
                              backgroundColor: Colors.transparent,
                              maxRadius: displayWidth(context) * 0.13,
                              backgroundImage: user_photo == null
                                  ? AssetImage(
                                      "assets/images/user_icon_big.png")
                                  : AssetImage(user_photo.toString()),
                            ),
                          ),
                          Container(
                            alignment: Alignment.center,
                            margin: EdgeInsets.only(bottom: 40),
                            child: CircleAvatar(
                              backgroundColor: Colors.transparent,
                              maxRadius: displayWidth(context) * 0.23,
                              backgroundImage: getBorder(user_level),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        Text("SCORE",
                            style: TextStyle(
                                fontSize: 60,
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
                        Text(
                          score.is_true.toString() +
                              "/" +
                              score.total_test.toString(),
                          style: TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ],
                    ),
                    Text(
                      " + " + score.is_true.toString(),
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    Center(
                        child: FAProgressBar(
                      backgroundColor: Colors.white,
                      progressColor: Color(0xFFF5A71F),
                      currentValue: total_score,
                      maxValue: next_point_level,
                      size: 10,
                    )),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          user_level.toString(),
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                        Text(
                          total_score.toString() +
                              " / " +
                              next_point_level.toString(),
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                        Text(
                          next_level.toString(),
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 80),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(builder: (c) => HomeMain()),
                                  (route) => false);
                            },
                            child: Image(
                              width: displayWidth(context) * 0.15,
                              image: AssetImage("assets/images/home.png"),
                            ),
                          ),
                          InkWell(
                            onTap: () async {
                              bool reload = await reloadTest();
                              if (reload) {
                                Navigator.pop(context, true);
                              }
                            },
                            child: Image(
                              width: displayWidth(context) * 0.15,
                              image: AssetImage("assets/images/reload.png"),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              )),
            ))
        : PreloaderPage();
  }

  showAlertDialog(BuildContext context) {
    showGeneralDialog(
      barrierLabel: "Dialog",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: Duration(milliseconds: 400),
      context: context,
      pageBuilder: (context, anim1, anim2) {
        return DialogLevel(
          textDialog: "Selamat! kamu naik level menjadi " + next_level,
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return SlideTransition(
          position:
              Tween(begin: Offset(0, 1), end: Offset(0, 0)).animate(anim1),
          child: child,
        );
      },
    );
  }
}
