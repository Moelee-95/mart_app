// lib/screens/main/profile/edit_address_screen.dart
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:grocery_stores/models/address.dart';
import 'package:grocery_stores/screens/main/home_screen.dart';
import 'package:grocery_stores/generated/l10n.dart';
import 'package:provider/provider.dart';
import '../../../providers/smart_mart_provider.dart';

class EditAddressScreen extends StatefulWidget {
  final LatLng selectedLocation;
  final String initialAddress;
  final Address? address;

  const EditAddressScreen({
    super.key,
    required this.selectedLocation,
    required this.initialAddress,
    this.address,
  });

  @override
  State<EditAddressScreen> createState() => _EditAddressScreenState();
}

class _EditAddressScreenState extends State<EditAddressScreen> {
  final TextEditingController _areaController = TextEditingController();
  final TextEditingController _buildingController = TextEditingController();
  final TextEditingController _aptController = TextEditingController();
  final TextEditingController _floorController = TextEditingController();
  final TextEditingController _streetController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _directionsController = TextEditingController();
  final TextEditingController _labelController = TextEditingController();
  bool _fieldInitialized = false;

  String _selectedType = 'Apartment';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initializeFields();
  }

  void _initializeFields() async {
    // If we have an existing address (editing mode), populate fields
    if (widget.address != null) {
      final address = widget.address!;
      _areaController.text = address.area;
      _buildingController.text = address.buildingName;
      _aptController.text = address.apartmentNumber;
      _floorController.text = address.floor;
      _streetController.text = address.nearbyLandmark;
      _phoneController.text = address.phone;
      _directionsController.text = address.additionalDirections;
      _labelController.text = address.label;
      _selectedType = address.type;
    } else {
      // New address - initialize as empty
      _buildingController.text = '';
      _aptController.text = '';
      _floorController.text = '';
      _streetController.text = '';
      _phoneController.text = '';
      _labelController.text = '';
      _directionsController.text = '';
    }

    setState(() {
      _fieldInitialized = true;
    });

    // Handle area field
    if (widget.initialAddress.isNotEmpty && widget.address == null) {
      List<String> addressParts = widget.initialAddress.split('\n');
      setState(() {
        _areaController.text = addressParts.isNotEmpty ? addressParts[0] : '';
      });
    }

    if (_areaController.text.trim().isEmpty) {
      setState(() {
        _areaController.text = 'My Area';
      });
    }
  }

  // Helper method to get dynamic hints based on selected type
  Map<String, String> _getHintsForType() {
    switch (_selectedType.toLowerCase()) {
      case 'apartment':
        return {
          'building': 'Building Name',
          'apt': 'Apt. No.',
          'floor': 'Floor',
        };
      case 'house':
        return {
          'building': 'House Name/Number',
          'apt': 'House Number',
          'floor': 'Floor (Optional)',
        };
      case 'office':
        return {
          'building': 'Office Building',
          'apt': 'Office/Suite No.',
          'floor': 'Floor',
        };
      default:
        return {
          'building': 'Building Name',
          'apt': 'Apt. No.',
          'floor': 'Floor',
        };
    }
  }

  @override
  void dispose() {
    _areaController.dispose();
    _buildingController.dispose();
    _aptController.dispose();
    _floorController.dispose();
    _streetController.dispose();
    _phoneController.dispose();
    _directionsController.dispose();
    _labelController.dispose();
    super.dispose();
  }

  bool verifyFields() {
    if (_buildingController.text.trim().isEmpty ||
        _streetController.text.trim().isEmpty ||
        _phoneController.text.trim().isEmpty) {
      return false;
    }
    return true;
  }

  void _saveAddress() async {
    // Get the provider reference first
    final provider = Provider.of<SmartMart>(context, listen: false);

    // Enhanced validation before sending
    List<String> errors = [];

    if (_areaController.text.trim().isEmpty) {
      setState(() {
        _areaController.text = 'My Area';
      });
    }

    if (_phoneController.text.trim().isEmpty) {
      errors.add(S.of(context).phoneNumberRequired);
    }

    if (_buildingController.text.trim().isEmpty) {
      errors.add('Building name is required');
    }

    if (_streetController.text.trim().isEmpty) {
      errors.add('Street is required');
    }

    if (errors.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errors.join('\n')),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 4),
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Create the address object
      final newAddress = Address(
        id: DateTime.now().millisecondsSinceEpoch,
        customerId: provider.customer.id ?? 0,
        latitude: widget.selectedLocation.latitude,
        longitude: widget.selectedLocation.longitude,
        area: _areaController.text.trim(),
        type: _selectedType,
        buildingName: _buildingController.text.trim(),
        floor: _floorController.text.trim(),
        apartmentNumber: _aptController.text.trim(),
        nearbyLandmark: _streetController.text.trim(),
        phone: _formatPhoneNumber(_phoneController.text.trim()),
        additionalDirections: _directionsController.text.trim(),
        label: _labelController.text.trim().isEmpty
            ? _selectedType
            : _labelController.text.trim(),
      );

      // Add to provider (persistent storage)
      // Check if we're editing an existing address or creating a new one
      if (widget.address != null) {
        // Editing existing address - update it
        await provider.updateSavedAddress(widget.address!.id!, newAddress);
      } else {
        // Creating new address - add it
        await provider.addSavedAddress(newAddress);
      }

      if (mounted) {
        setState(() => _isLoading = false);

        // Show success dialog
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              title: Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.green, size: 28),
                  SizedBox(width: 12),
                  Text(S.of(context).success),
                ],
              ),
              content: Text(S.of(context).addressSavedSuccessfully),
              actions: [
                TextButton(
                  onPressed: () {
                    //remove  all screens and go to home
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => const HomeScreen(),
                      ),
                    );
                  },
                  child: Text(
                    S.of(context).ok,
                    style: TextStyle(
                      color: Colors.teal,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    }
  }
  

  String _buildFullAddress() {
    List<String> parts = [];

    if (_buildingController.text.trim().isNotEmpty) {
      parts.add(_buildingController.text.trim());
    }

    if (_aptController.text.trim().isNotEmpty) {
      parts.add('Apt ${_aptController.text.trim()}');
    }

    if (_floorController.text.trim().isNotEmpty) {
      parts.add('Floor ${_floorController.text.trim()}');
    }

    if (_streetController.text.trim().isNotEmpty) {
      parts.add(_streetController.text.trim());
    }

    if (_areaController.text.trim().isNotEmpty) {
      parts.add(_areaController.text.trim());
    }

    if (_directionsController.text.trim().isNotEmpty) {
      parts.add('(${_directionsController.text.trim()})');
    }

    return parts.join(', ');
  }

  String _formatPhoneNumber(String phone) {
    if (!phone.startsWith('+')) {
      return '+964$phone';
    }
    return phone;
  }

  // Helper function to map UI types to backend expected values
  String _mapTypeToBackend(String uiType) {
    switch (uiType.toLowerCase()) {
      case 'apartment':
        return 'home';
      case 'house':
        return 'home';
      case 'office':
        return 'office';
      default:
        return 'other';
    }
  }

  @override
  Widget build(BuildContext context) {
    final hints = _getHintsForType(); // Get dynamic hints

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            // Map header
            Container(
              height: 200,
              child: Stack(
                children: [
                  GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: widget.selectedLocation,
                      zoom: 15.0,
                    ),
                    markers: {
                      Marker(
                        markerId: const MarkerId('selected_location'),
                        position: widget.selectedLocation,
                        icon: BitmapDescriptor.defaultMarkerWithHue(
                          BitmapDescriptor.hueRed,
                        ),
                      ),
                    },
                    zoomGesturesEnabled: false,
                    scrollGesturesEnabled: false,
                    rotateGesturesEnabled: false,
                    tiltGesturesEnabled: false,
                    zoomControlsEnabled: false,
                    myLocationButtonEnabled: false,
                    mapToolbarEnabled: false,
                  ),
                  // Header overlay
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      padding: EdgeInsets.only(
                        top: MediaQuery.of(context).padding.top + 10,
                        left: 16,
                        right: 16,
                        bottom: 10,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.white.withOpacity(0.9),
                            Colors.transparent,
                          ],
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: IconButton(
                              icon: const Icon(Icons.arrow_back, size: 20),
                              onPressed: () => Navigator.pop(context),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              S.of(context).editAddress,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                          const SizedBox(width: 40), // Balance the back button
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Form content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Area field
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade400,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.location_on,
                              size: 14,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                S.of(context).area,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                              ValueListenableBuilder<TextEditingValue>(
                                valueListenable: _areaController,
                                builder: (context, value, child) {
                                  return Text(
                                    _fieldInitialized && value.text.isNotEmpty
                                        ? value.text
                                        : (_fieldInitialized
                                              ? S.of(context).unknownArea
                                              : S.of(context).loading),
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Address type selection
                    Row(
                      children: [
                        _buildTypeChip(
                          S.of(context).apartment,
                          Icons.apartment,
                        ),
                        const SizedBox(width: 12),
                        _buildTypeChip(S.of(context).house, Icons.home),
                        const SizedBox(width: 12),
                        _buildTypeChip(S.of(context).office, Icons.business),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Building name with dynamic hint
                    _buildTextField(hints['building']!, _buildingController),
                    const SizedBox(height: 16),

                    // Apartment and Floor row with dynamic hints
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextField(hints['apt']!, _aptController),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildTextField(
                            hints['floor']!,
                            _floorController,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Street
                    _buildTextField(S.of(context).street, _streetController),
                    const SizedBox(height: 16),

                    // Phone number
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              border: Border(
                                right: BorderSide(color: Colors.grey.shade300),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 20,
                                  height: 14,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                  child: const Text(
                                    '🇮🇶',
                                    style: TextStyle(fontSize: 12),
                                  ),
                                ),
                                const SizedBox(width: 4),
                                const Icon(Icons.keyboard_arrow_down, size: 16),
                              ],
                            ),
                          ),
                          Expanded(
                            child: TextField(
                              controller: _phoneController,
                              keyboardType: TextInputType.phone,
                              decoration: InputDecoration(
                                hintText: S.of(context).phoneNumber,
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 16,
                                ),
                              ),
                            ),
                          ),
                          if (_phoneController.text.isNotEmpty)
                            const Padding(
                              padding: EdgeInsets.only(right: 12),
                              child: Icon(
                                Icons.check_circle,
                                color: Colors.green,
                                size: 20,
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Additional directions
                    _buildTextField(
                      S.of(context).additionalDirectionsOptional,
                      _directionsController,
                      maxLines: 3,
                    ),
                    const SizedBox(height: 16),

                    // Address label
                    _buildTextField(
                      S.of(context).addressLabelOptional,
                      _labelController,
                    ),
                    const SizedBox(height: 8),

                    Text(
                      S.of(context).addressLabelDescription,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                        height: 1.4,
                      ),
                    ),

                    const SizedBox(height: 30),

                    // Save button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _saveAddress,
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
                                S.of(context).saveAddress,
                                style: TextStyle(
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
          ],
        ),
      ),
    );
  }

  Widget _buildTypeChip(String label, IconData icon) {
    bool isSelected = _selectedType == label;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedType = label;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.black87 : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16,
              color: isSelected ? Colors.white : Colors.grey.shade600,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: isSelected ? Colors.white : Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
    String hint,
    TextEditingController controller, {
    int maxLines = 1,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey.shade500),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
          suffixIcon: controller.text.isNotEmpty
              ? const Icon(Icons.check_circle, color: Colors.green, size: 20)
              : null,
        ),
        onChanged: (value) {
          setState(() {}); // Rebuild to show/hide check icon
        },
      ),
    );
  }
}
