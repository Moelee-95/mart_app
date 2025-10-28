import 'package:flutter/material.dart';
import 'package:grocery_stores/widgets/cart_icon_button.dart';
import 'package:grocery_stores/widgets/product_card.dart';
import 'package:provider/provider.dart';
import '../../../models/main_item.dart';
import '../../../providers/smart_mart_provider.dart';
import '../../../widgets/add_to_cart_button.dart';
import 'package:grocery_stores/generated/l10n.dart';

class ProductDetailScreen extends StatelessWidget {
  const ProductDetailScreen({super.key, required this.item});

  final mainItem item;

  static const EdgeInsets _screenPadding = EdgeInsets.all(16.0);
  static const double _imageHeight = 300.0;
  static const double _sectionSpacing = 24.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: SingleChildScrollView(
        padding: _screenPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProductImageSection(item: item),
            const SizedBox(height: _sectionSpacing),
            ProductInfoSection(item: item),
            const SizedBox(height: _sectionSpacing),
            const FrequentlyBoughtSection(),
            const SizedBox(height: 100), // Space for bottom bar
          ],
        ),
      ),
      bottomNavigationBar: ProductBottomBar(item: item),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 1,
      foregroundColor: Colors.black,
      actions: [const CartIconButton(iconSize: 32)],
    );
  }
}

class ProductBottomBar extends StatelessWidget {
  const ProductBottomBar({super.key, required this.item});

  final mainItem item;

  static const TextStyle _currencyStyle = TextStyle(
    fontSize: 20,
    color: Colors.black,
  );

