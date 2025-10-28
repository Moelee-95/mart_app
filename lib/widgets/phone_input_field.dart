import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PhoneInputField extends StatelessWidget {
  final TextEditingController controller;
  final String prefixText;
  final Function(String)? onChanged;

  const PhoneInputField({
    super.key,
    required this.controller,
    this.prefixText = '+964',
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            child: Text(
              prefixText,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ),
          Container(width: 1, height: 20, color: Colors.grey.shade300),
          Expanded(
            child: TextField(
              controller: controller,
              keyboardType: TextInputType.phone,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(11),
              ],
              onChanged: (value) {
                if (value.startsWith('0') && value.length > 1) {
                  String newValue = value.substring(1);
                  controller.value = TextEditingValue(
                    text: newValue,
                    selection: TextSelection.fromPosition(
                      TextPosition(offset: newValue.length),
                    ),
                  );
                }
                if (onChanged != null) {
                  onChanged!(value);
                }
              },
              decoration: const InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                hintText: '7701234567',
                hintStyle: TextStyle(color: Colors.grey),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
