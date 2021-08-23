import 'dart:convert';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:untitled8/api/api_key.dart';
import 'package:untitled8/models/failure.dart';
import 'package:untitled8/models/meal_plan.dart';
import 'package:http/http.dart' as http;
import 'package:untitled8/models/similar.dart';
import 'package:untitled8/models/type_model.dart';

class HomePageRepo {
  final List<String> apiKey = ApiKey.keys;

  Future<MealPlanList> getMealPlanList() async {
    await FirebaseFirestore.instance
        .collection('MealPlan')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .collection('EveryDayPlan')
        .doc(DateTime(
                DateTime.now().year, DateTime.now().month, DateTime.now().day)
            .toString()
            .trim())
        .get()
        .then((value) async {
      if (!value.exists) {
        var url = Uri.parse(
            'https://api.spoonacular.com/mealplanner/generate?timeFrame=day&apiKey=fd78d9a0edbd4200ad09b47adf0244a6');
        var response = await http.get(url);
        var body = json.decode(response.body);
        if (response.statusCode == 200) {
          value.reference.set(body);
        } else if (response.statusCode == 401) {
          throw Failure(code: 401, message: body['message']);
        } else {
          var msg = 'Something went wrong';
          if (body.containsKey('message')) {
            msg = body['message'];
          }
          throw Failure(code: response.statusCode, message: msg);
        }
      } else {
        print("it existes");
      }
    });
    final newdoc = await FirebaseFirestore.instance
        .collection('MealPlan')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .collection('EveryDayPlan')
        .doc(DateTime(
                DateTime.now().year, DateTime.now().month, DateTime.now().day)
            .toString()
            .trim())
        .get();
    return MealPlanList.fromDocument(newdoc);
  }

  Future<FoodTypeList> getBrackfast(String type, int no) async {
    var url = Uri.parse(
        'https://api.spoonacular.com/recipes/random?number=5&tags=$type&apiKey=fd78d9a0edbd4200ad09b47adf0244a6');
    var response = await http.get(url);
    var body = json.decode(response.body);
    print("get random food: " + response.statusCode.toString());

    if (response.statusCode == 200) {
      return FoodTypeList.fromJson(body['recipes']);
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
