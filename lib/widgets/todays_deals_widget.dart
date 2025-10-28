// widgets/todays_deals_widget.dart

import 'package:flutter/material.dart';
import 'package:grocery_stores/widgets/product_card.dart';
import '../models/main_item.dart';
import 'package:grocery_stores/generated/l10n.dart';

class TodaysDealsWidget extends StatefulWidget {
  final List<mainItem> deals;

  const TodaysDealsWidget({super.key, required this.deals});

  @override
  State<TodaysDealsWidget> createState() => _TodaysDealsWidgetState();
}

class _TodaysDealsWidgetState extends State<TodaysDealsWidget> {
  // Configuration constants
  static const int _itemsPerPage = 8;
  static const int _preloadThreshold = 4; // Load more when 4 items from end
  static const Duration _loadDelay = Duration(milliseconds: 800);

  // State variables
  int _displayedItems = _itemsPerPage;
  bool _isLoading = false;
  bool _hasReachedEnd = false;

  @override
  void didUpdateWidget(TodaysDealsWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Reset state when deals list changes
    if (oldWidget.deals != widget.deals) {
      _resetPagination();
    }
  }

  void _resetPagination() {
    setState(() {
      _displayedItems = _itemsPerPage;
      _isLoading = false;
      _hasReachedEnd = false;
    });
  }

  bool get _hasMoreItems =>
      !_hasReachedEnd && widget.deals.length > _displayedItems;

  int get _totalItemsToShow => _displayedItems.clamp(0, widget.deals.length);

  @override
  Widget build(BuildContext context) {
    if (widget.deals.isEmpty) {
      return _buildEmptyState();
    }

    return SliverGrid(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 0.45,
        crossAxisSpacing: 2,
        mainAxisSpacing: 4,
      ),
      delegate: SliverChildBuilderDelegate(
        _buildGridItem,
        childCount: _calculateChildCount(),
      ),
    );
  }

  Widget _buildEmptyState() {
    return SliverToBoxAdapter(
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.local_offer_outlined, size: 48, color: Colors.grey),
              SizedBox(height: 16),
              Text(
                S.of(context).noDealsAvailable,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget? _buildGridItem(BuildContext context, int index) {
    // Check if we should trigger loading more items
    _checkAndTriggerLoad(index);

    if (index < _totalItemsToShow) {
      return ProductCard(item: widget.deals[index]);
    } else if (index == _totalItemsToShow && _hasMoreItems && _isLoading) {
      return _buildLoadingIndicator();
    }

    return null;
  }

  void _checkAndTriggerLoad(int currentIndex) {
    // Trigger load when we're close to the end and not already loading
    final shouldLoadMore =
        currentIndex >= _totalItemsToShow - _preloadThreshold &&
        _hasMoreItems &&
        !_isLoading;

    if (shouldLoadMore) {
      // Use post frame callback to avoid calling setState during build
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _loadMoreItems();
        }
      });
    }
  }

  int _calculateChildCount() {
    int count = _totalItemsToShow;

    // Add loading indicator slot if needed
    if (_hasMoreItems && _isLoading) {
      count += 1;
    }

    return count;
  }

  Widget _buildLoadingIndicator() {
    return Container(
      padding: const EdgeInsets.all(16),
      child:  Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
              ),
            ),
            SizedBox(height: 8),
            Text(
              S.of(context).loadingMore,
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _loadMoreItems() async {
    // Prevent multiple simultaneous loads
    if (_isLoading || _hasReachedEnd) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // Simulate network delay
      await Future.delayed(_loadDelay);

      if (!mounted) return;

      setState(() {
        final newDisplayedItems = _displayedItems + _itemsPerPage;
        _displayedItems = newDisplayedItems.clamp(0, widget.deals.length);
        _hasReachedEnd = _displayedItems >= widget.deals.length;
        _isLoading = false;
      });
    } catch (error) {
      // Handle loading errors gracefully
      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        // You could show a snackbar or error message here
        debugPrint('Error loading more items: $error');
      }
    }
  }
}
