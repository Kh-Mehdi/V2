import 'package:flutter/material.dart';

class PanneauDetectedScreen extends StatelessWidget {
  final String panneauName;
  final double confidence;
  final VoidCallback onDetailsPressed;

  const PanneauDetectedScreen({
    super.key,
    required this.panneauName,
    required this.confidence,
    required this.onDetailsPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(20),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Panneau Détecté",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 15),
            Image.asset('assets/logo.png', height: 100),
            const SizedBox(height: 10),
            Text(panneauName,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 5),
            Text(
              "Confiance: ${(confidence * 100).toStringAsFixed(1)}%",
              style: TextStyle(
                fontSize: 16,
                color: confidence > 0.7 ? Colors.green : Colors.orange,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: onDetailsPressed,
              child: const Text("Plus de détails"),
            ),
          ],
        ),
      ),
    );
  }
}
