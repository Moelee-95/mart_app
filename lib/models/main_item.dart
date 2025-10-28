// lib/models/main_item.dart
class mainItem {
  final String id;
  final String name;
  final String? nameKu;
  final String category;
  final String? categoryKu;
  final double price; // Always the original price
  final String imageUrl;
  final String description;
  final String? descriptionKu;
  final String? brandId;
  final String? adId;

  // Discount and offer fields
  final bool hasDiscount;
  final double? discountPercentage;
  final String? bulkOffer; // e.g., "Buy 5 Get 1"
  final String? bulkOfferKu;
  final int? dealID;

  mainItem({
    required this.id,
    required this.name,
    this.nameKu,
    required this.category,
    this.categoryKu,
    required this.price,
    required this.imageUrl,
    required this.description,
    this.descriptionKu,
    this.hasDiscount = false,
    this.discountPercentage,
    this.bulkOffer,
    this.bulkOfferKu,
    this.brandId,
    this.dealID,
    this.adId,
  });

  // Helper method to calculate discounted price
  double get discountedPrice {
    if (hasDiscount && discountPercentage != null) {
      return price * (1 - discountPercentage! / 100);
    }
    return price;
  }

  // Helper method to get the display price (discounted if available, otherwise original)
  double get displayPrice => hasDiscount ? discountedPrice : price;

  // Helper method to check if item has any offer (discount or bulk)
  bool get hasAnyOffer => hasDiscount || (bulkOffer?.isNotEmpty ?? false);

  // Helper method to get the offer text for the badge
  String? get offerText {
    if (hasDiscount && discountPercentage != null) {
      return 'Save ${discountPercentage!.round()}%';
    }
    if (bulkOffer?.isNotEmpty ?? false) {
      return bulkOffer;
    }
    return null;
  }
}
