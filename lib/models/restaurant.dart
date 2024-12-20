class Restaurant {
  final String name;
  final String type;
  final String address;
  final double rating;
  final String link;
  final double distance;
  final String? imageUrl;
  final String? description;
  final String? telephone;

  Restaurant({
    required this.name,
    required this.type,
    required this.address,
    required this.rating,
    required this.link,
    required this.distance,
    this.imageUrl,
    this.description,
    this.telephone,
  });

  factory Restaurant.fromJson(Map<String, dynamic> json) {
    return Restaurant(
      name: json['title'].replaceAll(RegExp(r'<[^>]*>'), ''),
      type: json['category'] ?? '',
      address: json['roadAddress'] ?? json['address'] ?? '',
      rating: double.tryParse(json['rating'] ?? '0') ?? 0.0,
      link: json['link'] ?? '',
      distance: double.tryParse(json['distance'] ?? '0') ?? 0.0,
      imageUrl: json['imageUrl'],
      description: json['description'],
      telephone: json['telephone'],
    );
  }
}
