// screens/main/delivery/deal_details_screen.dart

import 'package:flutter/material.dart';
import 'package:grocery_stores/screens/main/search_screen.dart';
import 'package:grocery_stores/widgets/category_tabs_widget.dart';
import 'package:provider/provider.dart';
import '../../../models/deal.dart';
import '../../../providers/smart_mart_provider.dart';
import 'package:grocery_stores/generated/l10n.dart';

class DealDetailsScreen extends StatelessWidget {
  const DealDetailsScreen({super.key, required this.deal});

  final Deal deal;

  @override
  Widget build(BuildContext context) {
    return Consumer<SmartMart>(
      builder: (context, groceryProvider, child) {
        final categoriesWithItems = groceryProvider.getCategoriesWithDealItems(
          deal.id,
        );
        final allCategories = ['All', ...categoriesWithItems];

        return DefaultTabController(
          length: allCategories.length,
          child: Scaffold(
            backgroundColor: Colors.white,
            body: Column(
              children: [
                // App Bar with optional banner
                _buildAppBarSection(context),
                // In build() method, replace the Expanded widget content with:
                Expanded(
                  child: SafeArea(
                    child: allCategories.isNotEmpty
                        ? CategoryTabsWidget(
                            categoryProvider: () => allCategories,
                            itemsProvider: (category) => category == 'All'
                                ? groceryProvider.getItemsByDealId(deal.id)
                                : groceryProvider.getItemsByDealAndCategory(
                                    deal.id,
                                    category,
                                  ),
                            categoryDisplayNameProvider: (category, isKurdish) {
                              if (category == 'All') return S.of(context).all;
                              return _getCategoryDisplayName(
                                category,
                                groceryProvider,
                                isKurdish,
                              );
                            },
                            emptyStateMessage: S
                                .of(context)
                                .noProductsAvailableInCategory,
                          )
                        : Center(
                            child: Text(
                              S.of(context).noProductsAvailableForDeal,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAppBarSection(BuildContext context) {
    final hasValidBanner = deal.bannerUrl.isNotEmpty;

    if (hasValidBanner) {
      // With banner image
      return SizedBox(
        height: 300,
        child: Stack(
          children: [
            // Banner image with wave bottom
            Positioned.fill(
              child: ClipPath(
                clipper: WaveClipper(),
                child: Image.network(
                  deal.bannerUrl,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      color: Colors.grey[200],
                      child: const Center(
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[200],
                      child: const Center(
                        child: Icon(Icons.image_not_supported, size: 40),
                      ),
                    );
                  },
                ),
              ),
            ),

            // App bar content
            Positioned(
              top: MediaQuery.of(context).padding.top,
              left: 0,
              right: 0,
              child: _buildAppBarContent(context, true),
            ),

            // Title text at bottom of image
            Positioned(
              bottom: 16,
              left: 16,
              right: 16,
              child: Consumer<SmartMart>(
                builder: (context, groceryProvider, child) {
                  final isKurdish =
                      groceryProvider.currentLocale.languageCode == 'ku';
                  final dealTitle = isKurdish
                      ? (deal.titleKu ?? deal.title)
                      : deal.title;

                  return Text(
                    dealTitle,
                    style: const TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.w500,
                      color: Color.fromARGB(255, 255, 255, 255),
                    ),
                    textAlign: TextAlign.center,
                  );
                },
              ),
            ),
          ],
        ),
      );
    } else {
      // Without banner - simple app bar
      return Container(
        height: kToolbarHeight + MediaQuery.of(context).padding.top,
        color: Colors.white,
        child: Padding(
          padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
          child: _buildAppBarContent(context, false),
        ),
      );
    }
  }

  Widget _buildAppBarContent(BuildContext context, bool isOverlay) {
    return Container(
      height: kToolbarHeight,
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(
              Icons.arrow_back,
              color: isOverlay ? Colors.white : Colors.black,
            ),
          ),

          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SearchScreen()),
              );
            },
            icon: const Icon(Icons.search),
          ),
        ],
      ),
    );
  }

  String _getCategoryDisplayName(
    String category,
    SmartMart groceryProvider,
    bool isKurdish,
  ) {
    if (!isKurdish) return category;

    // Find any item in this category to get the Kurdish category name
    // Use deal.id from the widget's deal property
    final items = groceryProvider.getItemsByDealId(deal.id);
    try {
      final itemInCategory = items.firstWhere(
        (item) => item.category == category,
      );
      return itemInCategory.categoryKu ?? category;
    } catch (e) {
      // If no item found in this category, return the original category name
      return category;
    }
  }
}

class WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height - 30);

    var firstControlPoint = Offset(size.width / 4, size.height);
    var firstEndPoint = Offset(size.width / 2, size.height - 15);
    path.quadraticBezierTo(
      firstControlPoint.dx,
      firstControlPoint.dy,
      firstEndPoint.dx,
      firstEndPoint.dy,
    );

    var secondControlPoint = Offset(size.width * 3 / 4, size.height - 30);
    var secondEndPoint = Offset(size.width, size.height - 5);
    path.quadraticBezierTo(
      secondControlPoint.dx,
      secondControlPoint.dy,
      secondEndPoint.dx,
      secondEndPoint.dy,
    );

    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
