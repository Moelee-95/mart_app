// lib/providers/grocery_provider.dart
import 'dart:collection';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:grocery_stores/data/smart_mart_ads.dart';
import 'package:grocery_stores/data/smart_mart_brands_data.dart';
import 'package:grocery_stores/data/smart_mart_sample_stores.dart';
import 'package:grocery_stores/models/ad.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Models
import '../models/address.dart';
import '../models/cart_item.dart';
import '../models/customer.dart';
import '../models/deal.dart';
import '../models/main_category.dart';
import '../models/main_item.dart';
import '../models/order.dart';
import '../models/store.dart';
import '../models/brand.dart';

// Services
import '../services/auth_service.dart';
import '../services/token_storage.dart';

// Data
import 'package:grocery_stores/data/smart_mart_categories_data.dart';
import 'package:grocery_stores/data/smart_mart_items_data.dart';

// Enums
enum DeliveryMethod { delivery, pickup }

/// Main provider class for grocery store functionality
/// Manages state for authentication, cart, orders, stores, and localization
class SmartMart with ChangeNotifier {
  // =============================================================================
  // PRIVATE FIELDS
  // =============================================================================

  // Storage
  static const FlutterSecureStorage _storage = FlutterSecureStorage();

  // Auth & Session
  String? _token;
  bool _loading = false;

  // Localization
  Locale _currentLocale = const Locale('en');
  bool _languageSelected = false;

  // Search
  final List<String> _recentSearches = <String>[];
  static const int _maxRecentSearches = 10;

  // Data Collections
  final List<MainCategory> _categories = GroceryCategoriesData200.categories;
  final List<mainItem> _items = mainItemsData.items;
  final List<mainItem> _todaysDeals = mainItemsData.todaysDeals;
  final List<Deal> _deals = mainItemsData.deals;

  // Customer & Cart
  final Customer _customer = Customer();
  final List<CartItem> _cartItems = <CartItem>[];
  String _specialRequests = '';
  DeliveryMethod _selectedDeliveryMethod = DeliveryMethod.delivery;

  // Orders & Addresses
  final List<Order> _orders = [];
  final List<Address> _savedAddresses = [];

  // Navigation & UI State
  int _currentIndex = 0;
  Store? _selectedStore;
  final List<Store> _availableStores = [];
  bool _shouldShowStoreSelector = false;

  // =============================================================================
  // PUBLIC GETTERS
  // =============================================================================

  // Auth & Session
  String? get token => _token;
  bool get isLoggedIn => _token?.isNotEmpty ?? false;
  bool get isLoading => _loading;

  // Localization
  Locale get currentLocale => _currentLocale;
  String get currentLanguageCode => _currentLocale.languageCode;
  bool get isLanguageSelected => _languageSelected;
  bool get isKurdish => _currentLocale.languageCode == 'ku';

  // Search
  UnmodifiableListView<String> get recentSearches =>
      UnmodifiableListView(_recentSearches);

  // Data Collections
  UnmodifiableListView<MainCategory> get categories =>
      UnmodifiableListView(_categories);
  UnmodifiableListView<mainItem> get items => UnmodifiableListView(_items);
  UnmodifiableListView<mainItem> get todaysDeals =>
      UnmodifiableListView(_todaysDeals);
  UnmodifiableListView<Deal> get deals => UnmodifiableListView(_deals);

  // Customer
  Customer get customer => _customer;
  String get phone => _customer.phone;
  String get verification_token => _customer.verificationToken;
  String get pin => _customer.pin;
  String get fullName => _customer.fullName;
  int? get id => _customer.id;

  // Cart
  UnmodifiableListView<CartItem> get cartItems =>
      UnmodifiableListView(_cartItems);
  String get specialRequests => _specialRequests;
  DeliveryMethod get selectedDeliveryMethod => _selectedDeliveryMethod;
  double get totalAmount =>
      _cartItems.fold(0.0, (sum, item) => sum + (item.price * item.quantity));
  int get cartItemsCount =>
      _cartItems.fold(0, (sum, item) => sum + item.quantity);

