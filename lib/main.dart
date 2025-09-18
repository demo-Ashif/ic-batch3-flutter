import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:ic_batch3_flutter_classes/firebase_options.dart';
import 'package:ic_batch3_flutter_classes/pages/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Survey App with Firestore',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(centerTitle: true, elevation: 0),
      ),
      home: const HomePage(),
    );
  }
}
