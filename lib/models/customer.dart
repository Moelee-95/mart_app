// lib/models/customer.dart
import 'package:grocery_stores/models/address.dart';

class Customer {
  int? id;
  String phone;
  String verificationToken;
  String pin;
  String fullName;
  bool isLoggedIn;
  List<Address> addresses = [];

  Customer({
    this.id,
    this.phone = '',
    this.verificationToken = '',
    this.pin = '',
    this.fullName = '',
    this.isLoggedIn = false,
  });

  void addAddress(Address address) {
    addresses.add(address);
  }

  void removeAddress(int addressId) {
    this.addresses.removeWhere((addr) => addr.id == addressId);
  }

  void setDefaultAddress(int addressId) {
    for (var addr in this.addresses) {
      addr.isDefault = (addr.id == addressId);
    }
  }

  // Direct setters for building data incrementally
  void setId(int id) => this.id = id;
  void setPhone(String phone) => this.phone = phone;
  void setVerificationToken(String token) => this.verificationToken = token;
  void setPin(String pin) => this.pin = pin;
  void setFullName(String name) => this.fullName = name;

  // Clear all data
  void clear() {
    id = null;
    phone = '';
    verificationToken = '';
    pin = '';
    fullName = '';
    addresses.clear();
  }

  // Convert to JSON for API calls
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'phone': phone,
      'pin': pin,
      'verification_token': verificationToken,
      'full_name': fullName,
    };
  }

  // Create from JSON response
  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      id: json['id'],
      phone: json['phone'] ?? '',
      verificationToken: json['verification_token'] ?? '',
      pin: json['pin'] ?? '',
      fullName: json['full_name'] ?? '',
    );
  }

  // Check if customer data is complete for Registration Only
  bool get isComplete {
    return phone.isNotEmpty &&
        verificationToken.isNotEmpty &&
        pin.isNotEmpty &&
        fullName.isNotEmpty;
  }

  Address? get defaultAddress {
    try {
      return addresses.firstWhere((addr) => addr.isDefault);
    } catch (e) {
      return addresses.isNotEmpty ? addresses.first : null;
    }
  }

  // Get formatted phone number
  String get formattedPhone {
    if (phone.startsWith('+964')) {
      return phone.substring(4); // Remove +964
    }
    return phone;
  }

  @override
  String toString() {
    return 'Customer(phone: $phone, fullName: $fullName, hasPin: ${pin.isNotEmpty}, hasToken: ${verificationToken.isNotEmpty})';
  }
}
