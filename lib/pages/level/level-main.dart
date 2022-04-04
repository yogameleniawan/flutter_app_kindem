import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_stulish/helpers/sizes_helpers.dart';
import 'package:flutter_app_stulish/models/category.dart';
import 'package:flutter_app_stulish/pages/chapter/categories-main.dart';
import 'package:flutter_app_stulish/pages/components/perloader-page.dart';
import 'package:flutter_app_stulish/services/auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:http/http.dart' as http;

class LevelMain extends StatefulWidget {
  LevelMain({Key? key}) : super(key: key);

  @override
  State<LevelMain> createState() => _LevelMainState();
}

class _LevelMainState extends State<LevelMain> {
  List categories = [];
  List courses = [];
  @override
  void initState() {
    super.initState();
    getAllCategory();
  }

  Future getAllCategory() async {
    final String uri = dotenv.get('API_URL') + "/api/v1/getAllCategories";
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
  Widget build(BuildContext context) {
    if (categories.length > 0) {
      return Scaffold(
        backgroundColor: Color(0xFFF1F1F1),
        body: Container(
          padding: EdgeInsets.only(top: 20),
          child: ListView.builder(
              itemCount: categories.length,
              itemBuilder: (context, int index) {
                return Builder(builder: (context) {
                  return InkWell(
                    onTap: () {
                      if (index == 0) {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (BuildContext context) {
                          return CategoriesMain(
                            id_category: categories[index].id,
                            image_category: categories[index].image,
                            name_category: categories[index].name,
                          );
                        }));
                      } else {
                        if (categories[index - 1].is_complete == 1) {
                          Navigator.push(context, MaterialPageRoute(
                              builder: (BuildContext context) {
                            return CategoriesMain(
                              id_category: categories[index].id,
                              image_category: categories[index].image,
                              name_category: categories[index].name,
                            );
                          }));
                        }
                      }
                    },
                    child: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            children: [
                              index == 0
                                  ? Image(
                                      width: displayWidth(context) * 0.3,
                                      image: AssetImage(
                                          "assets/images/sword-top.png"),
                                    )
                                  : Image(
                                      width: displayWidth(context) * 0.08,
                                      image: AssetImage(
                                          "assets/images/sword-mid.png"),
                                    ),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  vertical: displayHeight(context) * 0.01,
                                  horizontal: displayWidth(context) * 0.01,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(
                                      displayWidth(context) * 0.1),
                                ),
                                child: index == 0
                                    ? ExtendedImage.network(
                                        categories[index].image,
                                        width: displayWidth(context) * 0.3,
                                        fit: BoxFit.fill,
                                        cache: true,
                                        borderRadius:
                                            BorderRadius.circular(100.0),
                                      )
                                    : categories[index - 1].is_complete == 1
                                        ? ExtendedImage.network(
                                            categories[index].image,
                                            width: displayWidth(context) * 0.3,
                                            fit: BoxFit.fill,
                                            cache: true,
                                            borderRadius:
                                                BorderRadius.circular(100.0),
                                          )
                                        : ExtendedImage.network(
                                            categories[index].image,
                                            width: displayWidth(context) * 0.3,
                                            fit: BoxFit.fill,
                                            color: Colors.black12,
                                            cache: true,
                                            borderRadius:
                                                BorderRadius.circular(100.0),
                                          ),
                              ),
                              index == categories.length - 1
                                  ? Padding(
                                      padding: EdgeInsets.only(bottom: 20),
                                      child: Image(
                                        width: displayWidth(context) * 0.08,
                                        image: AssetImage(
                                            "assets/images/sword-bottom.png"),
                                      ),
                                    )
                                  : Container(),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                });
              }),
        ),
      );
    } else {
      return PreloaderPage();
    }
  }
}
