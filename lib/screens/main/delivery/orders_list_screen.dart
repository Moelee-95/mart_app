// lib/screens/main/orders_list_screen.dart

import 'package:flutter/material.dart';
import 'package:grocery_stores/models/order.dart';
import 'package:grocery_stores/providers/smart_mart_provider.dart';
import 'package:provider/provider.dart';
import 'order_status_screen.dart';
import 'package:grocery_stores/generated/l10n.dart';

class OrdersListScreen extends StatefulWidget {
  const OrdersListScreen({super.key});

  @override
  State<OrdersListScreen> createState() => _OrdersListScreenState();
}

class _OrdersListScreenState extends State<OrdersListScreen> {
  bool isLoading = true;
  String selectedFilter = '';

  @override
  void initState() {
    super.initState();
    // Set default filter after context is available
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        selectedFilter = S.of(context).all;
      });
    });
    _loadOrders();
  }

  Future<void> _loadOrders() async {
    final provider = Provider.of<SmartMart>(context, listen: false);
    await provider.loadOrders();
    setState(() {
      isLoading = false;
    });
  }

  List<Order> _getFilteredOrders(List<Order> orders) {
    final filterLabels = [
      S.of(context).all,
      S.of(context).active,
      S.of(context).delivered,
      S.of(context).cancelled,
    ];

    final selectedIndex = filterLabels.indexOf(selectedFilter);

    if (selectedIndex == 0) return orders; // All

    return orders.where((order) {
      switch (selectedIndex) {
        case 1: // Active
          return order.currentStatus != OrderStatus.delivered &&
              order.currentStatus != OrderStatus.cancelled;
        case 2: // Delivered
          return order.currentStatus == OrderStatus.delivered;
        case 3: // Cancelled
          return order.currentStatus == OrderStatus.cancelled;
        default:
          return true;
      }
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SmartMart>(
      builder: (context, provider, child) {
        return Scaffold(
          backgroundColor: Colors.grey[50],
          appBar: _buildAppBar(),
          body: Column(
            children: [
              _buildFilterTabs(),
              Expanded(
                child: isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _getFilteredOrders(provider.orders).isEmpty
                    ? _buildEmptyState()
                    : _buildOrdersList(provider.orders),
              ),
            ],
          ),
        );
      },
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: Text(
        S.of(context).myOrders,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
      ),
      backgroundColor: Colors.white,
      elevation: 1,
      foregroundColor: Colors.black,
      actions: [
        IconButton(
          icon: const Icon(Icons.refresh),
          onPressed: () {
            setState(() {
              isLoading = true;
            });
            _loadOrders();
          },
        ),
      ],
    );
  }

  Widget _buildFilterTabs() {
    final filters = [
      S.of(context).all,
      S.of(context).active,
      S.of(context).delivered,
      S.of(context).cancelled,
    ];

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: filters.map((filter) => _buildFilterChip(filter)).toList(),
        ),
      ),
    );
  }

  Widget _buildFilterChip(String filter) {
    final isSelected = selectedFilter == filter;

    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(
          filter,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey[700],
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
        selected: isSelected,
        onSelected: (selected) {
          setState(() {
            selectedFilter = filter;
          });
        },
        selectedColor: Colors.teal,
        checkmarkColor: Colors.white,
        backgroundColor: Colors.grey[100],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );
  }

  Widget _buildEmptyState() {
    String message;
    IconData icon;

    final filterLabels = [
      S.of(context).all,
      S.of(context).active,
      S.of(context).delivered,
      S.of(context).cancelled,
    ];

    final selectedIndex = filterLabels.indexOf(selectedFilter);

    switch (selectedIndex) {
      case 1: // Active
        message = S.of(context).noActiveOrders;
        icon = Icons.shopping_bag_outlined;
        break;
      case 2: // Delivered
        message = S.of(context).noDeliveredOrders;
        icon = Icons.check_circle_outline;
        break;
      case 3: // Cancelled
        message = S.of(context).noCancelledOrders;
        icon = Icons.cancel_outlined;
        break;
      default:
        message = S.of(context).noOrdersYet;
        icon = Icons.shopping_cart_outlined;
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            S.of(context).startShoppingToSeeOrders,
            style: TextStyle(fontSize: 14, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  Widget _buildOrdersList(List<Order> orders) {
    final filteredOrders = _getFilteredOrders(orders);
    return RefreshIndicator(
      onRefresh: _loadOrders,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: filteredOrders.length,
        itemBuilder: (context, index) {
          final order = filteredOrders[index];
          return OrderCard(
            order: order,
            onTap: () => _navigateToOrderDetails(order),
            onRate: order.canBeRated ? () => _showRatingDialog(order) : null,
          );
        },
      ),
    );
  }

  void _navigateToOrderDetails(Order order) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => OrderStatusScreen(order: order)),
    );
  }

  void _showRatingDialog(Order order) {
    showDialog(
      context: context,
      builder: (context) => RatingDialog(
        order: order,
        onSubmit: (rating, review) {
          _submitRating(order, rating, review);
        },
      ),
    );
  }

  void _submitRating(Order order, double rating, String review) {
    // TODO: Submit rating to backend
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(S.of(context).thankYouForRating),
        backgroundColor: Colors.green,
      ),
    );
  }
}

