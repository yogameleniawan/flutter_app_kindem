import 'package:bouncing_widget/bouncing_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_stulish/helpers/sizes_helpers.dart';

class ChangeAvatar extends StatefulWidget {
  const ChangeAvatar({Key? key}) : super(key: key);

  @override
  State<ChangeAvatar> createState() => _ChangeAvatarState();
}

class _ChangeAvatarState extends State<ChangeAvatar> {
  List<bool> isSelected = [true, false, false, false, false, false];
  List<String> avatarList = [
    "assets/images/avatar-1.jpg",
    "assets/images/avatar-2.jpg",
    "assets/images/avatar-3.jpg",
    "assets/images/avatar-4.jpg",
    "assets/images/avatar-5.jpg",
    "assets/images/avatar-6.jpg",
  ];

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
                          backgroundImage:
                              AssetImage("assets/images/user_icon_big.png"),
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
                                        borderRadius: BorderRadius.circular(50),
                                        border: Border.all(
                                          width: 2,
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
                                onPressed: () {}),
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
