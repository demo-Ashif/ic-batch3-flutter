import 'package:flutter/material.dart';

class SecondScreen extends StatelessWidget {
  final String data;
  const SecondScreen({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Second Screen')),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
               Navigator.pop(context,'Data');
              },
              child: Text(data),
            ),
          ],
        ),
      ),
    );
  }
}