  // Orders & Addresses
  UnmodifiableListView<Order> get orders => UnmodifiableListView(_orders);
  UnmodifiableListView<Address> get savedAddresses =>
      UnmodifiableListView(_savedAddresses);
  int get pendingOrderItemCount => _orders
      .where(
        (order) =>
            order.currentStatus != OrderStatus.delivered &&
            order.currentStatus != OrderStatus.cancelled,
      )
      .length;

  // Navigation & Stores
  int get currentIndex => _currentIndex;
  Store? get selectedStore => _selectedStore;
  UnmodifiableListView<Store> get availableStores =>
      UnmodifiableListView(_availableStores);
  bool get shouldShowStoreSelector => _shouldShowStoreSelector;
  void set shouldShowStoreSelector(bool value) {
    _shouldShowStoreSelector = value;
    notifyListeners();
  }
  bool get hasSelectedStore => _selectedStore != null;

  // =============================================================================
  // INITIALIZATION
  // =============================================================================

  /// Initialize the provider session - loads all necessary data
  Future<void> initializeSession() async {
    await _setLoadingState(true);

    try {
      await Future.wait([
        _initializeAuth(),
        _initializeData(),
        _initializeStores(),
      ]);
    } catch (e) {
      debugPrint('Error initializing session: $e');
    } finally {
      await _setLoadingState(false);
      notifyListeners();
    }
  }

  Future<void> _initializeAuth() async {
    _token = await TokenStorage.getToken();
  }

  Future<void> _initializeData() async {
    await Future.wait([
      loadRecentSearches(),
      loadSavedLanguage(),
      loadOrders(),
      loadSavedAddresses(),
    ]);
  }

  Future<void> _initializeStores() async {
    _availableStores.clear();
    _availableStores.addAll(MainStoresData.stores);
    await loadSelectedStore();
    notifyListeners();
  }

  Future<void> _setLoadingState(bool loading) async {
    _loading = loading;
  }

  // =============================================================================
  // LOCALIZATION METHODS
  // =============================================================================

  void changeLanguage(String languageCode) {
    debugPrint('Changing language to: $languageCode');
    _currentLocale = Locale(languageCode);
    notifyListeners();
  }

  void setLanguageSelected(bool selected) {
    _languageSelected = selected;
    notifyListeners();
  }

  Future<void> saveLanguageSelection(String languageCode) async {
    await _storage.write(key: 'selected_language', value: languageCode);
    _languageSelected = true;
    changeLanguage(languageCode);
  }

  Future<void> loadSavedLanguage() async {
    try {
      final savedLanguage = await _storage.read(key: 'selected_language');
      if (savedLanguage != null) {
        _languageSelected = true;
        changeLanguage(savedLanguage);
      }
    } catch (e) {
      debugPrint('Error loading saved language: $e');
    }
  }

  String getCategoryDisplayName(MainCategory category) {
    return isKurdish ? (category.nameKu ?? category.name) : category.name;
  }

  // =============================================================================
  // AUTHENTICATION METHODS
  // =============================================================================

  void hydrateFromToken(String? token) {
    _token = token;
    notifyListeners();
  }

  Future<void> login(String token, {String tokenType = 'Bearer'}) async {
    await TokenStorage.storeToken(token, tokenType: tokenType);
    _token = token;
    notifyListeners();
  }

  Future<void> customerLogout() async {
    await TokenStorage.clearToken();
    _token = null;
    notifyListeners();
  }

  Future<void> clearToken() async {
    _token = null;
    await _storage.delete(key: 'token');
    notifyListeners();
  }

  void setVerificationToken(String verificationToken) {
    _customer.setVerificationToken(verificationToken);
    notifyListeners();
  }

  // =============================================================================
  // CUSTOMER METHODS
  // =============================================================================

  void setPhone(String phone) {
    _customer.setPhone(phone);
    notifyListeners();
  }

