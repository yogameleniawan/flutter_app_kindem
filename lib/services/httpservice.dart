import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:flutter_app_stulish/models/category.dart';
import 'package:http/http.dart' as http;

class HttpService {
  Future<List> getAllCategory() async {
    final String uri =
        "https://stulish-rest-api.herokuapp.com/api/getAllCategories";

    http.Response result = await http.get(Uri.parse(uri));
    if (result.statusCode == HttpStatus.ok) {
      print("sukses");
      final jsonResponse = json.decode(result.body);
      List categoryMap = jsonResponse['data'];
      List category = categoryMap.map((i) => Category.fromJson(i)).toList();
      return category;
    } else {
      print("gagal");
      return const [];
    }
  }
}
