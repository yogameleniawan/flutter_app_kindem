import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_stulish/models/course.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:text_to_speech/text_to_speech.dart';

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

class _CoursesMainState extends State<CoursesMain> {
  List courses = [];
  int indexCourses = 0;

  TextToSpeech tts = TextToSpeech();

  String text = '';
  double volume = 1; // Range: 0-1
  double rate = 0.97; // Range: 0-2
  double pitch = 1.54; // Range: 0-2

  void getCourses() async {
    final String uri =
        "https://stulish-rest-api.herokuapp.com/api/getCoursesById/" +
            widget.id_sub_category;

    http.Response result = await http.get(Uri.parse(uri));
    if (result.statusCode == HttpStatus.ok) {
      final jsonResponse = json.decode(result.body);
      List courseMap = jsonResponse['data'];
      List course = courseMap.map((i) => Courses.fromJson(i)).toList();
      setState(() {
        courses = course;
      });
    }
  }

  void speakIndonesia() {
    tts.setVolume(volume);
    tts.setRate(rate);
    tts.setLanguage("id-ID");
    tts.setPitch(pitch);
    tts.speak(text);
  }

  void speakEnglish() {
    tts.setVolume(volume);
    tts.setRate(rate);
    tts.setLanguage("en-US");
    tts.setPitch(pitch);
    tts.speak(text);
  }

  @override
  void initState() {
    super.initState();
    getCourses();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
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
              Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20)),
                child: CachedNetworkImage(
                  width: 250,
                  imageUrl:
                      "https://media.suara.com/pictures/970x544/2019/12/26/49091-gambar.jpg",
                  progressIndicatorBuilder: (context, url, downloadProgress) =>
                      CircularProgressIndicator(
                          value: downloadProgress.progress),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
              Column(
                children: [
                  Text(
                      courses.length > 0
                          ? courses[indexCourses].english_text
                          : "Empty",
                      style: TextStyle(
                        fontSize: 30,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      )),
                  Text(
                      courses.length > 0
                          ? courses[indexCourses].indonesia_text
                          : "Empty",
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
                          }
                        });
                      },
                      child: Image(
                        image: AssetImage("assets/images/arrow-left.png"),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          text = courses.length > 0
                              ? courses[indexCourses].indonesia_text
                              : "Empty";
                          speakIndonesia();
                        });
                      },
                      child: Image(
                        image: AssetImage("assets/images/indonesia.png"),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          text = courses.length > 0
                              ? courses[indexCourses].english_text
                              : "Empty";
                          speakEnglish();
                        });
                      },
                      child: Image(
                        image: AssetImage("assets/images/english.png"),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          if (indexCourses < courses.length) {
                            indexCourses++;
                          }
                        });
                      },
                      child: Image(
                        image: AssetImage("assets/images/arrow-right.png"),
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
