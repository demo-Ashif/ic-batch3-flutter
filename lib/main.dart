import 'package:flutter/material.dart';
import 'package:ic_batch3_flutter_classes/list_scroll_widgets.dart';
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
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const ListScrollWidgets(),
    );
  }
}
