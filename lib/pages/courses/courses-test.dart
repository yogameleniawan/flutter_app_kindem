import 'dart:math';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:coachmaker/coachmaker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_stulish/helpers/sizes_helpers.dart';
import 'package:flutter_app_stulish/models/course.dart';
import 'package:flutter_app_stulish/models/user.dart';
import 'package:flutter_app_stulish/pages/courses/components/image-course.dart';
import 'package:flutter_app_stulish/pages/result/result-main.dart';
import 'package:flutter_app_stulish/services/auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:skeletons/skeletons.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:text_to_speech/text_to_speech.dart';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_tts/flutter_tts.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';
import 'package:sweetsheet/sweetsheet.dart';
import 'components/dialog-message.dart';
import 'components/next-button.dart';

class CourseTest extends StatefulWidget {
  CourseTest({Key? key, required this.id_sub_category}) : super(key: key);
  final String id_sub_category;

  @override
  _CourseTestState createState() => _CourseTestState();
}

enum TtsState { playing, stopped, paused, continued }

class _CourseTestState extends State<CourseTest> {
  List courses = [];
  int indexCourses = 0;
  int _selectedIndexAnswer = 10;
  final answers = List<String>.generate(3, (i) => 'Answer $i');

  late FlutterTts flutterTts;
  String? language;
  String? engine;
  double volume = 1.0;
  double pitch = 1.54;
  double rate = 0.4;

  bool _isCheck = false;

  String? text;

  TtsState ttsState = TtsState.stopped;

  get isPlaying => ttsState == TtsState.playing;

  bool get isIOS => !kIsWeb && Platform.isIOS;
  bool get isAndroid => !kIsWeb && Platform.isAndroid;

  // Voice Recognition
  bool _hasSpeech = false;
  bool _logEvents = false;
  bool onMic = false;
  double level = 0.0;
  double minSoundLevel = 50000;
  double maxSoundLevel = -50000;
  String lastWords = '';
  String lastError = '';
  String lastStatus = '';

