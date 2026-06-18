import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:pdfaireader/screens/splash_screen.dart';
import 'package:pdfaireader/widgets/user_manager.dart';
import 'package:pdfaireader/widgets/auth_purchase_service.dart';
import 'package:pdfaireader/widgets/db_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await UserManager.init();
  await AuthPurchaseService.initialize();
  
  DbService.initializeTable();

  runApp(
    EasyLocalization(
      supportedLocales: const [
        Locale('en'),
        Locale('tr'),
        Locale('de'),
        Locale('it'),
        Locale('fr'),
        Locale('ja'),
        Locale('es'),
        Locale('ru'),
        Locale('ko'),
        Locale('hi'),
        Locale('pt'),
        Locale('zh'),
      ],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PDF AI Reader',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: const Color(0xFF3965DA),
        scaffoldBackgroundColor: const Color(0xFF050E22),
        fontFamily: 'Inter',
        useMaterial3: true,
      ),
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      home: const SplashScreen(),
    );
  }
}
