import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/smart_mart_provider.dart';
import '../screens/main/delivery/product_detail_screen.dart';
import 'add_to_cart_button.dart';
import 'package:grocery_stores/generated/l10n.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({super.key, required this.item});

  final dynamic item;

  static const EdgeInsets _cardPadding = EdgeInsets.all(1.0);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProductDetailScreen(item: item),
        ),
      ),
      child: Card(
        elevation: 0.0,
        color: Colors.transparent,
        child: Padding(
          padding: _cardPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 5, child: ProductImage(item: item)),
              const SizedBox(height: 1),
              Expanded(flex: 4, child: ProductInfo(item: item)),
            ],
          ),
        ),
      ),
    );
  }
}

class ProductImage extends StatelessWidget {
  const ProductImage({super.key, required this.item});

  final dynamic item;

  static const EdgeInsets _overlayPadding = EdgeInsets.only(
    right: 8,
    bottom: 8,
  );
  static const EdgeInsets _offerBadgePadding = EdgeInsets.only(left: 8, top: 8);
  static const double _minControlSize = 40.0;
  static const double _maxControlSize = 56.0;
  static const double _controlSizeRatio = 0.3;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double controlSize = (constraints.maxWidth * _controlSizeRatio)
            .clamp(_minControlSize, _maxControlSize);

        return Stack(
          children: [
            _buildProductImage(),
            if (item.hasAnyOffer) _buildOfferBadge(context),
            _buildAddToCartOverlay(context, controlSize - 1, constraints),
          ],
        );
      },
    );
  }

  Widget _buildProductImage() {
    return Positioned.fill(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
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
            return Container(
              color: Colors.grey[200],
              child: const Icon(Icons.image_not_supported, size: 32),
            );
          },
        ),
      ),
    );
  }

  Widget _buildOfferBadge(BuildContext context) {
    return Consumer<SmartMart>(
      builder: (context, groceryProvider, child) {
        final isKurdish = groceryProvider.currentLocale.languageCode == 'ku';
        
        String? offerText;
        if (item.hasDiscount && item.discountPercentage != null) {
          offerText = isKurdish 
              ? '% پاشکەوت ${item.discountPercentage!.round()}'
              : 'Save ${item.discountPercentage!.round()}%';
        } else if (item.bulkOffer?.isNotEmpty ?? false) {
          offerText = isKurdish ? (item.bulkOfferKu ?? item.bulkOffer) : item.bulkOffer;
        }
        
        return Positioned(
          top: _offerBadgePadding.top,
          left: _offerBadgePadding.left,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFB8FF00),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              offerText ?? '',
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAddToCartOverlay(
    BuildContext context,
    double controlSize,
    BoxConstraints constraints,
  ) {
    return Positioned(
      bottom: _overlayPadding.bottom,
      right: _overlayPadding.right,
      child: Consumer<SmartMart>(
        builder: (context, groceryProvider, child) {
          return ConstrainedBox(
            constraints: BoxConstraints(maxWidth: constraints.maxWidth * 1),
            child: AddToCartButton(
              size: controlSize,
              item: item,
              onAddToCart: (it) =>
                  _handleAddToCart(context, groceryProvider, it),
              onRemoveFromCart: (it) => groceryProvider.removeFromCart(it.id),
              initialQuantity: groceryProvider.getItemQuantity(item.id),
            ),
          );
        },
      ),
    );
  }

  void _handleAddToCart(
    BuildContext context,
    SmartMart provider,
    dynamic item,
  ) {
    provider.addToCart(item);
  }
}

class ProductInfo extends StatelessWidget {
  const ProductInfo({super.key, required this.item});

  final dynamic item;

  static const TextStyle _nameStyle = TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 14,
  );

  static const TextStyle _descriptionStyle = TextStyle(
    fontSize: 11,
    color: Colors.grey,
  );

  static const TextStyle _discountedPriceStyle = TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 17,
    color: Colors.black,
    decoration: TextDecoration.underline,
    decorationColor: Color(0xFFB8FF00), // Yellow-green underline
    decorationThickness: 3.0,
  );

  static const TextStyle _originalPriceStyle = TextStyle(
    fontSize: 12,
    color: Colors.grey,
    decoration: TextDecoration.lineThrough,
    decorationColor: Colors.grey,
  );

  static const TextStyle _regularPriceStyle = TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 15,
    color: Colors.black,
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildProductName(context),
        const SizedBox(height: 4),
        _buildProductDescription(context),
        _buildProductPricing(context),
      ],
    );
  }

  Widget _buildProductName(BuildContext context) {
    return Consumer<SmartMart>(
      builder: (context, groceryProvider, child) {
        final isKurdish = groceryProvider.currentLocale.languageCode == 'ku';
        final productName = isKurdish ? (item.nameKu ?? item.name) : item.name;
        
        return Text(
          productName,
          style: _nameStyle,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        );
      },
    );
  }

  Widget _buildProductDescription(BuildContext context) {
    return Consumer<SmartMart>(
      builder: (context, groceryProvider, child) {
        final isKurdish = groceryProvider.currentLocale.languageCode == 'ku';
        final productDescription = isKurdish ? (item.descriptionKu ?? item.description) : item.description;
        
        return Text(
          productDescription,
          style: _descriptionStyle,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        );
      },
    );
  }

  Widget _buildProductPricing(BuildContext context) {
    if (item.hasDiscount) {
      return Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 8,
        runSpacing: 2,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(4)),
            child: Text(
              '${S.of(context).iqd} ${item.discountedPrice.toStringAsFixed(0)}',
              style: _discountedPriceStyle,
            ),
          ),
          Text(
            '${S.of(context).iqd} ${item.price.toStringAsFixed(0)}',
            style: _originalPriceStyle,
          ),
        ],
      );
    } else {
      return Text(
        '${S.of(context).iqd} ${item.price.toStringAsFixed(0)}',
        style: _regularPriceStyle,
      );
    }
  }
}
