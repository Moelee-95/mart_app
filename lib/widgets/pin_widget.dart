import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:grocery_stores/generated/l10n.dart';

class PinInputWidget extends StatefulWidget {
  final Function(String) onPinComplete;
  final bool isLoading;
  final bool hasError;
  final bool autoFocus;
  final bool obscureText;
  final bool enabled;
  final int pinLength;
  final double fieldWidth;
  final double fieldHeight;
  final Color? focusedBorderColor;
  final Color? errorBorderColor;
  final Color? normalBorderColor;
  final Color? filledBackgroundColor;
  final Color? errorBackgroundColor;
  final String? errorText;
  final Animation<double>? shakeAnimation;

  const PinInputWidget({
    super.key,
    required this.onPinComplete,
    this.isLoading = false,
    this.hasError = false,
    this.autoFocus = true,
    this.obscureText = true,
    this.enabled = true,
    this.pinLength = 4,
    this.fieldWidth = 56,
    this.fieldHeight = 56,
    this.focusedBorderColor,
    this.errorBorderColor,
    this.normalBorderColor,
    this.filledBackgroundColor,
    this.errorBackgroundColor,
    this.errorText,
    this.shakeAnimation,
  });

  @override
  State<PinInputWidget> createState() => _PinInputWidgetState();
}

class _PinInputWidgetState extends State<PinInputWidget> {
  late final List<TextEditingController> _controllers;
  late final List<FocusNode> _focusNodes;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
      widget.pinLength,
      (_) => TextEditingController(),
    );
    _focusNodes = List.generate(widget.pinLength, (_) => FocusNode());

    if (widget.autoFocus) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && _focusNodes.isNotEmpty) {
          _focusNodes[0].requestFocus();
        }
      });
    }
  }

  @override
  void didUpdateWidget(PinInputWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Clear PIN when error state changes from true to false
    if (oldWidget.hasError && !widget.hasError) {
      _clearPin();
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _onChanged(String value, int index) {
    if (value.isNotEmpty && index < widget.pinLength - 1) {
      _focusNodes[index + 1].requestFocus();
    }

    // Check if PIN is complete
    final pin = _controllers.map((c) => c.text).join();
    if (pin.length == widget.pinLength && !widget.isLoading) {
      FocusScope.of(context).unfocus();
      // Use post-frame callback to prevent build-time errors
      WidgetsBinding.instance.addPostFrameCallback((_) {
        widget.onPinComplete(pin);
      });
    }
  }

  bool _onKey(KeyEvent event, int index) {
    if (event is KeyDownEvent || event is KeyRepeatEvent) {
      if (event.logicalKey == LogicalKeyboardKey.backspace) {
        // If current field has content, clear it and stay on the same field
        if (_controllers[index].text.isNotEmpty) {
          _controllers[index].clear();
          return true; // Consume the event
        }
        // If current field is empty and not the first field, move to previous field
        else if (index > 0) {
          _focusNodes[index - 1].requestFocus();
          // Clear the previous field as well
          _controllers[index - 1].clear();
          return true; // Consume the event
        }
      }
    }
    return false; // Don't consume other events
  }

  void _clearPin() {
    for (var controller in _controllers) {
      controller.clear();
    }
    if (widget.autoFocus && _focusNodes.isNotEmpty) {
      _focusNodes[0].requestFocus();
    }
  }

  Color _getBorderColor(int index) {
    if (widget.hasError) {
      return widget.errorBorderColor ?? Colors.red.shade400;
    }
    if (_controllers[index].text.isNotEmpty) {
      return widget.focusedBorderColor ?? Colors.teal;
    }
    return widget.normalBorderColor ?? Colors.grey.shade300;
  }

  Color _getBackgroundColor(int index) {
    if (widget.hasError) {
      return widget.errorBackgroundColor ?? Colors.red.withOpacity(0.05);
    }
    if (_controllers[index].text.isNotEmpty) {
      return widget.filledBackgroundColor ?? Colors.teal.withOpacity(0.05);
    }
    return Colors.transparent;
  }

  Widget _buildPinField(int index) {
    Widget field = KeyboardListener(
      focusNode: FocusNode(skipTraversal: true),
      onKeyEvent: (event) => _onKey(event, index),
      child: Container(
        width: widget.fieldWidth,
        height: widget.fieldHeight,
        margin: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          border: Border.all(
            color: _getBorderColor(index),
            width: widget.hasError ? 2.5 : 2,
          ),
          borderRadius: BorderRadius.circular(12),
          color: _getBackgroundColor(index),
        ),
        child: TextField(
          controller: _controllers[index],
          focusNode: _focusNodes[index],
          textAlign: TextAlign.center,
          keyboardType: TextInputType.number,
          maxLength: 1,
          obscureText: widget.obscureText,
          enabled: widget.enabled && !widget.isLoading,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w500,
            color: widget.hasError ? Colors.red.shade700 : Colors.black87,
          ),
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          decoration: const InputDecoration(
            border: InputBorder.none,
            counterText: '',
            contentPadding: EdgeInsets.zero,
          ),
          onChanged: (value) => _onChanged(value, index),
        ),
      ),
    );

    // Apply shake animation if provided
    if (widget.shakeAnimation != null) {
      return AnimatedBuilder(
        animation: widget.shakeAnimation!,
        builder: (context, child) {
          return Transform.translate(
            offset: widget.hasError
                ? Offset(widget.shakeAnimation!.value, 0)
                : Offset.zero,
            child: field,
          );
        },
      );
    }

    return field;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // PIN input fields
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(widget.pinLength, _buildPinField),
        ),

        // Error text
        if (widget.hasError && widget.errorText != null) ...[
          const SizedBox(height: 16),
          Text(
            widget.errorText!,
            style: TextStyle(
              color: Colors.red.shade600,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],

        // Clear button (only show when not loading and has content)
        if (!widget.isLoading &&
            _controllers.any((c) => c.text.isNotEmpty)) ...[
          const SizedBox(height: 20),
          TextButton.icon(
            onPressed: _clearPin,
            icon: Icon(Icons.clear, size: 16, color: Colors.grey.shade600),
            label: Text(
              S.of(context).clearPin,
              style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
            ),
          ),
        ],
      ],
    );
  }
}

