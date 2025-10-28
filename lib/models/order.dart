// lib/models/order.dart
import 'package:flutter/material.dart';
class Order {
  final String id;
  final List<OrderItem> items;
  final double subtotal;
  final double deliveryFee;
  final double total;
  final String deliveryAddress;
  final DateTime orderTime;
  OrderStatus currentStatus;
  final List<OrderStatusStep> statusSteps;
  final PaymentMethod paymentMethod;
  final bool canRate;
  final double? rating;
  final String? review;
  final String specialRequests;

  Order({
    required this.id,
    required this.items,
    required this.subtotal,
    required this.deliveryFee,
    required this.total,
    required this.deliveryAddress,
    required this.orderTime,
    required this.currentStatus,
    this.specialRequests = '',
    required this.statusSteps,
    required this.paymentMethod,
    required this.canRate,
    this.rating,
    this.review,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      items: (json['items'] as List)
          .map((item) => OrderItem.fromJson(item))
          .toList(),
      subtotal: json['subtotal'].toDouble(),
      deliveryFee: json['deliveryFee'].toDouble(),
      total: json['total'].toDouble(),
      deliveryAddress: json['deliveryAddress'],
      orderTime: DateTime.parse(json['orderTime']),
      currentStatus: OrderStatus.values.firstWhere(
        (status) => status.name == json['currentStatus'],
      ),
      statusSteps: (json['statusSteps'] as List)
          .map((step) => OrderStatusStep.fromJson(step))
          .toList(),
      paymentMethod: PaymentMethod.fromJson(json['paymentMethod']),
      canRate: json['canRate'] ?? false,
      rating: json['rating']?.toDouble(),
      review: json['review'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'items': items.map((item) => item.toJson()).toList(),
      'subtotal': subtotal,
      'deliveryFee': deliveryFee,
      'total': total,
      'deliveryAddress': deliveryAddress,
      'orderTime': orderTime.toIso8601String(),
      'currentStatus': currentStatus.name,
      'statusSteps': statusSteps.map((step) => step.toJson()).toList(),
      'paymentMethod': paymentMethod.toJson(),
      'canRate': canRate,
      'rating': rating,
      'review': review,
    };
  }

  // Helper methods
  bool get isDelivered => currentStatus == OrderStatus.delivered;
  bool get canBeRated => isDelivered && canRate && rating == null;
  bool get isCancelled => currentStatus == OrderStatus.cancelled;
  bool get isActive => !isDelivered && !isCancelled;

  String get statusDisplayText {
    switch (currentStatus) {
      case OrderStatus.placed:
        return 'Order Placed';
      case OrderStatus.preparing:
        return 'Preparing';
      case OrderStatus.pickedUp:
        return 'Out for Delivery';
      case OrderStatus.delivered:
        return 'Delivered';
      case OrderStatus.cancelled:
        return 'Cancelled';
    }
  }

  Color get statusColor {
    switch (currentStatus) {
      case OrderStatus.placed:
        return Colors.blue;
      case OrderStatus.preparing:
        return Colors.orange;
      case OrderStatus.pickedUp:
        return Colors.purple;
      case OrderStatus.delivered:
        return Colors.green;
      case OrderStatus.cancelled:
        return Colors.red;
    }
  }

  // Create a copy with updated fields
  Order copyWith({
    String? id,
    List<OrderItem>? items,
    double? subtotal,
    double? deliveryFee,
    double? total,
    String? deliveryAddress,
    DateTime? orderTime,
    OrderStatus? currentStatus,
    List<OrderStatusStep>? statusSteps,
    PaymentMethod? paymentMethod,
    bool? canRate,
    double? rating,
    String? review,
  }) {
    return Order(
      id: id ?? this.id,
      items: items ?? this.items,
      subtotal: subtotal ?? this.subtotal,
      deliveryFee: deliveryFee ?? this.deliveryFee,
      total: total ?? this.total,
      deliveryAddress: deliveryAddress ?? this.deliveryAddress,
      orderTime: orderTime ?? this.orderTime,
      currentStatus: currentStatus ?? this.currentStatus,
      statusSteps: statusSteps ?? this.statusSteps,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      canRate: canRate ?? this.canRate,
      rating: rating ?? this.rating,
      review: review ?? this.review,
    );
  }
}

class OrderItem {
  final String id;
  final String name;
  final double price;
  final int quantity;
  final String imageUrl;

