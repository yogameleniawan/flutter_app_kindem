import 'package:avatar_glow/avatar_glow.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_stulish/models/course.dart';
import 'package:flutter_app_stulish/services/auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:text_to_speech/text_to_speech.dart';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_tts/flutter_tts.dart';

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

  stt.SpeechToText _speech = new stt.SpeechToText();
  bool _isListening = false;
  String _text = '____________';
  double _confidence = 1.0;

  String? text;

  TtsState ttsState = TtsState.stopped;

  get isPlaying => ttsState == TtsState.playing;

  bool get isIOS => !kIsWeb && Platform.isIOS;
  bool get isAndroid => !kIsWeb && Platform.isAndroid;

  @override
  initState() {
    super.initState();
    getCourses();
    initTts();
    _speech = stt.SpeechToText();
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

  void getCourses() async {
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

  void _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (val) => _isListening = false,
        onError: (val) => print('onError: $val'),
      );
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
          onResult: (val) => setState(() {
            _text = val.recognizedWords;
            if (val.hasConfidenceRating && val.confidence > 0) {
              _confidence = val.confidence;
            }
          }),
        );
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: AvatarGlow(
          animate: _isListening,
          glowColor: Theme.of(context).primaryColor,
          endRadius: 75.0,
          duration: const Duration(milliseconds: 2000),
          repeatPauseDuration: const Duration(milliseconds: 100),
          repeat: true,
          child: FloatingActionButton(
            backgroundColor: Color(0xFFFFD900),
            onPressed: _listen,
            child: Icon(_isListening ? Icons.mic : Icons.mic_none),
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
                  Text(_text,
                      style: TextStyle(color: Colors.white, fontSize: 20)),
                ],
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
                            _text = '____________';
                          }
                        });
                      },
                      child: indexCourses == 0
                          ? Image(
                              image: AssetImage("assets/images/blank.png"),
                            )
                          : Image(
                              image: AssetImage("assets/images/arrow-left.png"),
                            ),
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          if (indexCourses < courses.length - 1) {
                            indexCourses++;
                            _text = '____________';
                          }
                        });
                      },
                      child: indexCourses < courses.length - 1
                          ? Image(
                              image:
                                  AssetImage("assets/images/arrow-right.png"),
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
  }
}
