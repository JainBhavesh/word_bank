import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart'; // Import Get for translations
import 'package:flutter_localizations/flutter_localizations.dart'; // Import localization support
import 'package:word_bank/view/splash_screen.dart';

import 'routes/routes.dart';
import 'utils/translations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  try {
    await Firebase.initializeApp();
  } catch (e) {
    print("Error initializing Firebase: $e");
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      // When we use Get, then use GetMaterialApp
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
      getPages: AppRoutes.appRoutes(),
      locale: const Locale('zh', 'CN'), //set defualt chinese
      // locale: const Locale('en', 'US'), //set defualt english

      fallbackLocale: const Locale('en', 'US'),
      // fallbackLocale: const Locale('zh', 'CN'),

      translations: AppTranslations(),

      supportedLocales: const [
        Locale('en', 'US'),
        Locale('zh', 'CN'),
      ],

      // Localization delegates for Material, Cupertino, and Widgets
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate, // Material UI localization
        GlobalCupertinoLocalizations.delegate, // iOS-style localization
        GlobalWidgetsLocalizations.delegate, // Localization for widgets
      ],

      // Add your theme (optional)
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: const Color(0xFFF2F2F2),
      ),
    );
  }
}