  OrderItem({
    required this.id,
    required this.name,
    required this.price,
    required this.quantity,
    required this.imageUrl,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: json['id'],
      name: json['name'],
      price: json['price'].toDouble(),
      quantity: json['quantity'],
      imageUrl: json['imageUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'quantity': quantity,
      'imageUrl': imageUrl,
    };
  }

  double get totalPrice => price * quantity;

  OrderItem copyWith({
    String? id,
    String? name,
    double? price,
    int? quantity,
    String? imageUrl,
  }) {
    return OrderItem(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}

enum OrderStatus {
  placed,
  preparing,
  pickedUp,
  delivered,
  cancelled
}

class OrderStatusStep {
  final OrderStatus status;
  final String title;
  final String time;
  final bool isCompleted;
  final bool isCurrent;

  OrderStatusStep({
    required this.status,
    required this.title,
    required this.time,
    required this.isCompleted,
    required this.isCurrent,
  });

  factory OrderStatusStep.fromJson(Map<String, dynamic> json) {
    return OrderStatusStep(
      status: OrderStatus.values.firstWhere(
        (status) => status.name == json['status'],
      ),
      title: json['title'],
      time: json['time'],
      isCompleted: json['isCompleted'],
      isCurrent: json['isCurrent'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status.name,
      'title': title,
      'time': time,
      'isCompleted': isCompleted,
      'isCurrent': isCurrent,
    };
  }

  Color get stepColor {
    if (isCompleted) return Colors.green;
    if (isCurrent) return Colors.orange;
    return Colors.grey;
  }

  IconData get stepIcon {
    switch (status) {
      case OrderStatus.placed:
        return Icons.shopping_cart;
      case OrderStatus.preparing:
        return Icons.restaurant;
      case OrderStatus.pickedUp:
        return Icons.local_shipping;
      case OrderStatus.delivered:
        return Icons.check_circle;
      case OrderStatus.cancelled:
        return Icons.cancel;
    }
  }

  OrderStatusStep copyWith({
    OrderStatus? status,
    String? title,
    String? time,
    bool? isCompleted,
    bool? isCurrent,
  }) {
    return OrderStatusStep(
      status: status ?? this.status,
      title: title ?? this.title,
      time: time ?? this.time,
      isCompleted: isCompleted ?? this.isCompleted,
      isCurrent: isCurrent ?? this.isCurrent,
    );
  }
}

class PaymentMethod {
  final String method;
  final String details;
  final String? cardLast4;
  final String? cardType;

  PaymentMethod({
    required this.method,
    required this.details,
    this.cardLast4,
    this.cardType,
  });

  factory PaymentMethod.fromJson(Map<String, dynamic> json) {
    return PaymentMethod(
      method: json['method'],
      details: json['details'],
      cardLast4: json['cardLast4'],
      cardType: json['cardType'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'method': method,
      'details': details,
      'cardLast4': cardLast4,
      'cardType': cardType,
    };
  }

  IconData get paymentIcon {
    switch (method.toLowerCase()) {
      case 'cash':
        return Icons.money;
      case 'card':
      case 'credit_card':
        return Icons.credit_card;
      case 'paypal':
        return Icons.account_balance_wallet;
      case 'apple_pay':
        return Icons.phone_iphone;
      case 'google_pay':
        return Icons.payment;
      default:
        return Icons.payment;
    }
  }

  Color get paymentColor {
    switch (method.toLowerCase()) {
      case 'cash':
        return Colors.green;
      case 'card':
      case 'credit_card':
        return Colors.blue;
      case 'paypal':
        return Colors.indigo;
      case 'apple_pay':
        return Colors.black;
      case 'google_pay':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String get displayName {
    if (method.toLowerCase() == 'card' && cardLast4 != null) {
      return '${cardType ?? 'Card'} **** $cardLast4';
    }
    return details;
  }

  PaymentMethod copyWith({
    String? method,
    String? details,
    String? cardLast4,
    String? cardType,
  }) {
    return PaymentMethod(
      method: method ?? this.method,
      details: details ?? this.details,
      cardLast4: cardLast4 ?? this.cardLast4,
      cardType: cardType ?? this.cardType,
    );
  }
}

// Utility class for order-related operations
class OrderUtils {
  static String formatOrderId(String orderId) {
    if (orderId.length <= 6) return orderId;
    return orderId.substring(orderId.length - 6);
  }

  static String formatDateTime(DateTime dateTime) {
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

  static double calculateProgress(List<OrderStatusStep> steps) {
    if (steps.isEmpty) return 0.0;
    
    final completedSteps = steps.where((step) => step.isCompleted).length;
    return completedSteps / steps.length;
  }

  static int getCurrentStepIndex(List<OrderStatusStep> steps) {
    for (int i = 0; i < steps.length; i++) {
      if (steps[i].isCurrent) return i + 1;
    }
    return steps.where((step) => step.isCompleted).length;
  }

  static String getProgressText(List<OrderStatusStep> steps) {
    final currentStep = getCurrentStepIndex(steps);
    return 'Step $currentStep of ${steps.length}';
  }
}