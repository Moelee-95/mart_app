import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:grocery_stores/providers/smart_mart_provider.dart';
import 'package:grocery_stores/services/auth_service.dart';
import 'package:grocery_stores/services/store_utils.dart';
import 'package:grocery_stores/generated/l10n.dart';

class ChangePhoneOtpScreen extends StatefulWidget {
  const ChangePhoneOtpScreen({super.key});

  @override
  State<ChangePhoneOtpScreen> createState() => _ChangePhoneOtpScreenState();
}

class _ChangePhoneOtpScreenState extends State<ChangePhoneOtpScreen> {
  final List<TextEditingController> _controllers = List.generate(
    4,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(4, (_) => FocusNode());

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNodes.first.requestFocus();
    });
  }

  @override
  void dispose() {
    for (final c in _controllers) c.dispose();
    for (final f in _focusNodes) f.dispose();
    super.dispose();
  }

  void _onChanged(String value, int index) {
    if (value.isNotEmpty && index < 3) _focusNodes[index + 1].requestFocus();
    if (value.isEmpty && index > 0) _focusNodes[index - 1].requestFocus();
  }

  Future<void> _verify() async {
    final otp = _controllers.map((c) => c.text).join();
    if (otp.length < 4) {
      StoreUtils.showError(context, S.of(context).pleaseEnterCompleteCode);
      return;
    }

    final phone = context.read<SmartMart>().phone;
    if (phone.isEmpty) {
      StoreUtils.showError(context, S.of(context).missingPhoneGoBackRetry);
      return;
    }

    setState(() => _isLoading = true);
    try {
      // 1) Verify OTP using existing endpoint
      final verify = await AuthService.verifyOtp(phone, otp);

      if (verify['success'] != true) {
        StoreUtils.showError(
          context,
          verify['message'] ?? S.of(context).invalidVerificationCode,
        );

        return;
      }

      // 2) Update phone on server (requires auth). Adjust endpoint in AuthService.updatePhone.
      final verificationToken = verify['verification_token'] ?? '';
      final update = await AuthService.updatePhone(phone, verificationToken);

      if (update['success'] == true) {
        // Update local provider with the new, verified phone
        context.read<SmartMart>().setPhone(phone);
        StoreUtils.showSuccess(
          context,
          update['message'] ?? S.of(context).phoneNumberUpdated,
        );

        // Navigate back to Profile (pop twice: OTP -> ChangePhone -> Profile)
        if (mounted) {
          Navigator.of(context).pop(); // pop OTP
          Navigator.of(context).pop(); // pop ChangePhone
        }
      } else {
        StoreUtils.showError(
          context,
          update['message'] ?? S.of(context).failedToUpdatePhone,
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final phone = context.watch<SmartMart>().phone;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          S.of(context).verifyNewPhone,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),

        centerTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Text(
              S.of(context).enterCodeSent,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
                height: 1.3,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              '${S.of(context).sentVerificationCodeTo}$phone',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 40),
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
                          valueColor: AlwaysStoppedAnimation(Colors.white),
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
          ],
        ),
      ),
    );
  }
}
