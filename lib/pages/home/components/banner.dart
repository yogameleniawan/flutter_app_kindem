import 'package:flutter/material.dart';
import 'package:flutter_app_stulish/helpers/sizes_helpers.dart';
import 'package:flutter_app_stulish/pages/categories/categories-main.dart';

class BannerHome extends StatelessWidget {
  const BannerHome({
    Key? key,
  }) : super(key: key);

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
                Navigator.of(context).push(
                  PageRouteBuilder(
                    transitionDuration: Duration(milliseconds: 2000),
                    pageBuilder: (BuildContext context,
                        Animation<double> animation,
                        Animation<double> secondaryAnimation) {
                      return CategoriesMain();
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
