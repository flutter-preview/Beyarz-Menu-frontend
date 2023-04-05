import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'main.dart';

class HeroWidget extends StatelessWidget {
  const HeroWidget({super.key});

  static const String header = 'Menu app';

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 25.0),
      decoration: const BoxDecoration(color: MenuApp.heroColor),
      child: Text(header,
          textAlign: TextAlign.center,
          style: GoogleFonts.nunito(
              fontWeight: FontWeight.w100,
              fontSize: 72,
              color: Colors.black38)),
    );
  }
}
