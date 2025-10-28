import 'package:flutter/material.dart';

/// A highly customizable and reusable popup dialog widget
class CustomPopupDialog extends StatelessWidget {
  final String? title;
  final Widget? titleWidget;
  final String? message;
  final Widget? content;
  final List<Widget>? actions;
  final bool isDismissible;
  final bool showCloseButton;
  final EdgeInsetsGeometry? contentPadding;
  final EdgeInsetsGeometry? titlePadding;
  final Color? backgroundColor;
  final double? elevation;
  final ShapeBorder? shape;
  final Duration? animationDuration;
  final Alignment? alignment;
  final VoidCallback? onClose;

  const CustomPopupDialog({
    Key? key,
    this.title,
    this.titleWidget,
    this.message,
    this.content,
    this.actions,
    this.isDismissible = true,
    this.showCloseButton = true,
    this.contentPadding,
    this.titlePadding,
    this.backgroundColor,
    this.elevation,
    this.shape,
    this.animationDuration,
    this.alignment,
    this.onClose,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: backgroundColor ?? Colors.white,
      elevation: elevation ?? 8,
      shape: shape ??
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.9,
          maxHeight: MediaQuery.of(context).size.height * 0.8,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header with title and close button
            if (title != null || titleWidget != null || showCloseButton)
              _buildHeader(context),
            
            // Content area
            if (content != null || message != null)
              _buildContent(context),
            
            // Action buttons
            if (actions != null && actions!.isNotEmpty)
              _buildActions(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: titlePadding ?? 
          const EdgeInsets.fromLTRB(24, 20, 8, 0),
      child: Row(
        children: [
          // Title
          Expanded(
            child: titleWidget ??
                (title != null
                    ? Text(
                        title!,
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      )
                    : const SizedBox.shrink()),
          ),
          
          // Close button
          if (showCloseButton)
            IconButton(
              onPressed: () {
                onClose?.call();
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.close),
              iconSize: 20,
              padding: const EdgeInsets.all(8),
              constraints: const BoxConstraints(
                minWidth: 32,
                minHeight: 32,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Flexible(
      child: SingleChildScrollView(
        padding: contentPadding ?? 
            const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: content ??
            (message != null
                ? Text(
                    message!,
                    style: Theme.of(context).textTheme.bodyMedium,
                  )
                : const SizedBox.shrink()),
      ),
    );
  }

  Widget _buildActions(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: actions!
            .map((action) => Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: action,
                ))
            .toList(),
      ),
    );
  }
}

/// Extension methods for easy dialog showing
extension DialogExtensions on BuildContext {
  /// Show a simple message dialog
  Future<T?> showMessageDialog<T>({
    required String title,
    required String message,
    bool isDismissible = true,
    bool showCloseButton = true,
    VoidCallback? onClose,
  }) {
    return showDialog<T>(
      context: this,
      barrierDismissible: isDismissible,
      builder: (context) => CustomPopupDialog(
        title: title,
        message: message,
        isDismissible: isDismissible,
        showCloseButton: showCloseButton,
        onClose: onClose,
      ),
    );
  }

  /// Show a confirmation dialog
  Future<bool?> showConfirmationDialog({
    required String title,
    required String message,
    String confirmText = 'Confirm',
    String cancelText = 'Cancel',
    bool isDismissible = true,
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
  }) {
    return showDialog<bool>(
      context: this,
      barrierDismissible: isDismissible,
      builder: (context) => CustomPopupDialog(
        title: title,
        message: message,
        isDismissible: isDismissible,
        showCloseButton: false,
        actions: [
          TextButton(
            onPressed: () {
              onCancel?.call();
              Navigator.of(context).pop(false);
            },
            child: Text(cancelText),
          ),
          ElevatedButton(
            onPressed: () {
              onConfirm?.call();
              Navigator.of(context).pop(true);
            },
            child: Text(confirmText),
          ),
        ],
      ),
    );
  }

  /// Show a custom dialog with full control
  Future<T?> showCustomDialog<T>({
    String? title,
    Widget? titleWidget,
    String? message,
    Widget? content,
    List<Widget>? actions,
    bool isDismissible = true,
    bool showCloseButton = true,
    EdgeInsetsGeometry? contentPadding,
    EdgeInsetsGeometry? titlePadding,
    Color? backgroundColor,
    double? elevation,
    ShapeBorder? shape,

    
    VoidCallback? onClose,
  }) {
    return showDialog<T>(
      context: this,
      barrierDismissible: isDismissible,
      builder: (context) => CustomPopupDialog(
        title: title,
        titleWidget: titleWidget,
        message: message,
        content: content,
        actions: actions,
        isDismissible: isDismissible,
        showCloseButton: showCloseButton,
        contentPadding: contentPadding,
        titlePadding: titlePadding,
        backgroundColor: backgroundColor,
        elevation: elevation,
        shape: shape,
        onClose: onClose,
      ),
    );
  }
}

/// Utility class for predefined dialog configurations
class DialogConfig {
  static ShapeBorder get defaultShape => RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      );

  static ShapeBorder get roundedShape => RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      );

  static ShapeBorder get squareShape => RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      );

  static List<Widget> confirmationActions({
    required BuildContext context,
    required VoidCallback onConfirm,
    VoidCallback? onCancel,
    String confirmText = 'Confirm',
    String cancelText = 'Cancel',
  }) {
    return [
      TextButton(
        onPressed: onCancel ?? () => Navigator.of(context).pop(false),
        child: Text(cancelText),
      ),
      ElevatedButton(
        onPressed: () {
          onConfirm();
          Navigator.of(context).pop(true);
        },
        child: Text(confirmText),
      ),
    ];
  }

  static List<Widget> okAction({
    required BuildContext context,
    VoidCallback? onPressed,
    String text = 'OK',
  }) {
    return [
      ElevatedButton(
        onPressed: onPressed ?? () => Navigator.of(context).pop(),
        child: Text(text),
      ),
    ];
  }
}