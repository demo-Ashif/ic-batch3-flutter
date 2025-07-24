import 'package:flutter/material.dart';
import 'package:ic_batch3_flutter_classes/home_screen.dart';
import 'package:ic_batch3_flutter_classes/second_screen.dart';
// import 'package:ic_batch3_flutter_classes/row_column_widget.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Navigation',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      // home: const HomeScreen(),
      initialRoute: '/home',
      routes: {
        '/home': (context) => HomeScreen(),
        // '/second': (context) => SecondScreen(data: 'Hello'),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/second') {
          final args = settings.arguments as ScreenArguments;
          return MaterialPageRoute(
            builder: (context) => SecondScreen(data: args.message),
          );
        }
        return null;
      },
      onUnknownRoute: (settings) {
        return MaterialPageRoute(
          builder:
              (_) =>
                  Scaffold(body: Center(child: Text('404 - Page not found'))),
        );
      },
    );
  }
}

class ScreenArguments {
  final String message;

  ScreenArguments(this.message);
}
