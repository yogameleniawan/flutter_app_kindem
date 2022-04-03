import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_stulish/helpers/sizes_helpers.dart';
import 'package:flutter_app_stulish/models/course.dart';
import 'package:flutter_app_stulish/models/user.dart';
import 'package:flutter_app_stulish/pages/chapter/categories-main.dart';
import 'package:flutter_app_stulish/pages/courses/courses-test.dart';
import 'package:flutter_app_stulish/pages/level/level-main.dart';
import 'package:flutter_app_stulish/pages/profiles/profile-setting.dart';
import 'package:flutter_app_stulish/services/auth.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:showcaseview/showcaseview.dart';
import 'components/search-friend.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

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
  List courses = [];
  late BuildContext myContext;
  @override
  void initState() {
    super.initState();
    pageController = PageController(viewportFraction: 6.0);
    getUser();
    getCourses();
    WidgetsBinding.instance!.addPostFrameCallback(
      (_) => ShowCaseWidget.of(myContext)!.startShowCase([_one, _two]),
    );
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

  Future getCourses() async {
    final String uri = dotenv.get('API_URL') + "/api/v1/getIncompleteCourses";

    String? token =
        await Provider.of<AuthProvider>(context, listen: false).getToken();
    http.Response result = await http.get(Uri.parse(uri), headers: {
      'Authorization': 'Bearer $token',
    });
    if (result.statusCode == HttpStatus.ok) {
      final jsonResponse = json.decode(result.body);
      List courseMap = jsonResponse['data'];
      List course = courseMap.map((i) => Courses.incompleteCourse(i)).toList();
      setState(() {
        courses = course;
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
          body: Container(
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
                                transitionDuration: Duration(milliseconds: 500),
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
                          child: CircleAvatar(
                            maxRadius: displayHeight(context) * 0.043,
                            backgroundImage: user.photo.toString().isNotEmpty
                                ? AssetImage(user.photo.toString())
                                : AssetImage("assets/images/user_icon_big.png"),
                          ),
                        ),
                      )
                    ],
                  ),
                  Padding(
                    padding:
                        EdgeInsets.only(top: displayHeight(context) * 0.05),
                    child: Stack(children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image(
                          image: AssetImage("assets/images/banner.jpg"),
                        ),
                      ),
                      Positioned(
                          top: displayHeight(context) * 0.15,
                          left: displayWidth(context) * 0.05,
                          child: InkWell(
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(
                                  builder: (BuildContext context) {
                                // return CategoriesMain();
                                return LevelMain();
                              })).then((value) {
                                getCourses();
                              });
                            },
                            child: Container(
                                padding: EdgeInsets.fromLTRB(
                                  displayWidth(context) * 0.02,
                                  displayHeight(context) * 0.01,
                                  displayWidth(context) * 0.02,
                                  displayHeight(context) * 0.01,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Color(0xFFF5A71F),
                                ),
                                child: Text(
                                  'Cari Materi',
                                  style: TextStyle(color: Colors.white),
                                )),
                          ))
                    ]),
                  ),
                  SearchFriend(),
                  Text("Materi yang sedang kamu kerjakan"),
                  Expanded(
                      child: ListView.builder(
                          itemCount: courses.length,
                          itemBuilder: (context, int index) {
                            return Builder(builder: (context) {
                              return InkWell(
                                onTap: () {
                                  Navigator.push(context, MaterialPageRoute(
                                      builder: (BuildContext context) {
                                    return CourseTest(
                                      id_sub_category:
                                          courses[index].sub_category_id,
                                      is_redirect: true,
                                    );
                                  })).then((value) {
                                    getCourses();
                                  });
                                  ;
                                },
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      top: displayHeight(context) * 0.01,
                                      bottom: displayHeight(context) * 0.01),
                                  child: Container(
                                    width: displayWidth(context) * 1,
                                    height: displayHeight(context) * 0.1,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left:
                                                  displayWidth(context) * 0.05),
                                          child: Row(
                                            children: [
                                              ExtendedImage.network(
                                                courses[index].category_image,
                                                fit: BoxFit.fill,
                                                cache: true,
                                              ),
                                              Padding(
                                                padding: EdgeInsets.only(
                                                  left: displayWidth(context) *
                                                      0.03,
                                                ),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                        courses[index].sub_name,
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold)),
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          top: displayHeight(
                                                                  context) *
                                                              0.01),
                                                      child: Text(
                                                          "Chapter " +
                                                              courses[index]
                                                                  .category_name,
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal)),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              right:
                                                  displayWidth(context) * 0.03),
                                          child: CircularPercentIndicator(
                                            radius: 20.0,
                                            lineWidth: 3.0,
                                            percent: ((courses[index].complete /
                                                courses[index].total)),
                                            center: new Text(
                                                ((courses[index].complete /
                                                                courses[index]
                                                                    .total) *
                                                            100)
                                                        .toStringAsFixed(0) +
                                                    "%"),
                                            progressColor: Color(0xFFF5A71F),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            });
                          })),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
