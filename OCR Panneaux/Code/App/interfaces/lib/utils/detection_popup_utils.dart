import 'package:flutter/material.dart';
import '../services/unified_detection_service.dart';
import '../panneau_detail_screen.dart';

class DetectionPopupUtils {
  
  /// Affiche un popup d'alerte pour une détection de panneau
  /// avec option de voir les détails
  static void showDetectionDialog(
    BuildContext context, 
    UnifiedDetectionResult detection,
  ) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.warning_amber, color: Colors.orange, size: 28),
              SizedBox(width: 10),
              Text("Panneau Détecté!", style: TextStyle(fontSize: 20)),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset('assets/logo.png', height: 80),
              SizedBox(height: 15),
              Text(
                detection.className.replaceAll('_', ' ').toUpperCase(),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[800],
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10),
              Text(
                "Confiance: ${(detection.confidence * 100).toStringAsFixed(1)}%",
                style: TextStyle(
                  fontSize: 16,
                  color: detection.confidence > 0.7 ? Colors.green : Colors.orange,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 8),
              Text(
                "Source: ${detection.source}",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("Fermer"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _navigateToDetails(context, detection);
              },
              child: Text("Voir Détails"),
            ),
          ],
        );
      },
    );
  }

  /// Navigation vers l'écran de détail d'un panneau
  static void _navigateToDetails(
    BuildContext context, 
    UnifiedDetectionResult detection,
  ) {
    String description = _getPanneauDescription(detection);
    
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PanneauDetailScreen(
          panneauName: detection.className.replaceAll('_', ' ').toUpperCase(),
          description: description,
          confidence: detection.confidence,
        ),
      ),
    );
  }

  /// Génère une description riche basée sur le type de panneau
  static String _getPanneauDescription(UnifiedDetectionResult detection) {
    String className = detection.className.toLowerCase();
    switch (className) {
      case 'panneau_stop':
        return "PANNEAU STOP - Arrêt obligatoire. Marquez l'arrêt complet avant de céder le passage aux autres véhicules ayant la priorité.";
      case 'panneau_vitesse_30':
        return "LIMITATION DE VITESSE 30 KM/H - Respectez cette limitation dans cette zone, souvent située près d'écoles ou zones résidentielles.";
      case 'panneau_vitesse_50':
        return "LIMITATION DE VITESSE 50 KM/H - Vitesse maximale autorisée de 50 km/h dans cette zone urbaine.";
      case 'panneau_vitesse_90':
        return "LIMITATION DE VITESSE 90 KM/H - Vitesse maximale autorisée de 90 km/h sur cette portion de route.";
      case 'panneau_direction_droite':
        return "OBLIGATION DE TOURNER À DROITE - Direction obligatoire vers la droite à ce carrefour.";
      case 'panneau_direction_gauche':
        return "OBLIGATION DE TOURNER À GAUCHE - Direction obligatoire vers la gauche à ce carrefour.";
      case 'panneau_interdiction_stationnement':
        return "INTERDICTION DE STATIONNER - Le stationnement est interdit dans cette zone. Risque d'amende et de mise en fourrière.";
      case 'panneau_obligation_droite':
        return "OBLIGATION DE SERRER À DROITE - Circulez sur la partie droite de la chaussée.";
      case 'panneau_danger_virage':
        return "DANGER - VIRAGE - Attention, virage dangereux à l'approche. Réduisez votre vitesse et adaptez votre conduite.";
      case 'panneau_priorite':
        return "PRIORITÉ - Vous avez la priorité de passage. Restez vigilant aux autres usagers.";
      default:
        return "Panneau de signalisation détecté avec ${(detection.confidence * 100).toStringAsFixed(1)}% de confiance par le système de détection ${detection.source}. Respectez les indications de ce panneau pour une conduite sécurisée.";
    }
  }

  /// Affiche un snackbar simple pour une détection
  static void showDetectionSnackbar(
    BuildContext context, 
    UnifiedDetectionResult detection,
  ) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.warning_amber, color: Colors.white),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                '${detection.className.replaceAll('_', ' ')}: ${(detection.confidence * 100).toStringAsFixed(1)}%',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
        backgroundColor: detection.confidence > 0.7 ? Colors.green : Colors.orange,
        duration: Duration(seconds: 3),
        action: SnackBarAction(
          label: 'Détails',
          textColor: Colors.white,
          onPressed: () => _navigateToDetails(context, detection),
        ),
      ),
    );
  }
}
