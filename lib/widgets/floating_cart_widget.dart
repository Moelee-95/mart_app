import 'package:flutter/material.dart';
import 'package:grocery_stores/screens/main/delivery/cart_screen.dart';
import 'package:provider/provider.dart';
import '../providers/smart_mart_provider.dart';
import 'package:grocery_stores/generated/l10n.dart';

/// A floating cart widget that displays cart summary and provides navigation to cart screen.
///
/// Features:
/// - Shows cart item count and total amount
/// - Animates when cart changes
/// - Only visible when cart has items
/// - Customizable minimum order amount
/// - Responsive design with proper constraints
class FloatingCartWidget extends StatefulWidget {
  const FloatingCartWidget({
    super.key,
    this.onCartTap,
    this.minimumOrderAmount = 5000,
    this.margin = const EdgeInsets.all(16.0),
    this.height = 60.0,
    this.borderRadius = 30.0,
    this.backgroundColor = Colors.teal,
    this.textColor = Colors.white,
    this.disabledColor = Colors.grey,
    this.animationDuration = const Duration(milliseconds: 300),
    this.showProgressBar = true,
    this.progressBarHeight = 4.0,
  });

  /// Callback when cart widget is tapped. If null, navigates to '/cart'
  final VoidCallback? onCartTap;

  /// Minimum order amount required for checkout
  final double minimumOrderAmount;

  /// Widget margin from screen edges
  final EdgeInsetsGeometry margin;

  /// Height of the cart widget
  final double height;

  /// Border radius of the cart widget
  final double borderRadius;

  /// Background color when cart is ready for checkout
  final Color backgroundColor;

  /// Text color
  final Color textColor;

  /// Color when minimum order amount is not met
  final Color disabledColor;

  /// Animation duration for transitions
  final Duration animationDuration;

  /// Whether to show progress bar when cart amount is below minimum
  final bool showProgressBar;

  /// Height of the progress bar
  final double progressBarHeight;

  @override
  State<FloatingCartWidget> createState() => _FloatingCartWidgetState();
}

