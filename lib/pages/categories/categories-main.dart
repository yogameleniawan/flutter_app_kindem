import 'package:coachmaker/coachmaker.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_stulish/helpers/sizes_helpers.dart';
import 'package:flutter_app_stulish/models/category.dart';
import 'package:flutter_app_stulish/models/sub_category.dart';
import 'package:flutter_app_stulish/pages/components/choach-maker.dart';
import 'package:flutter_app_stulish/pages/courses/courses-main.dart';
import 'package:flutter_app_stulish/services/auth.dart';
import 'package:flutter_app_stulish/services/httpservice.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:provider/provider.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:skeletons/skeletons.dart';

import 'components/skeleton-chapter.dart';

class CategoriesMain extends StatefulWidget {
  CategoriesMain({Key? key}) : super(key: key);
  @override
  _CategoriesMainState createState() => _CategoriesMainState();
}

class _CategoriesMainState extends State<CategoriesMain> {
  final HttpService service = new HttpService();
  List categories = [];
  List map_category = [];
  List sub_categories = [];
  DefaultCacheManager manager = new DefaultCacheManager();
  bool _isLoading = true;
  bool _isLoadingCategory = false;
  bool _isLoadingChapter = false;
  String _chapter = "";
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
  bool _isComplete = false;
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
    getAllCategory();
    initTts();
    doTutorialCarousel();
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
            initial: 'carousel',
            title: 'Carousel Slider',
            maxWidth: 400,
            subtitle: [
              'Kamu bisa menggeser untuk mencari materi yang akan kamu pelajari',
            ],
            header: Image.asset(
              'assets/images/exam.png',
              height: 50,
              width: 50,
            )),
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
    text = "Geser gambar ini untuk berpindah materi";
    _speak("id-ID");
    setState(() {
      _isComplete = true;
    });
    // make speaker
  }

  doTutorialChapter() {
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
    text = "Kamu bisa memilih salah satu materi yang akan kamu pelajari";
    _speak("id-ID");
    _isComplete = true;
    // make speaker
  }

  // Do Tutorial

  // Fetching Data
  Future getAllCategory() async {
    setState(() {
      _isLoadingCategory = true;
    });
    final String uri =
        "https://stulish-rest-api.herokuapp.com/api/v1/getAllCategories";
    String? token =
        await Provider.of<AuthProvider>(context, listen: false).getToken();
    http.Response result = await http.get(Uri.parse(uri), headers: {
      'Authorization': 'Bearer $token',
    });
    if (result.statusCode == HttpStatus.ok) {
      final jsonResponse = json.decode(result.body);
      List categoryMap = jsonResponse['data'];
      List category = categoryMap.map((i) => Category.fromJson(i)).toList();
      setState(() {
        categories = category;
        map_category = categoryMap;
        _chapter = map_category[0]['name'];
        _isLoadingCategory = false;
      });
      _isLoading = false;
      getAllSubCategories(map_category[0]['id']);
    }
  }

  Future getAllSubCategories(String id) async {
    setState(() {
      _isLoadingChapter = true;
    });
    final String uri =
        "https://stulish-rest-api.herokuapp.com/api/v1/getSubCategoriesById/" +
            id;

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
        _isLoadingChapter = false;
      });
    }
  }

  // Fetching data

  @override
  Widget build(BuildContext context) {
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
                    Skeleton(
                      skeleton: SkeletonParagraph(
                        style: SkeletonParagraphStyle(
                            lines: 1,
                            spacing: 6,
                            lineStyle: SkeletonLineStyle(
                              randomLength: true,
                              height: 10,
                              borderRadius: BorderRadius.circular(8),
                              minLength: MediaQuery.of(context).size.width / 6,
                              maxLength: MediaQuery.of(context).size.width / 3,
                            )),
                      ),
                      isLoading: _isLoading,
                      child: Padding(
                        padding: EdgeInsets.only(
                            bottom: displayHeight(context) * 0.02,
                            top: displayHeight(context) * 0.02),
                        child: Text("Cari Materi",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.bold)),
                      ),
                    ),
                    CoachPoint(
                      initial: "carousel",
                      child: Padding(
                        padding: EdgeInsets.only(
                            bottom: displayHeight(context) * 0.1),
                        child: CarouselSlider(
                          options: CarouselOptions(
                            initialPage: 0,
                            aspectRatio: 2.0,
                            enlargeCenterPage: true,
                            height: displayHeight(context) * 0.3,
                            onPageChanged: (index, reason) async {
                              setState(() {
                                _chapter = map_category[index]['name'];
                                _isLoadingChapter = true;
                                print(_isLoadingChapter);
                              });
                              await getAllSubCategories(
                                  map_category[index]['id']);
                            },
                          ),
                          items: categories.map((data) {
                            return Builder(
                              builder: (BuildContext context) {
                                return Container(
                                    width: MediaQuery.of(context).size.width,
                                    // margin: EdgeInsets.symmetric(horizontal: 5.0),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    child: ExtendedImage.network(
                                      data.image,
                                      width: 200,
                                      fit: BoxFit.fill,
                                      cache: true,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(30.0)),
                                    ));
                              },
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    Skeleton(
                      skeleton: SkeletonParagraph(
                        style: SkeletonParagraphStyle(
                            lines: 1,
                            spacing: 6,
                            lineStyle: SkeletonLineStyle(
                              randomLength: true,
                              height: 10,
                              borderRadius: BorderRadius.circular(8),
                              minLength: MediaQuery.of(context).size.width / 6,
                              maxLength: MediaQuery.of(context).size.width / 3,
                            )),
                      ),
                      isLoading: _isLoading,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Text(
                          "Chapter " + _chapter,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Skeleton(
                        skeleton: SkeletonChapter(),
                        isLoading: _isLoadingChapter,
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
                      ),
                    )
                  ],
                ),
              ),
            ));
      }),
    );
  }
}
