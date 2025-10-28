// lib/models/address.dart
class Address {
  int? id;
  int customerId;
  double latitude;
  double longitude;
  String area;
  String type;
  String buildingName;
  String floor;
  String apartmentNumber;
  String nearbyLandmark;
  String phone;
  String additionalDirections;
  String label;
  bool isDefault;
  bool isActive;

  Address({
    this.id,
    required this.customerId,
    this.latitude = 0.0,
    this.longitude = 0.0,
    this.area = '',
    this.type = '',
    this.buildingName = '',
    this.floor = '',
    this.apartmentNumber = '',
    this.nearbyLandmark = '',
    this.phone = '',
    this.additionalDirections = '',
    this.label = '',
    this.isDefault = false,
    this.isActive = true,
  });

  // Add these helper properties for compatibility
  String get title => label.isEmpty ? type : label;
  String get address => _buildDisplayAddress();
  String get mobileNumber => phone;

  String _buildDisplayAddress() {
    List<String> parts = [];
    if (buildingName.isNotEmpty) parts.add(buildingName);
    if (apartmentNumber.isNotEmpty) parts.add('Apt $apartmentNumber');
    if (floor.isNotEmpty) parts.add('Floor $floor');
    if (area.isNotEmpty) parts.add(area);
    if (nearbyLandmark.isNotEmpty) parts.add(nearbyLandmark);
    if (additionalDirections.isNotEmpty) parts.add('($additionalDirections)');

    return parts.join(', ');
  }

  // Convert to JSON for API calls
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'customer_id': customerId,
      'latitude': latitude,
      'longitude': longitude,
      'area': area,
      'type': type,
      'building_name': buildingName,
      'floor': floor,
      'apartment_number': apartmentNumber,
      'nearby_landmark': nearbyLandmark,
      'phone': phone,
      'additional_directions': additionalDirections,
      'label': label,
      'is_default': isDefault,
      'is_active': isActive,
    };
  }

  // Create from JSON response
  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      id: json['id'],
      customerId: json['customer_id'],
      latitude: json['latitude']?.toDouble() ?? 0.0,
      longitude: json['longitude']?.toDouble() ?? 0.0,
      area: json['area'] ?? '',
      type: json['type'] ?? '',
      buildingName: json['building_name'] ?? '',
      floor: json['floor'] ?? '',
      apartmentNumber: json['apartment_number'] ?? '',
      nearbyLandmark: json['nearby_landmark'] ?? '',
      phone: json['phone'] ?? '',
      additionalDirections: json['additional_directions'] ?? '',
      label: json['label'] ?? '',
      isDefault: json['is_default'] ?? false,
      isActive: json['is_active'] ?? true,
    );
  }

  @override
  String toString() {
    return 'Address(id: $id, label: $label, area: $area, isDefault: $isDefault)';
  }

  // Add this method to your Address class
Address copyWith({
  int? id,
  int? customerId,
  double? latitude,
  double? longitude,
  String? area,
  String? type,
  String? buildingName,
  String? floor,
  String? apartmentNumber,
  String? nearbyLandmark,
  String? phone,
  String? additionalDirections,
  String? label,
  bool? isDefault,
  bool? isActive,
}) {
  return Address(
    id: id ?? this.id,
    customerId: customerId ?? this.customerId,
    latitude: latitude ?? this.latitude,
    longitude: longitude ?? this.longitude,
    area: area ?? this.area,
    type: type ?? this.type,
    buildingName: buildingName ?? this.buildingName,
    floor: floor ?? this.floor,
    apartmentNumber: apartmentNumber ?? this.apartmentNumber,
    nearbyLandmark: nearbyLandmark ?? this.nearbyLandmark,
    phone: phone ?? this.phone,
    additionalDirections: additionalDirections ?? this.additionalDirections,
    label: label ?? this.label,
    isDefault: isDefault ?? this.isDefault,
    isActive: isActive ?? this.isActive,
  );
}
}
