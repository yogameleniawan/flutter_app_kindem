import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_stulish/helpers/sizes_helpers.dart';
import 'package:flutter_app_stulish/models/course.dart';
import 'package:flutter_app_stulish/pages/courses/courses-test.dart';
import 'package:flutter_app_stulish/services/auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:skeletons/skeletons.dart';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

import 'package:flutter_tts/flutter_tts.dart';

import 'components/dialog-message.dart';
import 'components/image-course.dart';
import 'components/next-button.dart';
import 'components/prev-button.dart';
import 'components/skeleton-course-text.dart';
import 'components/text-course.dart';

class CoursesMain extends StatefulWidget {
  CoursesMain(
      {Key? key,
      required this.id_sub_category,
      required this.image,
      required this.sub_name})
      : super(key: key);
  final String id_sub_category;
  final String image;
  final String sub_name;
  @override
  _CoursesMainState createState() => _CoursesMainState();
}

enum TtsState { playing, stopped, paused, continued }

class _CoursesMainState extends State<CoursesMain> {
  List courses = [];
  int indexCourses = 0;

  late FlutterTts flutterTts;
  String? language;
  String? engine;
  double volume = 1.2;
  double pitch_in = 1.54;
  double rate_in = 0.5;
  double pitch_en = 1.2;
  double rate_en = 0.35;

  String? text;
  bool _isComplete = false;
  bool _isPauseIn = false;
  bool _isPauseEn = false;

  TtsState ttsState = TtsState.stopped;

  get isPlaying => ttsState == TtsState.playing;

  bool get isIOS => !kIsWeb && Platform.isIOS;
  bool get isAndroid => !kIsWeb && Platform.isAndroid;
  GlobalKey _one = GlobalKey();
  GlobalKey _two = GlobalKey();
  GlobalKey _three = GlobalKey();
  GlobalKey _four = GlobalKey();

