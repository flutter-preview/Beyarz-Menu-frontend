class Computed {
  int minRating;
  int maxRating;
  int minPrice;
  int maxPrice;
  int page;
  int offset;
  int limit;

  Computed({
    required this.minRating,
    required this.maxRating,
    required this.minPrice,
    required this.maxPrice,
    required this.page,
    required this.offset,
    required this.limit,
  });

  factory Computed.fromJson(Map<String, dynamic> json) {
    return Computed(
      minRating: json['minRating'],
      maxRating: json['maxRating'],
      minPrice: json['minPrice'],
      maxPrice: json['maxPrice'],
      page: json['page'],
      offset: json['offset'],
      limit: json['limit'],
    );
  }
}
