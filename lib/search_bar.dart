import 'package:flutter/material.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'main.dart';

class SearchField extends StatelessWidget {
  const SearchField({
    super.key,
    required this.onChanged,
  });

  static const String hintText = 'Enter any food restaurant or dish';
  final ValueChanged<String> onChanged;

  void updateSearchQuery(String newSearchQuery) {
    EasyDebounce.debounce('newSearchQueryDebounce',
        const Duration(milliseconds: 500), () => onChanged(newSearchQuery));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding:
            const EdgeInsets.symmetric(horizontal: MenuApp.horizontalPadding),
        child: Center(
          child: Transform.translate(
              offset: const Offset(0.0, -25.0),
              child: Material(
                  color: Colors.white,
                  borderOnForeground: false,
                  elevation: 8.0,
                  shadowColor: Colors.black45,
                  borderRadius: const BorderRadius.all(Radius.circular(3.0)),
                  child: TextField(
                    onChanged: (value) => updateSearchQuery(value),
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(3.0)),
                        borderSide: BorderSide.none,
                      ),
                      prefixIcon: Icon(Icons.search_outlined),
                      hintText: hintText,
                    ),
                  ))),
        ));
  }
}
