// models/ads.dart
class Ad{
  final String id;
  final String title;
  final String? titleKu;
  final String description;
  final String? descriptionKu;
  final String imageUrl;
  final String bannerUrl;

  const Ad({
    required this.id,
    required this.title,
    this.titleKu,
    required this.description,
    this.descriptionKu,
    required this.imageUrl,
    required this.bannerUrl
  });
}