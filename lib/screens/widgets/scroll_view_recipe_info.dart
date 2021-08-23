import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:html/dom.dart' as dom;
import 'package:untitled8/models/meal_plan.dart';
import 'package:untitled8/models/nutrients.dart';
import 'package:untitled8/screens/widgets/nutreitions.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../models/equipments.dart';
import '../../models/recipe.dart';
import '../../models/similar.dart';
import '../../theme/colors.dart';
import 'coustom_app_bar.dart';
import 'equipments.dart';
import 'ingredients.dart';
import 'similar_screen.dart';
import 'true_false_table.dart';
import 'type_info.dart';

class CustomRecipeInfo extends StatelessWidget {
  final Recipe recipe;
  final List<Similar> similar;
  final Nutrient nutrient;
  final List<Equipments> equipment;
  const CustomRecipeInfo({
    Key key,
    this.recipe,
    this.similar,
    this.equipment,
    this.nutrient,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: athens_gray,
      child: CustomScrollView(
        physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        slivers: <Widget>[
          SliverPersistentHeader(
            delegate: MySliverAppBar(
              recipe.image,
              recipe.title,
              recipe,
              expandedHeight: 300,
            ),
            pinned: true,
          ),
          SliverToBoxAdapter(
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
              child: Container(
                foregroundDecoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  recipe.title,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(10)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        Text(recipe.readyInMinutes.toString() + " мин.",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20)),
                        Text("ВРЕМЯ ПРИГОТОВЛЕНИЯ", style: TextStyle(color: Colors.grey))
                      ],
                    ),

                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                "Ингредиенты",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ),
          ),
          if (recipe.extendedIngredients.isNotEmpty)
            IngredientsWidget(
              recipe: recipe,
            ),
          if (recipe.instructions != null)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "приготовление",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    SizedBox(height: 20),
                    Html(
                        data: recipe.instructions,
                        onLinkTap: (String url,
                            RenderContext context,
                            Map<String, String> attributes,
                            dom.Element element) {
                          launch(url);
                        }),
                  ],
                ),
              ),
            ),
          if (equipment.isNotEmpty)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  "Оборудование",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ),
            ),
          if (equipment.isNotEmpty)
            EquipmentsListView(
              equipments: equipment,
            ),
          if (recipe.summary != null)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Краткое описание",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    SizedBox(height: 20),
                    Html(
                        data: recipe.summary,
                        onLinkTap: (String url,
                            RenderContext context,
                            Map<String, String> attributes,
                            dom.Element element) {
                          launch(url);
                        }),
                  ],
                ),
              ),
            ),


        ],
      ),
    );
  }
}
