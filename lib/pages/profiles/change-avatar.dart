import 'package:bouncing_widget/bouncing_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_stulish/helpers/sizes_helpers.dart';
import 'package:flutter_app_stulish/models/user.dart';
import 'package:flutter_app_stulish/services/auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

class ChangeAvatar extends StatefulWidget {
  const ChangeAvatar({Key? key}) : super(key: key);
  
  @override
  State<ChangeAvatar> createState() => _ChangeAvatarState();
}

class _ChangeAvatarState extends State<ChangeAvatar> {
  User user = new User();
  List<bool> isSelected = [true, false, false, false, false, false];
  List<String> avatarList = [
    "assets/images/avatar-1.jpg",
    "assets/images/avatar-2.jpg",
    "assets/images/avatar-3.jpg",
    "assets/images/avatar-4.jpg",
    "assets/images/avatar-5.jpg",
    "assets/images/avatar-6.jpg",
  ];
  String? avatarPath;

  @override
  void initState() {
    super.initState();
    getUser();
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
        user = users;
      });
    }
  }

  int indexAvatar = 0;
  void setAvatar() {
    setState(() {
      if (indexAvatar == 0) {
        avatarPath = "assets/images/avatar-1.jpg";
      } else if (indexAvatar == 1) {
        avatarPath = "assets/images/avatar-2.jpg";
      } else if (indexAvatar == 2) {
        avatarPath = "assets/images/avatar-3.jpg";
      } else if (indexAvatar == 3) {
        avatarPath = "assets/images/avatar-4.jpg";
      } else if (indexAvatar == 4) {
        avatarPath = "assets/images/avatar-5.jpg";
      } else if (indexAvatar == 5) {
        avatarPath = "assets/images/avatar-6.jpg";
      }
    });
  }

  Future updateAvatar(String avatar) async {
    final String uri = dotenv.get('API_URL') + "/api/v1/updateProfile";
    String? token =
        await Provider.of<AuthProvider>(context, listen: false).getToken();
    http.Response result = await http.post(Uri.parse(uri), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    }, body: {
      'profile_photo_path': avatar,
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          // extendBodyBehindAppBar: true,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.grey[200],
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios_new_rounded,
                  color: Color(0xFFF5A720)),
              onPressed: () {
                // Navigator.of(context)
                //     .pop(MaterialPageRoute(builder: (context) => ProfileSetting()));
                Navigator.of(context).pop();
              },
            ),
            title: Text(
              "GANTI AVATAR",
              style: TextStyle(color: Colors.black),
            ),
          ),
          body: Container(
            child: SingleChildScrollView(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25, vertical: 30),
                  child: Container(
                    child: Column(
                      children: [
                        Container(
                            margin: EdgeInsets.only(
                                bottom: displayHeight(context) * 0.01),
                            child: Text("Avatar Kamu")),
                        CircleAvatar(
                          maxRadius: displayHeight(context) * 0.11,
                          backgroundImage: user.photo.toString().isNotEmpty
                              ? AssetImage(user.photo.toString())
                              : AssetImage("assets/images/user_icon_big.png"),
                          // backgroundColor: Colors.blue,
                          // child: Image(
                          //   image:
                          //       AssetImage("assets/images/user_icon_big.png"),
                          // ),
                        ),
                        Container(
                          margin: EdgeInsets.only(
                              top: displayHeight(context) * 0.04),
                          child: Text("Pilih avatar baru kamu:"),
                        ),
                        Container(
                          margin: EdgeInsets.only(
                              top: displayHeight(context) * 0.015),
                          child: Ink(
                            width: displayWidth(context) * 0.9,
                            height: displayHeight(context) * 0.35,
                            child: Center(
                              child: GridView.count(
                                physics: NeverScrollableScrollPhysics(),
                                crossAxisCount: 3,
                                crossAxisSpacing: 8,
                                mainAxisSpacing: 8,
                                childAspectRatio: 1,
                                children:
                                    List.generate(isSelected.length, (index) {
                                  return InkWell(
                                    highlightColor: Colors.transparent,
                                    focusColor: Colors.transparent,
                                    hoverColor: Colors.transparent,
                                    splashColor: Colors.transparent,
                                    onTap: () {
                                      setState(() {
                                        for (int indexBtn = 0;
                                            indexBtn < isSelected.length;
                                            indexBtn++) {
                                          if (indexBtn == index) {
                                            isSelected[indexBtn] = true;
                                            indexAvatar = indexBtn;
                                          } else {
                                            isSelected[indexBtn] = false;
                                          }
                                        }
                                      });
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: isSelected[index]
                                            ? Color(0xffD6EAF8)
                                            : Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        border: Border.all(
                                          width: 3.5,
                                          color: isSelected[index]
                                              ? Color(0xFF0074CD)
                                              : Color(0xFFF5A720),
                                        ),
                                      ),
                                      child: CircleAvatar(
                                          maxRadius: displayHeight(context) *
                                              0.1 /
                                              1.4,
                                          backgroundImage:
                                              AssetImage(avatarList[index])),
                                    ),
                                  );
                                }),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(
                              top: displayHeight(context) * 0.03),
                          child: Center(
                            child: BouncingWidget(
                                duration: Duration(milliseconds: 90),
                                scaleFactor: 2.0,
                                child: Container(
                                  width: displayWidth(context) * 0.3,
                                  padding: EdgeInsets.symmetric(
                                      vertical: displayHeight(context) * 0.02),
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
                                    "GANTI",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                onPressed: () async {
                                  setAvatar();
                                  print(avatarPath);
                                  await updateAvatar(avatarPath.toString());
                                  Navigator.pop(context, false);
                                  MotionToast(
                                          icon: Icons
                                              .check_circle_outline_outlined,
                                          primaryColor: Color(0xFFBBDDFB),
                                          height: displayHeight(context) * 0.07,
                                          width: displayWidth(context) * 0.8,
                                          description:
                                              Text("Avatar berhasil diubah"))
                                      .show(context);
                                }),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ));
  }
}
