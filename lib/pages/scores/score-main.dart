import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_stulish/models/score.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:flutter_app_stulish/services/auth.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:intl/intl.dart';

class ScoreMain extends StatefulWidget {
  ScoreMain({
    Key? key,
    required this.id_user,
  }) : super(key: key);
  final int id_user;
  @override
  _ScoreMainState createState() => _ScoreMainState();
}

class _ScoreMainState extends State<ScoreMain> {
  List scores = [];
  DateTime now = DateTime.now();
  @override
  void initState() {
    super.initState();
    getAllScores();
  }

  Future getAllScores() async {
    final String uri = dotenv.get('API_URL') +
        "/api/v1/getAllScore?user_id=" +
        widget.id_user.toString();
    String? token =
        await Provider.of<AuthProvider>(context, listen: false).getToken();
    http.Response result = await http.get(Uri.parse(uri), headers: {
      'Authorization': 'Bearer $token',
    });
    if (result.statusCode == HttpStatus.ok) {
      final jsonResponse = json.decode(result.body);
      List allScoreMap = jsonResponse['data'];
      List allScores = allScoreMap.map((i) => Score.fromJson(i)).toList();
      setState(() {
        scores = allScores;
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
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20, top: 20),
                      child: Text("YOUR SCORES (SKOR KAMU)",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold)),
                    ),
                    Expanded(
                      child: ListView.builder(
                          itemCount: scores.length,
                          itemBuilder: (context, int index) {
                            DateTime parseDate =
                                new DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
                                    .parse(scores[index].created_at);
                            var inputDate =
                                DateTime.parse(parseDate.toString());
                            var outputFormat = DateFormat('MM/dd/yyyy hh:mm a');
                            var outputDate = outputFormat.format(inputDate);
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 20),
                              child: Container(
                                padding: const EdgeInsets.only(
                                    top: 10, bottom: 10, left: 5, right: 5),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20)),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(right: 10),
                                          child: ExtendedImage.network(
                                            scores[index].image,
                                            width: 80,
                                            fit: BoxFit.fill,
                                            cache: true,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(30.0)),
                                          ),
                                        ),
                                        Text(
                                          scores[index].name,
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xFF007251)),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 20, right: 20),
                                          child: Text(
                                            scores[index].score,
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color: Color(0xFF007251)),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: Row(
                                        children: [
                                          Icon(Icons.timer),
                                          Text("Test Time : " + outputDate),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                    ),
                  ],
                ),
              ),
            )));
  }
}
