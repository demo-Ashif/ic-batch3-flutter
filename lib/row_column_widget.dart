import 'package:flutter/material.dart';

class RowColumnWidget extends StatelessWidget {
  const RowColumnWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Wrap Alignment Demo')),
      body: Container(
        color: Colors.grey[200],
        width: double.infinity,
        height: 300,
        child: Wrap(
          spacing: 12,
          runSpacing: 12,
          alignment: WrapAlignment.center,
          runAlignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.end,
          children: [
            Container(color: Colors.red, height: 40, width: 80),
            Container(color: Colors.green, height: 60, width: 80),
            Container(color: Colors.blue, height: 30, width: 80),
            Container(color: Colors.orange, height: 50, width: 80),
            Container(color: Colors.purple, height: 70, width: 80),
            Container(color: Colors.cyan, height: 40, width: 80),
          ],
        ),
      ),
    )
    ;
  }
}
