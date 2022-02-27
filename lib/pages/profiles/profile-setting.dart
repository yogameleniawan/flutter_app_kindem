import 'package:bouncing_widget/bouncing_widget.dart';
import 'package:flutter/material.dart';

class ProfileSetting extends StatefulWidget {
  const ProfileSetting({Key? key}) : super(key: key);
  @override
  _ProfileSettingState createState() => _ProfileSettingState();
}

class _ProfileSettingState extends State<ProfileSetting> {
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Color(0xFF0074CD),
        body: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 40, vertical: 70),
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(bottom: 70),
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
                                  "Nama User Sing Paling Dowo Dewe",
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
                  margin: EdgeInsets.only(top: 20.0),
                  width: MediaQuery.of(context).size.width * 50,
                  height: MediaQuery.of(context).size.height * 0.6,
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
                  child: Column(
                    children: [
                      Container(
                        margin: EdgeInsets.symmetric(
                          horizontal: 25.0,
                        ),
                        padding: EdgeInsets.symmetric(vertical: 35.0),
                        // color: Colors.red,
                        child: Column(
                          children: [
                            Container(
                              child: ResultDetail(),
                            ),

                            Container(
                              margin:
                                  EdgeInsets.only(left: 6, right: 6, top: 25),
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
                                  contentPadding: const EdgeInsets.symmetric(
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
                              margin:
                                  EdgeInsets.only(left: 6, right: 6, top: 25),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Color(0xFFF5A720),
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: TextFormField(
                                // controller: ,
                                initialValue: "Nama User",
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
                                  prefixIcon: Icon(Icons.text_fields,
                                      color: Colors.black),
                                  suffixIcon:
                                      Icon(Icons.edit, color: Colors.black),
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
                              margin: EdgeInsets.only(top: 35),
                              child: Button(),
                            ),
                          ],
                        ),
                      )
                    ],
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
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 30, horizontal: 30),
            margin: EdgeInsets.symmetric(horizontal: 6),
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
              children: [
                Container(
                  child: Text(
                    "25",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 67,
                    ),
                  ),
                ),
                Container(
                    child: Text(
                  "Materi yang",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                )),
                Container(
                    child: Text(
                  "diselesaikan",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                )),
              ],
            ),
          ),
        ),
        Expanded(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 6),
            padding: EdgeInsets.symmetric(vertical: 30, horizontal: 30),
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
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  child: Text(
                    "25",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 67,
                    ),
                  ),
                ),
                Container(
                    child: Text(
                  "Exp yang",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                )),
                Container(
                    child: Text(
                  "diselesaikan",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                )),
              ],
            ),
          ),
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
          onPressed: () {},
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
            margin: EdgeInsets.symmetric(horizontal: 6),
            decoration: BoxDecoration(
              color: Color(0xFFF5A720),
              borderRadius: BorderRadius.circular(20.0),
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
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
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
            margin: EdgeInsets.symmetric(horizontal: 6),
            padding: EdgeInsets.symmetric(vertical: 15, horizontal: 22),
            decoration: BoxDecoration(
              color: Color(0xFFF5A720),
              borderRadius: BorderRadius.circular(20.0),
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
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
