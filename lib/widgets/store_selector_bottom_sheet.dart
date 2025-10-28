import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/smart_mart_provider.dart';
import '../generated/l10n.dart';
import 'custom_bottom_sheet.dart';

class StoreSelectorBottomSheet extends StatelessWidget {
  const StoreSelectorBottomSheet({super.key});

  static Future<void> show(BuildContext context) {
    return CustomBottomSheet.show(
      context: context,
      title: S.of(context).selectStore,
      height: MediaQuery.of(context).size.height * 0.7,
      content: const StoreSelectorBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SmartMart>(
      builder: (context, provider, child) {
        final stores = provider.availableStores;
        final selectedStore = provider.selectedStore;
        final isKurdish = provider.isKurdish;

        if (stores.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.store_outlined, size: 64, color: Colors.grey[400]),
                const SizedBox(height: 16),
                Text(
                  S.of(context).noStoresAvailable,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.separated(
          itemCount: stores.length,
          separatorBuilder: (context, index) => Divider(
            color: Colors.grey[200],
            height: 1,
          ),
          itemBuilder: (context, index) {
            final store = stores[index];
            final isSelected = selectedStore?.id == store.id;

            return ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              leading: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(12),
                  border: isSelected 
                    ? Border.all(color: Colors.green, width: 2)
                    : Border.all(color: Colors.grey[200]!, width: 1),
                ),
                child: store.imageUrl != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        store.imageUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                          Icon(Icons.store, color: Colors.green[600]),
                      ),
                    )
                  : Icon(Icons.store, color: Colors.green[600]),
              ),
              title: Text(
                store.getDisplayName(isKurdish),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  color: isSelected ? Colors.green[700] : Colors.black,
                ),
              ),
              subtitle: Text(
                store.getDisplayAddress(isKurdish),
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              trailing: isSelected
                ? Icon(Icons.check_circle, color: Colors.green[600])
                : Icon(Icons.radio_button_unchecked, color: Colors.grey[400]),
              onTap: () async {
                if (!isSelected) {
                  await provider.selectStore(store);
                  if (context.mounted) {
                    Navigator.pop(context);
                  }
                }
              },
            );
          },
        );
      },
    );
  }
}