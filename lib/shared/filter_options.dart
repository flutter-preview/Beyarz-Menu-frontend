import 'package:flutter/material.dart';

class FilterOptions with ChangeNotifier {
  // Option is unselected (false) by default
  bool hasGluten = false;
  bool isVegan = false;
  bool isHalal = false;
  bool location = false;

  double? minRating;
  double? maxRating;
  double? minPrice;
  double? maxPrice;
  double? chosenMinRating;
  double? chosenMaxRating;
  double? chosenMinPrice;
  double? chosenMaxPrice;

  void setGluten(bool value) => {hasGluten = value, notifyListeners()};
  void setVegan(bool value) => {isVegan = value, notifyListeners()};
  void setHalal(bool value) => {isHalal = value, notifyListeners()};
  void setLocation(bool value) => {location = value, notifyListeners()};

  void setMinPrice(double? value) => {
        if (value != null) {minPrice = value, notifyListeners()},
      };
  void setMaxPrice(double? value) => {
        if (value != null) {maxPrice = value, notifyListeners()},
      };
  void setMinRating(double? value) => {
        if (value != null) {minRating = value, notifyListeners()}
      };
  void setMaxRating(double? value) => {
        if (value != null) {maxRating = value, notifyListeners()},
      };

  void setChosenMinPrice(double? value) => {
        if (value != null) {chosenMinPrice = value, notifyListeners()},
      };
  void setChosenMaxPrice(double? value) => {
        if (value != null) {chosenMaxPrice = value, notifyListeners()},
      };
  void setChosenMinRating(double? value) => {
        if (value != null) {chosenMinRating = value, notifyListeners()},
      };
  void setChosenMaxRating(double? value) => {
        if (value != null) {chosenMaxRating = value, notifyListeners()},
      };
}
