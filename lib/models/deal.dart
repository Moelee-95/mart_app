// models/deals.dart
class Deal{
  final int id;
  final String title;
  final String? titleKu;
  final String description;
  final String? descriptionKu;
  final String imageUrl;
  final String bannerUrl;

  const Deal({
    required this.id,
    required this.title,
    this.titleKu,
    required this.description,
    this.descriptionKu,
    required this.imageUrl,
    required this.bannerUrl
  });
}