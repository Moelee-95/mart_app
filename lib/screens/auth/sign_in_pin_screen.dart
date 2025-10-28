// screens/auth/sign_in_pin_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:grocery_stores/providers/smart_mart_provider.dart';
import 'package:grocery_stores/screens/auth/register_screen_3_setup_pin.dart';
import 'package:grocery_stores/screens/main/home_screen.dart';
import 'package:grocery_stores/screens/auth/register_screen_2_verify_number.dart';
import 'package:grocery_stores/services/auth_service.dart';
import 'package:grocery_stores/services/token_storage.dart';
import 'package:grocery_stores/widgets/pin_widget.dart';
import 'package:provider/provider.dart';

class AuthPinScreen extends StatefulWidget {
  final String phone;
  final String? authType;
  final VoidCallback? onSuccess;
  final String? title;
  final String? subtitle;

  const AuthPinScreen({
    required this.phone,
    this.authType = 'login',
    super.key,
    this.onSuccess,
    this.title,
    this.subtitle,
  });

  @override
  State<AuthPinScreen> createState() => _AuthPinScreenState();
}

class _AuthPinScreenState extends State<AuthPinScreen> {
  bool _isLoading = false;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _validatePin(String pin) async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      final result = await AuthService.login(widget.phone, pin);

      if (!mounted) return;

      if (result['success']) {
        if (widget.authType == "changePin") {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SetupPinScreen(authType: widget.authType)),
          );
        } else if (widget.authType == "login") {
          _handleSuccess(result);
        }
      } else {
        _handleError();
      }
    } catch (e) {
      if (mounted) _handleError();
    } finally{
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _handleSuccess(result) {
    setState(() => _isLoading = false);

    final provider = context.read<SmartMart>();
    provider.setCustomerFullName(result['customer']['full_name']);
    provider.setPhone(result['customer']['phone']);
    
    // store token in token storage
    TokenStorage.storeToken(
      result['access_token'],
      tokenType: result['token_type'],
    );

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const HomeScreen()),
    );
  }

  void _handleError() {
    setState(() {
      _isLoading = false;
      _hasError = true;
    });

    _showErrorSnackBar();
  }

  void _showErrorSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Incorrect PIN. Please try again.'),
        backgroundColor: Colors.red.shade400,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Navigator.of(context).canPop()
            ? IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black87),
                onPressed: _isLoading
                    ? null
                    : () => Navigator.of(context).pop(),
              )
            : null,
        title: Text(
          widget.title ?? 'Enter PIN',
          style: const TextStyle(
            color: Colors.black54,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height - 
                           MediaQuery.of(context).padding.top - 
                           kToolbarHeight - 48, // 48 for padding adjustments
              ),
              child: IntrinsicHeight(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 60),

                    // Title
                    Text(
                      widget.title ?? 'Welcome Back',
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),

                    const SizedBox(height: 8),

                    // Subtitle
                    Text(
                      widget.subtitle ?? 'Enter your PIN to continue',
                      style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                    ),

                    const SizedBox(height: 80),

                    // PIN input fields - Using the Pin widget
                    AuthPinInputWidget(
                      onPinComplete: _validatePin,
                      isLoading: _isLoading,
                      hasError: _hasError,
                      onError: () {
                        _showErrorSnackBar();
                      },
                    ),

                    const SizedBox(height: 40),

                    // Loading indicator
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 200),
                      child: _isLoading
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
                                  const SizedBox(height: 12),
                                  Text(
                                    'Verifying PIN...',
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

                    SizedBox(height: MediaQuery.of(context).viewInsets.bottom > 0 ? 20 : 0),
                    const Spacer(),

                    // Forgot PIN button
                    Center(
                      child: TextButton(
                        onPressed: _isLoading ? null : _showForgotPinDialog,
                        child: Text(
                          'Forgot PIN?',
                          style: TextStyle(
                            color: Colors.teal.shade600,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showForgotPinDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Forgot PIN?'),
        content: const Text(
          'Use Biometric authentication to reset your PIN. or Send OTP to your registered mobile number',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              // Handle forgot PIN logic here
            },
            child: const Text('Use Biometric'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              //Send OTP then Verify to reset PIN
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) =>
                      OtpVerificationScreen(authType: 'forgot_pin'),
                ),
              );
            },
            child: const Text('Send OTP'),
          ),
        ],
      ),
    );
  }
}