

import 'package:cbs/providers/cart_provider.dart';
import 'package:cbs/providers/id_provider.dart';
import 'package:cbs/providers/sql.dart';
import 'package:cbs/providers/wish_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cbs/main_screens/customer_home.dart';
import 'package:cbs/auth/customer_signup.dart';
import 'package:cbs/auth/customer_login.dart';
import 'package:provider/provider.dart';

// import 'main_screens/customer_home.dart';
import 'main_screens/flash.dart';
// import 'firebase_options.dart';
// import 'package:flutter_stripe/flutter_stripe.dart';

import 'main_screens/onboarding_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();


  await Firebase.initializeApp(
    // options: DefaultFirebaseOptions.currentPlatform,
  );
  SQLHelper.getDatabase;
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => Cart()),
    ChangeNotifierProvider(create: (_) => Wish()),
    ChangeNotifierProvider(create: (_) => IdProvider()),

  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/flash_screen',
      routes: {
        '/flash_screen': (context) => const FlashScreen(),
        '/customer_home': (context) => const CustomerHomeScreen(),
        '/customer_signup': (context) => const CustomerRegister(),
        '/customer_login': (context) => const CustomerLogin(),
        '/onboarding_screen': (context) => const Onboardingscreen(),
      },
    );
  }
}