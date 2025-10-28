// widgets/deals_widget.dart

import 'package:flutter/material.dart';
import '../models/deal.dart';
import '../screens/main/delivery/deal_details_screen.dart';
import 'package:provider/provider.dart';
import '../providers/smart_mart_provider.dart';

class DealsWidget extends StatelessWidget {
  final List<Deal> deals;
  
  const DealsWidget({
    super.key,
    required this.deals,
  });


  static const double _cardHeight = 160;

  @override
  Widget build(BuildContext context) {
    if (deals.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: _cardHeight,
          child: _buildDealsHorizontalList(),
        ),
      ],
    );
  }

  Widget _buildDealsHorizontalList() {
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      itemCount: deals.length,
      separatorBuilder: (context, index) => const SizedBox(width: 10),
      itemBuilder: (context, index) {
        return DealCard(deal: deals[index]);
      },
    );
  }
}

class DealCard extends StatelessWidget {
  const DealCard({super.key, required this.deal});

  final Deal deal;

  static const double _cardWidth = 125;
  static const double _borderRadius = 16;
  static const EdgeInsets _cardPadding = EdgeInsets.all(5);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _navigateToDeals(context, deal),
      borderRadius: BorderRadius.circular(_borderRadius),
      child: Container(
        width: _cardWidth,
        decoration: BoxDecoration(
          color: const Color(0xFFF5F5DC),
          borderRadius: BorderRadius.circular(_borderRadius),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.01),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: _cardPadding,
          child: Stack(
            children: [
              // Background image positioned with custom size and position
              Positioned(
                top: 30, // Start below the title area
                left: 2,
                right: 2,
                bottom: 0,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(_borderRadius - 5),
                  child: _buildDealImage(),
                ),
              ),
              // Title overlay with semi-transparent background
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: _buildDealTitle(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

Widget _buildDealTitle(BuildContext context) {
  return Consumer<SmartMart>(
    builder: (context, groceryProvider, child) {
      final isKurdish = groceryProvider.currentLocale.languageCode == 'ku';
      final title = isKurdish ? (deal.titleKu ?? deal.title) : deal.title;
      
      return Container(
        padding: const EdgeInsets.all(2.0),
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 0, 0, 0), // White text for better contrast
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      );
    },
  );
}

  Widget _buildDealImage() {
    return Image.network(
      deal.imageUrl,
      fit: BoxFit.cover, // Cover the entire space
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return const Center(
          child: CircularProgressIndicator(strokeWidth: 2),
        );
      },
      errorBuilder: (context, error, stackTrace) {
        return Container(
          color: Colors.grey[300],
          child: const Center(
            child: Icon(Icons.image_not_supported, size: 40, color: Colors.grey),
          ),
        );
      },
    );
  }

  void _navigateToDeals(BuildContext context, Deal deal) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => DealDetailsScreen(deal: deal),
      ),
    );
  }
}