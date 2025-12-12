import 'package:flutter/material.dart';
import 'package:lab_2/screens/details.dart';
import 'package:lab_2/screens/details_meals.dart';
import 'package:lab_2/screens/favourites.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'firebase_options.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'firebase_options.dart';

import 'screens/home.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  print('Background message: ${message.notification?.title}');
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await _initializeLocalNotifications();

  await _initializeFCM();

  await _sendStartupNotification();

  runApp(const MyApp());
}

Future<void> _initializeLocalNotifications() async {
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );

  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse: (details) {

      print('Notification tapped: ${details.payload}');
    },
  );
}

Future<void> _initializeFCM() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  await messaging.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );

  String? token = await messaging.getToken();
  print('FCM Token: $token');

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('Foreground message: ${message.notification?.title}');
    _showLocalNotification(message);
  });

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    print('App opened from notification: ${message.notification?.title}');
  });
}

Future<void> _showLocalNotification(RemoteMessage message) async {
  const AndroidNotificationDetails androidNotificationDetails =
      AndroidNotificationDetails(
    'recipe_channel',
    'Recipe Notifications',
    channelDescription: 'Notifications for recipe updates',
    importance: Importance.max,
    priority: Priority.high,
    icon: '@mipmap/ic_launcher',
  );

  const NotificationDetails notificationDetails =
      NotificationDetails(android: androidNotificationDetails);

  await flutterLocalNotificationsPlugin.show(
    0,
    message.notification?.title ?? 'Recipe Notification',
    message.notification?.body ?? 'Check out this recipe!',
    notificationDetails,
    payload: message.data['recipe_id'] ?? 'default',
  );
}

Future<void> _sendStartupNotification() async {

  await Future.delayed(Duration(seconds: 1));

  final List<Map<String, String>> welcomeMessages = [
    {'title': '🍽️ Meals App Started!', 'body': 'Welcome back! Ready to discover delicious recipes?'},
    {'title': '👨‍🍳 Time to Cook!', 'body': 'What amazing dish will you create today?'},
    {'title': '🥘 Recipe Hunter!', 'body': 'Your culinary adventure begins now!'},
    {'title': '🍳 Kitchen Master!', 'body': 'Let\'s find your next favorite recipe!'},
    {'title': '🧑‍🍳 Chef Mode ON!', 'body': 'Explore delicious meals and get cooking!'},
  ];

  final randomMessage = welcomeMessages[(DateTime.now().millisecondsSinceEpoch ~/ 1000) % welcomeMessages.length];

  const AndroidNotificationDetails androidNotificationDetails =
      AndroidNotificationDetails(
    'startup_channel',
    'App Startup Notifications',
    channelDescription: 'Notifications when app starts',
    importance: Importance.max,
    priority: Priority.high,
    icon: '@mipmap/ic_launcher',
    autoCancel: false,
  );

  const NotificationDetails notificationDetails =
      NotificationDetails(android: androidNotificationDetails);

  await flutterLocalNotificationsPlugin.show(
    999,
    randomMessage['title']!,
    randomMessage['body']!,
    notificationDetails,
    payload: 'app_startup',
  );

  print('Startup notification sent: ${randomMessage['title']}');
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      title: 'Meals App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.pinkAccent),
      ),
      initialRoute: "/",
      routes: {
        "/": (context) => const MyHomePage(title: 'Meals App'),
        "/details": (context) => const DetailsPage(),
        "/meal-details": (context) => const MealDetailsPage(),
        "/favorites": (context) => const FavoritesScreen(),

      },
    );
  }
}