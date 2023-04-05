class Menu {
  String restaurant;
  String description;
  String dish;
  String ethnicCategory;
  String ingredient;
  int rating;
  int hasGluten;
  int isVegan;
  int isHalal;
  int price;
  Map<String, dynamic> coord;

  Menu({
    required this.restaurant,
    required this.description,
    required this.dish,
    required this.ethnicCategory,
    required this.ingredient,
    required this.rating,
    required this.hasGluten,
    required this.isVegan,
    required this.isHalal,
    required this.price,
    required this.coord,
  });

  factory Menu.fromJson(Map<String, dynamic> json) {
    return Menu(
        restaurant: json['restaurant'],
        description: json['description'],
        dish: json['dish'],
        ethnicCategory: json['ethnic_category'],
        ingredient: json['ingredient'],
        rating: json['rating'],
        hasGluten: json['hasGluten'],
        isVegan: json['isVegan'],
        isHalal: json['isHalal'],
        price: json['price'],
        coord: json['coord']);
  }
}
