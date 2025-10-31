import 'package:flutter/material.dart';
import 'package:projet/models/food.dart';

class FoodDetail extends StatelessWidget {
  final Food food;

  FoodDetail({required this.food});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Food Detail'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              ListTile(
                title: Text("Name"),
                subtitle: Text("${food.name}"),
              ),
              ListTile(
                title: Text("ID"),
                subtitle: Text("${food.id}"),
              ),
              ListTile(
                title: Text("Image"),
                subtitle: Text("${food.image}"),
              ),
              ListTile(
                title: Text("Price"),
                subtitle: Text("${food.price}"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