  void setPin(String pin) {
    _customer.setPin(pin);
    notifyListeners();
  }

  void setCustomerFullName(String fullName) {
    _customer.setFullName(fullName);
    notifyListeners();
  }

  Future<Map<String, dynamic>> registerCustomer() async {
    if (!_customer.isComplete) {
      return _createErrorResponse('Customer information is incomplete');
    }

    try {
      final result = await AuthService.registerAccount(
        _customer.phone,
        _customer.verificationToken,
        _customer.pin,
        _customer.fullName,
      );

      if (result['success'] == true) {
        _customer.isLoggedIn = true;
        _customer.id = result['customer']['id'];
        notifyListeners();
      }
      return result;
    } catch (e) {
      return _createErrorResponse('Registration failed: $e');
    }
  }

  void clearCustomer() {
    _customer.clear();
    notifyListeners();
  }

  Map<String, dynamic> _createErrorResponse(String message) {
    return {'success': false, 'message': message};
  }

  // =============================================================================
  // SEARCH METHODS
  // =============================================================================

  Future<void> loadRecentSearches() async {
    try {
      final searches = await _storage.read(key: 'recent_searches');
      if (searches?.isNotEmpty ?? false) {
        final searchList = searches!.split(',');
        _recentSearches.clear();
        _recentSearches.addAll(searchList.take(_maxRecentSearches));
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading recent searches: $e');
    }
  }

  Future<void> _saveRecentSearches() async {
    try {
      final searchesString = _recentSearches.join(',');
      await _storage.write(key: 'recent_searches', value: searchesString);
    } catch (e) {
      debugPrint('Error saving recent searches: $e');
    }
  }

  void addRecentSearch(String query) {
    final trimmedQuery = query.trim();
    if (trimmedQuery.isEmpty) return;

    final normalizedQuery = trimmedQuery.toLowerCase();

    // Remove if already exists to move it to top
    _recentSearches.removeWhere(
      (search) => search.toLowerCase() == normalizedQuery,
    );

    // Add to beginning and limit size
    _recentSearches.insert(0, trimmedQuery);
    if (_recentSearches.length > _maxRecentSearches) {
      _recentSearches.removeRange(_maxRecentSearches, _recentSearches.length);
    }

    _saveRecentSearches();
    notifyListeners();
  }

  void clearRecentSearches() {
    _recentSearches.clear();
    _storage.delete(key: 'recent_searches');
    notifyListeners();
  }

  List<mainItem> searchItems(String query, {String? category}) {
    if (query.trim().isEmpty) return [];

    final normalizedQuery = query.trim().toLowerCase();
    final searchResults = getAllItems().where(
      (item) => _itemMatchesQuery(item, normalizedQuery),
    );

    if (category?.isNotEmpty == true && category != 'All') {
      return searchResults
          .where(
            (item) => item.category.toLowerCase() == category!.toLowerCase(),
          )
          .toList();
    }

    return searchResults.toList();
  }

  bool _itemMatchesQuery(mainItem item, String normalizedQuery) {
    return item.name.toLowerCase().contains(normalizedQuery) ||
        item.description.toLowerCase().contains(normalizedQuery) ||
        item.category.toLowerCase().contains(normalizedQuery) ||
        (item.nameKu?.toLowerCase().contains(normalizedQuery) ?? false) ||
        (item.descriptionKu?.toLowerCase().contains(normalizedQuery) ?? false);
  }

  List<String> getSearchSuggestions(String query, {int maxSuggestions = 10}) {
    if (query.trim().isEmpty) return [];

    final normalizedQuery = query.trim().toLowerCase();
    final suggestions = <String>{};

    for (final item in getAllItems()) {
      _addItemSuggestions(item, normalizedQuery, suggestions);
      if (suggestions.length >= maxSuggestions * 2) break;
    }

    return _sortSuggestions(
      suggestions.toList(),
      normalizedQuery,
    ).take(maxSuggestions).toList();
  }

  void _addItemSuggestions(
    mainItem item,
    String normalizedQuery,
    Set<String> suggestions,
  ) {
    final displayName = isKurdish ? (item.nameKu ?? item.name) : item.name;

    // Check English and Kurdish names
    [item.name.toLowerCase(), item.nameKu?.toLowerCase()]
        .where((name) => name?.contains(normalizedQuery) == true)
        .forEach((_) => suggestions.add(displayName));

    // Add category if matches
    if (item.category.toLowerCase().contains(normalizedQuery)) {
      suggestions.add(item.category);
    }
  }

  List<String> _sortSuggestions(
    List<String> suggestions,
    String normalizedQuery,
  ) {
    return suggestions..sort((a, b) {
      final aLower = a.toLowerCase();
      final bLower = b.toLowerCase();
      final aStartsWith = aLower.startsWith(normalizedQuery);
      final bStartsWith = bLower.startsWith(normalizedQuery);

      if (aStartsWith && !bStartsWith) return -1;
      if (!aStartsWith && bStartsWith) return 1;
      return aLower.compareTo(bLower);
    });
  }

  // =============================================================================
  // ITEM AND CATEGORY METHODS
  // =============================================================================

  List<mainItem> getAllItems() {
    return [..._items, ..._todaysDeals];
  }

  List<mainItem> getItemsByCategory(String categoryName) {
    if (categoryName.isEmpty) return _items;
    return _items.where(_categoryMatcher(categoryName)).toList();
  }

  List<mainItem> getAllItemsByCategory(String categoryName) {
    if (categoryName.isEmpty) return getAllItems();
    return getAllItems().where(_categoryMatcher(categoryName)).toList();
  }

  bool Function(mainItem) _categoryMatcher(String categoryName) {
    return (item) => item.category.toLowerCase() == categoryName.toLowerCase();
  }

  // =============================================================================
  // DEAL METHODS
  // =============================================================================

  List<mainItem> getItemsByDealId(int dealId) {
    return getAllItems().where((item) => item.dealID == dealId).toList();
  }

  List<mainItem> getItemsByDealAndCategory(int dealId, String categoryName) {
    if (categoryName.isEmpty) return getItemsByDealId(dealId);
    return getItemsByDealId(
      dealId,
    ).where(_categoryMatcher(categoryName)).toList();
  }

  List<String> getCategoriesWithDealItems(int dealId) {
    final categories = getItemsByDealId(
      dealId,
    ).map((item) => item.category).toSet().toList();
    return categories..sort();
  }

  bool dealHasItems(int dealId) => getItemsByDealId(dealId).isNotEmpty;

  Deal? getDealById(int dealId) {
    try {
      return _deals.firstWhere((deal) => deal.id == dealId);
    } catch (e) {
      return null;
    }
  }

  // =============================================================================
  // CART METHODS
  // =============================================================================

  void setCurrentIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }

