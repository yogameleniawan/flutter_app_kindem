import 'package:flutter/material.dart';
import 'package:kindem_app/helpers/sizes_helpers.dart';
import 'package:kindem_app/models/user.dart';
import 'package:kindem_app/pages/friend_list/components/skeleton-friend-list.dart';
import 'package:kindem_app/pages/profiles/profile-detail.dart';
import 'package:kindem_app/services/auth.dart';
import 'package:kindem_app/services/httpservice.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:skeletons/skeletons.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'dart:async';

class RankingList extends StatefulWidget {
  const RankingList({Key? key}) : super(key: key);

  @override
  State<RankingList> createState() => _RankingListState();
}

class _RankingListState extends State<RankingList> {
  final HttpService service = new HttpService();
  TextEditingController searchController = new TextEditingController();
  List users = [];
  bool _isLoadingUser = false;
  bool _isLoading = true;
  // List userx = [];
  User userx = new User();

  Future getAllUsers() async {
    setState(() {
      _isLoadingUser = true;
    });

    final String uri = dotenv.get('API_URL') + "/api/v1/getRankingUsers";
    String? token =
        await Provider.of<AuthProvider>(context, listen: false).getToken();
    http.Response result = await http.get(Uri.parse(uri), headers: {
      'Authorization': 'Bearer $token',
    });

    if (result.statusCode == HttpStatus.ok) {
      final jsonResponse = json.decode(result.body);
      List userMap = jsonResponse['data'];
      List user = userMap.map((i) => User.allUser(i)).toList();
      setState(() {
        users = user;
        _isLoadingUser = false;
      });
      _isLoading = false;
    }
  }

  void getUser() async {
    final String uri = dotenv.get('API_URL') + "/api/v1/user";
    String? token =
        await Provider.of<AuthProvider>(context, listen: false).getToken();
    http.Response result = await http.get(Uri.parse(uri), headers: {
      'Authorization': 'Bearer $token',
    });
    if (result.statusCode == HttpStatus.ok) {
      final jsonResponse = json.decode(result.body);
      var users = User.toString(jsonResponse);
      setState(() {
        userx = users;
      });
    }
  }

