import 'dart:convert';
import 'package:http/http.dart' as http;
import '../shared/menu.dart';
import '../search_result.dart';
import '../shared/computed.dart';

Future<Map<String, dynamic>> fetchSuggestions(
    String? query,
    int pageKey,
    int pageSize,
    double? chosenMinRating,
    double? chosenMaxRating,
    double? chosenMinPrice,
    double? chosenMaxPrice,
    double? lat,
    double? lon,
    bool? hasGluten,
    bool? isVegan,
    bool? isHalal) async {
  Uri searchUri;

  Map<String, String> queryParams = {
    'pageKey': pageKey.toString(),
    'pageSize': pageSize.toString(),
    'minRating': chosenMinRating == null ? '' : chosenMinRating.toString(),
    'maxRating': chosenMaxRating == null ? '' : chosenMaxRating.toString(),
    'minPrice': chosenMinPrice == null ? '' : chosenMinPrice.round().toString(),
    'maxPrice': chosenMaxPrice == null ? '' : chosenMaxPrice.round().toString(),
    'lat': lat == null ? '' : lat.toString(),
    'lon': lon == null ? '' : lon.toString(),
    'hasGluten': hasGluten == true ? '1' : '',
    'isVegan': isVegan == true ? '1' : '',
    'isHalal': isHalal == true ? '1' : '',
  };

  // Only include used params
  queryParams.removeWhere((key, value) => value == '');

  Uri createSearchUri(String path) =>
      Uri.http(SearchResult.serverUrlFromEnv, path, queryParams);

  if (query != null && query != '' && query != ' ') {
    String craftedPathUrl = "${SearchResult.searchUrl}/$query";
    searchUri = createSearchUri(craftedPathUrl);
  } else {
    searchUri = createSearchUri(SearchResult.menusIndexUrl);
  }

  final response = await http.get(searchUri);

  if (response.statusCode == 200) {
    final List<dynamic> decodedBody =
        jsonDecode(response.body)['result']['menus'];
    List<Menu> menuList =
        decodedBody.map<Menu>((menu) => Menu.fromJson(menu)).toList();

    String stats = jsonDecode(response.body)['result']['meta']['statistics'];

    final dynamic decodedComputed =
        jsonDecode(response.body)['result']['meta']['computed'];
    Computed computed = Computed.fromJson(decodedComputed);

    return {'menus': menuList, 'statistics': stats, 'computed': computed};
  } else if (response.statusCode == 404) {
    String status = jsonDecode(response.body)['status'];

    switch (status) {
      case '':
        throw Exception("${response.reasonPhrase}");
      default:
        throw Exception(status);
    }
  } else if (response.statusCode == 500) {
    throw Exception("${response.reasonPhrase}, server is having issues");
  } else {
    throw Exception(
        'Exception: ${response.statusCode}, ${response.reasonPhrase}');
  }
}