class OrderCard extends StatelessWidget {
  final Order order;
  final VoidCallback onTap;
  final VoidCallback? onRate;

  const OrderCard({
    super.key,
    required this.order,
    required this.onTap,
    this.onRate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            spreadRadius: 0,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildOrderHeader(),
              const SizedBox(height: 12),
              _buildOrderItems(context),
              const SizedBox(height: 12),
              _buildOrderFooter(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOrderHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Order #${order.id.substring(order.id.length - 6)}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 4),
            Text(
              _formatDateTime(order.orderTime),
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: order.statusColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            order.statusDisplayText,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: order.statusColor,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOrderItems(BuildContext context) {
    final itemsToShow = order.items.take(2).toList();
    final remainingCount = order.items.length - itemsToShow.length;

    return Column(
      children: [
        ...itemsToShow.map(
          (item) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    item.imageUrl,
                    width: 40,
                    height: 40,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.image_not_supported,
                        color: Colors.grey,
                        size: 20,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    '${item.name} x${item.quantity}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Text(
                  'IQD ${(item.price * item.quantity).toStringAsFixed(0)}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
        if (remainingCount > 0)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              S.of(context).moreItems(remainingCount),
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildOrderFooter(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              S.of(context).totalAmountOrder(order.total.toStringAsFixed(0)),
            ),
            if (order.rating != null)
              Row(
                children: [
                  ...List.generate(
                    5,
                    (index) => Icon(
                      index < order.rating!.floor()
                          ? Icons.star
                          : Icons.star_border,
                      size: 16,
                      color: Colors.teal,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    order.rating!.toStringAsFixed(1),
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ],
              ),
          ],
        ),
        Row(
          children: [
            Consumer<SmartMart>(
              builder: (context, provider, child) {
                return ElevatedButton(
                  onPressed: () => provider.updateOrderStatus(order.id),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: order.statusColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: Icon(Icons.next_plan, size: 16, color: Colors.white),
                );
              },
            ),
            const SizedBox(width: 8),
            Consumer<SmartMart>(
              builder: (context, provider, child) {
                return ElevatedButton(
                  onPressed: () {
                    provider.repeatOrder(
                      order,
                    ); // Pass the order instance, not Order class
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: Text('Repate order'),
                );
              },
            ),
            if (onRate != null) ...[
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: onRate,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Text(
                  S.of(context).rateOrder,
                  style: const TextStyle(fontSize: 12),
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return '${difference.inDays} days ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hours ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minutes ago';
    } else {
      return 'Just now';
    }
  }
}

class RatingDialog extends StatefulWidget {
  final Order order;
  final Function(double rating, String review) onSubmit;

  const RatingDialog({super.key, required this.order, required this.onSubmit});

  @override
  State<RatingDialog> createState() => _RatingDialogState();
}

class _RatingDialogState extends State<RatingDialog> {
  double rating = 5.0;
  final TextEditingController reviewController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text(
        S.of(context).rateYourOrder,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Order #${widget.order.id.substring(widget.order.id.length - 6)}',
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) {
              return GestureDetector(
                onTap: () => setState(() => rating = index + 1.0),
                child: Icon(
                  index < rating ? Icons.star : Icons.star_border,
                  size: 40,
                  color: Colors.teal,
                ),
              );
            }),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: reviewController,
            decoration: InputDecoration(
              labelText: S.of(context).writeReviewOptional,
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.all(12),
            ),
            maxLines: 3,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(S.of(context).cancel),
        ),
        ElevatedButton(
          onPressed: () {
            widget.onSubmit(rating, reviewController.text);
            Navigator.of(context).pop();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.teal,
            foregroundColor: Colors.white,
          ),
          child: Text(S.of(context).submitRating),
        ),
      ],
    );
  }
}
