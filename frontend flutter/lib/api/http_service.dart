import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:projet/models/food.dart';

class Api {
  static const String baseUrl = "http://192.168.35.9:8080/food";
  static const String getAllFood = "$baseUrl/getALLFood";
  static const String createFood = "$baseUrl/createFood";
  static const String deleteFood = "$baseUrl/deleteFood";
  static const String updateFood = "$baseUrl/updateFood";
  static const String findByName = "$baseUrl/findByNameContaining";
  static const String findByPriceRange = "$baseUrl/findByPriceRange";
}

class HttpService {

  Future<List<Food>> getFoods() async {
    try {
      final response = await http.get(Uri.parse(Api.getAllFood));
      if (response.statusCode == 200) {
        return (jsonDecode(response.body) as List)
            .map((item) => Food.fromMap(item))
            .toList();
      } else {
        throw Exception('Unable to retrieve foods. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception during getFoods: $e');
      throw e;
    }
  }

  Future<Food> addFood(Food food) async {
    try {
      final response = await http.post(
        Uri.parse(Api.createFood),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Access-Control-Allow-Origin': '*',
        },
        body: jsonEncode(food.toMap()),
      );

      if (response.statusCode == 200) {
        return Food.fromMap(jsonDecode(response.body));
      } else {
        throw Exception('Failed to create food. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception during addFood: $e');
      throw e;
    }
  }

  Future<void> editFood(Food food) async {
    try {
      final response = await http.put(
        Uri.parse('${Api.updateFood}/${food.id}'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Access-Control-Allow-Origin': '*',
        },
        body: jsonEncode(food.toMap()),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to update food. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception during updateFood: $e');
      throw e;
    }
  }

  Future<void> deleteFood(int id) async {
    try {
      final response = await http.delete(
        Uri.parse('${Api.deleteFood}/$id'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Access-Control-Allow-Origin': '*',
        },
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to delete food. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception during deleteFood: $e');
      throw e;
    }
  }

  Future<List<Food>> getFoodsByName(String name) async {
    try {
      final response = await http.get(Uri.parse('${Api.findByName}/$name'));

      if (response.statusCode == 200) {
        return (jsonDecode(response.body) as List)
            .map((item) => Food.fromMap(item))
            .toList();
      } else {
        throw Exception('Unable to retrieve foods by name. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception during getFoodsByName: $e');
      throw e;
    }
  }

  Future<List<Food>> getFoodsByPriceRange(int minPrice, int maxPrice) async {
    try {
      final response = await http.get(Uri.parse('${Api.findByPriceRange}/$minPrice/$maxPrice'));

      if (response.statusCode == 200) {
        return (jsonDecode(response.body) as List)
            .map((item) => Food.fromMap(item))
            .toList();
      } else {
        throw Exception('Unable to retrieve foods by price range. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception during getFoodsByPriceRange: $e');
      throw e;
    }
  }

  Future<List<Food>> getFoodsByNameAndPriceRange(String name, int minPrice, int maxPrice) async {
    try {
      final response = await http.get(Uri.parse('${Api.findByName}/$name'));

      if (response.statusCode == 200) {
        List<Food> foodsByName = (jsonDecode(response.body) as List)
            .map((item) => Food.fromMap(item))
            .toList();
        List<Food> filteredFoods = foodsByName
            .where((food) => food.price >= minPrice && food.price <= maxPrice)
            .toList();

        return filteredFoods;
      } else {
        throw Exception('Unable to retrieve foods by name. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception during getFoodsByNameAndPriceRange: $e');
      throw e;
    }
  }
}