// Specialized version for authentication with built-in shake animation
class AuthPinInputWidget extends StatefulWidget {
  final Function(String) onPinComplete;
  final bool isLoading;
  final bool hasError;
  final bool autoFocus;
  final VoidCallback? onError;

  const AuthPinInputWidget({
    super.key,
    required this.onPinComplete,
    this.isLoading = false,
    this.hasError = false,
    this.autoFocus = true,
    this.onError,
  });

  @override
  State<AuthPinInputWidget> createState() => _AuthPinInputWidgetState();
}

class _AuthPinInputWidgetState extends State<AuthPinInputWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _shakeController;
  late Animation<double> _shakeAnimation;

  @override
  void initState() {
    super.initState();
    _setupShakeAnimation();
  }

  void _setupShakeAnimation() {
    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _shakeAnimation = Tween<double>(
      begin: 0,
      end: 10,
    ).chain(CurveTween(curve: Curves.elasticIn)).animate(_shakeController);
  }

  @override
  void didUpdateWidget(AuthPinInputWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (!oldWidget.hasError && widget.hasError) {
      _triggerShake();
    }
  }

  void _triggerShake() {
    HapticFeedback.mediumImpact();
    _shakeController.forward().then((_) {
      _shakeController.reverse();
    });

    // Use post-frame callback to prevent build-time errors
    if (widget.onError != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        widget.onError!();
      });
    }
  }

  @override
  void dispose() {
    _shakeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PinInputWidget(
      onPinComplete: widget.onPinComplete,
      isLoading: widget.isLoading,
      hasError: widget.hasError,
      autoFocus: widget.autoFocus,
      shakeAnimation: _shakeAnimation,
      errorText: widget.hasError ? S.of(context).incorrectPin : null,
    );
  }
}
