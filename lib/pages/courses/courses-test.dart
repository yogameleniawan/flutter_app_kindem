import 'dart:math';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:coachmaker/coachmaker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kindem_app/helpers/sizes_helpers.dart';
import 'package:kindem_app/models/course.dart';
import 'package:kindem_app/models/user.dart';
import 'package:kindem_app/pages/components/perloader-page.dart';
import 'package:kindem_app/pages/courses/components/image-course.dart';
import 'package:kindem_app/pages/result/result-main.dart';
import 'package:kindem_app/services/auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
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
  CourseTest(
      {Key? key, required this.id_sub_category, required this.is_redirect})
      : super(key: key);
  final String id_sub_category;
  bool is_redirect;

  @override
  _CourseTestState createState() => _CourseTestState();
}

enum TtsState { playing, stopped, paused, continued }

class _CourseTestState extends State<CourseTest> {
  List courses = []; // untuk menyimpan data soal
  int indexCourses = 0; // untuk menyimpan nilai index dari soal
  int _selectedIndexAnswer =
      10; // untuk menyimpan nilai index jawaban yang dipilih - terdapat 3 index 0 - 2
  List answers = []; // untuk menyimpan value random jawaban
  late FlutterTts flutterTts;
  String? language;
  String? engine;
  double volume = 1.0;
  double pitch = 1.54;
  double rate = 0.4;

  int courses_total = 0;
  int course_answer_total = 0;

  bool _isCheck = false;
  bool _isStore = false;
  bool _isLoadingStore = false;

  String? text;
  var _isPauseIn = false;
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
    if (widget.is_redirect) {
      getCourseAnswered();
    } else {
      getCourses(); // mengambil data soal dari REST API
    }
    initTts(); // inisialisasi text to speech
    initSpeechState();
    getUser(); // mengambil data user
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
    speech
        .listen(
            onResult: resultListener,
            listenFor: Duration(seconds: 30),
            pauseFor: Duration(seconds: 5),
            partialResults: true,
            localeId: _currentLocaleId,
            onSoundLevelChange: soundLevelListener,
            cancelOnError: true,
            listenMode: ListenMode.confirmation)
        .then((result) {
      print('_MyAppState.start => result $result');
    });
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

