import 'package:flutter/material.dart';
import 'package:ic_batch3_flutter_classes/main.dart';
import 'package:ic_batch3_flutter_classes/second_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home')),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () async {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => SecondScreen()),
                // );

                // Navigator.pushReplacementNamed(
                //   context,
                //   '/second',
                //   arguments: ScreenArguments('Hello Ashif!'),
                // );

                final result = await Navigator.pushNamed(
                  context,
                  '/second',
                  arguments: ScreenArguments('Hello Ashif!'),
                );

                if (result != null) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text('Received: $result')));
                }
              },
              child: Text('Go to Second Screen'),
            ),
          ],
        ),
      ),
    );
  }
}