  late BuildContext myContext;
  @override
  initState() {
    super.initState();
    getCourses();
    initTts();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      ShowCaseWidget.of(myContext)!.startShowCase([_one, _two, _three, _four]);
    });
    text = "Mari belajar dulu dan ikuti petunjuk untuk bermain aplikasi ini";
    _speak("id-ID");
    _isPauseIn = false;
    _isPauseEn = false;
  }

  initTts() {
    flutterTts = FlutterTts();

    if (isAndroid) {
      _getDefaultEngine();
    }

    flutterTts.setStartHandler(() {
      setState(() {
        print("Playing");
        ttsState = TtsState.playing;
      });
    });
  }

  Future _getDefaultEngine() async {
    var engine = "com.google.android.tts";
  }

  Future _speak(String lang) async {
    flutterTts.setLanguage(lang);

    await flutterTts.setVolume(volume);
    if (lang == 'id-ID') {
      await flutterTts.setSpeechRate(rate_in);
      await flutterTts.setPitch(pitch_in);
      _isPauseIn = true;
    } else {
      await flutterTts.setSpeechRate(rate_en);
      await flutterTts.setPitch(pitch_en);
      _isPauseEn = true;
    }

    await flutterTts.awaitSpeakCompletion(true);
    await flutterTts.speak(text!);
    setState(() {
      _isPauseIn = false;
      _isPauseEn = false;
    });
  }

  Future getCourses() async {
    final String uri =
        "https://stulish-rest-api.herokuapp.com/api/v1/getCoursesById/" +
            widget.id_sub_category;

    String? token =
        await Provider.of<AuthProvider>(context, listen: false).getToken();
    http.Response result = await http.get(Uri.parse(uri), headers: {
      'Authorization': 'Bearer $token',
    });
    if (result.statusCode == HttpStatus.ok) {
      final jsonResponse = json.decode(result.body);
      List courseMap = jsonResponse['data'];
      List course = courseMap.map((i) => Courses.fromJson(i)).toList();
      setState(() {
        courses = course;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: ShowCaseWidget(
        builder: Builder(builder: (context) {
          myContext = context;
          return Scaffold(
            backgroundColor: Color(0xFFF1F1F1),
            body: Container(
                child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: displayWidth(context) * 0.05,
                vertical: displayHeight(context) * 0.05,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ImageCourse(courses: courses, indexCourses: indexCourses),
                  TextCourse(courses: courses, indexCourses: indexCourses),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () {
                            setState(() {
                              if (indexCourses > 0) {
                                indexCourses--;
                              }
                            });
                          },
                          child: indexCourses == 0
                              ? Image(
                                  image: AssetImage("assets/images/blank.png"),
                                )
                              : PrevButton(),
                        ),
                        Column(
                          children: [
                            InkWell(
                              onTap: () {
                                setState(() {
                                  if (!_isPauseIn) {
                                    _isPauseIn = true;
                                    text = courses.length > 0
                                        ? courses[indexCourses].indonesia_text
                                        : "Empty";
                                    _speak("id-ID");
                                  }
                                });
                              },
                              child: Showcase(
                                key: _one,
                                description:
                                    'Ketuk tombol ini untuk \nmendengarkan Bahasa Indonesia',
                                child: _isPauseIn == false
                                    ? Image(
                                        width: displayWidth(context) * 0.15,
                                        image: AssetImage(
                                            "assets/images/sound.png"),
                                      )
                                    : Image(
                                        width: displayWidth(context) * 0.15,
                                        image: AssetImage(
                                            "assets/images/pause.png"),
                                      ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  top: displayHeight(context) * 0.01),
                              child: Image(
                                width: displayWidth(context) * 0.1,
                                image:
                                    AssetImage("assets/images/indonesia.png"),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            InkWell(
                              onTap: () {
                                setState(() {
                                  if (!_isPauseEn) {
                                    _isPauseEn = true;
                                    text = courses.length > 0
                                        ? courses[indexCourses].english_text
                                        : "Empty";
                                    _speak("en-US");
                                  }
                                });
                              },
                              child: Showcase(
                                key: _two,
                                description:
                                    'Ketuk tombol ini untuk mendengarkan Bahasa Inggris',
                                child: _isPauseEn == false
                                    ? Image(
                                        width: displayWidth(context) * 0.15,
                                        image: AssetImage(
                                            "assets/images/sound.png"),
                                      )
                                    : Image(
                                        width: displayWidth(context) * 0.15,
                                        image: AssetImage(
                                            "assets/images/pause.png"),
                                      ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  top: displayHeight(context) * 0.01),
                              child: Image(
                                width: displayWidth(context) * 0.1,
                                image: AssetImage("assets/images/english.png"),
                              ),
                            ),
                          ],
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              if (indexCourses < courses.length - 1) {
                                indexCourses++;
                                if (indexCourses == courses.length - 1 &&
                                    _isComplete == false) {
                                  text =
                                      "Ketuk tombol ini untuk melakukan ujian";
                                  _speak("id-ID");
                                  _isComplete = true;
                                }
                              }
                            });
                          },
                          child: indexCourses != courses.length - 1
                              ? Showcase(
                                  key: _three,
                                  description:
                                      'Ketuk tombol ini untuk berpindah materi',
                                  child: NextButton(),
                                )
                              : Showcase(
                                  key: _four,
                                  description:
                                      'Ketuk tombol ini untuk melakukan ujian',
                                  child: InkWell(
                                    onTap: () {
                                      print("tap");
                                      Navigator.push(context, MaterialPageRoute(
                                          builder: (BuildContext context) {
                                        return CourseTest(
                                          id_sub_category:
                                              widget.id_sub_category,
                                        );
                                      }));
                                    },
                                    child: Image(
                                      width: displayWidth(context) * 0.15,
                                      image:
                                          AssetImage("assets/images/exam.png"),
                                    ),
                                  ),
                                ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            )),
          );
        }),
      ),
      onWillPop: () {
        showAlertDialog(context);
        return Future.value(false); // if true allow back else block it
      },
    );
  }

  showAlertDialog(BuildContext context) {
    showGeneralDialog(
      barrierLabel: "Dialog",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: Duration(milliseconds: 400),
      context: context,
      pageBuilder: (context, anim1, anim2) {
        return DialogMessage(
          textDialog: "Apakah kamu ingin mengakhiri pembelajaran ini?",
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
