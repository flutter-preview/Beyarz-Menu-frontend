import 'package:flutter/material.dart';
import 'package:klick/shared/client_details.dart';
import 'package:provider/provider.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'shared/filter_options.dart';
import 'shared/menu.dart';
import 'shared/computed.dart';
import 'functions/fetch_suggestions.dart';
import 'main.dart';
import 'search_bar.dart';

void validateEnv(serverUrl) {
  // The given backend endpoint should not contain backslash
  assert(!serverUrl.endsWith('/'));
}

class SearchResult extends StatefulWidget {
  const SearchResult({super.key});

  static const String serverUrlFromEnv =
      String.fromEnvironment('serverUrl', defaultValue: 'localhost:3000');

  static const String searchUrl = '/search';
  static const String menusIndexUrl = '/menus';

  @override
  State<SearchResult> createState() => _SearchResultState();
}

class _SearchResultState extends State<SearchResult> {
  static const int pageSize = 10;
  static const int firstPageKey = 0;
  static Computed? metadata;
  static String? statistics;
  static String? searchQuery;
  double? chosenMinRating;
  double? chosenMaxRating;
  double? chosenMinPrice;
  double? chosenMaxPrice;
  double? lat;
  double? lon;
  bool? hasGluten;
  bool? isVegan;
  bool? isHalal;

  static PagingController<int, Menu> pagingController =
      PagingController(firstPageKey: firstPageKey);

  Future<void> fetchPageAndUpdateDrawer(int pageKey) async {
    try {
      Map<String, dynamic> response = await fetchSuggestions(
          searchQuery,
          pageKey,
          pageSize,
          chosenMinRating,
          chosenMaxRating,
          chosenMinPrice,
          chosenMaxPrice,
          lat,
          lon,
          hasGluten,
          isVegan,
          isHalal);

      List<Menu> newItems = response['menus'];
      statistics = response['statistics'];
      metadata = response['computed'];
      bool isLastPage = newItems.length < pageSize;

      if (isLastPage) {
        pagingController.appendLastPage(newItems);
      } else {
        int nextPageKey = pageKey + newItems.length;
        pagingController.appendPage(newItems, nextPageKey);
      }
    } catch (error) {
      statistics = null;
      pagingController.error = error;
    } finally {
      updateDrawerDetails();
    }
  }

  @override
  void initState() {
    pagingController
        .addPageRequestListener((pageKey) => fetchPageAndUpdateDrawer(pageKey));
    super.initState();
  }

  @override
  void dispose() {
    pagingController.dispose();
    super.dispose();
  }

  void updateSearchQuery(String newSearchQuery) {
    searchQuery = newSearchQuery;
    pagingController.refresh();
  }

  void updateDrawerDetails() {
    // There shouldn't be a limit on the lowest number,
    // a user typically wants to adjust their highest possible amount
    // context.read<FilterOptions>().setMinRating(metadata?.minRating.toDouble());
    // context.read<FilterOptions>().setMinPrice(metadata?.minPrice.toDouble());

    // Set filter option attributes from server stats
    context.read<FilterOptions>().setMinRating(1.0);
    context.read<FilterOptions>().setMaxRating(metadata?.maxRating.toDouble());

    context.read<FilterOptions>().setMinPrice(0.0);
    context.read<FilterOptions>().setMaxPrice(metadata?.maxPrice.toDouble());
  }

  Widget errorPage() {
    return Center(
      child: Column(children: [
        Text(
          pagingController.error.toString().replaceFirst('Exception: ', ''),
          style: const TextStyle(fontWeight: FontWeight.w200, fontSize: 18.0),
        ),
        const Padding(padding: EdgeInsets.symmetric(vertical: 4.0)),
        ElevatedButton.icon(
          onPressed: () => pagingController.retryLastFailedRequest(),
          icon: const Icon(Icons.replay_outlined, size: 18),
          label: const Text('Try again'),
        )
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    chosenMinRating = context.read<FilterOptions>().chosenMinRating;
    chosenMaxRating = context.read<FilterOptions>().chosenMaxRating;
    chosenMinPrice = context.read<FilterOptions>().chosenMinPrice;
    chosenMaxPrice = context.read<FilterOptions>().chosenMaxPrice;

    hasGluten = context.read<FilterOptions>().hasGluten;
    isVegan = context.read<FilterOptions>().isVegan;
    isHalal = context.read<FilterOptions>().isHalal;

    lat = context.watch<FilterOptions>().location
        ? context.read<ClientDetails>().latitude
        : null;
    lon = context.watch<FilterOptions>().location
        ? context.read<ClientDetails>().longitude
        : null;

    return Column(children: [
      SearchField(
        onChanged: updateSearchQuery,
      ),
      if (statistics is String)
        Container(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: Text(statistics.toString())),
      Container(
          constraints: const BoxConstraints(
              maxWidth: MenuApp.maxWidth,
              minWidth: MenuApp.minWidth,
              maxHeight: MenuApp.maxItemsScrollHeight),
          child: PagedListView<int, Menu>(
              pagingController: pagingController,
              builderDelegate: PagedChildBuilderDelegate<Menu>(
                  animateTransitions: true,
                  firstPageErrorIndicatorBuilder: (context) => errorPage(),
                  newPageErrorIndicatorBuilder: (context) => errorPage(),
                  noMoreItemsIndicatorBuilder: (context) {
                    return const Center(
                      child: Text('No more items left',
                          style: TextStyle(
                              fontWeight: FontWeight.w400, fontSize: 18.0)),
                    );
                  },
                  itemBuilder: (context, Menu menu, index) {
                    final Menu current = menu;
                    final restaurant = current.restaurant;
                    final description = current.description;
                    final rating = current.rating;
                    final price = current.price;

                    List<String> tagsList = [];
                    current.hasGluten == 1 ? tagsList.add('Gluten') : null;
                    current.isVegan == 1 ? tagsList.add('Vegan') : null;
                    current.isHalal == 1 ? tagsList.add('Halal') : null;
                    String tags = tagsList.join(' ');

                    return Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: MenuApp.horizontalPadding,
                            vertical: 6.0),
                        child: Card(
                          clipBehavior: Clip.antiAlias,
                          color: Colors.white,
                          borderOnForeground: false,
                          elevation: 8.0,
                          shadowColor: Colors.black45,
                          child: ListTile(
                            title: Text(
                              restaurant,
                              style:
                                  const TextStyle(fontWeight: FontWeight.w500),
                            ),
                            subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Divider(),
                                  Text(description),
                                  const Divider(),
                                  if (tagsList.isNotEmpty) ...[
                                    Text(tags),
                                    const Divider(),
                                  ],
                                  Text('Rating of $rating stars'),
                                  const Divider(),
                                  Text('$price SEK'),
                                ]),
                          ),
                        ));
                  })))
    ]);
  }
}
