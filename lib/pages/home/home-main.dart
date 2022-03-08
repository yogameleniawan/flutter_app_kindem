import 'package:flutter/material.dart';
import 'package:flutter_app_stulish/helpers/sizes_helpers.dart';
import 'package:flutter_app_stulish/models/user.dart';
import 'package:flutter_app_stulish/pages/categories/categories-main.dart';
import 'package:flutter_app_stulish/pages/home/components/banner.dart';
import 'package:flutter_app_stulish/pages/profiles/profile-detail.dart';
import 'package:flutter_app_stulish/pages/profiles/profile-setting.dart';
import 'package:flutter_app_stulish/pages/scores/score-main.dart';
import 'package:flutter_app_stulish/services/auth.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:showcaseview/showcaseview.dart';
import 'components/course-card.dart';
import 'components/search-friend.dart';

class HomeMain extends StatefulWidget {
  HomeMain({Key? key}) : super(key: key);

  @override
  _HomeMainState createState() => _HomeMainState();
}

class _HomeMainState extends State<HomeMain> {
  PageController pageController = new PageController();
  bool isTest = false;
  User user = new User();
  GlobalKey _one = GlobalKey();
  GlobalKey _two = GlobalKey();
  late BuildContext myContext;
  @override
  void initState() {
    super.initState();
    pageController = PageController(viewportFraction: 6.0);
    getUser();

    WidgetsBinding.instance!.addPostFrameCallback(
      (_) => ShowCaseWidget.of(myContext)!.startShowCase([_one, _two]),
    );
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

  @override
  Widget build(BuildContext context) {
    return ShowCaseWidget(
      builder: Builder(builder: (context) {
        myContext = context;
        return Scaffold(
          backgroundColor: Color(0xFFF1F1F1),
          body: SingleChildScrollView(
            child: Container(
              child: Padding(
                padding: const EdgeInsets.only(top: 50, right: 20, left: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 5, bottom: 20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Helo",
                                      style: TextStyle(color: Colors.black),
                                    ),
                                    Text(
                                      user.name,
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 24),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Showcase(
                          key: _one,
                          description: 'Ketuk ini untuk melihat profile kamu',
                          child: InkWell(
                            onTap: () {
                              Navigator.of(context).push(
                                PageRouteBuilder(
                                  transitionDuration:
                                      Duration(milliseconds: 500),
                                  pageBuilder: (BuildContext context,
                                      Animation<double> animation,
                                      Animation<double> secondaryAnimation) {
                                    return ProfileSetting();
                                  },
                                  transitionsBuilder: (BuildContext context,
                                      Animation<double> animation,
                                      Animation<double> secondaryAnimation,
                                      Widget child) {
                                    return Align(
                                      child: FadeTransition(
                                        opacity: animation,
                                        child: child,
                                      ),
                                    );
                                  },
                                ),
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Image(
                                image:
                                    AssetImage("assets/images/user_icon.png"),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    BannerHome(),
                    SearchFriend(),
                    Text("Materi yang sedang kamu kerjakan"),
                    CourseCard(),
                    CourseCard(),
                    CourseCard(),
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
