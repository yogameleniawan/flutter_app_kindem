import 'package:animate_do/animate_do.dart';
import 'package:coachmaker/coachmaker.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kindem_app/helpers/sizes_helpers.dart';
import 'package:kindem_app/models/category.dart';
import 'package:kindem_app/models/sub_category.dart';
import 'package:kindem_app/pages/components/choach-maker.dart';
import 'package:kindem_app/pages/components/perloader-page.dart';
import 'package:kindem_app/pages/courses/courses-main.dart';
import 'package:kindem_app/pages/result/result-main.dart';
import 'package:kindem_app/services/auth.dart';
import 'package:kindem_app/services/httpservice.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:http/http.dart' as http;
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:provider/provider.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:skeletons/skeletons.dart';
import 'package:kindem_app/pages/courses/courses-test.dart';
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
  List<CoachModel> listCoachModel = [];
  GlobalKey _one = GlobalKey();
  late BuildContext myContext;

  @override
  void initState() {
    super.initState();
    getAllSubCategories(widget.id_category);
    manager.emptyCache();
  }

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
  }

  // Do Tutorial

  Future tutorialCheck() async {
    final String uri = dotenv.get('API_URL') + "/api/v1/tutorialCheck";

    String? token =
        await Provider.of<AuthProvider>(context, listen: false).getToken();
    http.Response result = await http.post(Uri.parse(uri), headers: {
      'Authorization': 'Bearer $token',
    }, body: {
      'page': 'chapter',
    });

    if (result.statusCode == HttpStatus.ok) {
      final jsonResponse = json.decode(result.body);

      if (jsonResponse['is_done'] == false) {
        doTutorialCarousel();
      }
    }
  }

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

      tutorialCheck();
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
                                        return sub_categories[index].complete ==
                                                0
                                            ? CoursesMain(
                                                id_sub_category:
                                                    sub_categories[index].id,
                                              )
                                            : sub_categories[index].complete ==
                                                    sub_categories[index].total
                                                ? ResultMain(
                                                    id_sub_category:
                                                        sub_categories[index]
                                                            .id,
                                                  )
                                                : CourseTest(
                                                    id_sub_category:
                                                        sub_categories[index]
                                                            .id,
                                                    is_redirect: true,
                                                  );
                                      })).then((value) {
                                        getAllSubCategories(widget.id_category);
                                      });
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
                                            sub_categories[index].complete == 0
                                                ? Image(
                                                    width: 40,
                                                    image: AssetImage(
                                                        "assets/images/next.png"),
                                                  )
                                                : CircularPercentIndicator(
                                                    radius: 20.0,
                                                    lineWidth: 3.0,
                                                    percent: ((sub_categories[
                                                                index]
                                                            .complete /
                                                        sub_categories[index]
                                                            .total)),
                                                    center: new Text(((sub_categories[
                                                                            index]
                                                                        .complete /
                                                                    sub_categories[
                                                                            index]
                                                                        .total) *
                                                                100)
                                                            .toStringAsFixed(
                                                                0) +
                                                        "%"),
                                                    progressColor:
                                                        Color(0xFFF5A71F),
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
