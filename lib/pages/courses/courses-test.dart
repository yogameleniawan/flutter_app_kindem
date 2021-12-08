import 'dart:math';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_stulish/models/course.dart';
import 'package:flutter_app_stulish/models/user.dart';
import 'package:flutter_app_stulish/pages/result/result-main.dart';
import 'package:flutter_app_stulish/services/auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:text_to_speech/text_to_speech.dart';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_tts/flutter_tts.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';

class CourseTest extends StatefulWidget {
  CourseTest(
      {Key? key,
      required this.id_sub_category,
      required this.image,
      required this.sub_name,
      required this.isTest})
      : super(key: key);
  final String id_sub_category;
  final String image;
  final String sub_name;
  final bool isTest;

  @override
  _CourseTestState createState() => _CourseTestState();
}

enum TtsState { playing, stopped, paused, continued }

class _CourseTestState extends State<CourseTest> {
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

  // Voice Recognition
  bool _hasSpeech = false;
  bool onMic = false;
  double level = 0.0;
  double minSoundLevel = 50000;
  double maxSoundLevel = -50000;
  String lastWords = '';

  String _currentLocaleId = '';

  final SpeechToText speech = SpeechToText();
  // Voice Recognition

  User user = new User();

  @override
  initState() {
    super.initState();
    getCourses();
    initTts();
    initSpeechState();
    getUser();
  }

  Future<void> initSpeechState() async {
    var hasSpeech = await speech.initialize(
      debugLogging: true,
    );
    if (hasSpeech) {
      _currentLocaleId = 'en_001';
    }

    if (!mounted) return;

    setState(() {
      _hasSpeech = hasSpeech;
    });
  }

  void startListening() {
    lastWords = '';

    speech.listen(
        onResult: resultListener,
        listenFor: Duration(seconds: 30),
        pauseFor: Duration(seconds: 5),
        partialResults: true,
        localeId: _currentLocaleId,
        onSoundLevelChange: soundLevelListener,
        cancelOnError: true,
        listenMode: ListenMode.confirmation);
    setState(() {
      onMic = true;
    });
  }

  void resultListener(SpeechRecognitionResult result) {
    setState(() {
      lastWords = '${result.recognizedWords}';
      onMic = false;
    });
  }

  void soundLevelListener(double level) {
    minSoundLevel = min(minSoundLevel, level);
    maxSoundLevel = max(maxSoundLevel, level);
    setState(() {
      this.level = level;
    });
  }

  Future getUser() async {
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

  void storeAnswer(
      String answer, String courseText, String course_id, int user_id) async {
    final String uri =
        "https://stulish-rest-api.herokuapp.com/api/v1/storeAnswer";
    Map data = {
      'answer': answer,
      'checked': true,
      'course_text': courseText,
      'course_id': course_id,
      'sub_category_id': widget.id_sub_category,
      'user_id': user_id,
    };
    var body = json.encode(data);

    String? token =
        await Provider.of<AuthProvider>(context, listen: false).getToken();
    http.Response result = await http.post(Uri.parse(uri),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: body);
    if (result.statusCode == HttpStatus.ok) {
      print("Success");
    }
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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: AvatarGlow(
          animate: onMic,
          glowColor: Theme.of(context).primaryColor,
          endRadius: 40.0,
          duration: const Duration(milliseconds: 2000),
          repeatPauseDuration: const Duration(milliseconds: 100),
          repeat: true,
          child: FloatingActionButton(
            backgroundColor: Color(0xFFFFD900),
            onPressed: startListening,
            child: Icon(onMic ? Icons.mic_none : Icons.mic),
          ),
        ),
        backgroundColor: Color(0xFF007251),
        body: Container(
            child: Padding(
          padding: const EdgeInsets.only(top: 40, right: 20, left: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20)),
                      child: CachedNetworkImage(
                        width: 80,
                        imageUrl: widget.image,
                        progressIndicatorBuilder:
                            (context, url, downloadProgress) =>
                                CircularProgressIndicator(
                                    value: downloadProgress.progress),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Text(widget.sub_name,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold)),
                  )
                ],
              ),
              Center(
                  child: FAProgressBar(
                backgroundColor: Colors.white,
                progressColor: Color(0xFFFFD900),
                currentValue: (indexCourses + 1) * 10,
                maxValue: courses.length * 10,
                size: 15,
              )),
              InkWell(
                onTap: () {
                  setState(() {
                    text = courses.length > 0
                        ? courses[indexCourses].english_text
                        : "Empty";
                    _speak("en-US");
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20)),
                  child: CachedNetworkImage(
                    width: 250,
                    imageUrl: courses.length > 0
                        ? courses[indexCourses].image
                        : "https://i.stack.imgur.com/5ykYD.png",
                    progressIndicatorBuilder:
                        (context, url, downloadProgress) =>
                            CircularProgressIndicator(
                                value: downloadProgress.progress),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                ),
              ),
              Column(
                children: [
                  Text("What is this?",
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      )),
                  Text(lastWords,
                      style: TextStyle(color: Colors.white, fontSize: 20)),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {},
                      child: Image(
                        image: AssetImage("assets/images/blank.png"),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        storeAnswer(
                            lastWords,
                            courses[indexCourses].english_text,
                            courses[indexCourses].id,
                            user.id);
                        setState(() {
                          if (indexCourses < courses.length - 1) {
                            indexCourses++;
                            lastWords = '____________';
                          } else if (indexCourses == courses.length - 1) {
                            _navigateNextTest(context);
                          }
                        });
                      },
                      child: indexCourses < courses.length - 1
                          ? Image(
                              image:
                                  AssetImage("assets/images/arrow-right.png"),
                            )
                          : Image(
                              image: AssetImage("assets/images/complete.png"),
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
  }

  _navigateNextTest(BuildContext context) async {
    final result = await Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext context) {
      return ResultMain(
        id_user: user.id,
        id_sub_category: widget.id_sub_category,
        image_sub_category: widget.image,
      );
    }));
    if (result == true) {
      setState(() {
        indexCourses = 0;
        lastWords = '____________';
      });
    }
  }
}