  AssetImage getBorder(String level) {
    if (level == "Emperor") {
      return AssetImage("assets/images/1-emperor.png");
    } else if (level == "King") {
      return AssetImage("assets/images/2-king.png");
    } else if (level == "Duke") {
      return AssetImage("assets/images/3-duke.png");
    } else if (level == "Prince") {
      return AssetImage("assets/images/4-prince.png");
    } else if (level == "Knight") {
      return AssetImage("assets/images/5-knight.png");
    } else {
      return AssetImage("assets/images/6-citizen.png");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    getAllUsers();
    getUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (users.length == 0) {
      return Center(child: CircularProgressIndicator());
    } else {
      return Scaffold(
        backgroundColor: Color(0xFFF1F1F1),
        body: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: 15, bottom: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Ranking Saya",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  InkWell(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (BuildContext context) {
                        return ProfileDetail(user: userx);
                      }));
                    },
                    child: Padding(
                      padding: EdgeInsets.only(
                          top: displayHeight(context) * 0.01,
                          bottom: displayHeight(context) * 0.01),
                      child: Container(
                        padding:
                            EdgeInsets.only(left: displayWidth(context) * 0.05),
                        width: displayWidth(context) * 1,
                        height: displayHeight(context) * 0.1,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  backgroundColor: Colors.transparent,
                                  maxRadius: displayWidth(context) * 0.09,
                                  backgroundImage: getBorder(userx.level),
                                  child: CircleAvatar(
                                      maxRadius: displayWidth(context) * 0.052,
                                      backgroundImage: userx.photo == null
                                          ? AssetImage(
                                              "assets/images/user_icon_big.png")
                                          : AssetImage(userx.photo.toString())
                                      // AssetImage(userx.photo.toString()),
                                      ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                    left: displayWidth(context) * 0.03,
                                  ),
                                  child: Container(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width: displayWidth(context) * 0.45,
                                          child: Text(
                                            userx.name.length > 30
                                                ? '${userx.name.substring(0, 30)}...'
                                                : userx.name,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            softWrap: false,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              top: displayHeight(context) *
                                                  0.01),
                                          child: Text(userx.level,
                                              style: TextStyle(
                                                  fontWeight:
                                                      FontWeight.normal)),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            if (userx.ranking == 1) ...[
                              Container(
                                alignment: Alignment.center,
                                width: displayWidth(context) * 0.1,
                                height: displayHeight(context) * 0.059,
                                margin: EdgeInsets.only(right: 22),
                                decoration: BoxDecoration(
                                  color: Color(0xFFF5A720),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: Text("#" + userx.ranking.toString(),
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16)),
                              ),
                            ] else if (userx.ranking == 2) ...[
                              Container(
                                alignment: Alignment.center,
                                width: displayWidth(context) * 0.1,
                                height: displayHeight(context) * 0.059,
                                margin: EdgeInsets.only(right: 22),
                                decoration: BoxDecoration(
                                  color: Color(0xFF0067B6),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: Text("#" + userx.ranking.toString(),
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16)),
                              ),
                            ] else if (userx.ranking == 3) ...[
                              Container(
                                alignment: Alignment.center,
                                width: displayWidth(context) * 0.1,
                                height: displayHeight(context) * 0.059,
                                margin: EdgeInsets.only(right: 22),
                                decoration: BoxDecoration(
                                  color: Color(0xFF43AB9B),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: Text("#" + userx.ranking.toString(),
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16)),
                              ),
                            ] else ...[
                              Container(
                                alignment: Alignment.center,
                                width: displayWidth(context) * 0.1,
                                height: displayHeight(context) * 0.059,
                                margin: EdgeInsets.only(right: 22),
                                decoration: BoxDecoration(
                                  color: Colors.grey[350],
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: Text("#" + userx.ranking.toString(),
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16)),
                              ),
                            ]
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 15),
                    child: Text("Ranking 10 Besar",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                // physics: NeverScrollableScrollPhysics(),
                itemCount: users.length,
                itemBuilder: (context, int index) {
                  if (users.length > 0) {
                    return Builder(
                      builder: (context) {
                        if (users[index].photo == null) {
                          users[index].photo =
                              "assets/images/user_icon_big.png";
                        }
                        return InkWell(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(
                                builder: (BuildContext context) {
                              return ProfileDetail(user: users[index]);
                            }));
                          },
                          child: Padding(
                            padding: EdgeInsets.only(
                                // top: displayHeight(context) * 0.01,
                                bottom: displayHeight(context) * 0.02),
                            child: Container(
                              padding: EdgeInsets.only(
                                  left: displayWidth(context) * 0.05),
                              width: displayWidth(context) * 1,
                              height: displayHeight(context) * 0.1,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      CircleAvatar(
                                        backgroundColor: Colors.transparent,
                                        maxRadius: displayWidth(context) * 0.09,
                                        backgroundImage:
                                            getBorder(users[index].level),
                                        child: CircleAvatar(
                                          backgroundColor: Colors.transparent,
                                          maxRadius:
                                              displayWidth(context) * 0.052,
                                          backgroundImage:
                                              AssetImage(users[index].photo),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                          left: displayWidth(context) * 0.03,
                                        ),
                                        child: Container(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                width: displayWidth(context) *
                                                    0.45,
                                                child: Text(
                                                  users[index].name.length > 30
                                                      ? '${users[index].name.substring(0, 30)}...'
                                                      : users[index].name,
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  softWrap: false,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    top:
                                                        displayHeight(context) *
                                                            0.01),
                                                child: Text(users[index].level,
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.normal)),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  if (index == 0) ...[
                                    Container(
                                      alignment: Alignment.center,
                                      width: displayWidth(context) * 0.1,
                                      height: displayHeight(context) * 0.059,
                                      margin: EdgeInsets.only(right: 22),
                                      decoration: BoxDecoration(
                                        color: Color(0xFFF5A720),
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      child: Text("#1",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16)),
                                    ),
                                  ] else if (index == 1) ...[
                                    Container(
                                      alignment: Alignment.center,
                                      width: displayWidth(context) * 0.1,
                                      height: displayHeight(context) * 0.059,
                                      margin: EdgeInsets.only(right: 22),
                                      decoration: BoxDecoration(
                                        color: Color(0xFF0067B6),
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      child: Text("#2",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16)),
                                    ),
                                  ] else if (index == 2) ...[
                                    Container(
                                      alignment: Alignment.center,
                                      width: displayWidth(context) * 0.1,
                                      height: displayHeight(context) * 0.059,
                                      margin: EdgeInsets.only(right: 22),
                                      decoration: BoxDecoration(
                                        color: Color(0xFF43AB9B),
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      child: Text("#3",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16)),
                                    ),
                                  ] else ...[
                                    Container(
                                      alignment: Alignment.center,
                                      width: displayWidth(context) * 0.1,
                                      height: displayHeight(context) * 0.059,
                                      margin: EdgeInsets.only(right: 22),
                                      decoration: BoxDecoration(
                                        color: Colors.grey[350],
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      child: Text("#" + (index + 1).toString(),
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16)),
                                    ),
                                  ]
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  } else {
                    return Container();
                  }
                },
              ),
            ),
          ],
        ),
      );
    }
  }
}
