package edu.iset4C.formationSpringBoot.services;



import java.util.List;	

import java.util.Optional;



import org.springframework.beans.factory.annotation.Autowired;

import org.springframework.stereotype.Service;



import edu.iset4C.formationSpringBoot.entite.Food;

import edu.iset4C.formationSpringBoot.respositories.FoodRespository;



@Service

public class FoodServiceImp implements FoodService {

	

	@Autowired 

	private FoodRespository foodRespository;



	

	@Override

	public List<Food> getAllFood() {

		return foodRespository.findAll();

	}

	



	@Override
	public Food findFoodById(Long id) {

		Optional<Food> utOptional =foodRespository.findById(id);

		if(utOptional.isEmpty()) {

			return null;	

		}else {

			return utOptional.get();

		}	

	}


	@Override
	public Food createFood(Food food) {

		return foodRespository.save(food);

	}


	@Override
	public Food updateFood(Food food) {

	    Optional<Food> utOptional = foodRespository.findById(food.getId());

	    if (utOptional.isEmpty()) {

	        return null;

	    } else {

	        return foodRespository.save(food);

	    }

	}


	@Override

	public void deleteFood(Long id) {

		foodRespository.deleteById(id); 

	}

	@Override

	public List<Food> findByName(String name) {

		return foodRespository.findByName(name); 	 

	}


	 @Override

	    public List<Food> findByNameContaining(String name) {

	        return foodRespository.findByNameContaining(name);

	    }

	 @Override

	    public List<Food> findByPriceRange(int minPrice, int maxPrice) {

	        return foodRespository.findByPriceRange(minPrice, maxPrice);

	    }

}