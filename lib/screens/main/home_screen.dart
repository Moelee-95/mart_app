// main/home_screen.dart

import 'package:flutter/material.dart';
import 'package:grocery_stores/screens/main/delivery/orders_list_screen.dart';
import 'package:grocery_stores/widgets/cart_icon_button.dart';
import 'package:grocery_stores/widgets/deals_widget.dart';
import 'package:grocery_stores/widgets/ads_widget.dart';
import 'package:grocery_stores/widgets/categories_widget.dart';
import 'package:grocery_stores/widgets/section.dart';
import 'package:grocery_stores/widgets/shop_by_brand_widget.dart';
import 'package:grocery_stores/widgets/simple_image_dialog.dart';
import 'package:grocery_stores/widgets/store_selector_bottom_sheet.dart';
import 'package:grocery_stores/widgets/todays_deals_widget.dart';
import 'package:provider/provider.dart';
import '../../providers/smart_mart_provider.dart';
import 'profile/profile_screen.dart';
import 'search_screen.dart';
import 'package:grocery_stores/generated/l10n.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SmartMart>(
      builder: (context, groceryProvider, child) {
        return Scaffold(
          body: IndexedStack(
            index: groceryProvider.currentIndex,
            children: [
              const HomeContentScreen(),
              const OrdersListScreen(),
              const ProfileScreen(),
            ],
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: groceryProvider.currentIndex,
            onTap: groceryProvider.setCurrentIndex,
            type: BottomNavigationBarType.fixed,
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.track_changes_outlined),
                label: S.of(context).home,
              ),
              BottomNavigationBarItem(
                icon: Stack(
                  children: [
                    const Icon(Icons.receipt_long_rounded),
                    if (groceryProvider.pendingOrderItemCount > 0)
                      Positioned(
                        right: 0,
                        top: 0,
                        child: Container(
                          padding: const EdgeInsets.all(0),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 16,
                            minHeight: 16,
                          ),
                          child: Text(
                            '${groceryProvider.pendingOrderItemCount}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                  ],
                ),
                label: S.of(context).orders,
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_outline),
                label: S.of(context).account,
              ),
            ],
          ),
        );
      },
    );
  }
}

class HomeContentScreen extends StatelessWidget {
  const HomeContentScreen({super.key});

  static const EdgeInsets _bodyPadding = EdgeInsets.symmetric(
    horizontal: 0,
    vertical: 8,
  );
  static const EdgeInsets _sections_titles_Padding = EdgeInsets.symmetric(
    horizontal: 10,
    vertical: 16,
  );

  static const double _sectionSpacing = 24;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Consumer<SmartMart>(
          builder: (context, groceryProvider, child) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (groceryProvider.shouldShowStoreSelector &&
                  groceryProvider.availableStores.isNotEmpty) {
                StoreSelectorBottomSheet.show(context);
                groceryProvider.shouldShowStoreSelector = false;
              }
            });

            // Temporary loading state
            if (groceryProvider.categories == null ||
                groceryProvider.todaysDeals == null ||
                groceryProvider.deals == null) {
              return const Center(child: CircularProgressIndicator());
            }

            return CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: _bodyPadding,
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      // Deals Section
                      DealsWidget(deals: groceryProvider.deals),
                      const SizedBox(height: _sectionSpacing),
                      IconButton(
                        onPressed: () {
                          context.showSimpleImageDialog(
                            buttonText: 'Go to Screen',
                            onButtonPressed: () {
                              StoreSelectorBottomSheet.show(context);
                            },
                            backgroundImage:
                                'https://i.ibb.co/YT4zT23K/wtf.jpg',
                          );
                        },
                        icon: Icon(Icons.menu_open),
                      ),
                      Padding(
                        padding: _sections_titles_Padding,
                        child: Text(
                          S.of(context).categories,
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      CategoriesWidget(categories: groceryProvider.categories!),
                      const SizedBox(height: _sectionSpacing),
                      WavySection(
                        children: [
                          Padding(
                            padding: _sections_titles_Padding,
                            child: Text(
                              S.of(context).shopByBrand,
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          const BrandsGridWidget(),
                        ],
                      ),

                      const SizedBox(height: _sectionSpacing),
                      AdsWidget(Ads: groceryProvider.getAds()),
                      const SizedBox(height: _sectionSpacing),
                      Padding(
                        padding: _sections_titles_Padding,
                        child: Text(
                          S.of(context).todaysDeals,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ]),
                  ),
                ),

                // Today's Deals Grid as Sliver
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 0),
                  sliver: TodaysDealsWidget(
                    deals: groceryProvider.todaysDeals!,
                  ),
                ),

                // Bottom padding to avoid navigation bar
                const SliverPadding(padding: EdgeInsets.only(bottom: 100)),
              ],
            );
          },
        ),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 1,
      toolbarHeight: 64,
      title: GestureDetector(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SearchScreen()),
        ),
        child: Container(
          height: 45,
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(25),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: Row(
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 16, right: 12),
                child: Icon(Icons.search, color: Colors.grey, size: 22),
              ),
              Text(
                S.of(context).searchProducts,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [const CartIconButton(iconSize: 32)],
    );
  }
}
