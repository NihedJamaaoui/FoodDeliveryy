import 'package:flutter/material.dart';
import 'food.dart';

class FavPage extends StatefulWidget {
  final List<Food> favCon;
  final List<Food> bigCon;
  final Function(List<Food>) onFavoritesCleared;

  const FavPage({
    Key? key,
    required this.favCon,
    required this.bigCon,
    required this.onFavoritesCleared,
  }) : super(key: key);

  @override
  _FavPageState createState() => _FavPageState();
}

class _FavPageState extends State<FavPage> {
  void clearFavorites(BuildContext context) {
    setState(() {
      widget.favCon.clear();

      // Update isFavorite property in bigCon
      for (var food in widget.bigCon) {
        food.isFavorite = widget.favCon.contains(food);
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Favorites cleared'),
        duration: Duration(seconds: 2),
      ),
    );
    widget.onFavoritesCleared(List.from(widget.bigCon)); // Pass a copy to ensure immutability
  }


  @override
  Widget build(BuildContext context) {
    Color backgroundColor = Color(0xff40404B);
    Color backgroundColor2 = Color(0xb640404b);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites List'),
        backgroundColor: Color(0xff40404B),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              clearFavorites(context);
            },
          ),
        ],
      ),
      body: Container(
        color: backgroundColor2,
        child: ListView.builder(
          itemCount: widget.favCon.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.network(
                      widget.favCon[index].image,
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                    SizedBox(height: 8),
                    Text(
                      widget.favCon[index].name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Price: ${widget.favCon[index].price},00 Dt',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}