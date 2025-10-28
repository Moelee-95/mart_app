import 'package:flutter/material.dart';
import 'package:grocery_stores/models/main_item.dart';
import 'package:grocery_stores/screens/main/delivery/order_status_screen.dart';
import 'package:grocery_stores/screens/main/delivery/product_detail_screen.dart';
import 'package:grocery_stores/screens/main/home_screen.dart';
import 'package:grocery_stores/widgets/delivery_selection_widget.dart';
import 'package:provider/provider.dart';
import '../../../providers/smart_mart_provider.dart';
import '../../../widgets/add_to_cart_button.dart';
import 'package:grocery_stores/generated/l10n.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  static const double _sectionSpacing = 24.0;

  @override
  Widget build(BuildContext context) {
    return Consumer<SmartMart>(
      builder: (context, groceryProvider, child) {
        return Scaffold(
          appBar: _buildAppBar(context),
          body: groceryProvider.cartItems.isEmpty
              ? const EmptyCartView()
              : CartContent(groceryProvider: groceryProvider),
          bottomNavigationBar: groceryProvider.cartItems.isNotEmpty
              ? CartBottomBar(groceryProvider: groceryProvider)
              : null,
        );
      },
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            S.of(context).cart,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
          ),
          Text(
            S.of(context).deliveryApp,
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
        ],
      ),
      backgroundColor: Colors.white,
      elevation: 1,
      foregroundColor: Colors.black,
    );
  }
}

class EmptyCartView extends StatelessWidget {
  const EmptyCartView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_cart_outlined, size: 100, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            S.of(context).yourCartIsEmpty,
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            child: Text(S.of(context).goToHomeScreen),
            onPressed: () {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const HomeScreen()),
                (Route<dynamic> route) => false,
              );
            },
          ),
        ],
      ),
    );
  }
}

class CartContent extends StatelessWidget {
  const CartContent({super.key, required this.groceryProvider});

  final SmartMart groceryProvider;
  static const EdgeInsets _contentPadding = EdgeInsets.all(10.0);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: _contentPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CartItemsList(),
          const SizedBox(height: CartScreen._sectionSpacing),

          // Add this new section for delivery selection
          Text(
            S.of(context).deliveryOptions,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 12),
          const DeliverySelectionWidget(),
          const SizedBox(height: CartScreen._sectionSpacing),

          const SpecialRequestsSection(),
          const SizedBox(height: CartScreen._sectionSpacing),
          const PaymentSummarySection(),
          const SizedBox(height: 100), // Space for bottom bar
        ],
      ),
    );
  }
}

class CartItemsList extends StatelessWidget {
  const CartItemsList({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SmartMart>(
      builder: (context, groceryProvider, child) {
        return Column(
          children: groceryProvider.cartItems.map((cartItem) {
            // Find the original item to get complete details
            final originalItem = groceryProvider
                .getAllItems()
                .where((item) => item.id == cartItem.productId)
                .firstOrNull;

            return CartItemCard(cartItem: cartItem, originalItem: originalItem);
          }).toList(),
        );
      },
    );
  }
}

class CartItemCard extends StatelessWidget {
  const CartItemCard({super.key, required this.cartItem, this.originalItem});

  final dynamic cartItem;
  final dynamic originalItem;

  static const EdgeInsets _cardPadding = EdgeInsets.symmetric(
    horizontal: 2.0,
    vertical: 16.0,
  );
  static const double _imageSize = 90.0;
  static const double _spacing = 12.0;
  static const TextStyle _currencyStyle = TextStyle(
    fontSize: 16,
    color: Colors.black,
  );

  static const TextStyle _discountedPriceStyle = TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 16,
    color: Colors.black,
    decoration: TextDecoration.underline,
    decorationColor: Color(0xFFB8FF00),
    decorationThickness: 2.5,
  );

  static const TextStyle _originalPriceStyle = TextStyle(
    fontSize: 14,
    color: Colors.grey,
    decoration: TextDecoration.lineThrough,
    decorationColor: Colors.grey,
  );

