import 'package:flutter/material.dart';
import 'package:flutter_app_stulish/helpers/sizes_helpers.dart';
import 'package:flutter_app_stulish/pages/chapter/categories-main.dart';
import 'package:flutter_app_stulish/pages/level/level-main.dart';

class BannerHome extends StatelessWidget {
  BannerHome({Key? key, required this.getCourses}) : super(key: key);
  final Future getCourses;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: displayHeight(context) * 0.05),
      child: Stack(children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image(
            image: AssetImage("assets/images/banner.jpg"),
          ),
        ),
        Positioned(
            top: displayHeight(context) * 0.15,
            left: displayWidth(context) * 0.05,
            child: InkWell(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (BuildContext context) {
                  // return CategoriesMain();
                  return LevelMain();
                })).then((value) {
                  getCourses;
                });
              },
              child: Container(
                  padding: EdgeInsets.fromLTRB(
                    displayWidth(context) * 0.02,
                    displayHeight(context) * 0.01,
                    displayWidth(context) * 0.02,
                    displayHeight(context) * 0.01,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Color(0xFFF5A71F),
                  ),
                  child: Text(
                    'Cari Materi',
                    style: TextStyle(color: Colors.white),
                  )),
            ))
      ]),
    );
  }
}
