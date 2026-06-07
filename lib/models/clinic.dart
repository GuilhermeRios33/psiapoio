class Review {
  final String reviewerName;
  final double rating;
  final String comment;

  const Review({
    required this.reviewerName,
    required this.rating,
    required this.comment,
  });
}

class Clinic {
  final String name;
  final String address;
  final String placeId;
  final double lat;
  final double lng;
  final String phone;
  final String about;
  final double rating;
  final int reviewCount;
  final List<String> specialties;
  final List<Review> reviews;

  final List<String> topics;

  const Clinic({
    required this.name,
    required this.address,
    required this.placeId,
    required this.lat,
    required this.lng,
    this.phone = '',
    this.about = '',
    this.rating = 0.0,
    this.reviewCount = 0,
    this.specialties = const [],
    this.reviews = const [],
    this.topics = const [],
  });

  factory Clinic.fromGooglePlaces(Map<String, dynamic> json) {
    final location = (json['geometry'] as Map)['location'] as Map;
    return Clinic(
      name: json['name'] as String? ?? '',
      address: json['formatted_address'] as String? ??
          json['vicinity'] as String? ??
          '',
      placeId: json['place_id'] as String? ?? '',
      lat: (location['lat'] as num).toDouble(),
      lng: (location['lng'] as num).toDouble(),
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      reviewCount: (json['user_ratings_total'] as num?)?.toInt() ?? 0,
    );
  }

  String get mapsUrl {
    final encodedAddress = Uri.encodeComponent(address);
    return 'https://www.google.com/maps/search/?api=1'
        '&query=$encodedAddress'
        '&query_place_id=$placeId';
  }
}
