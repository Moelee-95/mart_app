import 'package:flutter/material.dart';
import 'package:grocery_stores/screens/main/delivery/brand_details_screen.dart';
import 'package:grocery_stores/widgets/safe_network_image.dart';
import 'package:provider/provider.dart';
import 'package:grocery_stores/providers/smart_mart_provider.dart';

class BrandsGridWidget extends StatelessWidget {
  const BrandsGridWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SmartMart>(
      builder: (context, groceryProvider, child) {
        return SizedBox(
          height: 220,
          child: GridView.builder(
            scrollDirection: Axis.horizontal,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 2,
              mainAxisSpacing: 2,
            ),
            itemCount: groceryProvider.brands.length,
            itemBuilder: (context, index) {
              final brand = groceryProvider.brands[index];
              return Column(
                children: [
                  InkWell(
                    child: SafeNetworkImage(
                      imageUrl: brand.imageUrl,
                      width: 100,
                      height: 100,
                      fit: BoxFit.contain,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    onTap: () {
                      // Handle brand tap
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BrandDetailsScreen(brand: brand),
                        ),
                      );
                    },
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}