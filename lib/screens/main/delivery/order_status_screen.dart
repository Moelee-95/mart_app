import 'package:flutter/material.dart';
import 'package:grocery_stores/models/order.dart';
import 'package:grocery_stores/generated/l10n.dart';

class OrderStatusScreen extends StatelessWidget {
  final Order order;

  const OrderStatusScreen({super.key, required this.order});

  static const EdgeInsets _screenPadding = EdgeInsets.all(16.0);
  static const double _sectionSpacing = 24.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: _buildAppBar(context),
      body: SingleChildScrollView(
        padding: _screenPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const OrderConfirmationHeader(),
            const SizedBox(height: _sectionSpacing),
            DeliveryInformationSection(address: order.deliveryAddress),
            const SizedBox(height: _sectionSpacing),
            OrderSummarySection(order: order),
            const SizedBox(height: _sectionSpacing),
            OrderStatusSection(statusSteps: order.statusSteps),
            const SizedBox(height: _sectionSpacing),
            PaymentSummarySection(paymentMethod: order.paymentMethod),
            const SizedBox(height: _sectionSpacing),
            const OrderTrackingSection(),
            const SizedBox(height: _sectionSpacing),
            const ContactSupportSection(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: Text(
        S.of(context).orderConfirmationStatus,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
      ),
      backgroundColor: Colors.white,
      elevation: 1,
      foregroundColor: Colors.black,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => Navigator.of(context).pop(),
      ),
    );
  }
}

class OrderConfirmationHeader extends StatelessWidget {
  const OrderConfirmationHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
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
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 40,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            S.of(context).orderPlaced,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            S.of(context).orderPlacedMessage,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

class DeliveryInformationSection extends StatelessWidget {
  final String address;

  const DeliveryInformationSection({super.key, required this.address});

  @override
  Widget build(BuildContext context) {
    return _buildSectionCard(
      title: S.of(context).deliveryInformation,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.orange.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.location_on,
              color: Colors.orange,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  S.of(context).deliveryAddress,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  address,
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class OrderSummarySection extends StatelessWidget {
  final Order order;

  const OrderSummarySection({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return _buildSectionCard(
      title: S.of(context).orderSummary,
      titleTrailing: Text(
        S.of(context).itemsCount(order.items.length),
        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
      ),
      child: Column(
        children: [
          ...order.items.map((item) => _buildOrderItem(context, item)),
          const Divider(height: 24),
          _buildSummaryRow(
            context,
            S.of(context).subtotal,
            'IQD ${order.subtotal.toStringAsFixed(0)}',
          ),
          const SizedBox(height: 8),
          _buildSummaryRow(
            context,
            S.of(context).deliveryFee,
            'IQD ${order.deliveryFee.toStringAsFixed(0)}',
          ),
          const SizedBox(height: 12),
          _buildSummaryRow(
            context,
            S.of(context).total,
            'IQD ${order.total.toStringAsFixed(0)}',
            isBold: true,
          ),
        ],
      ),
    );
  }

  Widget _buildOrderItem(BuildContext context, OrderItem item) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              item.imageUrl,
              width: 50,
              height: 50,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.image_not_supported,
                  color: Colors.grey,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  S.of(context).quantity(item.quantity),
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          Text(
            'IQD ${(item.price * item.quantity).toStringAsFixed(0)}',
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(
    BuildContext context,
    String label,
    String amount, {
    bool isBold = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: isBold ? FontWeight.w500 : FontWeight.normal,
          ),
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

class OrderStatusSection extends StatelessWidget {
  final List<OrderStatusStep> statusSteps;

  const OrderStatusSection({super.key, required this.statusSteps});

  @override
  Widget build(BuildContext context) {
    return _buildSectionCard(
      title: S.of(context).orderStatus,
      child: Column(
        children: statusSteps.map((step) => _buildStatusStep(step)).toList(),
      ),
    );
  }

  Widget _buildStatusStep(OrderStatusStep step) {
    final color = step.isCompleted
        ? Colors.green
        : step.isCurrent
        ? Colors.orange
        : Colors.grey[400]!;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: step.isCompleted
                  ? Colors.green
                  : step.isCurrent
                  ? Colors.orange
                  : Colors.transparent,
              border: Border.all(color: color, width: 2),
              shape: BoxShape.circle,
            ),
            child: step.isCompleted
                ? const Icon(Icons.check, color: Colors.white, size: 16)
                : null,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  step.title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: step.isCompleted || step.isCurrent
                        ? Colors.black
                        : Colors.grey[500],
                  ),
                ),
                if (step.time.isNotEmpty)
                  Text(
                    step.time,
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PaymentSummarySection extends StatelessWidget {
  final PaymentMethod paymentMethod;

  const PaymentSummarySection({super.key, required this.paymentMethod});

  @override
  Widget build(BuildContext context) {
    return _buildSectionCard(
      title: S.of(context).paymentSummary,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.credit_card, color: Colors.blue, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  S.of(context).paymentMethod,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  paymentMethod.details,
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class OrderTrackingSection extends StatelessWidget {
  const OrderTrackingSection({super.key});

  @override
  Widget build(BuildContext context) {
    return _buildSectionCard(
      title: S.of(context).trackOrder,
      child: Column(
        children: [
          Row(
            children: [
              Text(
                S.of(context).orderInProgress,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),
              Text(
                S.of(context).stepProgress(2, 4),
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
            ],
          ),
          const SizedBox(height: 12),
          LinearProgressIndicator(
            value: 0.5, // This should be dynamic from backend
            backgroundColor: Colors.grey[300],
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
            minHeight: 6,
          ),
        ],
      ),
    );
  }
}

class ContactSupportSection extends StatelessWidget {
  const ContactSupportSection({super.key});

  @override
  Widget build(BuildContext context) {
    return _buildSectionCard(
      title: S.of(context).contactSupport,
      child: Column(
        children: [
          _buildContactButton(
            icon: Icons.phone,
            title: S.of(context).contactSupportButton,
            onTap: () {
              // Handle contact support
            },
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                // Handle contact market
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                S.of(context).contactMarket,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactButton({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Icon(icon, size: 20, color: Colors.grey[600]),
            const SizedBox(width: 12),
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const Spacer(),
            Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[400]),
          ],
        ),
      ),
    );
  }
}

Widget _buildSectionCard({
  required String title,
  Widget? titleTrailing,
  required Widget child,
}) {
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.all(20),
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
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            if (titleTrailing != null) titleTrailing,
          ],
        ),
        const SizedBox(height: 16),
        child,
      ],
    ),
  );
}
