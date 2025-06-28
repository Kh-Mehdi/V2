import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  bool _isProcessing = false;

  Future<void> _simulatePayment() async {
    setState(() {
      _isProcessing = true;
    });

    try {
      // Simulation d'un processus de paiement local
      await Future.delayed(Duration(seconds: 2));

      // Afficher un dialogue de succès
      if (mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.green),
                  SizedBox(width: 8),
                  Text('Paiement Simulé'),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('✅ Paiement de 10 USD simulé avec succès'),
                  SizedBox(height: 8),
                  Text('🎯 Fonctionnalités débloquées:',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text('• Détection avancée illimitée'),
                  Text('• Sauvegarde des résultats'),
                  Text('• Mode premium activé'),
                  SizedBox(height: 12),
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade100,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      '💡 Mode démo: Dans une vraie application, intégrez Stripe ou un autre service de paiement.',
                      style:
                          TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Fermer le dialogue
                    Navigator.of(context)
                        .pop(); // Retourner à l'écran précédent
                  },
                  child: Text('Continuer'),
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Erreur de simulation: $e")),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  Future<void> _openStripeInfo() async {
    // Ouvrir une page d'information sur Stripe pour les développeurs
    const url = 'https://stripe.com/docs/checkout/quickstart';
    final uri = Uri.parse(url);

    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Impossible d'ouvrir le lien Stripe")),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Erreur: $e")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Paiement")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.payment,
              size: 80,
              color: Colors.blue,
            ),
            SizedBox(height: 20),
            Text(
              'Service Premium',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Débloquez toutes les fonctionnalités avancées',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 30),
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blue),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  Text('✅ Détection illimitée'),
                  Text('✅ Sauvegarde des résultats'),
                  Text('✅ Mode premium'),
                  Text('✅ Support prioritaire'),
                ],
              ),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: _isProcessing ? null : _simulatePayment,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                textStyle: TextStyle(fontSize: 18),
              ),
              child: _isProcessing
                  ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                        SizedBox(width: 10),
                        Text("Traitement..."),
                      ],
                    )
                  : Text("Payer 10 USD (Simulation)"),
            ),
            SizedBox(height: 20),
            TextButton(
              onPressed: _openStripeInfo,
              child: Text(
                'ℹ️ Voir la documentation Stripe',
                style: TextStyle(fontSize: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
