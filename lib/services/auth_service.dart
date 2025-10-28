// lib/services/auth_service.dart
import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:grocery_stores/services/token_storage.dart';

class AuthService {
  static const String baseUrl = 'http://159.198.65.165/api';

  static const _headers = {'Content-Type': 'application/json'};

  static Future<Map<String, dynamic>> _post(
    String endpoint,
    Map<String, dynamic> body, {
    bool authRequired = false,
  }) async {
    try {
      final uri = Uri.parse('$baseUrl$endpoint');
      final headers = Map<String, String>.from(_headers);

      if (authRequired) {
        final token = await TokenStorage.getAuthorizationHeader();
        if (token == null) {
          return {'success': false, 'message': 'Authentication required'};
        }
        headers['Authorization'] = token;
      }

      final response = await http.post(
        uri,
        headers: headers,
        body: jsonEncode(body),
      );

      return jsonDecode(response.body);
    } catch (e) {
      return {'success': false, 'message': 'Network error: $e'};
    }
  }


  static Future<Map<String, dynamic>> sendOtp(String phone) {
    final fullPhone = phone.startsWith('+') ? phone : '+964$phone';
    return _post('/verify/send-otp', {'phone': fullPhone});
  }

  static Future<Map<String, dynamic>> verifyOtp(String phone, String otp) {
    return _post('/verify/verify-otp', {
      'phone': phone,
      'otp_code': otp,
    });
  }

  static Future<Map<String, dynamic>> checkCustomerExists(String phone) {
    return _post('/customers/check-exists', {'phone': phone});
  }

  static Future<Map<String, dynamic>> login(String phone, String pin) {
    return _post('/customers/login', {
      'phone': phone,
      'pin': pin,
    });
  }

  static Future<Map<String, dynamic>> registerAccount(
    String phone,
    String verificationToken,
    String pin,
    String fullName,
  ) async {
    final result = await _post('/customers/register', {
      'full_name': fullName,
      'phone': phone,
      'pin': pin,
      'verification_token': verificationToken,
    });

    if (result['success'] == true && result['access_token'] != null) {
      const storage = FlutterSecureStorage();
      await storage.write(key: 'auth_token', value: result['access_token']);
      await storage.write(
        key: 'id',
        value: result['customer']['id'].toString(),
      );
    }

    return result;
  }

  static Future<Map<String, dynamic>> changePin(String newPin) {
    return _post('/customers/change_pin', {'newPin': newPin}, authRequired: true);
  }

  static Future<Map<String, dynamic>> updatePhone(
    String newPhone,
    String verificationToken,
  ) async {
    final phone = newPhone.startsWith('+') ? newPhone : '+964$newPhone';
    return _post('/customers/update-phone', {
      'phone': phone,
      'verification_token': verificationToken,
    }, authRequired: true);
  }

  static Future<Map<String, dynamic>> addAddress(
    double latitude,
    double longitude,
    String area,
    String type,
    String buildingName,
    String floor,
    String apartmentNumber,
    String nearbyLandmark,
    String phone,
    String additionalDirections,
    String label,
    bool isDefault,
  ) async {
    final token = await TokenStorage.getAuthorizationHeader();
    final id = await const FlutterSecureStorage().read(key: 'id');

    if (token == null || id == null) {
      return {'success': false, 'message': 'Authentication required'};
    }

    final validTypes = ['home', 'work', 'office', 'other'];
    final normalizedType = type.toLowerCase().trim();

    if (!validTypes.contains(normalizedType)) {
      return {
        'success': false,
        'message': 'Invalid address type. Must be one of: ${validTypes.join(', ')}',
      };
    }

    if (area.trim().isEmpty || phone.trim().isEmpty) {
      return {'success': false, 'message': 'Area and phone are required'};
    }

    final requestBody = <String, dynamic>{
      'latitude': latitude,
      'longitude': longitude,
      'area': area.trim(),
      'type': normalizedType,
      'phone': phone.trim(),
      'is_default': isDefault,
    };

    if (buildingName.trim().isNotEmpty) requestBody['building_name'] = buildingName.trim();
    if (floor.trim().isNotEmpty) requestBody['floor'] = floor.trim();
    if (apartmentNumber.trim().isNotEmpty) requestBody['apartment_number'] = apartmentNumber.trim();
    if (nearbyLandmark.trim().isNotEmpty) requestBody['nearby_landmark'] = nearbyLandmark.trim();
    if (additionalDirections.trim().isNotEmpty) requestBody['additional_directions'] = additionalDirections.trim();
    if (label.trim().isNotEmpty) requestBody['label'] = label.trim();

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/customers/$id/addresses'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': token,
          'Accept': 'application/json',
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        final error = jsonDecode(response.body);
        return {
          'success': false,
          'message': error['message'] ?? 'Server error ${response.statusCode}',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error: $e'};
    }
  }
}
