import 'package:coachmaker/coachmaker.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_stulish/helpers/sizes_helpers.dart';
import 'package:flutter_app_stulish/models/course.dart';
import 'package:flutter_app_stulish/models/user.dart';
import 'package:flutter_app_stulish/pages/components/perloader-page.dart';
import 'package:flutter_app_stulish/pages/materi/materi-main.dart';
import 'package:flutter_app_stulish/pages/components/choach-maker.dart';
import 'package:flutter_app_stulish/pages/courses/courses-test.dart';
import 'package:flutter_app_stulish/pages/chapter/chapter-main.dart';
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
  List courses = [];
  List<CoachModel> listCoachModel = [];
  bool _isLoad = true;
  @override
  void initState() {
    super.initState();
    pageController = PageController(viewportFraction: 6.0);
    getUser();
    getCourses();
    addSession();
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
        _isLoad = false;
      });
    }
  }

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

  Future addSession() async {
    final String uri = dotenv.get('API_URL') + "/api/v1/addSession";

    String? token =
        await Provider.of<AuthProvider>(context, listen: false).getToken();
    http.Response result = await http.get(Uri.parse(uri), headers: {
      'Authorization': 'Bearer $token',
    });
    if (result.statusCode == HttpStatus.ok) {
      final jsonResponse = json.decode(result.body);
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
      tutorialCheck();
    }
  }

  Future tutorialCheck() async {
    final String uri = dotenv.get('API_URL') + "/api/v1/tutorialCheck";

    String? token =
        await Provider.of<AuthProvider>(context, listen: false).getToken();
    http.Response result = await http.post(Uri.parse(uri), headers: {
      'Authorization': 'Bearer $token',
    }, body: {
      'page': 'home-main',
    });

    if (result.statusCode == HttpStatus.ok) {
      final jsonResponse = json.decode(result.body);

      if (jsonResponse['is_done'] == false) {
        initTutorial();
      }
    }
  }

  initTutorial() {
    initializeCoachModel();
    coachMaker(context, listCoachModel).show();
  }

  initializeCoachModel() {
    setState(() {
      listCoachModel = [
        CoachModel(
            initial: 'profile',
            title: 'Profile Kamu',
            maxWidth: 400,
            subtitle: [
              '1. Kamu dapat menekan tombol ini untuk berpindah ke halaman profile',
            ],
            header: Image.asset(
              'assets/images/user_icon.png',
              height: 50,
              width: 50,
            )),
        CoachModel(
            initial: 'btn-materi',
            title: 'Tombol untuk mencari materi',
            maxWidth: 400,
            subtitle: [
              '1. Kamu dapat menekan tombol ini untuk mencari materi yang akan kamu pelajari',
            ]),
        CoachModel(
          initial: 'btn-teman',
          title: 'Tombol untuk melihat teman-teman kamu',
          maxWidth: 400,
          subtitle: [
            'Kamu dapat menekan tombol ini untuk melihat siapa saja teman kamu.',
          ],
        ),
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoad) {
      return PreloaderPage();
    } else {
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
                            padding: const EdgeInsets.only(top: 5, bottom: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: Text(
                                    "Hai ...",
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                                Text(
                                  user.name,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    CoachPoint(
                      initial: 'profile',
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
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
                          ).then((_) {
                            getUser();
                          });
                        },
                        child: CircleAvatar(
                          backgroundColor: Colors.transparent,
                          maxRadius: displayHeight(context) * 0.06,
                          backgroundImage: getBorder(user.level),
                          child: CircleAvatar(
                            backgroundColor: Colors.transparent,
                            maxRadius: displayHeight(context) * 0.035,
                            backgroundImage: user.photo == null
                                ? AssetImage("assets/images/user_icon_big.png")
                                : AssetImage(user.photo.toString()),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(top: displayHeight(context) * 0.05),
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
                        child: CoachPoint(
                          initial: 'btn-materi',
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
                          ),
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
                                            left: displayWidth(context) * 0.05),
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
                                                  Text(courses[index].sub_name,
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold)),
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
    }
  }
}
