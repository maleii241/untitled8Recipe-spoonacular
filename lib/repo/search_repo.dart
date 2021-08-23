import 'dart:convert';
import 'dart:math';

import 'package:untitled8/api/api_key.dart';
import 'package:untitled8/models/failure.dart';
import 'package:untitled8/models/search_autocomplete_model.dart';
import 'package:untitled8/models/search_result_model.dart';
import 'package:http/http.dart' as http;

class SearchRepo {
  final List<String> apiKey = ApiKey.keys;

  Future<SearchResultList> getSearchList(String type, int no) async {
    var url = Uri.parse(
        'https://api.spoonacular.com/recipes/complexSearch?query=$type&number=$no&apiKey=fd78d9a0edbd4200ad09b47adf0244a6');
    var response = await http.get(url);
    var body = json.decode(response.body);
    print("get random food: " + response.statusCode.toString());

    if (response.statusCode == 200) {
      return SearchResultList.fromJson(body['results']);
    } else if (response.statusCode == 401) {
      throw Failure(code: 401, message: body['message']);
    } else {
      var msg = 'Something went wrong';
      if (body.containsKey('message')) {
        msg = body['message'];
      }
      throw Failure(code: response.statusCode, message: msg);
    }
  }

  Future<SearchAutoCompleteList> getAutoCompleteList(String searchText) async {
    var url = Uri.parse(
        'https://api.spoonacular.com/recipes/autocomplete?number=100&query=$searchText&apiKey=fd78d9a0edbd4200ad09b47adf0244a6');
    var response = await http.get(url);
    var body = json.decode(response.body);
    print("get random food: " + response.statusCode.toString());

    if (response.statusCode == 200) {
      return SearchAutoCompleteList.fromJson(body);
    } else if (response.statusCode == 401) {
      throw Failure(code: 401, message: body['message']);
    } else {
      var msg = 'Something went wrong';
      if (body.containsKey('message')) {
        msg = body['message'];
      }
      throw Failure(code: response.statusCode, message: msg);
    }
  }
}
