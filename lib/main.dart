import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'shared/client_details.dart';
import 'shared/filter_options.dart';
import 'functions/geolocation.dart';
import 'hero.dart';
import 'search_result.dart';
import 'drawer.dart';

void main() {
  runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider<FilterOptions>(
            create: (BuildContext context) => FilterOptions()),
        ChangeNotifierProvider<ClientDetails>(
            create: (BuildContext context) => ClientDetails())
      ],
      child: Builder(builder: (BuildContext context) {
        if (context.watch<FilterOptions>().location) {
          determinePosition().then((pos) => {
                context
                    .read<ClientDetails>()
                    .setCoords(pos.latitude, pos.longitude)
              });
        }
        return const MenuApp();
      })));
}

class MenuApp extends StatelessWidget {
  const MenuApp({super.key});

  static const String appBarTitle = '';
  static const String title = 'Menu';
  static const Color heroColor = Color.fromARGB(200, 243, 243, 244);
  static const double maxWidth = 800.0;
  static const double minWidth = 400.0;
  static const double horizontalPadding = 50.0;
  static const double maxItemsScrollHeight = 400;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: title,
        theme: ThemeData(scaffoldBackgroundColor: Colors.white),
        home: Scaffold(
            appBar: AppBar(
              title: const Text(appBarTitle),
              foregroundColor: Colors.black54,
              backgroundColor: heroColor,
              shadowColor: Colors.transparent,
            ),
            drawer: const DrawerWidget(),
            body: ListView(children: const <Widget>[
              HeroWidget(),
              SearchResult(),
            ])));
  }
}
