import 'package:animate_do/animate_do.dart';
import 'package:coachmaker/coachmaker.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_stulish/helpers/sizes_helpers.dart';
import 'package:flutter_app_stulish/models/category.dart';
import 'package:flutter_app_stulish/models/sub_category.dart';
import 'package:flutter_app_stulish/pages/components/choach-maker.dart';
import 'package:flutter_app_stulish/pages/components/perloader-page.dart';
import 'package:flutter_app_stulish/pages/courses/courses-main.dart';
import 'package:flutter_app_stulish/services/auth.dart';
import 'package:flutter_app_stulish/services/httpservice.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:http/http.dart' as http;
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:provider/provider.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:skeletons/skeletons.dart';

import 'components/skeleton-chapter.dart';

class CategoriesMain extends StatefulWidget {
  CategoriesMain(
      {Key? key,
      required this.id_category,
      required this.image_category,
      required this.name_category})
      : super(key: key);
  final String id_category;
  final String image_category;
  final String name_category;
  @override
  _CategoriesMainState createState() => _CategoriesMainState();
}

class _CategoriesMainState extends State<CategoriesMain> {
  final HttpService service = new HttpService();

  List sub_categories = [];
  DefaultCacheManager manager = new DefaultCacheManager();
  bool _isDoTutorial = false;
  List<CoachModel> listCoachModel = [];
  GlobalKey _one = GlobalKey();
  late BuildContext myContext;

  // Text to Speech Variable
  late FlutterTts flutterTts;
  String? language;
  String? engine;
  double volume = 1.2;
  double pitch = 1.54;
  double rate = 0.5;

  String? text;
  bool _isPauseIn = false;
  bool _isPauseEn = false;
  bool _isStartPage = false;
  TtsState ttsState = TtsState.stopped;

  get isPlaying => ttsState == TtsState.playing;

  bool get isIOS => Platform.isIOS;
  bool get isAndroid => Platform.isAndroid;
  // Text to Speech Variable

  @override
  void initState() {
    super.initState();
    initTts();
    getAllSubCategories(widget.id_category);
    manager.emptyCache();
  }

  // Text To Speech

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
    setState(() {
      _isPauseIn = false;
      _isPauseEn = false;
    });
  }

  // Text To Speech

  // Do Tutorial
  doTutorialCarousel() {
    // make coach maker btn_exam
    setState(() {
      listCoachModel = [
        CoachModel(
            initial: 'chapter',
            title: 'Chapter List',
            maxWidth: 400,
            subtitle: [
              'Kamu bisa memilih salah satu materi yang akan kamu pelajari',
            ],
            header: Image.asset(
              'assets/images/exam.png',
              height: 50,
              width: 50,
            )),
      ];
    });

    coachMaker(context, listCoachModel).show();
    // make coach maker btn_exam

    // make speaker
    text = "Kamu bisa menggeser untuk mencari materi yang akan kamu pelajari";
    _speak("id-ID");
    // make speaker
  }

  // Do Tutorial

  // Fetching Data

  Future getAllSubCategories(String id) async {
    final String uri =
        dotenv.get('API_URL') + "/api/v1/getSubCategoriesById/" + id;

    String? token =
        await Provider.of<AuthProvider>(context, listen: false).getToken();
    http.Response result = await http.get(Uri.parse(uri), headers: {
      'Authorization': 'Bearer $token',
    });

    if (result.statusCode == HttpStatus.ok) {
      final jsonResponse = json.decode(result.body);
      List subCategoryMap = jsonResponse['data'];
      List subCategory =
          subCategoryMap.map((i) => SubCategory.fromJson(i)).toList();

      setState(() {
        sub_categories = subCategory;
      });

      if (sub_categories.length > 0 && _isDoTutorial == false) {
        doTutorialCarousel();
      }
      setState(() {
        _isDoTutorial = true;
      });
    }
  }

  // Fetching data

  @override
  Widget build(BuildContext context) {
    if (sub_categories.length > 0) {
      return ShowCaseWidget(
        builder: Builder(builder: (context) {
          myContext = context;
          return Scaffold(
              backgroundColor: Color(0xFFF1F1F1),
              body: Container(
                child: Padding(
                  padding: const EdgeInsets.only(top: 40, right: 20, left: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          width: displayWidth(context) * 1,
                          // margin: EdgeInsets.symmetric(horizontal: 5.0),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20)),
                          child: ExtendedImage.network(
                            widget.image_category,
                            fit: BoxFit.fill,
                            cache: true,
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                          )),
                      Padding(
                        padding: EdgeInsets.only(
                            left: 10, top: displayHeight(context) * 0.1),
                        child: Text(
                          "Chapter " + widget.name_category,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                      ),
                      Expanded(
                        child: CoachPoint(
                          initial: "chapter",
                          child: ListView.builder(
                              itemCount: sub_categories.length,
                              itemBuilder: (context, int index) {
                                return Builder(builder: (context) {
                                  return InkWell(
                                    onTap: () {
                                      Navigator.push(context, MaterialPageRoute(
                                          builder: (BuildContext context) {
                                        return CoursesMain(
                                          id_sub_category:
                                              sub_categories[index].id,
                                        );
                                      }));
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 5),
                                                  child: Text(
                                                    "|",
                                                    style: TextStyle(
                                                      fontSize: 30,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 5,
                                                              bottom: 5),
                                                      child: Text(
                                                        sub_categories[index]
                                                            .name,
                                                        style: TextStyle(
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                    Text(
                                                      sub_categories[index]
                                                          .name,
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            Image(
                                              width: 40,
                                              image: AssetImage(
                                                  "assets/images/next.png"),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                });
                              }),
                        ),
                      )
                    ],
                  ),
                ),
              ));
        }),
      );
    } else {
      return PreloaderPage();
    }
  }
}
