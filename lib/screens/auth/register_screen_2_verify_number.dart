// screens/auth/register_screen_2_verify_number.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:grocery_stores/providers/smart_mart_provider.dart';
import 'package:provider/provider.dart';
import 'package:grocery_stores/screens/auth/register_screen_3_setup_pin.dart';
import 'package:grocery_stores/services/store_utils.dart';
import 'package:grocery_stores/services/auth_service.dart';
import 'package:grocery_stores/generated/l10n.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String? authType; // 'forgot_pin' or 'register'

  const OtpVerificationScreen({this.authType = 'register', super.key});

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final List<TextEditingController> _controllers = List.generate(
    4,
    (index) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(4, (index) => FocusNode());

  bool _isLoading = false;
  bool _canResend = false;
  int _resendTimer = 30;

  @override
  void initState() {
    super.initState();
    _startResendTimer();
    // Auto focus first field
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNodes[0].requestFocus();
    });
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

  void _startResendTimer() {
    _canResend = false;
    _resendTimer = 30;

    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (mounted) {
        setState(() {
          _resendTimer--;
          if (_resendTimer <= 0) {
            _canResend = true;
          }
        });
        return _resendTimer > 0;
      }
      return false;
    });
  }

  void _onChanged(String value, int index) {
    if (value.isNotEmpty && index < 3) {
      _focusNodes[index + 1].requestFocus();
    }
    if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
  }

  void _register(String otp) async {
    String phone = context.read<SmartMart>().customer.phone;
    final result = await AuthService.verifyOtp(phone, otp);

    if (!mounted) return;
    if (result['success']) {
      context.read<SmartMart>().setVerificationToken(
        result['verification_token'],
      );
      StoreUtils.showSuccess(context, result['message']);
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const SetupPinScreen(authType: "registration"),
        ),
      );
    } else {
      StoreUtils.showError(context, result['message']);
    }
  }

  void _forgotPin(String otp) async {
    String phone = context.read<SmartMart>().customer.phone;
    final result = await AuthService.verifyOtp(phone, otp);
    if (!mounted) return;
    //temp disable
    if (result['success']) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const SetupPinScreen(authType: 'forgot_pin'),
        ),
      );
    }
  }

  void _verify() {
    String otp = _controllers.map((controller) => controller.text).join();

    if (otp.length < 4) {
      StoreUtils.showError(context, S.of(context).pleaseEnterCompleteCode);
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      if (widget.authType == 'registration') {
        _register(otp);
      } else if (widget.authType == 'forgot_pin') {
        _forgotPin(otp);
      } else {
        StoreUtils.showInfo(
          context,
          "Wrong Auth type " + widget.authType.toString(),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _resendCode() {
    if (!_canResend) return;

    // Clear existing OTP
    for (var controller in _controllers) {
      controller.clear();
    }

    // Restart timer
    _startResendTimer();

    // Focus first field
    _focusNodes[0].requestFocus();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(S.of(context).verificationCodeSent),
        backgroundColor: Colors.teal,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          S.of(context).otpVerification,
          style: const TextStyle(
            color: Colors.black54,
            fontSize: 16,
            fontWeight: FontWeight.normal,
          ),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              // Title
              Text(
                S.of(context).enterCodeSent,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                  height: 1.3,
                ),
              ),

              const SizedBox(height: 16),

              // Subtitle with phone number
              RichText(
                text: TextSpan(
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade600,
                    height: 1.4,
                  ),
                  children: [
                    TextSpan(text: S.of(context).sentVerificationCodeTo),
                    TextSpan(
                      text: ' ${context.read<SmartMart>().phone}',
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    TextSpan(text: S.of(context).enterBelowToContinue),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              // OTP input fields
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(
                  4,
                  (index) => Container(
                    width: 45,
                    height: 55,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: _controllers[index].text.isNotEmpty
                            ? Colors.teal
                            : Colors.grey.shade300,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: TextField(
                      controller: _controllers[index],
                      focusNode: _focusNodes[index],
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      maxLength: 1,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        counterText: '',
                      ),
                      onChanged: (value) => _onChanged(value, index),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // Verify button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _verify,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    elevation: 0,
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        )
                      : Text(
                          S.of(context).verify,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),

              const SizedBox(height: 30),

              // Resend code section
              Center(
                child: Column(
                  children: [
                    if (!_canResend) ...[
                      Text(
                        S.of(context).resendCodeIn(_resendTimer),
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ] else ...[
                      GestureDetector(
                        onTap: _resendCode,
                        child: Text(
                          S.of(context).didntReceiveCodeResend,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.teal,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
