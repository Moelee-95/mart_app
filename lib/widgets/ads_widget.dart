// widgets/Ads_widget.dart

import 'package:flutter/material.dart';
import 'package:grocery_stores/models/ad.dart';
import 'package:grocery_stores/screens/main/delivery/ad_details_screen.dart';
import 'package:provider/provider.dart';
import '../providers/smart_mart_provider.dart';

class AdsWidget extends StatelessWidget {
  final List<Ad> Ads;

  const AdsWidget({super.key, required this.Ads});

  static const double _titleFontSize = 24;
  static const double _itemSpacing = 16;
  static const double _cardHeight = 160;

  @override
  Widget build(BuildContext context) {
    if (Ads.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: _cardHeight, child: _buildAdsHorizontalList()),
      ],
    );
  }

  Widget _buildAdsHorizontalList() {
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      itemCount: Ads.length,
      separatorBuilder: (context, index) => const SizedBox(width: 10),
      itemBuilder: (context, index) {
        return AdCard(ad: Ads[index]);
      },
    );
  }
}

class AdCard extends StatelessWidget {
  const AdCard({super.key, required this.ad});

  final Ad ad;

  static const double _cardWidth = 200;
  static const double _borderRadius = 10;
  static const EdgeInsets _cardPadding = EdgeInsets.all(2);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AdDetailsScreen(ad: ad)),
        );
      },
      borderRadius: BorderRadius.circular(_borderRadius),
      child: Container(
        width: _cardWidth,
        decoration: BoxDecoration(
          color: Colors.teal[100],
          borderRadius: BorderRadius.circular(_borderRadius),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.09),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: _cardPadding,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(_borderRadius - 5),
            child: _buildAdImage(),
          ),
        ),
      ),
    );
  }

  Widget _buildAdTitle(BuildContext context) {
    return Consumer<SmartMart>(
      builder: (context, groceryProvider, child) {
        final isKurdish = groceryProvider.currentLocale.languageCode == 'ku';
        final title = isKurdish ? (ad.titleKu ?? ad.title) : ad.title;

        return Container(
          padding: const EdgeInsets.all(2.0),
          decoration: BoxDecoration(
            // Semi-transparent background for better text readability
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                const Color.fromARGB(255, 97, 76, 0).withOpacity(0.2),
                const Color.fromARGB(255, 172, 134, 0).withOpacity(0.1),
                Colors.transparent,
              ],
            ),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(11),
              topRight: Radius.circular(11),
            ),
          ),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.white, // White text for better contrast
              shadows: [
                Shadow(
                  offset: Offset(1, 1),
                  blurRadius: 2,
                  color: Colors.black54,
                ),
              ],
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        );
      },
    );
  }

  Widget _buildAdImage() {
    return Image.network(
      ad.imageUrl,
      fit: BoxFit.cover, // Cover the entire space
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return const Center(child: CircularProgressIndicator(strokeWidth: 2));
      },
      errorBuilder: (context, error, stackTrace) {
        return Container(
          color: Colors.grey[300],
          child: const Center(
            child: Icon(
              Icons.image_not_supported,
              size: 40,
              color: Colors.grey,
            ),
          ),
        );
      },
    );
  }

  // void _navigateToAds(BuildContext context, Ad ad) {
  //   Navigator.of(context).push(
  //     MaterialPageRoute(
  //       builder: (context) => AdDetailsScreen(ad: ad),
  //     ),
  //   );
  // }
}
