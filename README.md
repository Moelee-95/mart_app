# grocery_stores

Delivery App delivery mobile application

## Getting Started

when adding a new localization to intl_en.arb and intl_ku.arb, run the following command:
# Clean and get dependencies
flutter clean
flutter pub get

# Generate localization files
dart run intl_utils:generate

Make sure to import import 'package:grocery_stores/generated/l10n.dart';
.dart everywhere you need to use the localization.



