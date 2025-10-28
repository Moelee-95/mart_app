import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:grocery_stores/providers/smart_mart_provider.dart';
import 'package:grocery_stores/services/auth_service.dart';
import 'package:grocery_stores/services/store_utils.dart';
import 'change_phone_otp_screen.dart';
import 'package:grocery_stores/generated/l10n.dart';

class ChangePhoneScreen extends StatefulWidget {
  const ChangePhoneScreen({super.key});

  @override
  State<ChangePhoneScreen> createState() => _ChangePhoneScreenState();
}

class _ChangePhoneScreenState extends State<ChangePhoneScreen> {
  final TextEditingController _phoneController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _continue() async {
    if (!StoreUtils.validatephone(context, _phoneController.text.trim())) {
      return;
    }

    setState(() => _isLoading = true);
    try {
      // Normalize: remove leading zero if user typed it
      String raw = _phoneController.text.trim();
      if (raw.startsWith('0') && raw.length > 1) {
        raw = raw.substring(1);
      }

      final fullPhone = '+964$raw';
      final result = await AuthService.sendOtp(fullPhone);

      if (!mounted) return;

      if (result['success'] == true) {
        StoreUtils.showSuccess(
          context,
          result['message'] ?? S.of(context).otpSent,
        );

        // Store the phone in provider so OTP screen can read it (same pattern as register flow)
        context.read<SmartMart>().setPhone(fullPhone);

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ChangePhoneOtpScreen()),
        );
      } else {
        StoreUtils.showError(
          context,
          result['message'] ?? S.of(context).failedToSendOtp,
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        title: Text(
          S.of(context).changePhoneNumber,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            children: [
              const SizedBox(height: 20),
              Text(
                S.of(context).enterYourNewPhoneNumber,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 24),

              // Phone input matching your existing style
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 16,
                      ),
                      child: const Text(
                        '+964',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Container(
                      width: 1,
                      height: 20,
                      color: Colors.grey.shade300,
                    ),
                    Expanded(
                      child: TextField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(11),
                        ],
                        onChanged: (value) {
                          if (value.startsWith('0') && value.length > 1) {
                            final newValue = value.substring(1);
                            _phoneController.value = TextEditingValue(
                              text: newValue,
                              selection: TextSelection.collapsed(
                                offset: newValue.length,
                              ),
                            );
                          }
                        },
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 16,
                          ),
                          hintText: '7701234567',
                          hintStyle: TextStyle(color: Colors.grey),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _continue,
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
                          S.of(context).continueButton,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
