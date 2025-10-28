// widgets/category_tabs_widget.dart
import 'package:flutter/material.dart';
import 'package:grocery_stores/providers/smart_mart_provider.dart';
import 'package:grocery_stores/screens/main/delivery/cart_screen.dart';
import 'package:grocery_stores/widgets/floating_cart_widget.dart';
import 'package:grocery_stores/widgets/product_card.dart';
import 'package:provider/provider.dart';
import 'package:grocery_stores/generated/l10n.dart';

typedef CategoryProvider = List<String> Function();
typedef ItemsProvider = List Function(String category);
typedef CategoryDisplayNameProvider =
    String Function(String category, bool isKurdish);

class CategoryTabsWidget extends StatefulWidget {
  const CategoryTabsWidget({
    super.key,
    required this.categoryProvider,
    required this.itemsProvider,
    this.categoryDisplayNameProvider,
    this.initialCategory,
    this.emptyStateMessage,
    this.emptyStateIcon = Icons.inventory_2_outlined,
    this.showFloatingCart = true,
    this.minimumOrderAmount = 7000,
    this.onCartTap,
    this.gridSpacing = 10.0,
    this.gridPadding = const EdgeInsets.all(5.0),
  });

  final CategoryProvider categoryProvider;
  final ItemsProvider itemsProvider;
  final CategoryDisplayNameProvider? categoryDisplayNameProvider;
  final String? initialCategory;
  final String? emptyStateMessage;
  final IconData emptyStateIcon;
  final bool showFloatingCart;
  final double minimumOrderAmount;
  final VoidCallback? onCartTap;
  final double gridSpacing;
  final EdgeInsets gridPadding;

  @override
  State<CategoryTabsWidget> createState() => _CategoryTabsWidgetState();
}

class _CategoryTabsWidgetState extends State<CategoryTabsWidget>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  List<String> _categories = [];

  @override
  void initState() {
    super.initState();
    _initializeTabController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final newCategories = widget.categoryProvider();
    if (_categoriesChanged(newCategories)) {
      _categories = newCategories;
      _reinitializeTabController();
    }
  }

  bool _categoriesChanged(List<String> newCategories) {
    if (_categories.length != newCategories.length) return true;
    for (int i = 0; i < _categories.length; i++) {
      if (_categories[i] != newCategories[i]) return true;
    }
    return false;
  }

  void _initializeTabController() {
    _categories = widget.categoryProvider();
    _createTabController();
  }

  void _reinitializeTabController() {
    _disposeTabController();
    _createTabController();
  }

  void _createTabController() {
    if (_categories.isNotEmpty) {
      _tabController = TabController(
        length: _categories.length,
        vsync: this,
        initialIndex: _getInitialIndex(),
      );
    }
  }

  int _getInitialIndex() {
    if (widget.initialCategory != null) {
      final index = _categories.indexOf(widget.initialCategory!);
      return index >= 0 ? index : 0;
    }
    return 0;
  }

  void _disposeTabController() {
    if (_tabController != null) {
      _tabController!.dispose();
      _tabController = null;
    }
  }

  @override
  void dispose() {
    _disposeTabController();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_categories.isEmpty) {
      return _buildEmptyState();
    }

    return Column(
      children: [
        _buildTabBar(),
        Expanded(child: _buildTabBarView()),
      ],
    );
  }

  Widget _buildTabBar() {
    if (_tabController == null) return const SizedBox.shrink();

    return Container(
      color: Colors.white,
      child: Consumer<SmartMart>(
        builder: (context, groceryProvider, child) {
          final isKurdish = groceryProvider.currentLocale.languageCode == 'ku';

          return TabBar(
            controller: _tabController,
            isScrollable: true,
            indicatorColor: Colors.black,
            labelColor: Colors.black,
            unselectedLabelColor: Colors.grey[600],
            labelStyle: const TextStyle(fontWeight: FontWeight.w600),
            unselectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.normal,
            ),
            tabs: _categories.map((category) {
              String displayText;
              if (category == 'All') {
                displayText = S.of(context).all;
              } else if (widget.categoryDisplayNameProvider != null) {
                displayText = widget.categoryDisplayNameProvider!(
                  category,
                  isKurdish,
                );
              } else {
                displayText = category;
              }
              return Tab(text: displayText);
            }).toList(),
          );
        },
      ),
    );
  }

  Widget _buildTabBarView() {
    if (_tabController == null) return const SizedBox.shrink();

    return TabBarView(
      controller: _tabController,
      children: _categories.map((category) {
        return _buildCategoryContent(category);
      }).toList(),
    );
  }

  Widget _buildCategoryContent(String category) {
    final items = widget.itemsProvider(category);

    Widget content = items.isEmpty 
        ? _buildEmptyState() 
        : _buildProductGrid(items, category);

    if (widget.showFloatingCart) {
      content = content.withFloatingCart(
        onCartTap: widget.onCartTap ?? _defaultCartTap,
        minimumOrderAmount: widget.minimumOrderAmount,
      );
    }

    return content;
  }

  Widget _buildProductGrid(List items, String category) {
    return Padding(
      key: ValueKey(category), // Essential for proper rebuilding
      padding: widget.gridPadding,
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 200,
          childAspectRatio: 0.60,
          crossAxisSpacing: widget.gridSpacing,
          mainAxisSpacing: widget.gridSpacing,
        ),
        itemCount: items.length,
        itemBuilder: (context, index) {
          return ProductCard(item: items[index]);
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(widget.emptyStateIcon, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            widget.emptyStateMessage ?? S.of(context).noProductsAvailable,
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _defaultCartTap() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CartScreen()),
    );
  }
}