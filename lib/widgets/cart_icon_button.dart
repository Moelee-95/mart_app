// widgets/cart_icon_button.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/smart_mart_provider.dart';
import '../screens/main/delivery/cart_screen.dart';

class CartIconButton extends StatelessWidget {
  const CartIconButton({
    super.key,
    this.iconSize = 24,
    this.badgeSize = 18,
    this.badgeFontSize = 12,
    this.iconColor = Colors.black,
    this.badgeColor = Colors.orange,
  });

  final double iconSize;
  final double badgeSize;
  final double badgeFontSize;
  final Color iconColor;
  final Color badgeColor;

  @override
  Widget build(BuildContext context) {
    return Consumer<SmartMart>(
      builder: (context, provider, child) {
        final itemCount = provider.cartItemsCount;
        return Stack(
          children: [
            IconButton(
              iconSize: iconSize,
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CartScreen()),
              ),
              icon: Icon(
                Icons.shopping_bag_outlined,
                color: iconColor,
              ),
            ),
            if (itemCount > 0)
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  padding: const EdgeInsets.all(1),
                  decoration: BoxDecoration(
                    color: badgeColor,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  constraints: BoxConstraints(
                    minWidth: badgeSize,
                    minHeight: badgeSize,
                  ),
                  child: Text(
                    itemCount > 99 ? '99+' : itemCount.toString(),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: badgeFontSize,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}