class _FloatingCartWidgetState extends State<FloatingCartWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );

    _slideAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleCartTap(BuildContext context) {
    if (widget.onCartTap != null) {
      widget.onCartTap!();
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const CartScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SmartMart>(
      builder: (context, groceryProvider, child) {
        final hasItems = groceryProvider.cartItemsCount > 0;
        final totalAmount = groceryProvider.totalAmount;
        final itemCount = groceryProvider.cartItemsCount;
        final canCheckout = totalAmount >= widget.minimumOrderAmount;

        // Animate widget visibility
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (hasItems && !_animationController.isCompleted) {
            _animationController.forward();
          } else if (!hasItems && _animationController.isCompleted) {
            _animationController.reverse();
          }
        });

        if (!hasItems) {
          return const SizedBox.shrink();
        }

        return AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(0, _slideAnimation.value * 100),
              child: Transform.scale(
                scale: _scaleAnimation.value,
                child: Container(
                  margin: widget.margin,
                  child: _CartButton(
                    itemCount: itemCount,
                    totalAmount: totalAmount,
                    canCheckout: canCheckout,
                    minimumOrderAmount: widget.minimumOrderAmount,
                    height: widget.height,
                    borderRadius: widget.borderRadius,
                    backgroundColor: widget.backgroundColor,
                    disabledColor: widget.disabledColor,
                    textColor: widget.textColor,
                    onTap: () => _handleCartTap(context),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

/// Internal cart button widget that handles the visual representation
class _CartButton extends StatelessWidget {
  const _CartButton({
    required this.itemCount,
    required this.totalAmount,
    required this.canCheckout,
    required this.minimumOrderAmount,
    required this.height,
    required this.borderRadius,
    required this.backgroundColor,
    required this.disabledColor,
    required this.textColor,
    required this.onTap,
  });

  final int itemCount;
  final double totalAmount;
  final bool canCheckout;
  final double minimumOrderAmount;
  final double height;
  final double borderRadius;
  final Color backgroundColor;
  final Color disabledColor;
  final Color textColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: canCheckout ? onTap : null,
        borderRadius: BorderRadius.circular(borderRadius),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: height,
          width: screenWidth - 32, // Account for margins
          decoration: BoxDecoration(
            color: canCheckout ? backgroundColor : disabledColor,
            borderRadius: BorderRadius.circular(borderRadius),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: canCheckout
              ? _CheckoutReadyContent(
                  itemCount: itemCount,
                  totalAmount: totalAmount,
                  textColor: textColor,
                )
              : _MinimumOrderContent(
                  minimumOrderAmount: minimumOrderAmount,
                  currentAmount: totalAmount,
                  textColor: textColor,
                ),
        ),
      ),
    );
  }
}

/// Content shown when cart is ready for checkout
class _CheckoutReadyContent extends StatelessWidget {
  const _CheckoutReadyContent({
    required this.itemCount,
    required this.totalAmount,
    required this.textColor,
  });

  final int itemCount;
  final double totalAmount;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          // Cart icon with badge
          _CartIconWithBadge(itemCount: itemCount, iconColor: textColor),
          const SizedBox(width: 16),

          // View cart text
          Expanded(
            child: Text(
              S.of(context).cart,
              style: TextStyle(
                color: textColor,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          // Total amount
          Text(
            'IQD ${totalAmount.toInt()}',
            style: TextStyle(
              color: textColor,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

/// Content shown when minimum order amount is not met
class _MinimumOrderContent extends StatelessWidget {
  const _MinimumOrderContent({
    required this.minimumOrderAmount,
    required this.currentAmount,
    required this.textColor,
    this.showProgressBar = true,
  });

  final double minimumOrderAmount;
  final double currentAmount;
  final Color textColor;
  final bool showProgressBar;

  @override
  Widget build(BuildContext context) {
    final progress = (currentAmount / minimumOrderAmount).clamp(0.0, 1.0);
    final remainingAmount = (minimumOrderAmount - currentAmount).clamp(
      0.0,
      minimumOrderAmount,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: showProgressBar && currentAmount > 0
          ? _buildProgressContent(progress, remainingAmount, context)
          : _buildInitialContent(context),
    );
  }

  Widget _buildProgressContent(double progress, double remainingAmount, context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Icon(Icons.shopping_bag_outlined, color: textColor, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  remainingAmount <= 0
                      ? S.of(context).readyToCheckout
                      : '${S.of(context).add} ${remainingAmount.toInt()} ${S.of(context).iqd} ${S.of(context).moreToPlaceOrder}',
                  style: TextStyle(
                    color: textColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          _ProgressBar(
            progress: progress,
            backgroundColor: textColor.withOpacity(0.2),
            foregroundColor: textColor,
            height: 4,
          ),
        ],
      ),
    );
  }

  Widget _buildInitialContent(context) {
    return Row(
      children: [
        Icon(Icons.shopping_bag_outlined, color: textColor, size: 24),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            '${S.of(context).startAdding} ${S.of(context).iqd} ${minimumOrderAmount.toInt()} ${S.of(context).toPlaceYourOrder}',
            style: TextStyle(
              color: textColor,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}

/// Custom progress bar widget
class _ProgressBar extends StatefulWidget {
  const _ProgressBar({
    required this.progress,
    required this.backgroundColor,
    required this.foregroundColor,
    this.height = 4.0,
    this.borderRadius = 2.0,
    this.animationDuration = const Duration(milliseconds: 500),
  });

  final double progress;
  final Color backgroundColor;
  final Color foregroundColor;
  final double height;
  final double borderRadius;
  final Duration animationDuration;

  @override
  State<_ProgressBar> createState() => _ProgressBarState();
}

class _ProgressBarState extends State<_ProgressBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _progressAnimation;
  double _currentProgress = 0.0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );

    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: widget.progress,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    _controller.forward();
    _currentProgress = widget.progress;
  }

  @override
  void didUpdateWidget(_ProgressBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.progress != widget.progress) {
      _progressAnimation =
          Tween<double>(begin: _currentProgress, end: widget.progress).animate(
            CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
          );

      _controller.reset();
      _controller.forward();
      _currentProgress = widget.progress;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        borderRadius: BorderRadius.circular(widget.borderRadius),
      ),
      child: AnimatedBuilder(
        animation: _progressAnimation,
        builder: (context, child) {
          return Align(
            alignment: Alignment.centerLeft,
            child: Container(
              width:
                  MediaQuery.of(context).size.width * _progressAnimation.value,
              decoration: BoxDecoration(
                color: widget.foregroundColor,
                borderRadius: BorderRadius.circular(widget.borderRadius),
              ),
            ),
          );
        },
      ),
    );
  }
}

/// Cart icon with item count badge
class _CartIconWithBadge extends StatelessWidget {
  const _CartIconWithBadge({required this.itemCount, required this.iconColor});

  final int itemCount;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 32,
      height: 32,
      child: Stack(
        children: [
          Icon(Icons.shopping_cart, color: iconColor, size: 24),
          if (itemCount > 0)
            Positioned(
              right: 0,
              top: 0,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: iconColor,
                  shape: BoxShape.circle,
                ),
                constraints: const BoxConstraints(minWidth: 20, minHeight: 20),
                child: Text(
                  itemCount > 99 ? '99+' : itemCount.toString(),
                  style: TextStyle(
                    color: iconColor == Colors.white
                        ? Colors.teal
                        : Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Extension to easily add floating cart to any screen
extension FloatingCartExtension on Widget {
  /// Wraps the widget with a Stack containing the floating cart
  Widget withFloatingCart({
    VoidCallback? onCartTap,
    double minimumOrderAmount = 5000,
    EdgeInsetsGeometry? margin,
    double? height,
    Color? backgroundColor,
    bool showProgressBar = true,
  }) {
    return Stack(
      children: [
        this,
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: FloatingCartWidget(
            onCartTap: onCartTap,
            minimumOrderAmount: minimumOrderAmount,
            margin: margin ?? const EdgeInsets.all(16),
            height: height ?? 60,
            backgroundColor: backgroundColor ?? Colors.teal,
            showProgressBar: showProgressBar,
          ),
        ),
      ],
    );
  }
}