  void setDeliveryMethod(DeliveryMethod method) {
    _selectedDeliveryMethod = method;
    notifyListeners();
  }

  void setSpecialRequests(String requests) {
    _specialRequests = requests;
    notifyListeners();
  }

  int getItemQuantity(String itemId) {
    try {
      final item = _cartItems.firstWhere((item) => item.productId == itemId);
      return item.quantity;
    } catch (e) {
      return 0;
    }
  }

  void addToCart(mainItem item) {
    final existingIndex = _cartItems.indexWhere((c) => c.productId == item.id);
    final cartItem = _createCartItem(item);

    if (existingIndex >= 0) {
      _updateCartItemQuantity(
        existingIndex,
        _cartItems[existingIndex].quantity + 1,
      );
    } else {
      _cartItems.add(cartItem);
    }
    notifyListeners();
  }

  void removeFromCart(String productId) {
    final existingIndex = _cartItems.indexWhere(
      (c) => c.productId == productId,
    );
    if (existingIndex < 0) return;

    final currentQuantity = _cartItems[existingIndex].quantity;
    if (currentQuantity > 1) {
      _updateCartItemQuantity(existingIndex, currentQuantity - 1);
    } else {
      _cartItems.removeAt(existingIndex);
    }
    notifyListeners();
  }