  static const TextStyle _regularPriceStyle = TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 16,
    color: Colors.black,
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            if (originalItem != null) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      ProductDetailScreen(item: originalItem!),
                ),
              );
            }
          },
          child: Container(
            padding: _cardPadding,
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                _buildProductImage(),
                const SizedBox(width: _spacing),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildProductInfo(context),
                      const SizedBox(height: 12),
                      _buildPriceDisplay(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Divider(height: 1, thickness: 1, color: Colors.grey[300]),
      ],
    );
  }

  Widget _buildProductImage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.network(
        cartItem.imageUrl,
        width: _imageSize,
        height: _imageSize,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Container(
          width: _imageSize,
          height: _imageSize,
          decoration: BoxDecoration(
            color: Colors.grey[500],
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(Icons.image_not_supported, color: Colors.grey),
        ),
      ),
    );
  }

  Widget _buildProductInfo(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                cartItem.name,
                style: const TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                cartItem.description ?? '',
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ],
          ),
        ),
        _buildQuantityControls(context),
      ],
    );
  }

  Widget _buildPriceDisplay() {
    // Check if original item has discount to show pricing accordingly
    if (originalItem?.hasDiscount ?? false) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(text: 'IQD ', style: _currencyStyle),
                    TextSpan(
                      text: '${cartItem.price.toStringAsFixed(0)}',
                      style: _discountedPriceStyle,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 2),
              Text(
                'IQD ${originalItem!.price.toStringAsFixed(0)}',
                style: _originalPriceStyle,
              ),
            ],
          ),
          if (originalItem?.hasAnyOffer ?? false) ...[
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 3),
              decoration: BoxDecoration(
                color: const Color(0xFFB8FF00),
                borderRadius: BorderRadius.circular(3),
              ),
              child: Text(
                originalItem?.offerText ?? '',
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ],
      );
    } else {
      return RichText(
        text: TextSpan(
          children: [
            TextSpan(text: 'IQD ', style: _currencyStyle),
            TextSpan(
              text: '${cartItem.price.toStringAsFixed(0)}',
              style: _regularPriceStyle,
            ),
          ],
        ),
      );
    }
  }

  Widget _buildQuantityControls(BuildContext context) {
    return Consumer<SmartMart>(
      builder: (context, groceryProvider, child) {
        if (originalItem == null) {
          // Fallback if original item not found
          return _buildFallbackQuantityControls(context, groceryProvider);
        }

        return AddToCartButton(
          size: 40,
          item: originalItem!,
          onAddToCart: (item) => groceryProvider.addToCart(item),
          onRemoveFromCart: (item) => groceryProvider.removeFromCart(item.id),
          initialQuantity: cartItem.quantity,
          alwaysExpanded: true,
        );
      },
    );
  }

  Widget _buildFallbackQuantityControls(
    BuildContext context,
    SmartMart groceryProvider,
  ) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildQuantityButton(
            icon: Icons.remove,
            onPressed: () {
              groceryProvider.removeFromCart(cartItem.productId);
            },
            color: Colors.orange,
          ),
          Container(
            constraints: const BoxConstraints(minWidth: 40),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Text(
              '${cartItem.quantity}',
              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ),
          _buildQuantityButton(
            icon: Icons.add,
            onPressed: () {
              // Create a temporary item for adding
              final tempItem = mainItem(
                id: cartItem.productId,
                name: cartItem.name,
                price: cartItem.price,
                imageUrl: cartItem.imageUrl,
                category: 'Unknown',
                description: '',
              );
              groceryProvider.addToCart(tempItem);
            },
            color: Colors.orange,
          ),
        ],
      ),
    );
  }

  Widget _buildQuantityButton({
    required IconData icon,
    required VoidCallback onPressed,
    required Color color,
  }) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(8),
        child: Icon(icon, size: 20, color: color),
      ),
    );
  }
}

class SpecialRequestsSection extends StatefulWidget {
  const SpecialRequestsSection({super.key});

  @override
  State<SpecialRequestsSection> createState() => _SpecialRequestsSectionState();
}

class _SpecialRequestsSectionState extends State<SpecialRequestsSection> {
  final TextEditingController _requestsController = TextEditingController();
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    // Load existing special requests
    final groceryProvider = Provider.of<SmartMart>(
      context,
      listen: false,
    );
    _requestsController.text = groceryProvider.specialRequests;
  }

  @override
  void dispose() {
    _requestsController.dispose();
    super.dispose();
  }

  void _toggleEdit() {
    setState(() {
      _isEditing = !_isEditing;
    });
  }

  void _saveRequests() {
    final groceryProvider = Provider.of<SmartMart>(
      context,
      listen: false,
    );
    groceryProvider.setSpecialRequests(_requestsController.text.trim());
    setState(() {
      _isEditing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SmartMart>(
      builder: (context, groceryProvider, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  S.of(context).specialRequests,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                ),
                if (!_isEditing && groceryProvider.specialRequests.isNotEmpty)
                  TextButton(
                    onPressed: _toggleEdit,
                    child: Text(
                      S.of(context).edit,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(8),
                color: _isEditing ? Colors.white : Colors.grey[50],
              ),
              child: _isEditing
                  ? Column(
                      children: [
                        TextField(
                          controller: _requestsController,
                          maxLines: 3,
                          decoration: InputDecoration(
                            hintText: S.of(context).anySpecialRequests,
                            border: InputBorder.none,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: () {
                                _requestsController.text =
                                    groceryProvider.specialRequests;
                                setState(() {
                                  _isEditing = false;
                                });
                              },
                              child: Text(S.of(context).cancel),
                            ),
                            const SizedBox(width: 8),
                            ElevatedButton(
                              onPressed: _saveRequests,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.orange,
                                foregroundColor: Colors.white,
                              ),
                              child: Text(S.of(context).save),
                            ),
                          ],
                        ),
                      ],
                    )
                  : InkWell(
                      onTap: _toggleEdit,
                      child: Row(
                        children: [
                          const Icon(
                            Icons.chat_bubble_outline,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  groceryProvider.specialRequests.isEmpty
                                      ? S.of(context).anySpecialRequests
                                      : S.of(context).specialRequests,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  groceryProvider.specialRequests.isEmpty
                                      ? S.of(context).anythingElseWeNeedToKnow
                                      : groceryProvider.specialRequests,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color:
                                        groceryProvider.specialRequests.isEmpty
                                        ? Colors.grey
                                        : Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
            ),
          ],
        );
      },
    );
  }
}

