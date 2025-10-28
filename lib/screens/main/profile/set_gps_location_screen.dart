import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:grocery_stores/models/address.dart';
import 'package:grocery_stores/screens/main/home_screen.dart';
import 'dart:async';
import 'edit_address_screen.dart';

class DeliveryAddressScreen extends StatefulWidget {
  final Address? address;
  const DeliveryAddressScreen({super.key, this.address});

  @override
  State<DeliveryAddressScreen> createState() => _DeliveryAddressScreenState();
}

class _DeliveryAddressScreenState extends State<DeliveryAddressScreen> {
  final TextEditingController _searchController = TextEditingController();
  GoogleMapController? _mapController;
  Timer? _addressUpdateTimer;
  bool _showDeliveryTooltip = false;
  Timer? _tooltipTimer;

  LatLng _currentLocation = const LatLng(
    36.1911,
    44.0093,
  ); // Default Erbil coordinates
  LatLng _selectedLocation = const LatLng(36.1911, 44.0093);
  String _selectedAddress = '';
  bool _isLoading = true;
  bool _mapLoading = true;
  bool _isUpdatingAddress = false;

  @override
  void initState() {
    super.initState();
    if (widget.address != null) {
      _selectedLocation = LatLng(
        widget.address!.latitude,
        widget.address!.longitude,
      );
      _currentLocation = _selectedLocation;
    }
    _getCurrentLocation();
    _addMapLoadingTimeout();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _mapController?.dispose();
    _addressUpdateTimer?.cancel();
    _tooltipTimer?.cancel();
    super.dispose();
  }

  void _addMapLoadingTimeout() {
    Timer(const Duration(seconds: 10), () {
      if (_mapLoading && mounted) {
        setState(() {
          _mapLoading = false;
          _showDeliveryTooltip = true;
        });
      }
    });
  }

