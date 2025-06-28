import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  Future<void> _redirectToStripeCheckout() async {
    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:3000/create-checkout-session'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        final checkoutUrl = jsonResponse['url'];
        final uri = Uri.parse(checkoutUrl);

        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        } else {
          throw 'Impossible d\'ouvrir le lien : \$checkoutUrl';
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Erreur Stripe: \${response.body}")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur: \$e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Paiement")),
      body: Center(
        child: ElevatedButton(
          onPressed: _redirectToStripeCheckout,
          child: const Text("Payer 10 USD"),
        ),
      ),
    );
  }
}
