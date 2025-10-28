import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/main_item.dart';

class AddToCartButton extends StatefulWidget {
  final mainItem item;
  final Function(mainItem) onAddToCart;
  final Function(mainItem) onRemoveFromCart;
  final int initialQuantity;
  final bool alwaysExpanded;

  /// Overall control height/width (circle size).
  final double size;

  const AddToCartButton({
    Key? key,
    required this.item,
    required this.onAddToCart,
    required this.onRemoveFromCart,
    required this.initialQuantity,
    this.size = 48,
    this.alwaysExpanded = false,
  }) : super(key: key);

  @override
  State<AddToCartButton> createState() => _AddToCartButtonState();
}

class _AddToCartButtonState extends State<AddToCartButton>
    with TickerProviderStateMixin {
  late int quantity;
  bool isExpanded = false;

  late AnimationController _tapCtrl;
  late Animation<double> _tapScale;

  late AnimationController _widthCtrl;
  late Animation<double> _width;

  Timer? _collapseTimer;

  // ---- Sizing ----
  double get h => widget.size ;
  double get r => h / 2;
  double get iconSize => h * 0.5;
  double get qtyFont => h * 0.42;
  double get qtyWidth => h; 

  @override
  void initState() {
    super.initState();
    quantity = widget.initialQuantity;
    isExpanded = false;

    _tapCtrl = AnimationController(
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );
    _tapScale = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(parent: _tapCtrl, curve: Curves.elasticOut));

    _widthCtrl = AnimationController(
      duration: const Duration(milliseconds: 350),
      vsync: this,
    );
    _width = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _widthCtrl, curve: Curves.easeInOutCubic),
    );

    if (quantity > 0 && !isExpanded) {
      _widthCtrl.value = 0.0;
    }
  }

  @override
  void didUpdateWidget(AddToCartButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialQuantity != oldWidget.initialQuantity) {
      setState(() {
        quantity = widget.initialQuantity;
        if (quantity == 0) {
          isExpanded = false;
          _widthCtrl.reset();
        } else if (widget.alwaysExpanded) {
          isExpanded = true;
          _widthCtrl.value = 1.0;
        }
      });
    }
  }

  @override
  void dispose() {
    _collapseTimer?.cancel();
    _tapCtrl.dispose();
    _widthCtrl.dispose();
    super.dispose();
  }

  void _onTap() {
    HapticFeedback.lightImpact();

    if (quantity == 0) {
      setState(() {
        quantity = 1;
        isExpanded = true;
      });
      widget.onAddToCart(widget.item);
      if (!widget.alwaysExpanded) {
        // ADD THIS CONDITION
        _widthCtrl.forward();
        _startCollapseTimer();
      }
    } else if (!isExpanded && !widget.alwaysExpanded) {
      // MODIFIED THIS LINE
      setState(() => isExpanded = true);
      _widthCtrl.forward();
      _cancelCollapseTimer();
    }

    _tapCtrl.forward().then((_) => _tapCtrl.reverse());
  }

  void _onAdd() {
    HapticFeedback.lightImpact();
    setState(() => quantity++);
    widget.onAddToCart(widget.item);
    _startCollapseTimer();
  }

  void _onRemove() {
    HapticFeedback.lightImpact();
    if (quantity > 1) {
      setState(() => quantity--);
      widget.onRemoveFromCart(widget.item);
      _startCollapseTimer();
    } else {
      setState(() {
        quantity = 0;
        isExpanded = false;
      });
      widget.onRemoveFromCart(widget.item);
      _cancelCollapseTimer();
    }
  }

  void _startCollapseTimer() {
    _cancelCollapseTimer();
    _collapseTimer = Timer(const Duration(seconds: 4), () {
      if (!mounted) return;
      if (quantity > 0) {
        _widthCtrl.reverse().then((_) {
          if (mounted) setState(() => isExpanded = false);
        });
      }
    });
  }

  void _cancelCollapseTimer() {
    _collapseTimer?.cancel();
  }

  @override
  @override
  Widget build(BuildContext context) {
    if (quantity == 0) {
      // Collapsed state (single "+" button on right side)
      return ScaleTransition(
        scale: _tapScale,
        child: InkWell(
          onTap: _onTap,
          borderRadius: BorderRadius.circular(r),
          child: Container(
            width: h,
            height: h,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(r),
              border: Border.all(color: Colors.teal, width: 0.2),
            ),
            child: Icon(Icons.add, color:Colors.teal, size: iconSize),
          ),
        ),
      );
    }

    return SizedBox(
      height: h,
      child:
          (isExpanded || widget.alwaysExpanded) // MODIFIED THIS LINE
          ? AnimatedBuilder(
              animation: _width,
              builder: (context, child) {
                return Transform.scale(
                  scaleX: widget.alwaysExpanded
                      ? 1.0
                      : _width.value, // MODIFIED THIS LINE
                  child: Opacity(
                    opacity: widget.alwaysExpanded
                        ? 1.0
                        : _width.value, // MODIFIED THIS LINE
                    child: _buildExpandedState(context),
                  ),
                );
              },
            )
          : _buildCollapsedState(context),
    );
  }

  Widget _buildExpandedState(BuildContext context) {
    return Container(
      width: h * 3, // Ensure minimum width for 3 buttons
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(r),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // minus
          Flexible(
            child: InkWell(
              onTap: _onRemove,
              borderRadius: BorderRadius.circular(r),
              child: Container(
                width: h,
                height: h,
                alignment: Alignment.center,
                child: Icon(Icons.remove, color: const Color.fromARGB(255, 255, 38, 0), size: iconSize),
              ),
            ),
          ),
          // quantity
          Flexible(
            child: Container(
              width: qtyWidth,
              height: h,
              alignment: Alignment.center,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                transitionBuilder: (child, animation) => SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, 0.5),
                    end: Offset.zero,
                  ).animate(animation),
                  child: FadeTransition(opacity: animation, child: child),
                ),
                child: Text(
                  quantity.toString(),
                  key: ValueKey<int>(quantity),
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: qtyFont,
                  ),
                ),
              ),
            ),
          ),
          // plus
          Flexible(
            child: InkWell(
              onTap: _onAdd,
              borderRadius: BorderRadius.circular(r),
              child: Container(
                width: h,
                height: h,
                alignment: Alignment.center,
                child: Icon(
                  Icons.add,
                  color: Theme.of(context).primaryColor,
                  size: iconSize,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCollapsedState(BuildContext context) {
    // Collapsed when quantity > 0 but pill hidden (shows number)
    return ScaleTransition(
      scale: _tapScale,
      child: GestureDetector(
        onTap: _onTap,
        child: Container(
          width: h,
          height: h,
          decoration: BoxDecoration(
            color: Colors.teal,
            borderRadius: BorderRadius.circular(r),
            border: Border.all(color: Colors.white, width: 0.3),
          ),
          alignment: Alignment.center,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            transitionBuilder: (child, animation) => SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 0.5),
                end: Offset.zero,
              ).animate(animation),
              child: FadeTransition(opacity: animation, child: child),
            ),
            child: Text(
              quantity.toString(),
              key: ValueKey<int>(quantity),
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
                fontSize: qtyFont,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