  Future storeAnswer(
      String answer, String courseText, String course_id, int user_id) async {
    final String uri = dotenv.get('API_URL') + "/api/v1/storeAnswer";
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
      setState(() {
        _isStore = true;
      });
    }
  }

  Future<void> processStoreAnswer() async {
    setState(() {
      _isStore = false;
      _isLoadingStore = true;
    });
    await storeAnswer(lastWords, courses[indexCourses].english_text,
        courses[indexCourses].id, user.id);
  }

  Future<void> doNextCourse() async {
    if (_isStore) {
      if (indexCourses == courses.length - 1) {
        Navigator.of(context).pop();
        Navigator.of(context).pop();
        Navigator.push(context,
            MaterialPageRoute(builder: (BuildContext context) {
          return ResultMain(
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
      setState(() {
        if (indexCourses < courses.length - 1) {
          indexCourses++;
          lastWords = '____________';
        }
        _isCheck = !_isCheck;
        _isLoadingStore = false;
        widget.is_redirect = false;
        _selectedIndexAnswer =
            10; // di set 10 karena apabila di set 0 maka jawaban yang dipilih pada pilihan pertama
      });
    }

    if (indexCourses < courses.length - 1) {
      if (courses[indexCourses + 1].is_voice == 0) {
        getChoiceAnswer(courses[indexCourses + 1].id,
            courses[indexCourses + 1].sub_category_id);
      }
    }
  }

  Future getChoiceAnswer(String id, String sub_category_id) async {
    final String uri = dotenv.get('API_URL') + "/api/v1/getAnswerChoices";
    Map data = {'id': id, 'sub_category_id': sub_category_id};
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
      final jsonResponse = json.decode(result.body);
      List answer = jsonResponse.map((i) => Courses.choiceAnswer(i)).toList();
      setState(() {
        print(jsonResponse);
        answers = answer;
      });
      print(answers.length);
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

    await flutterTts.awaitSpeakCompletion(true);
    await flutterTts.speak(text!);
    setState(() {
      _isPauseIn = false;
    });
  }

  Future getCourses() async {
    final String uri = dotenv.get('API_URL') +
        "/api/v1/getCoursesById?id=" +
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
      getChoiceAnswer(courses[0].id, courses[0].sub_category_id);
    }
  }

  Future getCourseAnswered() async {
    final String uri = dotenv.get('API_URL') + "/api/v1/redirectCourse";
    String? token =
        await Provider.of<AuthProvider>(context, listen: false).getToken();
    http.Response result = await http.post(Uri.parse(uri), headers: {
      'Authorization': 'Bearer $token',
    }, body: {
      'sub_category_id': widget.id_sub_category
    });
    if (result.statusCode == HttpStatus.ok) {
      final jsonResponse = json.decode(result.body);
      List courseMap = jsonResponse['data'];
      print(jsonResponse);
      List course = courseMap.map((i) => Courses.fromJson(i)).toList();
      setState(() {
        courses = course;
        courses_total = jsonResponse['courses_total'];
        course_answer_total = jsonResponse['course_answer_total'];
      });
      getChoiceAnswer(courses[0].id, courses[0].sub_category_id);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (courses.length > 0) {
      return WillPopScope(
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          home: Scaffold(
            backgroundColor: Color(0xFFF1F1F1),
            body: Container(
                child: Padding(
              padding: EdgeInsets.only(
                right: displayWidth(context) * 0.05,
                left: displayWidth(context) * 0.05,
                top: displayHeight(context) * 0.05,
                bottom: displayHeight(context) * 0.01,
              ),
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Center(
                      child: FAProgressBar(
                    backgroundColor: Colors.white,
                    progressColor: Color(0xFFF5A71F),
                    currentValue: widget.is_redirect
                        ? course_answer_total
                        : (indexCourses + 1) * 10,
                    maxValue: widget.is_redirect
                        ? courses_total
                        : courses.length * 10,
                    size: 15,
                  )),
                  ImageCourse(courses: courses, indexCourses: indexCourses),
                  courses[indexCourses].is_voice == 1
                      ? Column(
                          children: [
                            InkWell(
                                onTap: () {
                                  if (speech.isListening) {
                                    return;
                                  } else {
                                    setState(() {
                                      if (!_isPauseIn) {
                                        _isPauseIn = true;
                                        text = text =
                                            courses[indexCourses].english_text;
                                        _speak("en-US");
                                      }
                                      // _isPauseIn = !_isPauseIn;
                                    });
                                  }
                                },
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
                                      )),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                  "Tekan tombol diatas kemudian tekan tombol dibawah lalu tirukan!",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  )),
                            ),
                          ],
                        )
                      : Text("Pilih Jawabanmu!",
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          )),
                  courses[indexCourses].is_voice == 1
                      ? VoiceTest(context)
                      : ChooseTest(),
                  InkWell(
                      onTap: () async {
                        if (!_isLoadingStore) {
                          if (lastWords.toUpperCase() ==
                              courses[indexCourses].english_text) {
                            await processStoreAnswer();
                            _trueAnswerShow(courses[indexCourses].english_text,
                                courses[indexCourses].indonesia_text);
                          } else {
                            await processStoreAnswer();
                            _falseAnswerShow(courses[indexCourses].english_text,
                                courses[indexCourses].indonesia_text);
                          }
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
                              child: _isLoadingStore
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
    } else {
      return PreloaderPage();
    }
  }

  Widget ChooseTest() {
    return Expanded(
      child: ListView.builder(
          itemCount: answers.length,
          itemBuilder: (context, int index) {
            return Builder(builder: (context) {
              return answers.length > 0
                  ? InkWell(
                      onTap: () {
                        setState(() {
                          lastWords = answers[index].english_text;
                          _selectedIndexAnswer = index;
                        });
                      },
                      child: Padding(
                        padding: EdgeInsets.only(
                            bottom: displayHeight(context) * 0.01),
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
                              answers[index].english_text,
                              style: TextStyle(
                                color: index == _selectedIndexAnswer
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  : CircularProgressIndicator(
                      color: Color(0xFFF5A71F),
                    );
            });
          }),
    );
  }

  Widget VoiceTest(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: displayWidth(context) * 0.8,
          child: Center(
            child: Text(
              lastWords,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              softWrap: false,
              style: TextStyle(color: Colors.black, fontSize: 20),
            ),
          ),
        ),
        AvatarGlow(
          endRadius: 50,
          animate: speech.isListening,
          glowColor: Color(0xFFF5A71F),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 10, top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    if (_isPauseIn == false) {
                      startListening();
                    }
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
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(speech.isListening
              ? 'Sedang mendengarkan kamu bicara'
              : 'Tidak sedang mendengarkan kamu bicara'),
        ),
      ],
    );
  }

  Future _trueAnswerShow(String textEn, String textIn) async {
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
              Text(
                'Jawabannya adalah ' + textEn,
                style: TextStyle(color: Color(0xFF000000)),
              ),
              Text(
                'Artinya adalah ' + textIn,
                style: TextStyle(color: Color(0xFF000000)),
              ),
              InkWell(
                  onTap: () {
                    setState(() {
                      _isCheck = !_isCheck;
                    });
                    doNextCourse();
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
                    doNextCourse();
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
