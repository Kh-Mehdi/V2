import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'first_screen.dart'; 
import 'package:flutter_stripe/flutter_stripe.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
Stripe.publishableKey = 'pk_test_51Refmr9opIYTPf0Bjps0DEEZDe1FRatHtbs9wZEhJYUmWZSvOAyeyWGGbRHvc4DDQ25CCftugEAqMCrw45cSV8cE00d61bNAPS';
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Firebase App',
      home: FirstScreen(),
    );
  }
}
