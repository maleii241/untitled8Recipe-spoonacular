import 'dart:convert';
import 'dart:math';

import 'package:http/http.dart' as http;
import 'package:untitled8/models/nutrients.dart';
import '../api/api_key.dart';
import '../models/equipments.dart';
import '../models/failure.dart';
import '../models/similar.dart';
import '../models/recipe.dart';

class RecipeInformation {
  final List<String> apiKey = ApiKey.keys;

  Future<Recipe> getRecipeInformationFood(String id) async {
    var url = Uri.parse(
        'https://api.spoonacular.com/recipes/$id/information?apiKey=fd78d9a0edbd4200ad09b47adf0244a6');
    var response = await http.get(url);
    var body = json.decode(response.body);
    print("get random food: " + response.statusCode.toString());

    if (response.statusCode == 200) {
      return Recipe.fromJson(body);
    } else if (response.statusCode == 401) {
      throw Failure(code: 401, message: body['message']);
    } else {
      var msg = 'что-то пошло не так';
      if (body.containsKey('message')) {
        msg = body['message'];
      }
      throw Failure(code: response.statusCode, message: msg);
    }
  }

  Future<SimilarList> getSimilarFood(String id) async {
    var url = Uri.parse(
        'https://api.spoonacular.com/recipes/$id/similar?apiKey=fd78d9a0edbd4200ad09b47adf0244a6');
    var response = await http.get(url);
    var body = json.decode(response.body);
    print("get similar food :" + response.statusCode.toString());

    if (response.statusCode == 200) {
      return SimilarList.fromJson(body);
    } else if (response.statusCode == 401) {
      throw Failure(code: 401, message: body['message']);
    } else {
      var msg = 'что-то пошло не так';
      if (body.containsKey('message')) {
        msg = body['message'];
      }
      throw Failure(code: response.statusCode, message: msg);
    }
  }

  Future<EquipmentsList> getEquipments(String id) async {
    var url = Uri.parse(
        'https://api.spoonacular.com/recipes/$id/equipmentWidget.json?apiKey=fd78d9a0edbd4200ad09b47adf0244a6');
    var response = await http.get(url);
    var body = json.decode(response.body);
    print("get Equipments food :" + response.statusCode.toString());

    if (response.statusCode == 200) {
      return EquipmentsList.fromJson(body['equipment']);
    } else if (response.statusCode == 401) {
      throw Failure(code: 401, message: body['message']);
    } else {
      var msg = 'что-то пошло не так';
      if (body.containsKey('message')) {
        msg = body['message'];
      }
      throw Failure(code: response.statusCode, message: msg);
    }
  }

  Future<Nutrient> getNutrient(String id) async {
    var url = Uri.parse(
        'https://api.spoonacular.com/recipes/$id/nutritionWidget.json?apiKey=fd78d9a0edbd4200ad09b47adf0244a6');
    var response = await http.get(url);
    var body = json.decode(response.body);
    print("get Equipments food :" + response.statusCode.toString());

    if (response.statusCode == 200) {
      return Nutrient.fromJson(body);
    } else if (response.statusCode == 401) {
      throw Failure(code: 401, message: body['message']);
    } else {
      var msg = 'что-то пошло не так';
      if (body.containsKey('message')) {
        msg = body['message'];
      }
      throw Failure(code: response.statusCode, message: msg);
    }
  }
}
