package edu.iset4C.formationSpringBoot.UtilisateurController;

import java.util.List;  

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import edu.iset4C.formationSpringBoot.entite.Food;
import edu.iset4C.formationSpringBoot.services.FoodService;

@RestController
@RequestMapping("/food")
public class FoodController {
	
	@Autowired
	private FoodService foodService;


	
	
	@GetMapping(path = "/getALLFood") // http://localhost:8080/food/getALLFood
	public List<Food> getAllFood() {
		
		return foodService.getAllFood() ;
	}
	
	
	
	
	@PostMapping(path = "/createFood") // http://localhost:8080/food/createFood    
	public Food createFood(@RequestBody Food food) {
		
		return  foodService.createFood(food);
	}
										//	{
										//    "name": "Makloub",
	  									//    "image";
										//	  "price": 5000,
										//	}

	
	
	
	@PutMapping(path = "/updateFood/{id}") // http://localhost:8080/food/updateFood/1
	public Food updateFood(@PathVariable Long id, @RequestBody Food food) {
	    food.setId(id);
	    return foodService.updateFood(food);
	}
									//	{
									//    "id": 1,
									//    "name": "Makloub",
									//    "image";
									//	  "price": 5000,
									//	}
																		
										
	
	
	@DeleteMapping(path = "/deleteFood/{id}") // http://localhost:8080/food/deleteFood/1
	public void deleteFood(@PathVariable Long id) {
		foodService.deleteFood(id);
	}
	

	
	
	@GetMapping(path = "/findFoodById")// http://localhost:8080/food/findFoodById?id=1
	public ResponseEntity<Food> findFoodById(@RequestParam Long id) {
		Food utilisateur=foodService.findFoodById(id);
	   if(utilisateur==null) {
		   return new ResponseEntity<Food>(HttpStatus.NO_CONTENT);
	   }else {
		   return new ResponseEntity<Food>(utilisateur,HttpStatus.OK);
	   }
	    
	}
	
	
	 @GetMapping("/findByName/{name}")
	    public List<Food> findByName(@PathVariable String name) {
	        return foodService.findByName(name);
	    }
	 
	 
	 
	 @GetMapping("/findByNameContaining/{name}")
	    public List<Food> findByNameContaining(@PathVariable String name) {
	        return foodService.findByNameContaining(name);
	    }
	 
	 @GetMapping("/findByPriceRange/{minPrice}/{maxPrice}")
	 public List<Food> findByPriceRange(@PathVariable int minPrice,@PathVariable int maxPrice) {
	     return foodService.findByPriceRange(minPrice, maxPrice);

	 	}
	 
	}