  void clearCart() {
    _cartItems.clear();
    _specialRequests = '';
    notifyListeners();
  }

  CartItem _createCartItem(mainItem item) {
    final itemName = isKurdish ? (item.nameKu ?? item.name) : item.name;
    final itemDescription = isKurdish
        ? (item.descriptionKu ?? item.description)
        : item.description;

    return CartItem(
      id: DateTime.now().toIso8601String(),
      productId: item.id,
      name: itemName,
      price: item.displayPrice,
      quantity: 1,
      imageUrl: item.imageUrl,
      description: itemDescription,
    );
  }

  void _updateCartItemQuantity(int index, int newQuantity) {
    final existing = _cartItems[index];
    _cartItems[index] = CartItem(
      id: existing.id,
      productId: existing.productId,
      name: existing.name,
      price: existing.price,
      quantity: newQuantity,
      imageUrl: existing.imageUrl,
      description: existing.description,
    );
  }

  // =============================================================================
  // ORDER METHODS
  // =============================================================================

  Future<void> loadOrders() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final ordersJson = prefs.getStringList('orders') ?? [];

      _orders.clear();
      _orders.addAll(
        ordersJson.map((orderStr) => Order.fromJson(json.decode(orderStr))),
      );
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading orders: $e');
    }
  }

  Future<void> saveOrders() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final ordersJson = _orders
          .map((order) => json.encode(order.toJson()))
          .toList();
      await prefs.setStringList('orders', ordersJson);
    } catch (e) {
      debugPrint('Error saving orders: $e');
    }
  }

  Future<String> createOrder() async {
    if (_cartItems.isEmpty) return '';

    final order = _buildOrderFromCart();
    _orders.insert(0, order);

    await saveOrders();
    clearCart();
    notifyListeners();

    return order.id;
  }

  Future<bool> repeatOrder(Order order) async {
    // create new order from existing order
    final newOrder = Order(
      // create new id
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      items: order.items,
      subtotal: order.subtotal,
      deliveryFee: order.deliveryFee,
      total: order.total,
      deliveryAddress: order.deliveryAddress,
      orderTime: order.orderTime,
      currentStatus: OrderStatus.placed,
      statusSteps: order.statusSteps,
      paymentMethod: order.paymentMethod,
      canRate: order.canRate,
      rating: order.rating,
      review: order.review,
    );
    _orders.add(newOrder);
    await saveOrders();
    notifyListeners();
    if (order.currentStatus == OrderStatus.placed) {
      return true;
    } else {
      return false;
    }
  }

  Order _buildOrderFromCart() {
    final deliveryFee = _selectedDeliveryMethod == DeliveryMethod.delivery
        ? 2000.0
        : 0.0;
    const serviceFee = 500.0;
    final subtotal = totalAmount;
    final total = subtotal + deliveryFee + serviceFee;

    return Order(
      id: 'ORDER_${DateTime.now().millisecondsSinceEpoch}',
      items: _cartItems.map(_cartItemToOrderItem).toList(),
      subtotal: subtotal,
      deliveryFee: deliveryFee,
      total: total,
      deliveryAddress: _getDeliveryAddress(),
      orderTime: DateTime.now(),
      currentStatus: OrderStatus.placed,
      specialRequests: _specialRequests,
      statusSteps: _generateInitialStatusSteps(),
      paymentMethod: PaymentMethod(method: 'Cash', details: 'Cash'),
      canRate: false,
    );
  }

  OrderItem _cartItemToOrderItem(CartItem cartItem) {
    return OrderItem(
      id: cartItem.id,
      name: cartItem.name,
      price: cartItem.price,
      quantity: cartItem.quantity,
      imageUrl: cartItem.imageUrl,
    );
  }

  String _getDeliveryAddress() {
    if (_selectedDeliveryMethod == DeliveryMethod.delivery &&
        _customer.defaultAddress != null) {
      return _customer.defaultAddress!.address;
    } else if (_selectedDeliveryMethod == DeliveryMethod.pickup) {
      return getSelectedStoreDisplayName();
    }
    return 'No address selected';
  }

  List<OrderStatusStep> _generateInitialStatusSteps() {
    final now = DateTime.now().toString();
    return [
      OrderStatusStep(
        status: OrderStatus.placed,
        title: 'Order Placed',
        time: now,
        isCompleted: true,
        isCurrent: false,
      ),
      OrderStatusStep(
        status: OrderStatus.preparing,
        title: 'Preparing Order',
        time: '',
        isCompleted: false,
        isCurrent: true,
      ),
      OrderStatusStep(
        status: OrderStatus.pickedUp,
        title: 'Out for Delivery',
        time: '',
        isCompleted: false,
        isCurrent: false,
      ),
      OrderStatusStep(
        status: OrderStatus.delivered,
        title: 'Delivered',
        time: '',
        isCompleted: false,
        isCurrent: false,
      ),
    ];
  }

  Future<void> updateOrderStatus(String orderId) async {
    final orderIndex = _orders.indexWhere((order) => order.id == orderId);
    if (orderIndex == -1) return;

    final currentOrder = _orders[orderIndex];
    final nextStatus = _getNextOrderStatus(currentOrder.currentStatus);
    final updatedSteps = _updateOrderStatusSteps(
      currentOrder.statusSteps,
      nextStatus,
    );

    _orders[orderIndex] = currentOrder.copyWith(
      currentStatus: nextStatus,
      statusSteps: updatedSteps,
      canRate: nextStatus == OrderStatus.delivered,
    );

    await saveOrders();
    notifyListeners();
  }

  OrderStatus _getNextOrderStatus(OrderStatus currentStatus) {
    switch (currentStatus) {
      case OrderStatus.placed:
        return OrderStatus.preparing;
      case OrderStatus.preparing:
        return OrderStatus.pickedUp;
      case OrderStatus.pickedUp:
        return OrderStatus.delivered;
      case OrderStatus.delivered:
        return OrderStatus.placed; // Cycle back for testing
      case OrderStatus.cancelled:
        return OrderStatus.placed;
    }
  }

  List<OrderStatusStep> _updateOrderStatusSteps(
    List<OrderStatusStep> steps,
    OrderStatus nextStatus,
  ) {
    final now = DateTime.now().toString();
    return steps.map((step) {
      final isCompleted = step.status.index < nextStatus.index;
      final isCurrent = step.status == nextStatus;
      final time = isCompleted ? now : step.time;

      return step.copyWith(
        isCompleted: isCompleted,
        isCurrent: isCurrent,
        time: time,
      );
    }).toList();
  }

  // =============================================================================
  // ADDRESS METHODS
  // =============================================================================

  Future<void> loadSavedAddresses() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final addressesJson = prefs.getStringList('saved_addresses');

      if (addressesJson != null) {
        _savedAddresses.clear();
        _savedAddresses.addAll(
          addressesJson
              .map((json) => Address.fromJson(jsonDecode(json)))
              .toList(),
        );
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading saved addresses: $e');
    }
  }

  Future<void> _saveAddressesToStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final addressesJson = _savedAddresses
          .map((address) => jsonEncode(address.toJson()))
          .toList();
      await prefs.setStringList('saved_addresses', addressesJson);
    } catch (e) {
      debugPrint('Error saving addresses: $e');
    }
  }

  Future<void> addSavedAddress(Address address) async {
    _savedAddresses.add(address);
    await _saveAddressesToStorage();
    notifyListeners();
  }

  Future<void> updateSavedAddress(int addressId, Address updatedAddress) async {
    final index = _savedAddresses.indexWhere((addr) => addr.id == addressId);
    if (index >= 0) {
      _savedAddresses[index] = updatedAddress;
      await _saveAddressesToStorage();
      notifyListeners();
    }
  }

  Future<void> deleteSavedAddress(int addressId) async {
    _savedAddresses.removeWhere((addr) => addr.id == addressId);
    await _saveAddressesToStorage();
    notifyListeners();
  }

  Future<void> setDefaultAddress(int addressId) async {
    for (int i = 0; i < _savedAddresses.length; i++) {
      _savedAddresses[i] = _savedAddresses[i].copyWith(
        isDefault: _savedAddresses[i].id == addressId,
      );
    }
    await _saveAddressesToStorage();
    notifyListeners();
  }

  Address? getAddressById(int addressId) {
    try {
      return _savedAddresses.firstWhere((addr) => addr.id == addressId);
    } catch (e) {
      return null;
    }
  }

  // =============================================================================
  // STORE METHODS
  // =============================================================================

  Future<void> initializeStores() async {
    await _initializeStores();
  }

  Future<void> loadSelectedStore() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final storeId = prefs.getString('selected_store_id');

      if (storeId != null) {
        _selectedStore = _findStoreById(storeId) ?? _getDefaultStore();
        _shouldShowStoreSelector = false; // Store was previously selected
      } else {
        _selectedStore = _getDefaultStore();
        _shouldShowStoreSelector = true; // No store was previously selected
      }
    } catch (e) {
      debugPrint('Error loading selected store: $e');
      _selectedStore = _getDefaultStore();
      _shouldShowStoreSelector = true; // Error loading, show selector
    }
  }

  Store? _findStoreById(String storeId) {
    try {
      return _availableStores.firstWhere((store) => store.id == storeId);
    } catch (e) {
      return null;
    }
  }

  Store? _getDefaultStore() {
    return _availableStores.isNotEmpty ? _availableStores.first : null;
  }

  Future<void> selectStore(Store store) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('selected_store_id', store.id);

      _selectedStore = store;
      _shouldShowStoreSelector = false; // Store selected, don't show again

      clearCart();
      notifyListeners();
    } catch (e) {
      debugPrint('Error selecting store: $e');
    }
  }

  String getSelectedStoreDisplayName() {
    return _selectedStore?.getDisplayName(isKurdish) ?? 'No Store Selected';
  }

  // =============================================================================
  // ADS RELATED METHODS
  // =============================================================================
  List<Ad> getAds() {
    return MainStoreAds.ads;
  }
  List<Ad> ads = MainStoreAds.ads;

  List<mainItem> getItemsByAdId(String adId){
    return getAllItems().where((item) => item.adId == adId).toList();
  }

  // get categories by Ad items
  List<String> getCategoriesWithAdItems(String adId){
    final categories = getItemsByAdId(adId).map((item) => item.category).toSet().toList();
    return categories..sort();
  }

  List<mainItem> getItemsByAdandCategory(String adId, String categoryName){
    if(categoryName.isEmpty) return getItemsByAdId(adId);
    return getItemsByAdId(adId).where(_categoryMatcher(categoryName)).toList();
  }

  // =============================================================================
  // BRANDS RELATED METHODS
  // =============================================================================
  List<Brand> brands = BrandData.brands;

  //get items by brand id
  List<mainItem> getItemsByBrandId(String brandId) {
    return getAllItems().where((item) => item.brandId == brandId).toList();
  }

  // get categories with brand items
  List<String> getCategoriesWithBrandItems(String brandId) {
    final categories = getItemsByBrandId(brandId).map((item) => item.category).toSet().toList();
    return categories..sort();
  }

  // get items by brand and category
  List<mainItem> getItemsByBrandAndCategory(String brandId, String categoryName) {
    if (categoryName.isEmpty) return getItemsByBrandId(brandId);
    return getItemsByBrandId(brandId).where(_categoryMatcher(categoryName)).toList();
  }

  


}
