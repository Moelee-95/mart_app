// models/grocery_category.dart
class MainCategory {
  final String id;
  final String name;
  final String? nameKu;
  final String imageUrl;
  final String description;
  final String? descriptionKu;

  const MainCategory({
    required this.id,
    required this.name,
    this.nameKu,
    required this.imageUrl,
    required this.description,
    this.descriptionKu,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MainCategory &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'MainCategory{id: $id, name: $name, imageUrl: $imageUrl, description: $description}';
  }
}