import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_stulish/helpers/sizes_helpers.dart';
import 'package:flutter_app_stulish/models/course.dart';
import 'package:flutter_app_stulish/services/auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:skeletons/skeletons.dart';
import 'package:text_to_speech/text_to_speech.dart';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

import 'package:flutter_tts/flutter_tts.dart';

import 'components/skeleton-course-text.dart';
import 'dart:math' as math;

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
  double volume = 1.0;
  double pitch = 1.54;
  double rate = 0.4;

  String? text;

  TtsState ttsState = TtsState.stopped;

  get isPlaying => ttsState == TtsState.playing;

  bool get isIOS => !kIsWeb && Platform.isIOS;
  bool get isAndroid => !kIsWeb && Platform.isAndroid;
  GlobalKey _one = GlobalKey();
  GlobalKey _two = GlobalKey();
  GlobalKey _three = GlobalKey();
  late BuildContext myContext;
  @override
  initState() {
    super.initState();
    getCourses();
    initTts();
    WidgetsBinding.instance!.addPostFrameCallback(
      (_) => ShowCaseWidget.of(myContext)!.startShowCase([_one, _two, _three]),
    );
    text = "Mari belajar dulu dan ikuti petunjuk untuk bermain aplikasi ini";
    _speak("id-ID");
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
    await flutterTts.setSpeechRate(rate);
    await flutterTts.setPitch(pitch);

    await flutterTts.awaitSpeakCompletion(true);
    await flutterTts.speak(text!);
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
    return ShowCaseWidget(
      builder: Builder(builder: (context) {
        myContext = context;
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          home: Scaffold(
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
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: displayWidth(context) * 0.1,
                      vertical: displayWidth(context) * 0.3,
                    ),
                    child: Skeleton(
                      skeleton: SkeletonAvatar(
                        style: SkeletonAvatarStyle(
                          width: displayWidth(context) * 1,
                          minHeight: displayHeight(context) * 0.1,
                          maxHeight: displayHeight(context) * 0.3,
                        ),
                      ),
                      isLoading: courses.length < 1,
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20)),
                        child: CachedNetworkImage(
                          height: displayHeight(context) * 0.3,
                          width: displayWidth(context) * 0.8,
                          imageUrl: courses.length > 0
                              ? courses[indexCourses].image
                              : "",
                          progressIndicatorBuilder:
                              (context, url, downloadProgress) =>
                                  SkeletonAvatar(
                            style: SkeletonAvatarStyle(
                              width: displayWidth(context) * 1,
                              minHeight: displayHeight(context) * 0.1,
                              maxHeight: displayHeight(context) * 0.3,
                            ),
                          ),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                        ),
                      ),
                    ),
                  ),
                  Skeleton(
                    skeleton: SkeletonTextCourse(),
                    isLoading: courses.length < 1,
                    child: Column(
                      children: [
                        Text(
                            courses.length > 0
                                ? courses[indexCourses].english_text
                                : "-",
                            style: TextStyle(
                              fontSize: 30,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            )),
                        Text(
                            courses.length > 0
                                ? courses[indexCourses].indonesia_text
                                : "-",
                            style:
                                TextStyle(color: Colors.black, fontSize: 20)),
                      ],
                    ),
                  ),
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
                              : Transform(
                                  alignment: Alignment.center,
                                  transform: Matrix4.rotationY(math.pi),
                                  child: Image(
                                    width: displayWidth(context) * 0.15,
                                    image: AssetImage(
                                        "assets/images/next-icon.png"),
                                  ),
                                ),
                        ),
                        Column(
                          children: [
                            InkWell(
                              onTap: () {
                                setState(() {
                                  text = courses.length > 0
                                      ? courses[indexCourses].indonesia_text
                                      : "Empty";
                                  _speak("id-ID");
                                });
                              },
                              child: Showcase(
                                key: _one,
                                description:
                                    'Ketuk tombol ini untuk \nmendengarkan Bahasa Indonesia',
                                child: Image(
                                  width: displayWidth(context) * 0.15,
                                  image: AssetImage("assets/images/sound.png"),
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
                                  text = courses.length > 0
                                      ? courses[indexCourses].english_text
                                      : "Empty";
                                  _speak("en-US");
                                });
                              },
                              child: Showcase(
                                key: _two,
                                description:
                                    'Ketuk tombol ini untuk mendengarkan Bahasa Inggris',
                                child: Image(
                                  width: displayWidth(context) * 0.15,
                                  image: AssetImage("assets/images/sound.png"),
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
                              }
                            });
                          },
                          child: indexCourses < courses.length - 1
                              ? Showcase(
                                  key: _three,
                                  description:
                                      'Ketuk tombol ini untuk berpindah materi',
                                  child: Image(
                                    width: displayWidth(context) * 0.15,
                                    image: AssetImage(
                                        "assets/images/next-icon.png"),
                                  ),
                                )
                              : Image(
                                  image: AssetImage("assets/images/blank.png"),
                                ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            )),
          ),
        );
      }),
    );
  }
}