  static const TextStyle _discountedPriceStyle = TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 20,
    color: Colors.black,
    decoration: TextDecoration.underline,
    decorationColor: Color(0xFFB8FF00),
    decorationThickness: 3.0,
  );

  static const TextStyle _originalPriceStyle = TextStyle(
    fontSize: 16,
    color: Colors.grey,
    decoration: TextDecoration.lineThrough,
    decorationColor: Colors.grey,
  );

  static const TextStyle _regularPriceStyle = TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 20,
    color: Colors.black,
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Consumer<SmartMart>(
          builder: (context, groceryProvider, child) {
            final quantity = groceryProvider.getItemQuantity(item.id);

            return Row(
              children: [
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Discount badge if item has offer
                      if (item.hasAnyOffer) ...[
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFB8FF00),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Consumer<SmartMart>(
                            builder: (context, groceryProvider, child) {
                              final isKurdish = groceryProvider.currentLocale.languageCode == 'ku';
                              String? offerText;
                              if (item.hasDiscount && item.discountPercentage != null) {
                                offerText = isKurdish 
                                    ? 'پاشکەوت ${item.discountPercentage!.round()}%'
                                    : 'Save ${item.discountPercentage!.round()}%';
                              } else if (item.bulkOffer?.isNotEmpty ?? false) {
                                offerText = isKurdish ? (item.bulkOfferKu ?? item.bulkOffer) : item.bulkOffer;
                              }
                              
                              return Text(
                                offerText ?? '',
                                style: const TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 4),
                      ],
                      // Price display
                      _buildPriceDisplay(context),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                SizedBox(
                  width: 140, // Fixed width for the button
                  child: quantity == 0
                      ? ElevatedButton(
                          onPressed: () => groceryProvider.addToCart(item),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                          child: Text(
                            S.of(context).addToCart,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        )
                      : AddToCartButton(
                          size: 50,
                          item: item,
                          onAddToCart: (it) => groceryProvider.addToCart(it),
                          onRemoveFromCart: (it) =>
                              groceryProvider.removeFromCart(it.id),
                          initialQuantity: quantity,
                          alwaysExpanded: true,
                        ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildPriceDisplay(BuildContext context) {
    if (item.hasDiscount) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
        child: Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 10,
          children: [
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(text: '${S.of(context).iqd} ', style: _currencyStyle),
                  TextSpan(
                    text: '${item.discountedPrice.toStringAsFixed(0)}',
                    style: _discountedPriceStyle,
                  ),
                ],
              ),
            ),
            Text(
              '${S.of(context).iqd} ${item.price.toStringAsFixed(0)}',
              style: _originalPriceStyle,
            ),
          ],
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
        child: RichText(
          text: TextSpan(
            children: [
              TextSpan(text: '${S.of(context).iqd} ', style: _currencyStyle),
              TextSpan(
                text: '${item.price.toStringAsFixed(0)}',
                style: _regularPriceStyle,
              ),
            ],
          ),
          overflow: TextOverflow.ellipsis,
        ),
      );
    }
  }
}

class ProductImageSection extends StatelessWidget {
  const ProductImageSection({super.key, required this.item});

  final mainItem item;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ProductDetailScreen._imageHeight,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(16),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Image.network(
          item.imageUrl,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return const Center(
              child: CircularProgressIndicator(strokeWidth: 2),
            );
          },
          errorBuilder: (context, error, stackTrace) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.image_not_supported,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    S.of(context).imageNotAvailable,
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class ProductInfoSection extends StatelessWidget {
  const ProductInfoSection({super.key, required this.item});

  final mainItem item;

  @override
  Widget build(BuildContext context) {
    return Consumer<SmartMart>(
      builder: (context, groceryProvider, child) {
        final isKurdish = groceryProvider.currentLocale.languageCode == 'ku';
        final productName = isKurdish ? (item.nameKu ?? item.name) : item.name;
        final productDescription = isKurdish ? (item.descriptionKu ?? item.description) : item.description;
        
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              productName,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            Text(
              _getItemWeight(context),
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            const SizedBox(height: 16),
            Text(
              '${S.of(context).iqd} ${item.price.toStringAsFixed(0)}',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
            if (productDescription.isNotEmpty) ...[
              const SizedBox(height: 16),
              Text(
                productDescription,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[700],
                  height: 1.5,
                ),
              ),
            ],
          ],
        );
      },
    );
  }

  String _getItemWeight(BuildContext context) {
    // You can customize this based on your item properties
    // For now, returning a default weight format
    return S.of(context).productWeight;
  }
}

class FrequentlyBoughtSection extends StatelessWidget {
  const FrequentlyBoughtSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SmartMart>(
      builder: (context, groceryProvider, child) {
        // Get some random items as "frequently bought together"
        final allItems = groceryProvider.getAllItems();
        final suggestedItems = allItems.take(3).toList();

        if (suggestedItems.isEmpty) return const SizedBox.shrink();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              S.of(context).frequentlyBoughtTogether,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 280,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: suggestedItems.length,
                itemBuilder: (context, index) {
                  return SizedBox(
                    width: 160, // Same width as SuggestedItemCard
                    child: ProductCard(item: suggestedItems[index]),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

class SuggestedItemCard extends StatelessWidget {
  const SuggestedItemCard({super.key, required this.item});

  final mainItem item;

  static const double _cardWidth = 160.0;
  static const double _imageHeight = 120.0;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: _cardWidth,
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildItemImage(context),
          Expanded(child: _buildItemInfo(context)),
        ],
      ),
    );
  }

  Widget _buildItemImage(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: _imageHeight,
          width: double.infinity,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Image.network(
              item.imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                color: Colors.grey[200],
                child: const Icon(
                  Icons.image_not_supported,
                  color: Colors.grey,
                ),
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 8,
          right: 8,
          child: Consumer<SmartMart>(
            builder: (context, groceryProvider, child) {
              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: IconButton(
                  onPressed: () => groceryProvider.addToCart(item),
                  icon: const Icon(Icons.add, color: Colors.orange),
                  padding: const EdgeInsets.all(4),
                  constraints: const BoxConstraints(
                    minWidth: 32,
                    minHeight: 32,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildItemInfo(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Consumer<SmartMart>(
        builder: (context, groceryProvider, child) {
          final isKurdish = groceryProvider.currentLocale.languageCode == 'ku';
          final productName = isKurdish ? (item.nameKu ?? item.name) : item.name;
          
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                productName,
                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const Spacer(),
              Text(
                '${S.of(context).iqd} ${item.price.toStringAsFixed(0)}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}