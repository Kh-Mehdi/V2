
import 'package:flutter/material.dart';
import 'package:interfaces/home_screen.dart';
import 'subscription_options_screen.dart';

class AlertScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.warning_amber_rounded, size: 80),
            SizedBox(height: 10),
            Text("Alert!", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            Text("To use this app you need to get a subscription"),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomeScreen()));
              },
              child: Text("Show options"),
            )
          ],
        ),
      ),
    );
  }
}
