import 'package:flutter/material.dart';
import 'package:flutter_app_stulish/helpers/sizes_helpers.dart';
import 'package:flutter_app_stulish/models/user.dart';
import 'package:flutter_app_stulish/pages/categories/components/skeleton-chapter.dart';
import 'package:flutter_app_stulish/pages/friend_list/components/skeleton-friend-list.dart';
import 'package:flutter_app_stulish/pages/profiles/profile-detail.dart';
import 'package:flutter_app_stulish/services/auth.dart';
import 'package:flutter_app_stulish/services/httpservice.dart';
import 'package:provider/provider.dart';
import 'package:skeletons/skeletons.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'dart:async';

class FriendList extends StatefulWidget {
  const FriendList({Key? key}) : super(key: key);

  @override
  State<FriendList> createState() => _FriendListState();
}

class _FriendListState extends State<FriendList> {
  final HttpService service = new HttpService();
  List users = [];
  bool _isLoadingUser = false;
  bool _isLoading = true;

  Future getAllUsers() async {
    setState(() {
      _isLoadingUser = true;
    });

    final String uri =
        "https://stulish-rest-api.herokuapp.com/api/v1/getAllUsers";
    String? token =
        await Provider.of<AuthProvider>(context, listen: false).getToken();
    http.Response result = await http.get(Uri.parse(uri), headers: {
      'Authorization': 'Bearer $token',
    });

    // final String uri = "http://10.0.2.2:8000/api/getAllUsers";
    // http.Response result = await http.get(Uri.parse(uri));
    if (result.statusCode == HttpStatus.ok) {
      final jsonResponse = json.decode(result.body);
      List userMap = jsonResponse['data'];
      List user = userMap.map((i) => User.fromJson(i)).toList();
      setState(() {
        users = user;
        _isLoadingUser = false;
      });
      _isLoading = false;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAllUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF1F1F1),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.only(top: 55, right: 20, left: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Cari Teman",
                style: TextStyle(fontSize: 24),
              ),
              Container(
                color: Colors.white,
                margin: EdgeInsets.only(top: 10),
                child: TextFormField(
                  // controller: ,
                  // controller: usernameController,
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),

                  decoration: InputDecoration(
                    hintText: 'Nama User',
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 1.0, horizontal: 1.0),
                    hintStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                    prefixIcon: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Image.asset(
                        "assets/images/search.png",
                        width: 20,
                        height: 20,
                        fit: BoxFit.fill,
                      ),
                    ),
                    // Icon(Icons.text_fields, color: Colors.black),
                    // suffixIcon: Icon(Icons.edit, color: Colors.black),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(width: 1, color: Color(0xFFF5A720)),
                      borderRadius: BorderRadius.circular(6.0),
                      // borderSide: ,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(width: 1, color: Colors.blue),
                      borderRadius: BorderRadius.circular(6.0),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(top: 20),
                  child: Skeleton(
                    skeleton: SkeletonFriendList(),
                    isLoading: _isLoadingUser,
                    child: ListView.builder(
                      itemCount: users.length,
                      itemBuilder: (context, int index) {
                        return Builder(
                          builder: (context) {
                            return InkWell(
                              onTap: () {
                                Navigator.push(context, MaterialPageRoute(
                                    builder: (BuildContext context) {
                                  return ProfileDetail(name: users[index].name);
                                }));
                              },
                              child: Padding(
                                padding: EdgeInsets.only(
                                    top: displayHeight(context) * 0.01,
                                    bottom: displayHeight(context) * 0.01),
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
                                    children: [
                                      Image.asset(
                                        "assets/images/user_icon.png",
                                        width: displayWidth(context) * 0.12,
                                        // height: displayHeight(context) * 0.05,
                                        fit: BoxFit.fill,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                          left: displayWidth(context) * 0.03,
                                        ),
                                        child: Expanded(
                                          child: Container(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(users[index].name,
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold)),
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      top: displayHeight(
                                                              context) *
                                                          0.01),
                                                  child: Text(
                                                      "CITIZEN/RAKYAT BIASA (LV1)",
                                                      style: TextStyle(
                                                          fontWeight: FontWeight
                                                              .normal)),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
