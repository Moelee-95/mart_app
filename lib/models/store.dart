// lib/models/store.dart
class Store {
  final String id;
  final String name;
  final String nameKu;
  final String address;
  final String addressKu;
  final bool isActive;
  final String? imageUrl;

  Store({
    required this.id,
    required this.name,
    required this.nameKu,
    required this.address,
    required this.addressKu,
    this.isActive = true,
    this.imageUrl,
  });

  String getDisplayName(bool isKurdish) {
    return isKurdish ? nameKu : name;
  }

  String getDisplayAddress(bool isKurdish) {
    return isKurdish ? addressKu : address;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'nameKu': nameKu,
      'address': address,
      'addressKu': addressKu,
      'isActive': isActive,
      'imageUrl': imageUrl,
    };
  }

  factory Store.fromJson(Map<String, dynamic> json) {
    return Store(
      id: json['id'],
      name: json['name'],
      nameKu: json['nameKu'],
      address: json['address'],
      addressKu: json['addressKu'],
      isActive: json['isActive'] ?? true,
      imageUrl: json['imageUrl'],
    );
  }
}