import 'package:flutter/material.dart';
import 'package:lab_2/screens/details.dart';
import 'package:lab_2/screens/details_meals.dart';

import 'screens/home.dart';


// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//
//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
//   );
//   runApp(const MyApp());
// }

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Meals App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.pinkAccent),
      ),
      initialRoute: "/",
      routes: {
        // "/": (context) => const RegisterPage(),
        "/": (context) => const MyHomePage(title: 'Meals App'),
        "/details": (context) => const DetailsPage(),
        "/meal-details": (context) => const MealDetailsPage(),
      },
    );
  }
}