// screens/auth/register_screen_3_setup_pin.dart
import 'package:flutter/material.dart';
import 'package:grocery_stores/providers/smart_mart_provider.dart';
import 'package:grocery_stores/screens/auth/register_screen_4_info.dart';
import 'package:grocery_stores/screens/main/home_screen.dart';
import 'package:grocery_stores/services/auth_service.dart';
import 'package:grocery_stores/services/store_utils.dart';
import 'package:grocery_stores/widgets/pin_widget.dart';
import 'package:provider/provider.dart';
import 'package:grocery_stores/generated/l10n.dart';

class SetupPinScreen extends StatefulWidget {
  final String? authType;
  final String? title;
  final String? subtitle;
  final String? oldPin;

  const SetupPinScreen({
    required this.authType, // changePin, forgot_pin, registration: default
    this.oldPin,
    this.title,
    this.subtitle,
    super.key,
  });

  @override
  State<SetupPinScreen> createState() => _SetupPinScreenState();
}

class _SetupPinScreenState extends State<SetupPinScreen> {
  final PageController _pageController = PageController();
  bool _isFirstStep = true;
  String _firstPin = '';
  String _confirmPin = '';
  bool _isLoading = false;
  bool _hasError = false;

  void _handlePinComplete(String pin) {
    if (_isFirstStep) {
      setState(() {
        _firstPin = pin;
        _isFirstStep = false;
        _hasError = false;
      });
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _confirmPin = pin;
      _validateAndSubmit();
    }
  }

  void _validateAndSubmit() async {
    if (_firstPin != _confirmPin) {
      _showError(S.of(context).pinsDoNotMatch);
      return;
    }

    setState(() => _isLoading = true);

    try {
      if (widget.authType == "changePin") {
        final result = await AuthService.changePin(_firstPin);
        if (result['success']) {
          if (mounted) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomeScreen()),
            );
          }
        } else {
          if (mounted) {
            StoreUtils.showError(context, S.of(context).couldNotChangePin);
          }
        }
      } else if (widget.authType == 'registration') {
        context.read<SmartMart>().setPin(_firstPin);
        if (mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const RegisterAccountScreen(),
            ),
          );
        }
      } else if (widget.authType == "forgot_pin") {
        // Handle forgot pin logic here
        // Example: await AuthService.resetPin(_firstPin);
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
          );
        }
      } else {
        if (mounted) {
          StoreUtils.showError(
            context,
            S.of(context).unknownAuthType(widget.authType ?? ''),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        StoreUtils.showError(context, S.of(context).anErrorOccurred);
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showError(String message) {
    setState(() => _hasError = true);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
    _goBack();
  }

  void _goBack() {
    if (!_isFirstStep) {
      setState(() {
        _isFirstStep = true;
        _firstPin = '';
        _confirmPin = '';
        _isLoading = false;
        _hasError = false;
      });
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: _isFirstStep
            ? null
            : IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black87),
                onPressed: _isLoading ? null : _goBack,
              ),
        title: Text(
          _isFirstStep ? S.of(context).setupPin : S.of(context).confirmPin,
          style: const TextStyle(
            color: Colors.black54,
            fontSize: 16,
            fontWeight: FontWeight.normal,
          ),
        ),
        centerTitle: false,
      ),
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          _PinInputPage(
            key: const ValueKey('setup'),
            title: S.of(context).setupYourPin,
            subtitle: S.of(context).enterApp4DigitPin,
            onPinComplete: _handlePinComplete,
            autoFocus: true,
          ),
          _PinInputPage(
            key: const ValueKey('confirm'),
            title: S.of(context).confirmYourPin,
            subtitle: S.of(context).reEnterPinToConfirm,
            onPinComplete: _handlePinComplete,
            isLoading: _isLoading,
            hasError: _hasError,
            autoFocus: true,
          ),
        ],
      ),
    );
  }
}

class _PinInputPage extends StatelessWidget {
  final String title;
  final String subtitle;
  final Function(String) onPinComplete;
  final bool isLoading;
  final bool hasError;
  final bool autoFocus;

  const _PinInputPage({
    super.key,
    required this.title,
    required this.subtitle,
    required this.onPinComplete,
    this.isLoading = false,
    this.hasError = false,
    this.autoFocus = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight:
                MediaQuery.of(context).size.height -
                MediaQuery.of(context).padding.top -
                kToolbarHeight -
                48, // 48 for padding adjustments
          ),
          child: IntrinsicHeight(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),

                // Title
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),

                const SizedBox(height: 12),

                // Subtitle
                Text(
                  subtitle,
                  style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                ),

                const SizedBox(height: 80),

                // PIN input widget - Using the reusable widget
                PinInputWidget(
                  onPinComplete: onPinComplete,
                  isLoading: isLoading,
                  hasError: hasError,
                  autoFocus: autoFocus,
                  fieldWidth: 64,
                  fieldHeight: 64,
                  enabled: !isLoading,
                ),

                const SizedBox(height: 40),

                // Loading indicator
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: isLoading
                      ? Center(
                          key: const ValueKey('loading'),
                          child: Column(
                            children: [
                              const CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.teal,
                                ),
                                strokeWidth: 2.5,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                S.of(context).settingUpYourPin,
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        )
                      : const SizedBox.shrink(key: ValueKey('empty')),
                ),

                SizedBox(
                  height: MediaQuery.of(context).viewInsets.bottom > 0 ? 20 : 0,
                ),
                const Spacer(),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
