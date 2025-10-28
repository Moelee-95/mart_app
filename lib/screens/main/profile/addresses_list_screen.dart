// lib/screens/main/profile/addresses_list_screen.dart
import 'package:flutter/material.dart';
import 'package:grocery_stores/models/address.dart';
import 'package:grocery_stores/screens/main/profile/set_gps_location_screen.dart';
import 'package:grocery_stores/generated/l10n.dart';
import 'package:provider/provider.dart';
import '../../../providers/smart_mart_provider.dart';

class AddressesScreen extends StatefulWidget {
  const AddressesScreen({super.key});

  @override
  State<AddressesScreen> createState() => _AddressesScreenState();
}

class _AddressesScreenState extends State<AddressesScreen> {
  
  bool isLoading = false;
  bool isAddingAddress = false;

  @override
  void initState() {
    super.initState();
    // No need to load addresses since they're already in the provider
  }

  void _addNewAddress() {
    setState(() {
      isAddingAddress = true;
    });

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const DeliveryAddressScreen(),
        settings: const RouteSettings(name: '/add-address'),
      ),
    ).then((_) {
      setState(() {
        isAddingAddress = false;
      });
    });
  }

void _deleteAddress(int? addressId) {
  if (addressId != null) {
    final provider = Provider.of<SmartMart>(context, listen: false);
    provider.deleteSavedAddress(addressId); // Convert to string
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(S.of(context).addressDeletedSuccessfully),
        backgroundColor: Colors.green,
      ),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    return Consumer<SmartMart>(
      builder: (context, provider, child) {
        final addresses = provider.savedAddresses;

        return Scaffold(
          backgroundColor: Colors.grey[50],
          appBar: AppBar(
            title: Text(
              S.of(context).addresses,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => Navigator.of(context).pop(),
            ),
            actions: [
              TextButton(
                onPressed: isAddingAddress ? null : _addNewAddress,
                child: Text(
                  isAddingAddress ? S.of(context).adding : S.of(context).add,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: isAddingAddress ? Colors.grey : Colors.orange,
                  ),
                ),
              ),
            ],
          ),
          body: Column(
            children: [
              Expanded(
                child: Container(
                  color: Colors.white,
                  child: addresses.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.location_off,
                                size: 64,
                                color: Colors.grey,
                              ),
                              SizedBox(height: 16),
                              Text(
                                S.of(context).noAddressesFound,
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                S.of(context).addYourFirstAddress,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: EdgeInsets.zero,
                          itemCount: addresses.length,
                          itemBuilder: (context, index) {
                            final address = addresses[index];
                            return _buildAddressItem(address, provider);
                          },
                        ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAddressItem(Address address, SmartMart provider) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey[200]!, width: 0.5),
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 12,
        ),
        // leading: address.isDefault
        //     ? Icon(Icons.check_circle, color: Colors.green, size: 20)
        //     : Icon(Icons.radio_button_unchecked, color: Colors.grey, size: 20),
        title: Row(
          children: [
            Text(
              address.type,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              address.label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Colors.black,
              ),
            ),
            if (address.isDefault) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'Default',
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.green[700],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
            if (!address.isDefault)
              IconButton(
                icon: Icon(
                  Icons.check_circle_outlined,
                  color: Colors.grey[600],
                  size: 20,
                ),
                onPressed: () {
                  provider.setDefaultAddress(address.id!);
                },

                tooltip: 'Set as default',
              ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              address.address,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                height: 1.3,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${S.of(context).mobileNumber}: ${address.phone}',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            
            IconButton(
              icon: Icon(Icons.edit, color: Colors.grey[600], size: 20),
              onPressed: () => _showEditAddressDialog(address),
            ),
            IconButton(
              icon: Icon(Icons.delete, color: Colors.red[400], size: 20),
              onPressed: () => _showDeleteConfirmDialog(address),
            ),
          ],
        ),
        onTap: () {
          // Implement default address setting for savedAddresses
        },
      ),
    );
  }

  // Keep your existing dialog methods unchanged
void _showEditAddressDialog(Address address) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => DeliveryAddressScreen(address: address), // Pass the address
      settings: const RouteSettings(name: '/edit-address'),
    ),
  );
}

  void _showDeleteConfirmDialog(Address address) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(S.of(context).deleteAddress),
          content: Text(
            '${S.of(context).deleteAddressConfirmation} ${address.type} ${address.title}?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(S.of(context).cancel),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _deleteAddress(address.id);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: Text(S.of(context).delete),
            ),
          ],
        );
      },
    );
  }
}
