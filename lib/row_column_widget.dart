import 'package:flutter/material.dart';

class RowColumnWidget extends StatelessWidget {
  const RowColumnWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        child: Column(
          children: [
            Container(),
            Container(),
          ],
        ),
      )
    );
  }
}
