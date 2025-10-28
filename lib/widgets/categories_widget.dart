// lib/widgets/categories_widget.dart

import 'package:flutter/material.dart';
import '../models/main_category.dart';
import '../screens/main/delivery/products_screen.dart';
import 'package:provider/provider.dart';
import '../providers/smart_mart_provider.dart';

class CategoriesWidget extends StatelessWidget {
  final List<MainCategory> categories;

  const CategoriesWidget({super.key, required this.categories});



  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _MultiRowCategoriesWidget(
          categories: categories,
          itemsPerRow: 3,
          itemsPerColumn: 8,
        ),
      ],
    );
  }

}

class _MultiRowCategoriesWidget extends StatefulWidget {
  final List<MainCategory> categories;
  final int itemsPerRow;
  final int itemsPerColumn;

  const _MultiRowCategoriesWidget({
    required this.categories,
    this.itemsPerRow = 4,
    this.itemsPerColumn = 2,
  });

  @override
  State<_MultiRowCategoriesWidget> createState() =>
      _MultiRowCategoriesWidgetState();
}

class _MultiRowCategoriesWidgetState extends State<_MultiRowCategoriesWidget> {
  late ScrollController _scrollController;
  static const double _multiRowItemWidth = 100;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final int totalRows = widget.itemsPerRow;
    final int totalColumns = (widget.categories.length / totalRows).ceil();
    final double itemHeight = 120.0; // Height per individual item
    final double totalHeight = itemHeight * totalRows;

    return Column(
      children: [
        SizedBox(
          height: totalHeight,
          child: ListView.builder(
            controller: _scrollController,
            scrollDirection: Axis.horizontal,
            itemCount: totalColumns,
            itemBuilder: (context, columnIndex) {
              return SizedBox(
                width: _multiRowItemWidth,
                child: Column(
                  children: List.generate(totalRows, (rowIndex) {
                    final itemIndex = columnIndex * totalRows + rowIndex;
                    if (itemIndex >= widget.categories.length) {
                      return const Expanded(child: SizedBox());
                    }
                    return Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 8, bottom: 8),
                        child: MultiRowCategoryCard(
                          category: widget.categories[itemIndex],
                        ),
                      ),
                    );
                  }),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 8),
        _buildScrollIndicator(),
      ],
    );
  }

  Widget _buildScrollIndicator() {
    return AnimatedBuilder(
      animation: _scrollController,
      builder: (context, child) {
        // Multiple safety checks to prevent null errors
        if (!_scrollController.hasClients) {
          return const SizedBox.shrink();
        }

        final position = _scrollController.position;

        // Check if position has dimensions and pixels
        if (!position.hasContentDimensions || !position.hasPixels) {
          return const SizedBox.shrink();
        }

        // Check if there's anything to scroll
        if (position.maxScrollExtent <= 0) {
          return const SizedBox.shrink();
        }

        // Safe calculation - no need for null checks since pixels and maxScrollExtent are non-nullable
        final progress = (position.pixels / position.maxScrollExtent).clamp(
          0.0,
          1.0,
        );

        return Container(
          height: 3,
          width: 60,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(1.5),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: progress,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[600],
                borderRadius: BorderRadius.circular(1.5),
              ),
            ),
          ),
        );
      },
    );
  }
}

class MultiRowCategoryCard extends StatelessWidget {
  const MultiRowCategoryCard({super.key, required this.category});

  final MainCategory category;

  static const double _imageSize = 85;
  static const EdgeInsets _cardPadding = EdgeInsets.all(1.0);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _navigateToProducts(context, category),

      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: _cardPadding,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
            ),
            child: _buildCategoryImage(),
          ),
          const SizedBox(height: 4),
          Expanded(child: _buildCategoryName(context)),
        ],
      ),
    );
  }

  Widget _buildCategoryImage() {
    // print('Loading image: ${category.imageUrl}');
    return ClipRRect(
      borderRadius: BorderRadius.circular(6),
      child: Image.network(
        category.imageUrl,

        width: _imageSize,
        height: _imageSize,
        fit: BoxFit.contain,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return SizedBox(
            width: _imageSize,
            height: _imageSize,
            child: const Center(
              child: CircularProgressIndicator(strokeWidth: 1.5),
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: _imageSize,
            height: _imageSize,
            color: Colors.grey[200],
            child: const Icon(Icons.image_not_supported, size: 20),
          );
        },
      ),
    );
  }

  Widget _buildCategoryName(BuildContext context) {
    return Consumer<SmartMart>(
      builder: (context, groceryProvider, child) {
        final isKurdish = groceryProvider.currentLocale.languageCode == 'ku';
        final categoryName = isKurdish
            ? (category.nameKu ?? category.name)
            : category.name;

        return Center(
          child: Text(
            categoryName,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        );
      },
    );
  }

  void _navigateToProducts(BuildContext context, MainCategory category) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ProductsScreen(selectedCategory: category.name),
      ),
    );
  }
}
