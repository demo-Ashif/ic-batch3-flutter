import 'package:flutter/material.dart';

class ListScrollWidgets extends StatelessWidget {
  const ListScrollWidgets({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        children: [
          Container(color: Colors.red),
          Container(color: Colors.green),
          Container(color: Colors.blue),
        ],
      ),
    );
  }
}

// Container(color: Colors.blue, height: 200),
// Container(color: Colors.yellow, height: 200),
// Container(color: Colors.black, height: 200),
// Container(color: Colors.red, height: 200),
// Container(color: Colors.green, height: 200),
// Container(color: Colors.purple, height: 200),
// Container(color: Colors.blue, width: 150),
// Container(color: Colors.yellow, width: 50),
// Container(color: Colors.black, width: 50),
// Container(color: Colors.red, width: 250),
// Container(color: Colors.green, width: 50),
// Container(color: Colors.purple, width:150),
