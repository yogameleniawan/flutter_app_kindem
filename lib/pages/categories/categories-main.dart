import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_stulish/helpers/sizes_helpers.dart';
import 'package:flutter_app_stulish/models/category.dart';
import 'package:flutter_app_stulish/models/sub_category.dart';
import 'package:flutter_app_stulish/pages/sub_categories/sub_categories-main.dart';
import 'package:flutter_app_stulish/services/auth.dart';
import 'package:flutter_app_stulish/services/httpservice.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:provider/provider.dart';
import 'package:skeletons/skeletons.dart';

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

  @override
  void initState() {
    super.initState();
    getAllCategory();
    manager.emptyCache();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: ResponsiveSizer(builder: (context, orientation, screenType) {
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
                                minLength:
                                    MediaQuery.of(context).size.width / 6,
                                maxLength:
                                    MediaQuery.of(context).size.width / 3,
                              )),
                        ),
                        isLoading: _isLoading,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: Text("Cari Materi",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ),
                      Skeleton(
                        isLoading: _isLoadingCategory,
                        skeleton: SkeletonAvatar(
                          style: SkeletonAvatarStyle(
                            width: displayWidth(context) * 1,
                            minHeight: displayHeight(context) * 0.1,
                            maxHeight: displayHeight(context) / 3,
                          ),
                        ),
                        child: CarouselSlider(
                          options: CarouselOptions(
                            initialPage: 0,
                            aspectRatio: 2.0,
                            enlargeCenterPage: true,
                            height: 30.0.h,
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
                                return InkWell(
                                  onTap: () {
                                    Navigator.of(context).push(
                                      PageRouteBuilder(
                                        transitionDuration:
                                            Duration(milliseconds: 1000),
                                        pageBuilder: (BuildContext context,
                                            Animation<double> animation,
                                            Animation<double>
                                                secondaryAnimation) {
                                          return SubCategoriesMain(
                                            image: data.image,
                                            id_category: data.id,
                                          );
                                        },
                                        transitionsBuilder:
                                            (BuildContext context,
                                                Animation<double> animation,
                                                Animation<double>
                                                    secondaryAnimation,
                                                Widget child) {
                                          return Align(
                                            child: FadeTransition(
                                              opacity: animation,
                                              child: child,
                                            ),
                                          );
                                        },
                                      ),
                                    );
                                  },
                                  child: Container(
                                      width: MediaQuery.of(context).size.width,
                                      margin:
                                          EdgeInsets.symmetric(horizontal: 5.0),
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
                                      )),
                                );
                              },
                            );
                          }).toList(),
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
                                minLength:
                                    MediaQuery.of(context).size.width / 6,
                                maxLength:
                                    MediaQuery.of(context).size.width / 3,
                              )),
                        ),
                        isLoading: _isLoading,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 20, left: 10),
                          child: Text(
                            "Chapter " + _chapter,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20.sp),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Skeleton(
                          skeleton: SkeletonListView(),
                          isLoading: _isLoadingChapter,
                          child: ListView.builder(
                              itemCount: sub_categories.length,
                              itemBuilder: (context, int index) {
                                return Builder(builder: (context) {
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 5),
                                                child: Text(
                                                  "|",
                                                  style: TextStyle(
                                                    fontSize: 30.sp,
                                                    fontWeight: FontWeight.bold,
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
                                                            top: 5, bottom: 5),
                                                    child: Text(
                                                      sub_categories[index]
                                                          .name,
                                                      style: TextStyle(
                                                        fontSize: 18.sp,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                  Text(
                                                    sub_categories[index].name,
                                                    style: TextStyle(
                                                      fontSize: 14.sp,
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
                                  );
                                });
                              }),
                        ),
                      )
                    ],
                  ),
                ),
              ));
        }));
  }
}
