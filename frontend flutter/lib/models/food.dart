class Food {
  static int _lastId = 0;

  int id;
  String name;
  String image;
  int price;
  String description;
  bool? isFavorite;

  Food({
    int? id,
    required this.name,
    required this.image,
    required this.price,
    required this.description,
    this.isFavorite,
  }) : id = id ?? ++_lastId;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'price': price,
      'description': description,
      'isFavorite': isFavorite,
    };
  }

  factory Food.fromMap(Map<String, dynamic> map) {
    return Food(
      id: map['id'],
      name: map['name'],
      image: map['image'],
      price: map['price'],
      description: map['description'],
      isFavorite: map['isFavorite'],
    );
  }
}
