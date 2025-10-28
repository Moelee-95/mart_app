// lib/screens/main/search_screen.dart

import 'package:flutter/material.dart';
import 'package:grocery_stores/widgets/category_tabs_widget.dart';
import 'package:provider/provider.dart';
import '../../providers/smart_mart_provider.dart';
import '../../widgets/product_card.dart';
import '../../widgets/floating_cart_widget.dart';
import 'delivery/cart_screen.dart';
import 'package:grocery_stores/generated/l10n.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  String _searchQuery = '';
  String _selectedCategory = 'All';
  bool _isSearching = false;
  bool _showSuggestions = false;

  @override
  void initState() {
    super.initState();
    // Auto focus on search field when screen opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _searchFocusNode.requestFocus();
    });
  }

  void _performSearch(String query) {
    if (query.trim().isEmpty) return;

    final groceryProvider = Provider.of<SmartMart>(
      context,
      listen: false,
    );
    groceryProvider.addRecentSearch(query.trim());

    setState(() {
      _searchQuery = query.trim();
      _isSearching = true;
      _showSuggestions = false;
      _selectedCategory = 'All'; // Reset to 'All' when performing new search
    });

    // Create new tab controller with filtered categories
  }

  void _selectRecentSearch(String query) {
    _searchController.text = query;
    _performSearch(query);
  }

  void _selectSuggestion(String suggestion) {
    _searchController.text = suggestion;
    _performSearch(suggestion);
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() {
      _searchQuery = '';
      _isSearching = false;
      _selectedCategory = 'All';
      _showSuggestions = false;
    });

    // Dispose tab controller when clearing search
  }

  void _onSearchTextChanged(String value) {
    setState(() {
      if (value.isEmpty) {
        _isSearching = false;
        _showSuggestions = false;
        _searchQuery = '';
        // Dispose tab controller when search is cleared
      } else {
        _showSuggestions = true;
        _isSearching = false; // Don't show results until search is performed
      }
    });
  }

  List<String> _getFilteredCategories(SmartMart groceryProvider) {
    if (_searchQuery.isEmpty) {
      return ['All', ...groceryProvider.categories.map((c) => c.name)];
    }

    final allItems = groceryProvider.searchItems(_searchQuery);
    final categoriesWithItems = <String>{};

    for (final item in allItems) {
      categoriesWithItems.add(item.category);
    }

    final filteredCategories = ['All'];
    if (categoriesWithItems.isNotEmpty) {
      filteredCategories.addAll(categoriesWithItems.toList()..sort());
    }

    return filteredCategories;
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SmartMart>(
      builder: (context, groceryProvider, child) {

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: _buildAppBar(),
          body: _searchQuery.isNotEmpty && _isSearching
              ? CategoryTabsWidget(
                  categoryProvider: () =>
                      _getFilteredCategories(groceryProvider),
                  itemsProvider: (category) => groceryProvider.searchItems(
                    _searchQuery,
                    category: category == 'All' ? null : category,
                  ),
                  emptyStateMessage: S.of(context).noProductsFound,
                  emptyStateIcon: Icons.search_off,
                )
              : SafeArea(child: _buildBody(groceryProvider)),
        );
      },
    );
  }

  Widget _buildBody(SmartMart groceryProvider) {
    // Show suggestions when user is typing
    if (_showSuggestions &&
        _searchController.text.isNotEmpty &&
        !_isSearching) {
      return _buildSuggestions(groceryProvider);
    }

    // Show search results after performing search
    if (_isSearching && _searchQuery.isNotEmpty) {
      return _buildSearchResults(groceryProvider);
    }

    // Show recent searches by default
    return _buildRecentSearches(groceryProvider);
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 1,
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: const Icon(Icons.arrow_back, color: Colors.black),
      ),
      title: TextField(
        controller: _searchController,
        focusNode: _searchFocusNode,
        onSubmitted: _performSearch,
        onChanged: _onSearchTextChanged,
        decoration: InputDecoration(
          hintText: S.of(context).searchProducts,
          hintStyle: TextStyle(color: Colors.grey[600]),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        ),
        style: const TextStyle(fontSize: 16),
      ),
      actions: [
        if (_searchController.text.isNotEmpty)
          IconButton(
            onPressed: _clearSearch,
            icon: const Icon(Icons.clear, color: Colors.black),
          ),
        IconButton(
          onPressed: () {
            if (_searchController.text.isNotEmpty) {
              _performSearch(_searchController.text);
            }
          },
          icon: Icon(
            Icons.search,
            color: _searchController.text.isNotEmpty
                ? Colors.black
                : Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildSuggestions(SmartMart groceryProvider) {
    final searchText = _searchController.text;
    final suggestions = groceryProvider.getSearchSuggestions(searchText);

    if (suggestions.isEmpty) {
      return _buildRecentSearches(groceryProvider);
    }

    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final suggestion = suggestions[index];
        return ListTile(
          leading: const Icon(Icons.search, color: Colors.grey),
          title: RichText(
            text: TextSpan(
              style: const TextStyle(color: Colors.black, fontSize: 16),
              children: _highlightSearchTerm(
                suggestion,
                _searchController.text,
              ),
            ),
          ),
          trailing: const Icon(Icons.call_made, color: Colors.grey, size: 16),
          onTap: () => _selectSuggestion(suggestion),
        );
      },
    );
  }

  List<TextSpan> _highlightSearchTerm(String text, String searchTerm) {
    final spans = <TextSpan>[];
    final searchTermLower = searchTerm.toLowerCase();
    final textLower = text.toLowerCase();

    if (searchTerm.isEmpty || !textLower.contains(searchTermLower)) {
      return [TextSpan(text: text)];
    }

    final startIndex = textLower.indexOf(searchTermLower);
    if (startIndex == -1) {
      return [TextSpan(text: text)];
    }

    // Add text before the search term
    if (startIndex > 0) {
      spans.add(TextSpan(text: text.substring(0, startIndex)));
    }

    // Add the highlighted search term
    spans.add(
      TextSpan(
        text: text.substring(startIndex, startIndex + searchTerm.length),
        style: const TextStyle(
          fontWeight: FontWeight.w500,
          color: Colors.black,
        ),
      ),
    );

    // Add text after the search term
    final endIndex = startIndex + searchTerm.length;
    if (endIndex < text.length) {
      spans.add(TextSpan(text: text.substring(endIndex)));
    }

    return spans;
  }

  Widget _buildRecentSearches(SmartMart groceryProvider) {
    final recentSearches = groceryProvider.recentSearches;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (recentSearches.isNotEmpty) ...[
            Text(
              S.of(context).recentSearches,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 8,
              children: recentSearches.map((search) {
                return GestureDetector(
                  onTap: () => _selectRecentSearch(search),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.history, size: 16, color: Colors.grey[600]),
                        const SizedBox(width: 8),
                        Text(search, style: TextStyle(color: Colors.grey[800])),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            if (recentSearches.isNotEmpty)
              TextButton(
                onPressed: () {
                  groceryProvider.clearRecentSearches();
                },
                child: Text(
                  S.of(context).clearRecentSearches,
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ),
          ] else ...[
            const SizedBox(height: 100),
            Center(
              child: Column(
                children: [
                  Icon(Icons.search, size: 64, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    S.of(context).searchForProducts,
                    style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSearchResults(SmartMart groceryProvider) {
    final filteredItems = groceryProvider.searchItems(
      _searchQuery,
      category: _selectedCategory == 'All' ? null : _selectedCategory,
    );

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Text(
                S.of(context).searchResults,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '(${filteredItems.length})',
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
            ],
          ),
        ),
        Expanded(
          child: filteredItems.isEmpty
              ? _buildNoResults()
              : _buildProductGrid(filteredItems),
        ),
      ],
    ).withFloatingCart(
      onCartTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const CartScreen()),
      ),
      minimumOrderAmount: 7000,
    );
  }

  Widget _buildNoResults() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            S.of(context).noProductsFound,
            style: TextStyle(fontSize: 18, color: Colors.grey[600]),
          ),
          const SizedBox(height: 8),
          Text(
            S.of(context).trySearchingSomethingElse,
            style: TextStyle(fontSize: 14, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  Widget _buildProductGrid(List items) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 200,
          childAspectRatio: 0.60,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: items.length,
        itemBuilder: (context, index) {
          return ProductCard(item: items[index]);
        },
      ),
    );
  }
}
