import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_stulish/models/score.dart';
import 'package:flutter_app_stulish/models/user.dart';
import 'package:flutter_app_stulish/services/auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';

class ResultMain extends StatefulWidget {
  ResultMain(
      {Key? key,
      required this.id_user,
      required this.id_sub_category,
      required this.image_sub_category})
      : super(key: key);
  final int id_user;
  final String id_sub_category;
  final String image_sub_category;
  @override
  _ResultMainState createState() => _ResultMainState();
}

class _ResultMainState extends State<ResultMain> {
  Score score = new Score();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getScore();
  }

  Future getScore() async {
    final String uri =
        "https://stulish-rest-api.herokuapp.com/api/v1/getScore?user_id=" +
            widget.id_user.toString() +
            "&sub_category_id=" +
            widget.id_sub_category;
    String? token =
        await Provider.of<AuthProvider>(context, listen: false).getToken();
    http.Response result = await http.get(Uri.parse(uri), headers: {
      'Authorization': 'Bearer $token',
    });
    if (result.statusCode == HttpStatus.ok) {
      final jsonResponse = json.decode(result.body);
      var scores = Score.getScore(jsonResponse);
      setState(() {
        score = scores;
      });
    }
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20)),
                        child: CachedNetworkImage(
                          width: 80,
                          imageUrl: widget.image_sub_category,
                          progressIndicatorBuilder:
                              (context, url, downloadProgress) =>
                                  CircularProgressIndicator(
                                      value: downloadProgress.progress),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                        ),
                      ),
                    ),
                  ],
                ),
                Text("YOUR SCORE IS ",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
                Text(
                  score.is_true.toString() + "/" + score.total_test.toString(),
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          )),
        ));
  }
}
