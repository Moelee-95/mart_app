import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:grocery_stores/screens/common/splash_screen.dart';
import 'package:provider/provider.dart';
import 'providers/smart_mart_provider.dart';
import 'services/token_storage.dart';
import 'screens/main/home_screen.dart';
import 'generated/l10n.dart';

// Custom Material delegate that provides English for Kurdish
class FallbackMaterialDelegate
    extends LocalizationsDelegate<MaterialLocalizations> {
  const FallbackMaterialDelegate();

  @override
  bool isSupported(Locale locale) => locale.languageCode == 'ku';

  @override
  Future<MaterialLocalizations> load(Locale locale) {
    return GlobalMaterialLocalizations.delegate.load(const Locale('en'));
  }

  @override
  bool shouldReload(FallbackMaterialDelegate old) => false;
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final String? initialToken = await TokenStorage.getToken();
  runApp(MyApp(initialToken: initialToken));
}

class MyApp extends StatelessWidget {
  final String? initialToken;
  const MyApp({super.key, this.initialToken});

  bool get _isLoggedIn => (initialToken != null && initialToken!.isNotEmpty);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) {
            final provider = SmartMart();
            provider.hydrateFromToken(initialToken);

              WidgetsBinding.instance.addPostFrameCallback((_) {
              provider.initializeStores();
            });

            return provider;
          },
        ),
      ],
      child: Consumer<SmartMart>(
        builder: (context, provider, child) {
          return MaterialApp(
            title: 'Delivery App',
            theme: provider.currentLocale.languageCode == 'ku'
                ? ThemeData(
                    fontFamily: 'NRT',
                    colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
                    useMaterial3: true,
                  )
                : ThemeData(
                    colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
                    useMaterial3: true,
                  ),
            // Add internationalization configuration
            locale: provider.currentLocale,
            localizationsDelegates: const [
              S.delegate,
              FallbackMaterialDelegate(),
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: S.delegate.supportedLocales,
            home: _isLoggedIn ? const HomeScreen() : const SplashScreen(),
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}
