import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'shared/filter_options.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    double? minPrice = context.read<FilterOptions>().minPrice?.roundToDouble();
    double? maxPrice = context.read<FilterOptions>().maxPrice?.roundToDouble();
    double? minRating =
        context.read<FilterOptions>().minRating?.roundToDouble();
    double? maxRating =
        context.read<FilterOptions>().maxRating?.roundToDouble();

    double? chosenMinPrice =
        context.read<FilterOptions>().chosenMinPrice?.roundToDouble();
    double? chosenMaxPrice =
        context.read<FilterOptions>().chosenMaxPrice?.roundToDouble();
    double? chosenMinRating =
        context.read<FilterOptions>().chosenMinRating?.roundToDouble();
    double? chosenMaxRating =
        context.read<FilterOptions>().chosenMaxRating?.roundToDouble();

    chosenMinPrice ??= minPrice;
    chosenMaxPrice ??= maxPrice;
    chosenMinRating ??= minRating;
    chosenMaxRating ??= maxRating;

    // Edge cases
    if (chosenMinPrice != null &&
        minPrice != null &&
        chosenMinPrice < minPrice) {
      chosenMinPrice = minPrice;
    }

    if (chosenMaxPrice != null &&
        maxPrice != null &&
        chosenMaxPrice > maxPrice) {
      chosenMaxPrice = maxPrice;
    }

    if (chosenMinRating != null &&
        minRating != null &&
        chosenMinRating < minRating) {
      chosenMinRating = minRating;
    }

    if (chosenMaxRating != null &&
        maxRating != null &&
        chosenMaxRating > maxRating) {
      chosenMaxRating = maxRating;
    }

    return Drawer(
        child: Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8.0),
          child: const Text(
            "Diet",
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FilterChip(
                label: const Text("Gluten"),
                selected: context.watch<FilterOptions>().hasGluten,
                onSelected: (bool value) {
                  context.read<FilterOptions>().setGluten(value);
                }),
            FilterChip(
                label: const Text("Vegan"),
                selected: context.watch<FilterOptions>().isVegan,
                onSelected: (bool value) {
                  context.read<FilterOptions>().setVegan(value);
                }),
            FilterChip(
                label: const Text("Halal"),
                selected: context.watch<FilterOptions>().isHalal,
                onSelected: (bool value) {
                  context.read<FilterOptions>().setHalal(value);
                }),
          ],
        ),
        if (minPrice != null &&
            maxPrice != null &&
            chosenMinPrice != null &&
            chosenMaxPrice != null) ...[
          const Divider(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: const Text(
              "Price range",
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("$minPrice"),
              RangeSlider(
                min: minPrice,
                max: maxPrice,
                divisions: maxPrice.toInt(),
                labels: RangeLabels(
                    chosenMinPrice.toString(), chosenMaxPrice.toString()),
                values: RangeValues(chosenMinPrice, chosenMaxPrice),
                onChanged: (RangeValues values) {
                  context.read<FilterOptions>().setChosenMinPrice(values.start);
                  context.read<FilterOptions>().setChosenMaxPrice(values.end);
                },
              ),
              Text("$maxPrice"),
            ],
          ),
        ],
        if (minRating != null &&
            maxRating != null &&
            chosenMinRating != null &&
            chosenMaxRating != null) ...[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: const Text(
              "Rating",
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("$minRating"),
              RangeSlider(
                  min: minRating,
                  max: maxRating,
                  divisions: (maxRating - minRating).toInt(),
                  labels: RangeLabels(
                      chosenMinRating.toString(), chosenMaxRating.toString()),
                  values: RangeValues(chosenMinRating, chosenMaxRating),
                  onChanged: (RangeValues values) {
                    context
                        .read<FilterOptions>()
                        .setChosenMinRating(values.start);
                    context
                        .read<FilterOptions>()
                        .setChosenMaxRating(values.end);
                  }),
              Text("$maxRating"),
            ],
          ),
        ],
        const Divider(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: const Text(
            "Location",
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Switch(
                value: context.watch<FilterOptions>().location,
                onChanged: (bool value) =>
                    context.read<FilterOptions>().setLocation(value)),
            const Text("Get menus near your location")
          ],
        ),
      ],
    ));
  }
}
