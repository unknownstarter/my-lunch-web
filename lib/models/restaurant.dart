class Restaurant {
  final String name;
  final String type;
  final String address;
  final double rating;
  final String link;
  final String? imageUrl;
  final double distance;

  Restaurant({
    required this.name,
    required this.type,
    required this.address,
    required this.rating,
    required this.link,
    this.imageUrl,
    required this.distance,
  });

  factory Restaurant.fromJson(Map<String, dynamic> json) {
    return Restaurant(
      name: json['title'].replaceAll(RegExp(r'<[^>]*>'), ''),
      type: json['category'] ?? '',
      address: json['roadAddress'] ?? json['address'] ?? '',
      rating: double.tryParse(json['rating'] ?? '0') ?? 0.0,
      link: json['link'] ?? '',
      imageUrl: json['imageUrl'],
      distance: double.tryParse(json['distance'] ?? '0') ?? 0.0,
    );
  }
}
