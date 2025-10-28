import 'package:flutter/material.dart';
import 'package:grocery_stores/screens/main/search_screen.dart';
import 'package:grocery_stores/widgets/category_tabs_widget.dart';
import 'package:provider/provider.dart';
import '../../../providers/smart_mart_provider.dart';
import 'package:grocery_stores/generated/l10n.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({super.key, this.selectedCategory});

  final String? selectedCategory;

  @override
  Widget build(BuildContext context) {
    return Consumer<SmartMart>(
      builder: (context, groceryProvider, child) {
        final categories = [
          'All',
          ...groceryProvider.categories.map((c) => c.name),
        ];

        return DefaultTabController(
          length: categories.length,
          initialIndex: selectedCategory != null
              ? categories.indexOf(selectedCategory!)
              : 0,
          child: Scaffold(
            appBar: _buildAppBar(context),
            backgroundColor: Colors.white,
            // In build() method, replace the body with:
            body: SafeArea(
              child: CategoryTabsWidget(
                categoryProvider: () => [
                  'All',
                  ...groceryProvider.categories.map((c) => c.name),
                ],
                itemsProvider: (category) => category == 'All'
                    ? groceryProvider.getAllItems()
                    : groceryProvider.getAllItemsByCategory(category),
                initialCategory: selectedCategory,
                categoryDisplayNameProvider: (category, isKurdish) {
                  if (category == 'All') return S.of(context).all;
                  if (!isKurdish) return category;
                  // Get Kurdish category name
                  try {
                    final cat = groceryProvider.categories.firstWhere(
                      (c) => c.name == category,
                    );
                    return cat.nameKu ?? category;
                  } catch (e) {
                    return category;
                  }
                },
              ),
            ),
          ),
        );
      },
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    final title = selectedCategory?.isNotEmpty == true
        ? selectedCategory!
        : 'Delivery App';

    return AppBar(
      title: Text(title),
      backgroundColor: Colors.white,
      elevation: 1,
      foregroundColor: Colors.black,
      actions: [
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
    );
  }
}

//end