  String _currentLocaleId = '';
  final SweetSheet _trueAnswer = SweetSheet();
  final SweetSheet _falseAnswer = SweetSheet();
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
    _logEvent('Initialize');
    try {
      var hasSpeech = await speech.initialize(
        onError: errorListener,
        onStatus: statusListener,
        debugLogging: true,
      );
      if (hasSpeech) {
        _currentLocaleId = 'en_001';
      }
      if (!mounted) return;

      setState(() {
        _hasSpeech = hasSpeech;
      });
    } catch (e) {
      setState(() {
        _hasSpeech = false;
      });
    }
  }

  // This is called each time the users wants to start a new speech
  // recognition session
  void startListening() {
    _logEvent('start listening');
    lastWords = '';
    lastError = '';
    // Note that `listenFor` is the maximum, not the minimun, on some
    // recognition will be stopped before this value is reached.
    // Similarly `pauseFor` is a maximum not a minimum and may be ignored
    // on some devices.
    speech.listen(
        onResult: resultListener,
        listenFor: Duration(seconds: 30),
        pauseFor: Duration(seconds: 5),
        partialResults: true,
        localeId: _currentLocaleId,
        onSoundLevelChange: soundLevelListener,
        cancelOnError: true,
        listenMode: ListenMode.confirmation);
    setState(() {});
  }

  void stopListening() {
    _logEvent('stop');
    speech.stop();
    setState(() {
      level = 0.0;
    });
  }

  void cancelListening() {
    _logEvent('cancel');
    speech.cancel();
    setState(() {
      level = 0.0;
    });
  }

  /// This callback is invoked each time new recognition results are
  /// available after `listen` is called.
  void resultListener(SpeechRecognitionResult result) {
    _logEvent(
        'Result listener final: ${result.finalResult}, words: ${result.recognizedWords}');
    setState(() {
      lastWords = '${result.recognizedWords}';
      onMic = false;
    });
  }

  void soundLevelListener(double level) {
    minSoundLevel = min(minSoundLevel, level);
    maxSoundLevel = max(maxSoundLevel, level);
    // _logEvent('sound level $level: $minSoundLevel - $maxSoundLevel ');
    setState(() {
      this.level = level;
    });
  }

  void errorListener(SpeechRecognitionError error) {
    _logEvent(
        'Received error status: $error, listening: ${speech.isListening}');
    setState(() {
      lastError = '${error.errorMsg} - ${error.permanent}';
    });
  }

  void statusListener(String status) {
    _logEvent(
        'Received listener status: $status, listening: ${speech.isListening}');
    setState(() {
      lastStatus = '$status';
    });
  }

  void _logEvent(String eventDescription) {
    if (_logEvents) {
      var eventTime = DateTime.now().toIso8601String();
      print('$eventTime $eventDescription');
    }
  }

  void _switchLogging(bool? val) {
    setState(() {
      _logEvents = val ?? false;
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

  void processStoreAnswer() {
    storeAnswer(lastWords, courses[indexCourses].english_text,
        courses[indexCourses].id, user.id);
    setState(() {
      if (indexCourses < courses.length - 1) {
        indexCourses++;
        lastWords = '____________';
      }
      _isCheck = !_isCheck;
    });
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
    return WillPopScope(
      child: MaterialApp(
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
                Center(
                    child: FAProgressBar(
                  backgroundColor: Colors.white,
                  progressColor: Color(0xFFF5A71F),
                  currentValue: (indexCourses + 1) * 10,
                  maxValue: courses.length * 10,
                  size: 15,
                )),
                ImageCourse(courses: courses, indexCourses: indexCourses),
                ChooseTest(),
                // VoiceTest(context),
                InkWell(
                    onTap: () {
                      if (lastWords.toUpperCase() ==
                          courses[indexCourses].english_text) {
                        _trueAnswerShow();
                      } else {
                        _falseAnswerShow(courses[indexCourses].english_text,
                            courses[indexCourses].indonesia_text);
                      }
                    },
                    child: Container(
                        width: displayWidth(context) * 1,
                        height: displayHeight(context) * 0.08,
                        decoration: BoxDecoration(
                          color: Color(0xFFF5A71F),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Center(
                            child: _isCheck
                                ? CircularProgressIndicator(
                                    color: Colors.white,
                                  )
                                : Text("PERIKSA JAWABANMU",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold))))),
              ],
            ),
          )),
        ),
      ),
      onWillPop: () {
        showAlertDialog(context);
        return Future.value(false); // if true allow back else block it
      },
    );
  }

  Widget ChooseTest() {
    return Expanded(
      child: ListView.builder(
          itemCount: answers.length,
          itemBuilder: (context, int index) {
            return Builder(builder: (context) {
              return InkWell(
                onTap: () {
                  setState(() {
                    _selectedIndexAnswer = index;
                  });
                },
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Center(
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        vertical: displayHeight(context) * 0.01,
                        horizontal: displayWidth(context) * 0.1,
                      ),
                      decoration: BoxDecoration(
                        color: index == _selectedIndexAnswer
                            ? Color(0xFFF5A71F)
                            : Colors.white,
                      ),
                      child: Text(
                        answers[index],
                        style: TextStyle(
                          color: index == _selectedIndexAnswer
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            });
          }),
    );
  }

  Widget VoiceTest(BuildContext context) {
    return Column(
      children: [
        Text("What is this?",
            style: TextStyle(
              fontSize: 20,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            )),
        Text(lastWords, style: TextStyle(color: Colors.black, fontSize: 20)),
        Padding(
          padding: const EdgeInsets.only(bottom: 30),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: () {
                  startListening();
                },
                child: Image(
                  width: displayWidth(context) * 0.15,
                  image: speech.isListening
                      ? AssetImage("assets/images/mic-on.png")
                      : AssetImage("assets/images/mic-off.png"),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future _trueAnswerShow() async {
    return showModalBottomSheet(
      isDismissible: false,
      enableDrag: false,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      context: context,
      builder: (context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Icon(
                Icons.check_box,
                color: Color(0xFF78C83C),
                size: 60,
              ),
              Text(
                'Yey.. Jawabanmu benar!',
                style: TextStyle(
                    color: Color(0xFF78C83C),
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              // Text('text 2'),
              InkWell(
                  onTap: () {
                    setState(() {
                      _isCheck = !_isCheck;
                    });
                    processStoreAnswer();
                    Navigator.of(context).pop();
                  },
                  child: Container(
                      margin: EdgeInsets.symmetric(
                          horizontal: displayWidth(context) * 0.01,
                          vertical: displayHeight(context) * 0.01),
                      width: displayWidth(context) * 0.9,
                      height: displayHeight(context) * 0.08,
                      decoration: BoxDecoration(
                        color: Color(0xFF78C83C),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Center(
                          child: Text(
                        'LANJUT',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      )))),
            ],
          ),
        );
      },
    );
  }

  Future _falseAnswerShow(String textEn, String textIn) async {
    return showModalBottomSheet(
      isDismissible: false,
      enableDrag: false,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      context: context,
      builder: (context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Icon(
                Icons.close_outlined,
                color: Color(0xFFF5511F),
                size: 60,
              ),
              Text(
                'Ups.. Jawabanmu kurang tepat!',
                style: TextStyle(
                    color: Color(0xFFF5511F),
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                'Jawabannya adalah ' + textEn,
                style: TextStyle(color: Color(0xFFF5511F)),
              ),
              Text(
                'Artinya adalah ' + textIn,
                style: TextStyle(color: Color(0xFFF5511F)),
              ),
              InkWell(
                  onTap: () {
                    setState(() {
                      _isCheck = !_isCheck;
                    });
                    processStoreAnswer();
                    if (indexCourses == courses.length - 1) {
                      Navigator.of(context).pop();
                      Navigator.push(context,
                          MaterialPageRoute(builder: (BuildContext context) {
                        return ResultMain(
                          id_user: user.id,
                          id_sub_category: widget.id_sub_category,
                        );
                      }));
                      setState(() {
                        indexCourses = 0;
                        lastWords = '____________';
                      });
                    } else {
                      Navigator.of(context).pop();
                    }
                  },
                  child: Container(
                      margin: EdgeInsets.symmetric(
                          horizontal: displayWidth(context) * 0.01,
                          vertical: displayHeight(context) * 0.01),
                      width: displayWidth(context) * 0.9,
                      height: displayHeight(context) * 0.08,
                      decoration: BoxDecoration(
                        color: Color(0xFFF5511F),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Center(
                          child: Text(
                        'LANJUT',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      )))),
            ],
          ),
        );
      },
    );
  }

  _navigateNextTest(BuildContext context) async {
    final result = await Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext context) {
      return ResultMain(
        id_user: user.id,
        id_sub_category: widget.id_sub_category,
      );
    }));
    if (result == true) {
      setState(() {
        indexCourses = 0;
        lastWords = '____________';
      });
    }
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
          textDialog: "Apakah kamu ingin mengakhiri ujian ini?",
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
