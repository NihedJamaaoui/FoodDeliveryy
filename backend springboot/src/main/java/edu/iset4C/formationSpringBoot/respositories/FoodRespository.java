package edu.iset4C.formationSpringBoot.respositories;
import java.util.List; 
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import edu.iset4C.formationSpringBoot.entite.Food;

@Repository
public interface FoodRespository extends JpaRepository <Food , Long> {

	public List<Food> findByName(String name);

	@Query("SELECT f FROM Food f WHERE LOWER(f.name) LIKE LOWER(CONCAT('%', :name, '%'))")
    List<Food> findByNameContaining(String name);
	
	@Query("SELECT f FROM Food f WHERE f.price BETWEEN :minPrice AND :maxPrice")
    List<Food> findByPriceRange(@Param("minPrice") int minPrice, @Param("maxPrice") int maxPrice);

}