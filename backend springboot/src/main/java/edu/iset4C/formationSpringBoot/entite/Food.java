package edu.iset4C.formationSpringBoot.entite;

import java.io.Serializable;

import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;

@Entity
public class Food<Food> implements Serializable{


@Id
@GeneratedValue(strategy=GenerationType.IDENTITY)
private Long id;

private String name;
private String image;
private String Description;
private int price;
private boolean isFavorite;

public boolean isFavorite() {
	return isFavorite;
}
public void setFavorite(boolean isFavorite) {
	this.isFavorite = isFavorite;
}
public Long getId() {
return id;
}
public void setId(Long id) {
this.id = id;
}
public String getName() {
return name;
}
public void setName(String name) {
this.name = name;
}
public String getImage() {
return image;
}
public void setImage(String image) {
this.image = image;
}
public String getDescription() {
return Description;
}
public void setDescription(String description) {
Description = description;
}
public int getPrice() {
return price;
}
public void setPrice(int price) {
this.price = price;
}


}
