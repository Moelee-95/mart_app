// lib/screens/main/profile/profile_screen.dart

import 'package:flutter/material.dart';
import 'package:grocery_stores/providers/smart_mart_provider.dart';
import 'package:grocery_stores/screens/auth/sign_in_pin_screen.dart';
import 'package:grocery_stores/screens/auth/sign_in_screen.dart';
import 'package:grocery_stores/screens/main/delivery/orders_list_screen.dart';
import 'package:grocery_stores/screens/main/profile/account_info_screen.dart';
import 'package:grocery_stores/screens/main/profile/addresses_list_screen.dart';
import 'package:provider/provider.dart';
import 'package:grocery_stores/screens/main/profile/change_phone_screen.dart';
import 'package:grocery_stores/generated/l10n.dart';
import 'package:grocery_stores/widgets/store_selector_bottom_sheet.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // State variables that change during widget lifecycle
  bool isLoading = true;
  bool notificationsEnabled = false;
  String? userName;
  String? userPhone;
  bool isLoggingOut = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  // Simulate loading user data from API
  Future<void> _loadUserData() async {
    setState(() {
      userName = 'Moe Zim';
      userPhone = '07708138928';
      notificationsEnabled = false;
      isLoading = false;
    });
  }

  // Toggle notifications
  void _toggleNotifications() {
    setState(() {
      notificationsEnabled = !notificationsEnabled;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SmartMart>(
      builder: (context, provider, child) {
        return Scaffold(
          backgroundColor: Colors.grey[50],
          body: Column(
            children: [
              // Profile Header Section
              Container(
                width: double.infinity,
                color: Colors.white,
                padding: const EdgeInsets.all(10),
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: 30.0,
                    bottom: 1.0,
                    left: 8.0,
                    right: 8.0,
                  ),
                  child: Row(
                    children: [
                      const CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.green,
                        child: Icon(
                          Icons.person,
                          size: 30,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Show loading or actual data
                      if (isLoading) ...[
                        const CircularProgressIndicator(),
                        const SizedBox(width: 8),
                        Text(S.of(context).loading),
                      ] else ...[
                        Column(
                          children: [
                            Text(
                              userName ?? 'Unknown User',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              userPhone ?? 'Phone not available',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ),

              // Divider
              Container(height: 8, color: Colors.grey[50]),

              // Menu Items Section
              Expanded(
                child: Container(
                  color: Colors.white,
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      _buildMenuItem(S.of(context).accountInfo, () {
                        //Navigate to account_info_screen
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AccountInfoScreen(),
                          ),
                        );
                      }),
                      _buildMenuItem(S.of(context).orders, () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const OrdersListScreen(),
                          ),
                        );
                      }),
                      _buildMenuItem(S.of(context).savedAddresses, () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddressesScreen(),
                          ),
                        );
                      }),
                      _buildMenuItem(S.of(context).changePhoneNumber, () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ChangePhoneScreen(),
                          ),
                        );
                      }),
                      _buildMenuItem(S.of(context).changePin, () {
                        final phoneNumber = context
                            .read<SmartMart>()
                            .customer
                            .phone;

                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => AuthPinScreen(
                              phone: phoneNumber,
                              authType: 'changePin',
                              key: GlobalKey(),
                              onSuccess: () {},
                              subtitle: "Enter your Current PIN",
                              title: "change your PIN",
                            ),
                          ),
                        );
                      }),
                      // Interactive notification toggle
                      _buildToggleItem(
                        S.of(context).notifications,
                        notificationsEnabled,
                        _toggleNotifications,
                      ),
                      // Interactive language selector
                      _buildMenuItemWithStatus(
                        S.of(context).language,
                        provider.currentLocale.languageCode == 'ku'
                            ? 'کوردی'
                            : 'English',
                        () => _showLanguageSelector(),
                      ),
                      _buildMenuItemWithStatus(
                        S.of(context).selectedStore,
                        provider.getSelectedStoreDisplayName(),
                        () => StoreSelectorBottomSheet.show(context),
                      ),
                      // Logout with loading state
                      _buildMenuItem(
                        isLoggingOut
                            ? S.of(context).loggingOut
                            : S.of(context).logout,
                        () => _showLogoutDialog(context),
                        isLogout: true,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildToggleItem(String title, bool value, VoidCallback onTap) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey[200]!, width: 0.5),
        ),
      ),
      child: ListTile(
        title: Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              value ? S.of(context).enabled : S.of(context).disabled,
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
            const SizedBox(width: 8),
            Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[600]),
          ],
        ),
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      ),
    );
  }

  void _showLanguageSelector() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(S.of(context).selectLanguage),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('English'),
              onTap: () {
                context.read<SmartMart>().changeLanguage('en');
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('کوردی', style: TextStyle(fontFamily: 'NRT')),
              onTap: () {
                context.read<SmartMart>().changeLanguage('ku');
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(
    String title,
    VoidCallback onTap, {
    bool isLogout = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey[200]!, width: 0.5),
        ),
      ),
      child: ListTile(
        title: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: isLogout ? Colors.red : Colors.black,
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: Colors.grey[600],
        ),
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      ),
    );
  }

  Widget _buildMenuItemWithStatus(
    String title,
    String status,
    VoidCallback onTap,
  ) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey[200]!, width: 0.5),
        ),
      ),
      child: ListTile(
        title: Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              status,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                fontFamily: status == 'کوردی' ? 'NRT' : null,
              ),
            ),
            const SizedBox(width: 8),
            Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[600]),
          ],
        ),
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(S.of(context).logout),
          content: Text(S.of(context).logoutConfirmation),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(S.of(context).cancel),
            ),
            ElevatedButton(
              onPressed: () async {
                setState(() {
                  isLoggingOut = true;
                });

                if (mounted) {
                  context.read<SmartMart>().customerLogout();
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) => const SignInScreen(),
                    ),
                    (route) => false,
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: Text(S.of(context).logout),
            ),
          ],
        );
      },
    );
  }
}
