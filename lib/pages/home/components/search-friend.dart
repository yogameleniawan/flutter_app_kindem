import 'package:coachmaker/coachmaker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app_stulish/helpers/sizes_helpers.dart';
import 'package:flutter_app_stulish/pages/friend_list/all_user-main.dart';

class SearchFriend extends StatelessWidget {
  const SearchFriend({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          top: displayHeight(context) * 0.02,
          bottom: displayHeight(context) * 0.02),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            PageRouteBuilder(
              transitionDuration: Duration(milliseconds: 500),
              pageBuilder: (BuildContext context, Animation<double> animation,
                  Animation<double> secondaryAnimation) {
                return AllUser();
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
          width: displayWidth(context) * 1,
          height: displayHeight(context) * 0.05,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.only(left: displayWidth(context) * 0.02),
                child: Row(
                  children: [
                    Image(
                      width: displayWidth(context) * 0.05,
                      image: AssetImage("assets/images/user_icon.png"),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.only(left: displayWidth(context) * 0.02),
                      child: Text("20++",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ),
              CoachPoint(
                initial: 'btn-teman',
                child: Padding(
                  padding: EdgeInsets.only(right: displayWidth(context) * 0.02),
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
                        'Cari Teman',
                        style: TextStyle(color: Colors.white),
                      )),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
