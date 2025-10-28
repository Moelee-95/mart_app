import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/smart_mart_provider.dart';
import 'package:grocery_stores/generated/l10n.dart';

class DeliverySelectionWidget extends StatelessWidget {
  const DeliverySelectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SmartMart>(
      builder: (context, groceryProvider, child) {
        return Column(
          children: [
            // Delivery Option
            ModernDeliveryCard(
              isSelected:
                  groceryProvider.selectedDeliveryMethod ==
                  DeliveryMethod.delivery,
              title: S.of(context).deliverToLocation,
              subtitle: S.of(context).deliveryAddress,
              price: S.of(context).deliveryPrice,
              imageUrl: 'https://i.ibb.co/ztxnYXp/delivary-guy.png',
              backgroundColor: const Color(0xFFF8F9FA),
              selectedColor: const Color(0xFF2ECC71),
              onTap: () =>
                  groceryProvider.setDeliveryMethod(DeliveryMethod.delivery),
            ),
            const SizedBox(height: 25),

            // Pickup Option
            ModernDeliveryCard(
              isSelected:
                  groceryProvider.selectedDeliveryMethod ==
                  DeliveryMethod.pickup,
              title: S.of(context).pickupAtStore,
              subtitle: S.of(context).storeAddress,
              price: S.of(context).free,
              imageUrl: 'https://i.ibb.co/8gX28B45/store.png',
              backgroundColor: const Color.fromARGB(255, 255, 255, 255),
              selectedColor: const Color(0xFF27AE60),
              onTap: () =>
                  groceryProvider.setDeliveryMethod(DeliveryMethod.pickup),
            ),
          ],
        );
      },
    );
  }
}

class ModernDeliveryCard extends StatelessWidget {
  final bool isSelected;
  final String title;
  final String subtitle;
  final String price;
  final String imageUrl;
  final Color backgroundColor;
  final Color selectedColor;
  final VoidCallback onTap;

  const ModernDeliveryCard({
    super.key,
    required this.isSelected,
    required this.title,
    required this.subtitle,
    required this.price,
    required this.imageUrl,
    required this.backgroundColor,
    required this.selectedColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Determine colors based on selection state
    final effectiveBackgroundColor = isSelected
        ? backgroundColor
        : const Color(0xFFF5F5F5); // Light gray for unselected

    final effectiveBorderColor = isSelected
        ? selectedColor
        : Colors.grey[400]!; // Gray border for unselected

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          color: effectiveBackgroundColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: effectiveBorderColor,
            width: isSelected ? 3 : 1,
          ),
          boxShadow: [
            if (isSelected)
              BoxShadow(
                color: selectedColor.withOpacity(0.25),
                spreadRadius: 0,
                blurRadius: 12,
                offset: const Offset(0, 6),
              )
            else
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                spreadRadius: 0,
                blurRadius: 4,
                offset: const Offset(0, 1),
              ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Row(
            children: [
              // Content Section
              Expanded(child: _buildContentSection()),
              const SizedBox(width: 16),
              // Image Section
              _buildImageSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContentSection() {
    return Consumer<SmartMart>(
      builder: (context, provider, child) {
        final titleColor = isSelected
            ? const Color(0xFF2C3E50)
            : Colors.grey[600]!;
        final subtitleColor = isSelected
            ? const Color(0xFF7F8C8D)
            : Colors.grey[500]!;

        return Stack(
          clipBehavior: Clip.none,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: titleColor,
                    letterSpacing: 0.3,
                  ),
                ),
                const SizedBox(height: 8),

                // Add address selector for delivery
                if (title.contains('Deliver') ||
                    title.contains('Location')) ...[
                  GestureDetector(
                    onTap: () => _showAddressSelector(context, provider),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[300]!),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Expanded(
                            child: Text(
                              provider.customer.defaultAddress?.address ??
                                  'Select address',
                              style: TextStyle(
                                fontSize: 13,
                                color: subtitleColor,
                                letterSpacing: 0.2,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Icon(
                            Icons.keyboard_arrow_down,
                            size: 16,
                            color: subtitleColor,
                          ),
                        ],
                      ),
                    ),
                  ),
                ] else ...[
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: subtitleColor,
                      letterSpacing: 0.2,
                    ),
                  ),
                ],
                const SizedBox(height: 10),
              ],
            ),
            Positioned(bottom: -51, left: 0, child: _buildPriceBadge()),
          ],
        );
      },
    );
  }

  void _showAddressSelector(BuildContext context, SmartMart provider) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Select Delivery Address'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: provider.customer.addresses.length,
              itemBuilder: (context, index) {
                final address = provider.customer.addresses[index];
                return ListTile(
                  title: Text('${address.type} - ${address.label}'),
                  subtitle: Text(address.address),
                  leading: Radio<int?>(
                    value: address.id,
                    groupValue: provider.customer.defaultAddress?.id,
                    onChanged: (value) {
                      if (value != null) {
                        provider.setDefaultAddress(value);
                        Navigator.pop(context);
                      }
                    },
                  ),
                  onTap: () {
                    if (address.id != null) {
                      provider.setDefaultAddress(address.id!);
                      Navigator.pop(context);
                    }
                  },
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildPriceBadge() {
    final isGreenBackground = backgroundColor == const Color(0xFF2ECC71);

    // Adjust badge colors based on selection state
    Color badgeBackgroundColor;
    Color textColor;

    if (isSelected) {
      badgeBackgroundColor = isGreenBackground
          ? Colors.white.withOpacity(0.2)
          : const Color(0xFFECF0F1);
      textColor = isGreenBackground ? Colors.white : const Color(0xFF2C3E50);
    } else {
      // Gray colors for unselected state
      badgeBackgroundColor = Colors.grey[300]!;
      textColor = Colors.grey[600]!;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: badgeBackgroundColor,
        borderRadius: BorderRadius.circular(25),
        border: isSelected && isGreenBackground
            ? Border.all(color: Colors.white.withOpacity(0.3), width: 1)
            : null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            price,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: textColor,
            ),
          ),
          const SizedBox(width: 8),
          Icon(
            isSelected ? Icons.check : Icons.access_time_rounded,
            size: 18,
            color: textColor.withOpacity(0.8),
          ),
        ],
      ),
    );
  }

  Widget _buildImageSection() {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(0)),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: ColorFiltered(
              // Apply grayscale filter when not selected
              colorFilter: isSelected
                  ? const ColorFilter.mode(
                      Colors.transparent,
                      BlendMode.multiply,
                    )
                  : const ColorFilter.matrix(<double>[
                      0.2126, 0.7152, 0.0722, 0, 0, // Red channel
                      0.2126, 0.7152, 0.0722, 0, 0, // Green channel
                      0.2126, 0.7152, 0.0722, 0, 0, // Blue channel
                      0, 0, 0, 1, 0, // Alpha channel
                    ]),
              child: Opacity(
                opacity: isSelected
                    ? 1.0
                    : 0.5, // Reduce opacity when not selected
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.grey[200] : Colors.grey[300],
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Icon(
                        backgroundColor == const Color(0xFF2ECC71)
                            ? Icons.store_rounded
                            : Icons.delivery_dining_rounded,
                        size: 40,
                        color: isSelected ? Colors.grey[400] : Colors.grey[500],
                      ),
                    );
                  },
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.grey[200] : Colors.grey[300],
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                              : null,
                          strokeWidth: 2,
                          color: isSelected ? selectedColor : Colors.grey[400],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Optional: Create a configuration class for better maintainability
