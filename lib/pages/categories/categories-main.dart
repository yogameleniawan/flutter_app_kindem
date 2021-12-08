import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_stulish/models/category.dart';
import 'package:flutter_app_stulish/pages/sub_categories/sub_categories-main.dart';
import 'package:flutter_app_stulish/services/auth.dart';
import 'package:flutter_app_stulish/services/httpservice.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'dart:async';

import 'package:provider/provider.dart';

class CategoriesMain extends StatefulWidget {
  CategoriesMain({Key? key, required this.isTest}) : super(key: key);
  final bool isTest;
  @override
  _CategoriesMainState createState() => _CategoriesMainState();
}

class _CategoriesMainState extends State<CategoriesMain> {
  final HttpService service = new HttpService();
  List categories = [];
  DefaultCacheManager manager = new DefaultCacheManager();

  Future getAllCategory() async {
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
        home: Scaffold(
            backgroundColor: Color(0xFF007251),
            body: Container(
              child: Padding(
                padding: const EdgeInsets.only(top: 40, right: 20, left: 20),
                child: Column(
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pop(context, true);
                      },
                      child: Hero(
                        tag: "imageStudy",
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10)),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Image(
                              width: MediaQuery.of(context).size.width * 0.10,
                              image: widget.isTest == false
                                  ? AssetImage("assets/images/study.png")
                                  : AssetImage("assets/images/test.png"),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20, top: 80),
                      child: Text("CATEGORY",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold)),
                    ),
                    CarouselSlider(
                      options: CarouselOptions(height: 250.0),
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
                                        Animation<double> secondaryAnimation) {
                                      return SubCategoriesMain(
                                          image: data.image,
                                          id_category: data.id,
                                          isTest: widget.isTest);
                                    },
                                    transitionsBuilder: (BuildContext context,
                                        Animation<double> animation,
                                        Animation<double> secondaryAnimation,
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
                                  margin: EdgeInsets.symmetric(horizontal: 5.0),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(20)),
                                  child: Column(
                                    children: [
                                      ExtendedImage.network(
                                        data.image,
                                        width: 200,
                                        fit: BoxFit.fill,
                                        cache: true,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(30.0)),
                                      ),
                                      Text(
                                        data.name,
                                        style: TextStyle(
                                            fontSize: 20.0,
                                            color: Color(0xFF007251),
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  )),
                            );
                          },
                        );
                      }).toList(),
                    )
                  ],
                ),
              ),
            )));
  }
}
