import 'package:flutter/material.dart';
import 'package:interfaces/payment_screen.dart';

class SubscriptionOptionsScreen extends StatelessWidget {
  const SubscriptionOptionsScreen({super.key});

  void _showPaymentPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        insetPadding: const EdgeInsets.all(20),
        child: SizedBox(
          width: 400,
          height: 250,
          child: const PaymentPage(), // ta page de paiement ici
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/logo.png', width: 80),
            const SizedBox(height: 20),
            const Text(
              "Explication des 2 options d’abonnement...",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                subscriptionBox("Monthly", "\$20.00", "Billed Monthly"),
                subscriptionBox("Yearly", "\$200.00", "Free 1 Week Trial\nSave \$40.00")
              ],
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () => _showPaymentPopup(context),
              child: const Text("Subscribe >"),
            )
          ],
        ),
      ),
    );
  }

  Widget subscriptionBox(String title, String price, String desc) {
    return Container(
      width: 140,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blue),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(price, style: const TextStyle(fontSize: 18)),
          Text(desc, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