  Future<void> _getCurrentLocation() async {
    try {
      final permission = await _requestLocationPermission();

      if (permission) {
        final position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );

        final currentLatLng = LatLng(position.latitude, position.longitude);

        setState(() {
          _currentLocation = currentLatLng;
          _selectedLocation = currentLatLng;
          _isLoading = false;
        });

        await _updateAddress(_selectedLocation);
        _animateToLocation(currentLatLng);
      } else {
        setState(() {
          _isLoading = false;
        });
        await _updateAddress(_selectedLocation);
      }
    } catch (e) {
      debugPrint('Error getting location: $e');
      setState(() {
        _isLoading = false;
      });
      await _updateAddress(_selectedLocation);
    }
  }

  Future<bool> _requestLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    return permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always;
  }

  Future<void> _updateAddress(LatLng location) async {
    if (_isUpdatingAddress) return;

    setState(() {
      _isUpdatingAddress = true;
    });

    try {
      final placemarks = await placemarkFromCoordinates(
        location.latitude,
        location.longitude,
      );

      if (placemarks.isNotEmpty && mounted) {
        final place = placemarks[0];
        final address = _formatAddress(place);

        setState(() {
          _selectedAddress = address;
        });
      }
    } catch (e) {
      debugPrint('Error getting address: $e');
      if (mounted) {
        setState(() {
          _selectedAddress = 'Awabaraw Asha Spi\nIndustrial Area';
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isUpdatingAddress = false;
        });
      }
    }
  }

  String _formatAddress(Placemark place) {
    final area = place.subLocality ?? place.locality ?? 'Awabaraw Asha Spi';
    final city = place.administrativeArea ?? 'Industrial Area';
    return '$area\n$city';
  }

  void _onCameraMove(CameraPosition position) {
    // Cancel previous timers
    _addressUpdateTimer?.cancel();
    _tooltipTimer?.cancel();

    // Hide tooltip while moving
    if (_showDeliveryTooltip) {
      setState(() {
        _showDeliveryTooltip = false;
      });
    }

    // Update selected location immediately for responsive UI
    _selectedLocation = position.target;

    // Debounce address updates to avoid excessive API calls
    _addressUpdateTimer = Timer(const Duration(milliseconds: 500), () {
      if (mounted) {
        _updateAddress(_selectedLocation);
      }
    });

    // Show tooltip after map stops moving
    _tooltipTimer = Timer(const Duration(milliseconds: 800), () {
      if (mounted) {
        setState(() {
          _showDeliveryTooltip = true;
        });
      }
    });
  }

  Future<void> _searchLocation(String query) async {
    if (query.trim().isEmpty) return;

    try {
      final locations = await locationFromAddress(query);

      if (locations.isNotEmpty) {
        final newLocation = LatLng(
          locations[0].latitude,
          locations[0].longitude,
        );

        _animateToLocation(newLocation);
      }
    } catch (e) {
      debugPrint('Search error: $e');
      if (mounted) {
        _showSearchError();
      }
    }
  }

  void _animateToLocation(LatLng location) {
    _mapController?.animateCamera(CameraUpdate.newLatLngZoom(location, 15.0));
  }

  void _showSearchError() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Location not found'),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _onMapCreated(GoogleMapController controller) async {
    _mapController = controller;

    setState(() {
      _mapLoading = false;
    });

    // Initial camera position
    await Future.delayed(const Duration(milliseconds: 500));
    try {
      await _mapController?.animateCamera(
        CameraUpdate.newLatLngZoom(_selectedLocation, 15.0),
      );
    } catch (e) {
      debugPrint('Error moving camera: $e');
    }
  }

  void _moveToCurrentLocation() {
    _animateToLocation(_currentLocation);
  }

  void _zoomIn() {
    _mapController?.animateCamera(CameraUpdate.zoomIn());
  }

  void _zoomOut() {
    _mapController?.animateCamera(CameraUpdate.zoomOut());
  }

  void _confirmLocation() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditAddressScreen(
          selectedLocation: _selectedLocation,
          initialAddress: _selectedAddress,
        ),
      ),
    );
  }

  void _showSearchDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Search Location'),
        content: TextField(
          controller: _searchController,
          decoration: const InputDecoration(
            hintText: 'Enter location...',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
          ),
          onSubmitted: (value) {
            Navigator.pop(context);
            _searchLocation(value);
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _searchLocation(_searchController.text);
            },
            child: const Text('Search'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            _buildMap(),
            _buildTopBar(),
            _buildDeliveryTooltip(),
            _buildMapControls(),
            _buildCenterPin(),
            _buildBottomCard(),
            if (_mapLoading) _buildLoadingOverlay(),
          ],
        ),
      ),
    );
  }

  Widget _buildMap() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: _mapLoading
          ? _buildMapLoadingState()
          : GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: _selectedLocation,
                zoom: 15.0,
              ),
              onCameraMove: _onCameraMove,
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              zoomControlsEnabled: false,
              mapToolbarEnabled: false,
              compassEnabled: true,
              rotateGesturesEnabled: true,
              scrollGesturesEnabled: true,
              zoomGesturesEnabled: true,
              tiltGesturesEnabled: true,
              mapType: MapType.normal,
            ),
    );
  }

  Widget _buildMapLoadingState() {
    return Container(
      color: Colors.grey.shade200,
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Loading map...'),
            SizedBox(height: 8),
            Text(
              'check your API key',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Positioned(
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
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Go back to Home Screen
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: const CircleBorder(),
                padding: const EdgeInsets.all(14),
                backgroundColor: Colors.grey.shade100,
                elevation: 0,
              ),
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const HomeScreen()),
                  (route) => false,
                );
              },
              child: Icon(Icons.home, color: Colors.teal),
            ),

            const Expanded(
              child: Text(
                'Delivery Address',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ),
            GestureDetector(
              onTap: _showSearchDialog,
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.search, size: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDeliveryTooltip() {
    if (_selectedAddress.isEmpty || _mapLoading || !_showDeliveryTooltip) {
      return const SizedBox.shrink();
    }

    return Positioned(
      top: MediaQuery.of(context).size.height * 0.35,
      left: 20,
      right: 20,
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.transparent.withValues(
              red: 0,
              green: 0,
              blue: 0,
              alpha: 0.6,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Text(
            'Your order will be delivered here',
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w300,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMapControls() {
    if (_mapLoading) return const SizedBox.shrink();

    return Positioned(
      top: MediaQuery.of(context).size.height * 0.3,
      right: 16,
      child: Column(
        children: [
          GestureDetector(
            onTap: _moveToCurrentLocation,
            child: Container(
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
              child: const Icon(
                Icons.my_location,
                size: 24,
                color: Colors.blue,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: _zoomIn,
                  child: const Icon(Icons.add, size: 20),
                ),
                GestureDetector(
                  onTap: _zoomOut,
                  child: const Icon(Icons.remove, size: 20),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCenterPin() {
    if (_mapLoading) return const SizedBox.shrink();

    return const Center(
      child: Icon(Icons.location_on, color: Colors.teal, size: 60),
    );
  }

  Widget _buildBottomCard() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.location_on_outlined,
                    color: Colors.grey,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    _getAddressDisplayText(),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                      height: 1.3,
                    ),
                  ),
                ),
                if (_isUpdatingAddress)
                  const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _canConfirmLocation() ? _confirmLocation : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  elevation: 0,
                ),
                child: _isLoading || _mapLoading
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
                    : const Text(
                        'Confirm pin location',
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
    );
  }

  Widget _buildLoadingOverlay() {
    return Positioned(
      top: 100,
      left: 20,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.blue.withOpacity(0.8),
          borderRadius: BorderRadius.circular(4),
        ),
        child: const Text(
          'Map is loading...',
          style: TextStyle(color: Colors.white, fontSize: 12),
        ),
      ),
    );
  }

  String _getAddressDisplayText() {
    if (_isLoading) return 'Loading...';
    if (_selectedAddress.isEmpty) return 'Move map to select location';
    return _selectedAddress;
  }

  bool _canConfirmLocation() {
    return !_isLoading && !_mapLoading && _selectedAddress.isNotEmpty;
  }
}
