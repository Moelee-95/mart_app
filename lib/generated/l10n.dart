// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(
      _current != null,
      'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.',
    );
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(
      instance != null,
      'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?',
    );
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `FreshMart`
  String get title {
    return Intl.message('FreshMart', name: 'title', desc: '', args: []);
  }

  /// `Home`
  String get home {
    return Intl.message('Home', name: 'home', desc: '', args: []);
  }

  /// `Account`
  String get account {
    return Intl.message('Account', name: 'account', desc: '', args: []);
  }

  /// `Orders`
  String get orders {
    return Intl.message('Orders', name: 'orders', desc: '', args: []);
  }

  /// `Hello`
  String get hello {
    return Intl.message('Hello', name: 'hello', desc: '', args: []);
  }

  /// `Welcome to our app`
  String get welcome {
    return Intl.message(
      'Welcome to our app',
      name: 'welcome',
      desc: '',
      args: [],
    );
  }

  /// `Loading...`
  String get loading {
    return Intl.message('Loading...', name: 'loading', desc: '', args: []);
  }

  /// `Settings`
  String get settings {
    return Intl.message('Settings', name: 'settings', desc: '', args: []);
  }

  /// `Account info`
  String get accountInfo {
    return Intl.message(
      'Account info',
      name: 'accountInfo',
      desc: '',
      args: [],
    );
  }

  /// `Saved Addresses`
  String get savedAddresses {
    return Intl.message(
      'Saved Addresses',
      name: 'savedAddresses',
      desc: '',
      args: [],
    );
  }

  /// `Change Phone Number`
  String get changePhoneNumber {
    return Intl.message(
      'Change Phone Number',
      name: 'changePhoneNumber',
      desc: '',
      args: [],
    );
  }

  /// `Change PIN`
  String get changePin {
    return Intl.message('Change PIN', name: 'changePin', desc: '', args: []);
  }

  /// `Notifications`
  String get notifications {
    return Intl.message(
      'Notifications',
      name: 'notifications',
      desc: '',
      args: [],
    );
  }

  /// `Language`
  String get language {
    return Intl.message('Language', name: 'language', desc: '', args: []);
  }

  /// `Selected Store`
  String get selectedStore {
    return Intl.message(
      'Selected Store',
      name: 'selectedStore',
      desc: '',
      args: [],
    );
  }

  /// `Order History`
  String get orderHistory {
    return Intl.message(
      'Order History',
      name: 'orderHistory',
      desc: '',
      args: [],
    );
  }

  /// `Next Status`
  String get nextStatus {
    return Intl.message('Next Status', name: 'nextStatus', desc: '', args: []);
  }

  /// `Log out`
  String get logout {
    return Intl.message('Log out', name: 'logout', desc: '', args: []);
  }

  /// `Are you sure you want to logout?`
  String get logoutConfirmation {
    return Intl.message(
      'Are you sure you want to logout?',
      name: 'logoutConfirmation',
      desc: '',
      args: [],
    );
  }

  /// `Logging out...`
  String get loggingOut {
    return Intl.message(
      'Logging out...',
      name: 'loggingOut',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get cancel {
    return Intl.message('Cancel', name: 'cancel', desc: '', args: []);
  }

  /// `Enabled`
  String get enabled {
    return Intl.message('Enabled', name: 'enabled', desc: '', args: []);
  }

  /// `Disabled`
  String get disabled {
    return Intl.message('Disabled', name: 'disabled', desc: '', args: []);
  }

  /// `Select Language`
  String get selectLanguage {
    return Intl.message(
      'Select Language',
      name: 'selectLanguage',
      desc: '',
      args: [],
    );
  }

  /// `Welcome to FreshMart`
  String get welcomeToFreshMart {
    return Intl.message(
      'Welcome to FreshMart',
      name: 'welcomeToFreshMart',
      desc: '',
      args: [],
    );
  }

  /// `Your neighborhood smart mart at your fingertips`
  String get neighborhoodGroceryStore {
    return Intl.message(
      'Your neighborhood smart mart at your fingertips',
      name: 'neighborhoodGroceryStore',
      desc: '',
      args: [],
    );
  }

  /// `Get Started`
  String get getStarted {
    return Intl.message('Get Started', name: 'getStarted', desc: '', args: []);
  }

  /// `Delivery App`
  String get deliveryApp {
    return Intl.message(
      'Delivery App',
      name: 'deliveryApp',
      desc: '',
      args: [],
    );
  }

  /// `Shop with Ease`
  String get shopWithEase {
    return Intl.message(
      'Shop with Ease',
      name: 'shopWithEase',
      desc: '',
      args: [],
    );
  }

  /// `Browse, add to cart, and checkout in just a few taps`
  String get browseAddCheckout {
    return Intl.message(
      'Browse, add to cart, and checkout in just a few taps',
      name: 'browseAddCheckout',
      desc: '',
      args: [],
    );
  }

  /// `Next`
  String get next {
    return Intl.message('Next', name: 'next', desc: '', args: []);
  }

  /// `Pickup or Delivery`
  String get pickupOrDelivery {
    return Intl.message(
      'Pickup or Delivery',
      name: 'pickupOrDelivery',
      desc: '',
      args: [],
    );
  }

  /// `Choose what works best for you - collect from store or get it delivered`
  String get chooseWhatWorksBest {
    return Intl.message(
      'Choose what works best for you - collect from store or get it delivered',
      name: 'chooseWhatWorksBest',
      desc: '',
      args: [],
    );
  }

  /// `Shop Now`
  String get shopNow {
    return Intl.message('Shop Now', name: 'shopNow', desc: '', args: []);
  }

  /// `Speed`
  String get speed {
    return Intl.message('Speed', name: 'speed', desc: '', args: []);
  }

  /// `Convenience`
  String get convenience {
    return Intl.message('Convenience', name: 'convenience', desc: '', args: []);
  }

  /// `Reliability`
  String get reliability {
    return Intl.message('Reliability', name: 'reliability', desc: '', args: []);
  }

  /// `Sign In to your account`
  String get signInToAccount {
    return Intl.message(
      'Sign In to your account',
      name: 'signInToAccount',
      desc: '',
      args: [],
    );
  }

  /// `Sign In`
  String get signIn {
    return Intl.message('Sign In', name: 'signIn', desc: '', args: []);
  }

  /// `Don't have an account? `
  String get dontHaveAccount {
    return Intl.message(
      'Don\'t have an account? ',
      name: 'dontHaveAccount',
      desc: '',
      args: [],
    );
  }

  /// `Register Now`
  String get registerNow {
    return Intl.message(
      'Register Now',
      name: 'registerNow',
      desc: '',
      args: [],
    );
  }

  /// `By continuing, you agree to our `
  String get byContinuingAgree {
    return Intl.message(
      'By continuing, you agree to our ',
      name: 'byContinuingAgree',
      desc: '',
      args: [],
    );
  }

  /// `Terms of Service`
  String get termsOfService {
    return Intl.message(
      'Terms of Service',
      name: 'termsOfService',
      desc: '',
      args: [],
    );
  }

  /// ` and\n`
  String get andNewLine {
    return Intl.message(' and\n', name: 'andNewLine', desc: '', args: []);
  }

  /// `Privacy Policy`
  String get privacyPolicy {
    return Intl.message(
      'Privacy Policy',
      name: 'privacyPolicy',
      desc: '',
      args: [],
    );
  }

  /// `Phone Number`
  String get phoneNumber {
    return Intl.message(
      'Phone Number',
      name: 'phoneNumber',
      desc: '',
      args: [],
    );
  }

  /// `Continue`
  String get continueButton {
    return Intl.message('Continue', name: 'continueButton', desc: '', args: []);
  }

  /// `Back to Sign In`
  String get backToSignIn {
    return Intl.message(
      'Back to Sign In',
      name: 'backToSignIn',
      desc: '',
      args: [],
    );
  }

  /// `By continuing, you agree to our Terms of Service and Privacy Policy`
  String get termsAndPrivacy {
    return Intl.message(
      'By continuing, you agree to our Terms of Service and Privacy Policy',
      name: 'termsAndPrivacy',
      desc: '',
      args: [],
    );
  }

  /// `OTP verification`
  String get otpVerification {
    return Intl.message(
      'OTP verification',
      name: 'otpVerification',
      desc: '',
      args: [],
    );
  }

  /// `Enter the code we just\nsent you`
  String get enterCodeSent {
    return Intl.message(
      'Enter the code we just\nsent you',
      name: 'enterCodeSent',
      desc: '',
      args: [],
    );
  }

  /// `We sent a verification code to\n`
  String get sentVerificationCodeTo {
    return Intl.message(
      'We sent a verification code to\n',
      name: 'sentVerificationCodeTo',
      desc: '',
      args: [],
    );
  }

  /// `.\n\nEnter it below to continue.`
  String get enterBelowToContinue {
    return Intl.message(
      '.\n\nEnter it below to continue.',
      name: 'enterBelowToContinue',
      desc: '',
      args: [],
    );
  }

  /// `Verify`
  String get verify {
    return Intl.message('Verify', name: 'verify', desc: '', args: []);
  }

  /// `Resend code in {seconds}s`
  String resendCodeIn(int seconds) {
    return Intl.message(
      'Resend code in ${seconds}s',
      name: 'resendCodeIn',
      desc: '',
      args: [seconds],
    );
  }

  /// `Didn't receive the code? Resend`
  String get didntReceiveCodeResend {
    return Intl.message(
      'Didn\'t receive the code? Resend',
      name: 'didntReceiveCodeResend',
      desc: '',
      args: [],
    );
  }

  /// `Please enter complete verification code`
  String get pleaseEnterCompleteCode {
    return Intl.message(
      'Please enter complete verification code',
      name: 'pleaseEnterCompleteCode',
      desc: '',
      args: [],
    );
  }

  /// `Verification code sent!`
  String get verificationCodeSent {
    return Intl.message(
      'Verification code sent!',
      name: 'verificationCodeSent',
      desc: '',
      args: [],
    );
  }

  /// `Setup PIN`
  String get setupPin {
    return Intl.message('Setup PIN', name: 'setupPin', desc: '', args: []);
  }

  /// `Confirm PIN`
  String get confirmPin {
    return Intl.message('Confirm PIN', name: 'confirmPin', desc: '', args: []);
  }

  /// `Setup Your PIN`
  String get setupYourPin {
    return Intl.message(
      'Setup Your PIN',
      name: 'setupYourPin',
      desc: '',
      args: [],
    );
  }

  /// `Enter your app 4 digit PIN`
  String get enterApp4DigitPin {
    return Intl.message(
      'Enter your app 4 digit PIN',
      name: 'enterApp4DigitPin',
      desc: '',
      args: [],
    );
  }

  /// `Confirm Your PIN`
  String get confirmYourPin {
    return Intl.message(
      'Confirm Your PIN',
      name: 'confirmYourPin',
      desc: '',
      args: [],
    );
  }

  /// `Re-enter your PIN to confirm`
  String get reEnterPinToConfirm {
    return Intl.message(
      'Re-enter your PIN to confirm',
      name: 'reEnterPinToConfirm',
      desc: '',
      args: [],
    );
  }

  /// `Setting up your PIN...`
  String get settingUpYourPin {
    return Intl.message(
      'Setting up your PIN...',
      name: 'settingUpYourPin',
      desc: '',
      args: [],
    );
  }

  /// `PINs do not match. Please try again.`
  String get pinsDoNotMatch {
    return Intl.message(
      'PINs do not match. Please try again.',
      name: 'pinsDoNotMatch',
      desc: '',
      args: [],
    );
  }

  /// `Could not change pin`
  String get couldNotChangePin {
    return Intl.message(
      'Could not change pin',
      name: 'couldNotChangePin',
      desc: '',
      args: [],
    );
  }

  /// `Unknown auth type: {authType}`
  String unknownAuthType(String authType) {
    return Intl.message(
      'Unknown auth type: $authType',
      name: 'unknownAuthType',
      desc: '',
      args: [authType],
    );
  }

  /// `An error occurred. Please try again.`
  String get anErrorOccurred {
    return Intl.message(
      'An error occurred. Please try again.',
      name: 'anErrorOccurred',
      desc: '',
      args: [],
    );
  }

  /// `Complete Your Profile`
  String get completeYourProfile {
    return Intl.message(
      'Complete Your Profile',
      name: 'completeYourProfile',
      desc: '',
      args: [],
    );
  }

  /// `Phone: {phone}`
  String phoneLabel(String phone) {
    return Intl.message(
      'Phone: $phone',
      name: 'phoneLabel',
      desc: '',
      args: [phone],
    );
  }

  /// `Enter your full name`
  String get enterYourFullName {
    return Intl.message(
      'Enter your full name',
      name: 'enterYourFullName',
      desc: '',
      args: [],
    );
  }

  /// `Complete Registration`
  String get completeRegistration {
    return Intl.message(
      'Complete Registration',
      name: 'completeRegistration',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your full name`
  String get pleaseEnterYourFullName {
    return Intl.message(
      'Please enter your full name',
      name: 'pleaseEnterYourFullName',
      desc: '',
      args: [],
    );
  }

  /// `Full name must be at least 2 characters`
  String get fullNameMustBeAtLeast2Characters {
    return Intl.message(
      'Full name must be at least 2 characters',
      name: 'fullNameMustBeAtLeast2Characters',
      desc: '',
      args: [],
    );
  }

  /// `Missing customer information`
  String get missingCustomerInformation {
    return Intl.message(
      'Missing customer information',
      name: 'missingCustomerInformation',
      desc: '',
      args: [],
    );
  }

  /// `Registration failed: {error}`
  String registrationFailed(String error) {
    return Intl.message(
      'Registration failed: $error',
      name: 'registrationFailed',
      desc: '',
      args: [error],
    );
  }

  /// `Cart`
  String get cart {
    return Intl.message('Cart', name: 'cart', desc: '', args: []);
  }

  /// `Your cart is empty`
  String get yourCartIsEmpty {
    return Intl.message(
      'Your cart is empty',
      name: 'yourCartIsEmpty',
      desc: '',
      args: [],
    );
  }

  /// `Go to Home Screen`
  String get goToHomeScreen {
    return Intl.message(
      'Go to Home Screen',
      name: 'goToHomeScreen',
      desc: '',
      args: [],
    );
  }

  /// `Delivery Options`
  String get deliveryOptions {
    return Intl.message(
      'Delivery Options',
      name: 'deliveryOptions',
      desc: '',
      args: [],
    );
  }

  /// `Special requests`
  String get specialRequests {
    return Intl.message(
      'Special requests',
      name: 'specialRequests',
      desc: '',
      args: [],
    );
  }

  /// `Edit`
  String get edit {
    return Intl.message('Edit', name: 'edit', desc: '', args: []);
  }

  /// `Any special requests?`
  String get anySpecialRequests {
    return Intl.message(
      'Any special requests?',
      name: 'anySpecialRequests',
      desc: '',
      args: [],
    );
  }

  /// `Anything else we need to know?`
  String get anythingElseWeNeedToKnow {
    return Intl.message(
      'Anything else we need to know?',
      name: 'anythingElseWeNeedToKnow',
      desc: '',
      args: [],
    );
  }

  /// `Save`
  String get save {
    return Intl.message('Save', name: 'save', desc: '', args: []);
  }

  /// `Payment summary`
  String get paymentSummary {
    return Intl.message(
      'Payment summary',
      name: 'paymentSummary',
      desc: '',
      args: [],
    );
  }

  /// `Cart total`
  String get cartTotal {
    return Intl.message('Cart total', name: 'cartTotal', desc: '', args: []);
  }

  /// `Delivery fee`
  String get deliveryFee {
    return Intl.message(
      'Delivery fee',
      name: 'deliveryFee',
      desc: '',
      args: [],
    );
  }

  /// `Service fee`
  String get serviceFee {
    return Intl.message('Service fee', name: 'serviceFee', desc: '', args: []);
  }

  /// `Total amount`
  String get totalAmount {
    return Intl.message(
      'Total amount',
      name: 'totalAmount',
      desc: '',
      args: [],
    );
  }

  /// `Free`
  String get free {
    return Intl.message('Free', name: 'free', desc: '', args: []);
  }

  /// `Read more about fees`
  String get readMoreAboutFees {
    return Intl.message(
      'Read more about fees',
      name: 'readMoreAboutFees',
      desc: '',
      args: [],
    );
  }

  /// `Add items`
  String get addItems {
    return Intl.message('Add items', name: 'addItems', desc: '', args: []);
  }

  /// `Checkout`
  String get checkout {
    return Intl.message('Checkout', name: 'checkout', desc: '', args: []);
  }

  /// `Method: {method}`
  String method(String method) {
    return Intl.message(
      'Method: $method',
      name: 'method',
      desc: '',
      args: [method],
    );
  }

  /// `Total amount: {amount} IQD`
  String totalAmountCheckout(String amount) {
    return Intl.message(
      'Total amount: $amount IQD',
      name: 'totalAmountCheckout',
      desc: '',
      args: [amount],
    );
  }

  /// `Proceed with checkout?`
  String get proceedWithCheckout {
    return Intl.message(
      'Proceed with checkout?',
      name: 'proceedWithCheckout',
      desc: '',
      args: [],
    );
  }

  /// `Confirm Order`
  String get confirmOrder {
    return Intl.message(
      'Confirm Order',
      name: 'confirmOrder',
      desc: '',
      args: [],
    );
  }

  /// `Delivery`
  String get delivery {
    return Intl.message('Delivery', name: 'delivery', desc: '', args: []);
  }

  /// `Pickup`
  String get pickup {
    return Intl.message('Pickup', name: 'pickup', desc: '', args: []);
  }

  /// `Deliver to Your Location`
  String get deliverToLocation {
    return Intl.message(
      'Deliver to Your Location',
      name: 'deliverToLocation',
      desc: '',
      args: [],
    );
  }

  /// `Slemani, Daraza city, b122`
  String get deliveryAddress {
    return Intl.message(
      'Slemani, Daraza city, b122',
      name: 'deliveryAddress',
      desc: '',
      args: [],
    );
  }

  /// `2,000 IQD`
  String get deliveryPrice {
    return Intl.message('2,000 IQD', name: 'deliveryPrice', desc: '', args: []);
  }

  /// `Pickup at store`
  String get pickupAtStore {
    return Intl.message(
      'Pickup at store',
      name: 'pickupAtStore',
      desc: '',
      args: [],
    );
  }

  /// `Daraza city 1 Market`
  String get storeAddress {
    return Intl.message(
      'Daraza city 1 Market',
      name: 'storeAddress',
      desc: '',
      args: [],
    );
  }

  /// `My Orders`
  String get myOrders {
    return Intl.message('My Orders', name: 'myOrders', desc: '', args: []);
  }

  /// `All`
  String get all {
    return Intl.message('All', name: 'all', desc: '', args: []);
  }

  /// `Active`
  String get active {
    return Intl.message('Active', name: 'active', desc: '', args: []);
  }

  /// `Delivered`
  String get delivered {
    return Intl.message('Delivered', name: 'delivered', desc: '', args: []);
  }

  /// `Cancelled`
  String get cancelled {
    return Intl.message('Cancelled', name: 'cancelled', desc: '', args: []);
  }

  /// `No active orders`
  String get noActiveOrders {
    return Intl.message(
      'No active orders',
      name: 'noActiveOrders',
      desc: '',
      args: [],
    );
  }

  /// `No delivered orders`
  String get noDeliveredOrders {
    return Intl.message(
      'No delivered orders',
      name: 'noDeliveredOrders',
      desc: '',
      args: [],
    );
  }

  /// `No cancelled orders`
  String get noCancelledOrders {
    return Intl.message(
      'No cancelled orders',
      name: 'noCancelledOrders',
      desc: '',
      args: [],
    );
  }

  /// `No orders yet`
  String get noOrdersYet {
    return Intl.message(
      'No orders yet',
      name: 'noOrdersYet',
      desc: '',
      args: [],
    );
  }

  /// `Start shopping to see your orders here`
  String get startShoppingToSeeOrders {
    return Intl.message(
      'Start shopping to see your orders here',
      name: 'startShoppingToSeeOrders',
      desc: '',
      args: [],
    );
  }

  /// `+{count} more items`
  String moreItems(int count) {
    return Intl.message(
      '+$count more items',
      name: 'moreItems',
      desc: '',
      args: [count],
    );
  }

  /// `Total: IQD {amount}`
  String totalAmountOrder(String amount) {
    return Intl.message(
      'Total: IQD $amount',
      name: 'totalAmountOrder',
      desc: '',
      args: [amount],
    );
  }

  /// `Rate Order`
  String get rateOrder {
    return Intl.message('Rate Order', name: 'rateOrder', desc: '', args: []);
  }

  /// `Rate Your Order`
  String get rateYourOrder {
    return Intl.message(
      'Rate Your Order',
      name: 'rateYourOrder',
      desc: '',
      args: [],
    );
  }

  /// `Write a review (optional)`
  String get writeReviewOptional {
    return Intl.message(
      'Write a review (optional)',
      name: 'writeReviewOptional',
      desc: '',
      args: [],
    );
  }

  /// `Submit Rating`
  String get submitRating {
    return Intl.message(
      'Submit Rating',
      name: 'submitRating',
      desc: '',
      args: [],
    );
  }

  /// `Thank you for your rating!`
  String get thankYouForRating {
    return Intl.message(
      'Thank you for your rating!',
      name: 'thankYouForRating',
      desc: '',
      args: [],
    );
  }

  /// `No products available for this deal`
  String get noProductsAvailableForDeal {
    return Intl.message(
      'No products available for this deal',
      name: 'noProductsAvailableForDeal',
      desc: '',
      args: [],
    );
  }

  /// `No products available in this category`
  String get noProductsAvailableInCategory {
    return Intl.message(
      'No products available in this category',
      name: 'noProductsAvailableInCategory',
      desc: '',
      args: [],
    );
  }

  /// `Order Confirmation & Status`
  String get orderConfirmationStatus {
    return Intl.message(
      'Order Confirmation & Status',
      name: 'orderConfirmationStatus',
      desc: '',
      args: [],
    );
  }

  /// `Order Placed!`
  String get orderPlaced {
    return Intl.message(
      'Order Placed!',
      name: 'orderPlaced',
      desc: '',
      args: [],
    );
  }

  /// `Your order has been successfully placed. You will receive a notification when it's on its way.`
  String get orderPlacedMessage {
    return Intl.message(
      'Your order has been successfully placed. You will receive a notification when it\'s on its way.',
      name: 'orderPlacedMessage',
      desc: '',
      args: [],
    );
  }

  /// `Delivery Information`
  String get deliveryInformation {
    return Intl.message(
      'Delivery Information',
      name: 'deliveryInformation',
      desc: '',
      args: [],
    );
  }

  /// `Order Summary`
  String get orderSummary {
    return Intl.message(
      'Order Summary',
      name: 'orderSummary',
      desc: '',
      args: [],
    );
  }

  /// `{count} items`
  String itemsCount(int count) {
    return Intl.message(
      '$count items',
      name: 'itemsCount',
      desc: '',
      args: [count],
    );
  }

  /// `Subtotal`
  String get subtotal {
    return Intl.message('Subtotal', name: 'subtotal', desc: '', args: []);
  }

  /// `Qty: {qty}`
  String quantity(int qty) {
    return Intl.message('Qty: $qty', name: 'quantity', desc: '', args: [qty]);
  }

  /// `Order Status`
  String get orderStatus {
    return Intl.message(
      'Order Status',
      name: 'orderStatus',
      desc: '',
      args: [],
    );
  }

  /// `Track Order`
  String get trackOrder {
    return Intl.message('Track Order', name: 'trackOrder', desc: '', args: []);
  }

  /// `Order in progress`
  String get orderInProgress {
    return Intl.message(
      'Order in progress',
      name: 'orderInProgress',
      desc: '',
      args: [],
    );
  }

  /// `Step {current} of {total}`
  String stepProgress(int current, int total) {
    return Intl.message(
      'Step $current of $total',
      name: 'stepProgress',
      desc: '',
      args: [current, total],
    );
  }

  /// `Contact Support`
  String get contactSupportButton {
    return Intl.message(
      'Contact Support',
      name: 'contactSupportButton',
      desc: '',
      args: [],
    );
  }

  /// `Contact Market`
  String get contactMarket {
    return Intl.message(
      'Contact Market',
      name: 'contactMarket',
      desc: '',
      args: [],
    );
  }

  /// `Payment Method`
  String get paymentMethod {
    return Intl.message(
      'Payment Method',
      name: 'paymentMethod',
      desc: '',
      args: [],
    );
  }

  /// `Contact & Support`
  String get contactSupport {
    return Intl.message(
      'Contact & Support',
      name: 'contactSupport',
      desc: '',
      args: [],
    );
  }

  /// `Total`
  String get total {
    return Intl.message('Total', name: 'total', desc: '', args: []);
  }

  /// `Add to cart`
  String get addToCart {
    return Intl.message('Add to cart', name: 'addToCart', desc: '', args: []);
  }

  /// `Image not available`
  String get imageNotAvailable {
    return Intl.message(
      'Image not available',
      name: 'imageNotAvailable',
      desc: '',
      args: [],
    );
  }

  /// `1 kg • Approx. 8-12 pcs`
  String get productWeight {
    return Intl.message(
      '1 kg • Approx. 8-12 pcs',
      name: 'productWeight',
      desc: '',
      args: [],
    );
  }

  /// `Frequently bought together`
  String get frequentlyBoughtTogether {
    return Intl.message(
      'Frequently bought together',
      name: 'frequentlyBoughtTogether',
      desc: '',
      args: [],
    );
  }

  /// `No products available`
  String get noProductsAvailable {
    return Intl.message(
      'No products available',
      name: 'noProductsAvailable',
      desc: '',
      args: [],
    );
  }

  /// `Loading account info...`
  String get loadingAccountInfo {
    return Intl.message(
      'Loading account info...',
      name: 'loadingAccountInfo',
      desc: '',
      args: [],
    );
  }

  /// `Email`
  String get email {
    return Intl.message('Email', name: 'email', desc: '', args: []);
  }

  /// `First name`
  String get firstName {
    return Intl.message('First name', name: 'firstName', desc: '', args: []);
  }

  /// `Last name`
  String get lastName {
    return Intl.message('Last name', name: 'lastName', desc: '', args: []);
  }

  /// `Date of birth (optional)`
  String get dateOfBirthOptional {
    return Intl.message(
      'Date of birth (optional)',
      name: 'dateOfBirthOptional',
      desc: '',
      args: [],
    );
  }

  /// `Gender (optional)`
  String get genderOptional {
    return Intl.message(
      'Gender (optional)',
      name: 'genderOptional',
      desc: '',
      args: [],
    );
  }

  /// `Male`
  String get male {
    return Intl.message('Male', name: 'male', desc: '', args: []);
  }

  /// `Female`
  String get female {
    return Intl.message('Female', name: 'female', desc: '', args: []);
  }

  /// `Yes, I want to receive offers and discounts`
  String get receiveOffersAndDiscounts {
    return Intl.message(
      'Yes, I want to receive offers and discounts',
      name: 'receiveOffersAndDiscounts',
      desc: '',
      args: [],
    );
  }

  /// `Subscribe to newsletter`
  String get subscribeToNewsletter {
    return Intl.message(
      'Subscribe to newsletter',
      name: 'subscribeToNewsletter',
      desc: '',
      args: [],
    );
  }

  /// `Saving...`
  String get saving {
    return Intl.message('Saving...', name: 'saving', desc: '', args: []);
  }

  /// `Deleting...`
  String get deleting {
    return Intl.message('Deleting...', name: 'deleting', desc: '', args: []);
  }

  /// `Delete account`
  String get deleteAccount {
    return Intl.message(
      'Delete account',
      name: 'deleteAccount',
      desc: '',
      args: [],
    );
  }

  /// `Account information updated successfully`
  String get accountInfoUpdatedSuccessfully {
    return Intl.message(
      'Account information updated successfully',
      name: 'accountInfoUpdatedSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to delete your account? This action cannot be undone.`
  String get deleteAccountConfirmation {
    return Intl.message(
      'Are you sure you want to delete your account? This action cannot be undone.',
      name: 'deleteAccountConfirmation',
      desc: '',
      args: [],
    );
  }

  /// `Delete`
  String get delete {
    return Intl.message('Delete', name: 'delete', desc: '', args: []);
  }

  /// `Addresses`
  String get addresses {
    return Intl.message('Addresses', name: 'addresses', desc: '', args: []);
  }

  /// `Adding...`
  String get adding {
    return Intl.message('Adding...', name: 'adding', desc: '', args: []);
  }

  /// `Add`
  String get add {
    return Intl.message('Add', name: 'add', desc: '', args: []);
  }

  /// `Loading addresses...`
  String get loadingAddresses {
    return Intl.message(
      'Loading addresses...',
      name: 'loadingAddresses',
      desc: '',
      args: [],
    );
  }

  /// `No addresses found`
  String get noAddressesFound {
    return Intl.message(
      'No addresses found',
      name: 'noAddressesFound',
      desc: '',
      args: [],
    );
  }

  /// `Add your first address`
  String get addYourFirstAddress {
    return Intl.message(
      'Add your first address',
      name: 'addYourFirstAddress',
      desc: '',
      args: [],
    );
  }

  /// `Mobile Number`
  String get mobileNumber {
    return Intl.message(
      'Mobile Number',
      name: 'mobileNumber',
      desc: '',
      args: [],
    );
  }

  /// `Add New Address`
  String get addNewAddress {
    return Intl.message(
      'Add New Address',
      name: 'addNewAddress',
      desc: '',
      args: [],
    );
  }

  /// `This would open the add address form.`
  String get addAddressDialogContent {
    return Intl.message(
      'This would open the add address form.',
      name: 'addAddressDialogContent',
      desc: '',
      args: [],
    );
  }

  /// `Edit Address`
  String get editAddress {
    return Intl.message(
      'Edit Address',
      name: 'editAddress',
      desc: '',
      args: [],
    );
  }

  /// `Edit`
  String get editAddressFor {
    return Intl.message('Edit', name: 'editAddressFor', desc: '', args: []);
  }

  /// `Delete Address`
  String get deleteAddress {
    return Intl.message(
      'Delete Address',
      name: 'deleteAddress',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to delete`
  String get deleteAddressConfirmation {
    return Intl.message(
      'Are you sure you want to delete',
      name: 'deleteAddressConfirmation',
      desc: '',
      args: [],
    );
  }

  /// `Address deleted successfully`
  String get addressDeletedSuccessfully {
    return Intl.message(
      'Address deleted successfully',
      name: 'addressDeletedSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `Verify New Phone`
  String get verifyNewPhone {
    return Intl.message(
      'Verify New Phone',
      name: 'verifyNewPhone',
      desc: '',
      args: [],
    );
  }

  /// `Missing phone. Go back and retry.`
  String get missingPhoneGoBackRetry {
    return Intl.message(
      'Missing phone. Go back and retry.',
      name: 'missingPhoneGoBackRetry',
      desc: '',
      args: [],
    );
  }

  /// `Invalid verification code`
  String get invalidVerificationCode {
    return Intl.message(
      'Invalid verification code',
      name: 'invalidVerificationCode',
      desc: '',
      args: [],
    );
  }

  /// `Phone number updated`
  String get phoneNumberUpdated {
    return Intl.message(
      'Phone number updated',
      name: 'phoneNumberUpdated',
      desc: '',
      args: [],
    );
  }

  /// `Failed to update phone`
  String get failedToUpdatePhone {
    return Intl.message(
      'Failed to update phone',
      name: 'failedToUpdatePhone',
      desc: '',
      args: [],
    );
  }

  /// `Enter your new phone number`
  String get enterYourNewPhoneNumber {
    return Intl.message(
      'Enter your new phone number',
      name: 'enterYourNewPhoneNumber',
      desc: '',
      args: [],
    );
  }

  /// `OTP sent`
  String get otpSent {
    return Intl.message('OTP sent', name: 'otpSent', desc: '', args: []);
  }

  /// `Failed to send OTP`
  String get failedToSendOtp {
    return Intl.message(
      'Failed to send OTP',
      name: 'failedToSendOtp',
      desc: '',
      args: [],
    );
  }

  /// `Area`
  String get area {
    return Intl.message('Area', name: 'area', desc: '', args: []);
  }

  /// `Unknown Area`
  String get unknownArea {
    return Intl.message(
      'Unknown Area',
      name: 'unknownArea',
      desc: '',
      args: [],
    );
  }

  /// `Apartment`
  String get apartment {
    return Intl.message('Apartment', name: 'apartment', desc: '', args: []);
  }

  /// `House`
  String get house {
    return Intl.message('House', name: 'house', desc: '', args: []);
  }

  /// `Office`
  String get office {
    return Intl.message('Office', name: 'office', desc: '', args: []);
  }

  /// `Building name`
  String get buildingName {
    return Intl.message(
      'Building name',
      name: 'buildingName',
      desc: '',
      args: [],
    );
  }

  /// `Apt. no.`
  String get aptNo {
    return Intl.message('Apt. no.', name: 'aptNo', desc: '', args: []);
  }

  /// `Floor`
  String get floor {
    return Intl.message('Floor', name: 'floor', desc: '', args: []);
  }

  /// `Street`
  String get street {
    return Intl.message('Street', name: 'street', desc: '', args: []);
  }

  /// `Additional directions (optional)`
  String get additionalDirectionsOptional {
    return Intl.message(
      'Additional directions (optional)',
      name: 'additionalDirectionsOptional',
      desc: '',
      args: [],
    );
  }

  /// `Address label (optional)`
  String get addressLabelOptional {
    return Intl.message(
      'Address label (optional)',
      name: 'addressLabelOptional',
      desc: '',
      args: [],
    );
  }

  /// `Give this address a label so you can easily choose between them (e.g. Parent's home)`
  String get addressLabelDescription {
    return Intl.message(
      'Give this address a label so you can easily choose between them (e.g. Parent\'s home)',
      name: 'addressLabelDescription',
      desc: '',
      args: [],
    );
  }

  /// `Save address`
  String get saveAddress {
    return Intl.message(
      'Save address',
      name: 'saveAddress',
      desc: '',
      args: [],
    );
  }

  /// `Phone number is required`
  String get phoneNumberRequired {
    return Intl.message(
      'Phone number is required',
      name: 'phoneNumberRequired',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a valid phone number`
  String get enterValidPhoneNumber {
    return Intl.message(
      'Please enter a valid phone number',
      name: 'enterValidPhoneNumber',
      desc: '',
      args: [],
    );
  }

  /// `Area must be less than 255 characters`
  String get areaLengthLimit {
    return Intl.message(
      'Area must be less than 255 characters',
      name: 'areaLengthLimit',
      desc: '',
      args: [],
    );
  }

  /// `Building name must be less than 255 characters`
  String get buildingNameLengthLimit {
    return Intl.message(
      'Building name must be less than 255 characters',
      name: 'buildingNameLengthLimit',
      desc: '',
      args: [],
    );
  }

  /// `Floor must be less than 10 characters`
  String get floorLengthLimit {
    return Intl.message(
      'Floor must be less than 10 characters',
      name: 'floorLengthLimit',
      desc: '',
      args: [],
    );
  }

  /// `Apartment number must be less than 10 characters`
  String get aptNumberLengthLimit {
    return Intl.message(
      'Apartment number must be less than 10 characters',
      name: 'aptNumberLengthLimit',
      desc: '',
      args: [],
    );
  }

  /// `Street must be less than 255 characters`
  String get streetLengthLimit {
    return Intl.message(
      'Street must be less than 255 characters',
      name: 'streetLengthLimit',
      desc: '',
      args: [],
    );
  }

  /// `Additional directions must be less than 500 characters`
  String get directionsLengthLimit {
    return Intl.message(
      'Additional directions must be less than 500 characters',
      name: 'directionsLengthLimit',
      desc: '',
      args: [],
    );
  }

  /// `Address label must be less than 100 characters`
  String get addressLabelLengthLimit {
    return Intl.message(
      'Address label must be less than 100 characters',
      name: 'addressLabelLengthLimit',
      desc: '',
      args: [],
    );
  }

  /// `Phone number must be less than 20 characters`
  String get phoneNumberLengthLimit {
    return Intl.message(
      'Phone number must be less than 20 characters',
      name: 'phoneNumberLengthLimit',
      desc: '',
      args: [],
    );
  }

  /// `Success!`
  String get success {
    return Intl.message('Success!', name: 'success', desc: '', args: []);
  }

  /// `Address has been saved successfully.`
  String get addressSavedSuccessfully {
    return Intl.message(
      'Address has been saved successfully.',
      name: 'addressSavedSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `OK`
  String get ok {
    return Intl.message('OK', name: 'ok', desc: '', args: []);
  }

  /// `Failed to save address`
  String get failedToSaveAddress {
    return Intl.message(
      'Failed to save address',
      name: 'failedToSaveAddress',
      desc: '',
      args: [],
    );
  }

  /// `Today's Deals`
  String get todaysDeals {
    return Intl.message(
      'Today\'s Deals',
      name: 'todaysDeals',
      desc: '',
      args: [],
    );
  }

  /// `Search products`
  String get searchProducts {
    return Intl.message(
      'Search products',
      name: 'searchProducts',
      desc: '',
      args: [],
    );
  }

  /// `Recent searches`
  String get recentSearches {
    return Intl.message(
      'Recent searches',
      name: 'recentSearches',
      desc: '',
      args: [],
    );
  }

  /// `Clear recent searches`
  String get clearRecentSearches {
    return Intl.message(
      'Clear recent searches',
      name: 'clearRecentSearches',
      desc: '',
      args: [],
    );
  }

  /// `Search for products`
  String get searchForProducts {
    return Intl.message(
      'Search for products',
      name: 'searchForProducts',
      desc: '',
      args: [],
    );
  }

  /// `Search Results`
  String get searchResults {
    return Intl.message(
      'Search Results',
      name: 'searchResults',
      desc: '',
      args: [],
    );
  }

  /// `No products found`
  String get noProductsFound {
    return Intl.message(
      'No products found',
      name: 'noProductsFound',
      desc: '',
      args: [],
    );
  }

  /// `Try searching for something else`
  String get trySearchingSomethingElse {
    return Intl.message(
      'Try searching for something else',
      name: 'trySearchingSomethingElse',
      desc: '',
      args: [],
    );
  }

  /// `Categories`
  String get categories {
    return Intl.message('Categories', name: 'categories', desc: '', args: []);
  }

  /// `Ready to checkout!`
  String get readyToCheckout {
    return Intl.message(
      'Ready to checkout!',
      name: 'readyToCheckout',
      desc: '',
      args: [],
    );
  }

  /// `IQD`
  String get iqd {
    return Intl.message('IQD', name: 'iqd', desc: '', args: []);
  }

  /// `more to place order`
  String get moreToPlaceOrder {
    return Intl.message(
      'more to place order',
      name: 'moreToPlaceOrder',
      desc: '',
      args: [],
    );
  }

  /// `Start adding`
  String get startAdding {
    return Intl.message(
      'Start adding',
      name: 'startAdding',
      desc: '',
      args: [],
    );
  }

  /// `to place your order!`
  String get toPlaceYourOrder {
    return Intl.message(
      'to place your order!',
      name: 'toPlaceYourOrder',
      desc: '',
      args: [],
    );
  }

  /// `7701234567`
  String get phoneNumberHint {
    return Intl.message(
      '7701234567',
      name: 'phoneNumberHint',
      desc: '',
      args: [],
    );
  }

  /// `Clear PIN`
  String get clearPin {
    return Intl.message('Clear PIN', name: 'clearPin', desc: '', args: []);
  }

  /// `Incorrect PIN`
  String get incorrectPin {
    return Intl.message(
      'Incorrect PIN',
      name: 'incorrectPin',
      desc: '',
      args: [],
    );
  }

  /// `No deals available`
  String get noDealsAvailable {
    return Intl.message(
      'No deals available',
      name: 'noDealsAvailable',
      desc: '',
      args: [],
    );
  }

  /// `Loading more...`
  String get loadingMore {
    return Intl.message(
      'Loading more...',
      name: 'loadingMore',
      desc: '',
      args: [],
    );
  }

  /// `Select Store`
  String get selectStore {
    return Intl.message(
      'Select Store',
      name: 'selectStore',
      desc: '',
      args: [],
    );
  }

  /// `No stores available`
  String get noStoresAvailable {
    return Intl.message(
      'No stores available',
      name: 'noStoresAvailable',
      desc: '',
      args: [],
    );
  }

  /// `House Name/Number`
  String get houseName {
    return Intl.message(
      'House Name/Number',
      name: 'houseName',
      desc: '',
      args: [],
    );
  }

  /// `House Number`
  String get houseNumber {
    return Intl.message(
      'House Number',
      name: 'houseNumber',
      desc: '',
      args: [],
    );
  }

  /// `Floor (Optional)`
  String get houseFloor {
    return Intl.message(
      'Floor (Optional)',
      name: 'houseFloor',
      desc: '',
      args: [],
    );
  }

  /// `Office Building`
  String get officeBuildingName {
    return Intl.message(
      'Office Building',
      name: 'officeBuildingName',
      desc: '',
      args: [],
    );
  }

  /// `Office/Suite No.`
  String get officeNumber {
    return Intl.message(
      'Office/Suite No.',
      name: 'officeNumber',
      desc: '',
      args: [],
    );
  }

  /// `Floor`
  String get officeFloor {
    return Intl.message('Floor', name: 'officeFloor', desc: '', args: []);
  }

  /// `Shop By Brand`
  String get shopByBrand {
    return Intl.message(
      'Shop By Brand',
      name: 'shopByBrand',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ku'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
