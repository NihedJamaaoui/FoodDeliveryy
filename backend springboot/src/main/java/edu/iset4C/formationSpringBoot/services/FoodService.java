package edu.iset4C.formationSpringBoot.services;

import java.util.List;

import edu.iset4C.formationSpringBoot.entite.Food;

public interface FoodService {

//Les Methodes CRUD Basique
public List<Food> getAllFood();
public Food createFood(Food food);
public Food updateFood(Food food);
public void deleteFood(Long id);

public Food findFoodById(Long id);
public List<Food> findByName(String name);
List<Food> findByNameContaining(String name);
List<Food> findByPriceRange(int minPrice, int maxPrice);

}