class PaymentSummarySection extends StatelessWidget {
  const PaymentSummarySection({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SmartMart>(
      builder: (context, groceryProvider, child) {
        final cartTotal = groceryProvider.totalAmount;
        final deliveryFee =
            groceryProvider.selectedDeliveryMethod == DeliveryMethod.delivery
            ? 2000.0
            : 0.0;
        const serviceFee = 500.0;
        final totalAmount = cartTotal + deliveryFee + serviceFee;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              S.of(context).paymentSummary,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 16),
            _buildSummaryRow(
              S.of(context).cartTotal,
              'IQD ${cartTotal.toStringAsFixed(0)}',
            ),
            const SizedBox(height: 8),
            _buildSummaryRow(
              S.of(context).deliveryFee,
              deliveryFee > 0
                  ? 'IQD ${deliveryFee.toStringAsFixed(0)}'
                  : S.of(context).free,
              hasInfo: true,
            ),
            const SizedBox(height: 8),
            _buildSummaryRow(
              S.of(context).serviceFee,
              'IQD ${serviceFee.toStringAsFixed(0)}',
              hasInfo: true,
            ),
            const Divider(height: 24),
            _buildSummaryRow(
              S.of(context).total,
              'IQD ${totalAmount.toStringAsFixed(0)}',
              isBold: true,
            ),
            const SizedBox(height: 12),
            Text(
              S.of(context).readMoreAboutFees,
              style: TextStyle(
                decoration: TextDecoration.underline,
                color: Colors.blue,
                fontSize: 14,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSummaryRow(
    String label,
    String amount, {
    bool hasInfo = false,
    bool isBold = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: isBold ? FontWeight.w500 : FontWeight.normal,
              ),
            ),
            if (hasInfo) ...[
              const SizedBox(width: 4),
              const Icon(Icons.info_outline, size: 16, color: Colors.grey),
            ],
          ],
        ),
        Text(
          amount,
          style: TextStyle(
            fontSize: 16,
            fontWeight: isBold ? FontWeight.w500 : FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class CartBottomBar extends StatelessWidget {
  const CartBottomBar({super.key, required this.groceryProvider});

  final SmartMart groceryProvider;

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
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  side: const BorderSide(color: Colors.grey),
                ),
                child: Text(
                  S.of(context).addItems,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                onPressed: () => _showCheckoutDialog(context, groceryProvider),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                child: Text(
                  S.of(context).checkout,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

void _showCheckoutDialog(BuildContext context, SmartMart provider) {
  final cartTotal = provider.totalAmount;
  final deliveryFee = provider.selectedDeliveryMethod == DeliveryMethod.delivery ? 2000.0 : 0.0;
  const serviceFee = 500.0;
  final totalAmount = cartTotal + deliveryFee + serviceFee;

  final deliveryMethod = provider.selectedDeliveryMethod == DeliveryMethod.delivery
      ? S.of(context).delivery
      : S.of(context).pickup;

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(S.of(context).checkout),
        content: Text(
          '${S.of(context).method(deliveryMethod)}\n${S.of(context).totalAmountCheckout(totalAmount.toStringAsFixed(0))}\n\n${S.of(context).proceedWithCheckout}',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(S.of(context).cancel),
          ),
          ElevatedButton(
            onPressed: () async {
              final orderId = await provider.createOrder();
              Navigator.of(context).pop(); // Close dialog
              
              if (orderId.isNotEmpty) {
                final order = provider.orders.firstWhere((o) => o.id == orderId);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => OrderStatusScreen(order: order),
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
            child: Text(
              S.of(context).confirmOrder,
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      );
    },
  );
}
}