class DeliveryOptionConfig {
  final String title;
  final String subtitle;
  final String price;
  final String imageUrl;
  final Color backgroundColor;
  final Color selectedColor;
  final DeliveryMethod method;

  const DeliveryOptionConfig({
    required this.title,
    required this.subtitle,
    required this.price,
    required this.imageUrl,
    required this.backgroundColor,
    required this.selectedColor,
    required this.method,
  });

  static const delivery = DeliveryOptionConfig(
    title: 'Deliver to Your Location',
    subtitle: ' Darwaza city, b122',
    price: '2,000 IQD',
    imageUrl: 'https://i.ibb.co/ztxnYXp/delivary-guy.png',
    backgroundColor: Color(0xFFF8F9FA),
    selectedColor: Color(0xFF2ECC71),
    method: DeliveryMethod.delivery,
  );

  static const pickup = DeliveryOptionConfig(
    title: 'Pickup at store',
    subtitle: 'Daraza city 1 Market',
    price: 'Free',
    imageUrl: 'https://i.ibb.co/8gX28B45/store.png',
    backgroundColor: Color(0xFF2ECC71),
    selectedColor: Color(0xFF27AE60),
    method: DeliveryMethod.pickup,
  );
}

// Alternative implementation using the configuration
class ConfigurableDeliverySelectionWidget extends StatelessWidget {
  const ConfigurableDeliverySelectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SmartMart>(
      builder: (context, groceryProvider, child) {
        return Column(
          children: [
            _buildDeliveryOption(
              context,
              groceryProvider,
              DeliveryMethod.delivery,
            ),
            const SizedBox(height: 16),
            _buildDeliveryOption(
              context,
              groceryProvider,
              DeliveryMethod.pickup,
            ),
          ],
        );
      },
    );
  }

  Widget _buildDeliveryOption(
    BuildContext context,
    SmartMart provider,
    DeliveryMethod method,
  ) {
    final isDelivery = method == DeliveryMethod.delivery;

    return ModernDeliveryCard(
      isSelected: provider.selectedDeliveryMethod == method,
      title: isDelivery
          ? S.of(context).deliverToLocation
          : S.of(context).pickupAtStore,
      subtitle: isDelivery
          ? S.of(context).deliveryAddress
          : S.of(context).storeAddress,
      price: isDelivery ? S.of(context).deliveryPrice : S.of(context).free,
      imageUrl: isDelivery
          ? 'https://i.ibb.co/ztxnYXp/delivary-guy.png'
          : 'https://i.ibb.co/8gX28B45/store.png',
      backgroundColor: isDelivery
          ? const Color(0xFFF8F9FA)
          : const Color(0xFF2ECC71),
      selectedColor: isDelivery
          ? const Color(0xFF2ECC71)
          : const Color(0xFF27AE60),
      onTap: () => provider.setDeliveryMethod(method),
    );
  }
}
