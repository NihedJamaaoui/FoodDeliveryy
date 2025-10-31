import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:projet/Utilities/colors.dart';
import 'package:projet/Utilities/constant.dart';
import 'package:projet/api/http_service.dart';
import 'package:projet/models/favmodel.dart';
import 'package:projet/models/food.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'detail.dart';
import 'login.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Food> BigCon = [];
  List<Food> FavCon = [];
  late Future<List<Food>> foodList;
  late TextEditingController searchController;
  RangeValues priceRange = const RangeValues(0, 50);

  void updatePriceRange(RangeValues values) {
    setState(() {
      priceRange = values;
    });
  }



  Widget buildFilterBottomSheet() {
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Filter by Price Range',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                ),
              ),
              SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Price Range: ${priceRange.start.toInt()} - ${priceRange.end.toInt()} Dt'),
                ],
              ),
              RangeSlider(
                values: priceRange,
                min: 0,
                max: 100,
                onChanged: (values) {
                  setState(() {
                    priceRange = values;
                  });
                },
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  refreshFoodList();
                },
                child: const Text('Apply Filter'),
              ),
            ],
          ),
        );
      },
    );
  }


  @override
  void initState() {
    super.initState();
    loadFavorites();
    searchController = TextEditingController();

    foodList = HttpService().getFoods();

    fetchFoodsFromDatabase();
  }

  Future<void> fetchFoodsFromDatabase() async {
    try {
      List<Food> foods = await HttpService().getFoods();
      setState(() { BigCon = foods; });
    } catch (error) {
      print("Error fetching foods: $error");
    }
  }

  Future<void> refreshFoodList() async {
    if (searchController.text.isEmpty) {
      setState(() { foodList = HttpService().getFoods();  });
    } else {
      setState(() {
       foodList = HttpService().getFoodsByNameAndPriceRange(
        searchController.text,
        priceRange.start.toInt(),
        priceRange.end.toInt(),
      );
    });
    }
  }

  Future<void> refreshFoodList2() async {
    if (searchController.text.isEmpty) {
      setState(() {
        foodList = HttpService().getFoodsByPriceRange(
          priceRange.start.toInt(),
          priceRange.end.toInt(),
        );
      });
    } else {
      setState(() {
        foodList = HttpService().getFoodsByNameAndPriceRange(
          searchController.text,
          priceRange.start.toInt(),
          priceRange.end.toInt(),
        );
      });
    }
  }


  void loadFavorites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? favList = prefs.getStringList('favorites');

    if (favList != null) {
      setState(() {
        FavCon = favList.map((json) => Food.fromMap(jsonDecode(json))).toList();
      });
    }
  }

  void saveFavorites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> favList = FavCon.map((food) => jsonEncode(food.toMap())).toList();
    prefs.setStringList('favorites', favList);
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = Utils().getScreenSize();
    return Scaffold(
      backgroundColor: backgroundclr,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(left: 12.0, right: 12, top: 25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      height: screenSize.height * 0.065,
                      width: screenSize.width * 0.115,
                      decoration: BoxDecoration(
                        color: lbackgroundclr,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: IconButton(
                        icon: const Icon(
                          Icons.favorite,
                          color: whiteclr,
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FavPage(
                                favCon: FavCon,
                                bigCon: BigCon,
                                onFavoritesCleared: (updatedBigCon) {
                                  setState(() {
                                    BigCon = updatedBigCon;
                                  });
                                },
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Column(
                      children: [
                        const Text(
                          "StreetFoods By",
                          style: TextStyle(
                              color: whiteclr,
                              fontSize: 17,
                              fontWeight: FontWeight.w500),
                        ),
                        SizedBox(
                          height: screenSize.height * 0.002,
                        ),
                        const Text(
                          "Us",
                          style: TextStyle(
                            color: primaryclr,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      height: screenSize.height * 0.065,
                      width: screenSize.width * 0.115,
                      decoration: BoxDecoration(
                        color: lbackgroundclr,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: IconButton(
                        icon: const Icon(
                          Icons.exit_to_app,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
                        },),),
                  ],
                ),
                SizedBox(
                  height: screenSize.height * 0.025,
                ),
                const Text(
                  "What would you like\nto order",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: whiteclr,
                    fontSize: 21,
                  ),
                ),
                SizedBox(
                  height: screenSize.height * 0.027,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      height: screenSize.height * 0.065,
                      width: screenSize.width * 0.785,
                      child: TextField(
                        controller: searchController,
                        onChanged: (value) {
                          refreshFoodList();
                        },
                        decoration: InputDecoration(
                          prefixIcon: const Icon(
                            Icons.search,
                            color: Colors.grey,
                          ),
                          hintText: "Find for restaurant or food...",
                          hintStyle: const TextStyle(color: Colors.grey),
                          fillColor: lbackgroundclr,
                          filled: true,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Colors.grey),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Colors.grey),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: screenSize.height * 0.065,
                      width: screenSize.width * 0.115,
                      decoration: BoxDecoration(
                        color: lbackgroundclr,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: IconButton(
                        icon: const Icon(
                          Icons.tune,
                          color: whiteclr,
                        ),
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            builder: (BuildContext context) {
                              return buildFilterBottomSheet();
                            },
                          ).then((value) {
                            refreshFoodList2();
                          });
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: screenSize.height * 0.027,
                ),
                SizedBox(
                  height: screenSize.height * 0.015,
                ),
                const Text(
                  "Fastest delivery",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: whiteclr,
                    fontSize: 21,
                  ),
                ),
                SizedBox(
                  height: screenSize.height * 0.020,
                ),
                SizedBox(
                  height: screenSize.height * 0.357,
                  child: FutureBuilder<List<Food>>(
                    future: foodList,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        List<Food> foods = snapshot.data!;
                        return ListView.builder(
                          shrinkWrap: true,
                          physics: const ScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          itemCount: foods.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(7.0),
                              child: Stack(
                                children: [
                                  InkWell(
                                    onTap: (() {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: ((context) => DetailScreen(
                                            detail: foods[index],
                                          )),
                                        ),
                                      );
                                    }),
                                    child: Container(
                                      width: screenSize.width * 0.65,
                                      decoration: BoxDecoration(
                                        color: lbackgroundclr,
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            height: screenSize.height * 0.19,
                                            width: screenSize.width * 0.65,
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                fit: BoxFit.cover,
                                                image: NetworkImage(foods[index].image),
                                              ),
                                              borderRadius: const BorderRadius.only(
                                                topLeft: Radius.circular(15),
                                                topRight: Radius.circular(15),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              children: [
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Text(
                                                      foods[index].name,
                                                      style: const TextStyle(
                                                          color: whiteclr,
                                                          fontSize: 17,
                                                          fontWeight:
                                                          FontWeight.w500),
                                                    ),
                                                    Text(
                                                      foods[index].price.toString() + ".00 Dt",
                                                      style: const TextStyle(
                                                          color: whiteclr,
                                                          fontSize: 17,
                                                          fontWeight:
                                                          FontWeight.w500),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: screenSize.height * 0.025,
                                                ),
                                                Row(
                                                  children: [
                                                    Container(
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                          BorderRadius.circular(
                                                              12),
                                                          color: const Color(
                                                              0xff40404B)),
                                                      height:
                                                      screenSize.height * 0.045,
                                                      width: screenSize.width * 0.2,
                                                      child: const Center(
                                                        child: Text(
                                                          "Fastfood",
                                                          style: TextStyle(
                                                              fontWeight:
                                                              FontWeight.w500,
                                                              color: whiteclr),
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: screenSize.width * 0.025,
                                                    ),
                                                    Container(
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                          BorderRadius.circular(
                                                              12),
                                                          color: const Color(
                                                              0xff40404B)),
                                                      height:
                                                      screenSize.height * 0.045,
                                                      width: screenSize.width * 0.2,
                                                      child: const Center(
                                                        child: Text(
                                                          "Chicken",
                                                          style: TextStyle(
                                                              fontWeight:
                                                              FontWeight.w500,
                                                              color: whiteclr),
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: screenSize.width * 0.025,
                                                    ),
                                                    Container(
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                          BorderRadius.circular(
                                                              12),
                                                          color: const Color(
                                                              0xff40404B)),
                                                      height:
                                                      screenSize.height * 0.045,
                                                      width: screenSize.width * 0.12,
                                                      child: const Center(
                                                        child: Text(
                                                          "Fries",
                                                          style: TextStyle(
                                                              fontWeight:
                                                              FontWeight.w500,
                                                              color: whiteclr),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    right: 0,
                                    child: Padding(
                                      padding: const EdgeInsets.all(6.0),
                                      child: IconButton(
                                        icon: Icon(
                                          BigCon[index].isFavorite ?? false
                                              ? Icons.favorite_rounded
                                              : Icons.favorite_border_rounded,
                                          size: 25,
                                          color: FavCon.contains(foods[index]) ? Colors.red : Colors.white,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            if (FavCon.contains(foods[index])) {
                                              FavCon.remove(foods[index]);
                                            } else {
                                              FavCon.add(foods[index]);
                                            }
                                            saveFavorites();
                                          });
                                        },
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            );
                          },
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}