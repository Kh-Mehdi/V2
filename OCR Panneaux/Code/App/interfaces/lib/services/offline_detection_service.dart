import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:camera/camera.dart';

// Version simplifiée pour le mode hors ligne sans dépendances externes
class OfflineDetectionResult {
  final String className;
  final double confidence;
  final List<double> bbox;

  OfflineDetectionResult({
    required this.className,
    required this.confidence,
    required this.bbox,
  });
}

class OfflineDetectionService {
  static bool _isInitialized = false;
  static List<String> _labels = [];

  // Initialiser le service hors ligne
  static Future<bool> initialize() async {
    try {
      print('🔄 Initialisation du service de détection hors ligne...');

      // Charger les labels
      await _loadLabels();

      _isInitialized = true;
      print('✅ Service hors ligne initialisé avec succès');
      return true;
    } catch (e) {
      print('❌ Erreur lors de l\'initialisation: $e');
      return false;
    }
  }

  static Future<void> _loadLabels() async {
    try {
      String labelsData = await rootBundle.loadString('assets/labels.txt');
      _labels =
          labelsData.split('\n').where((label) => label.isNotEmpty).toList();
      print('✅ Labels chargés: ${_labels.length} classes');
    } catch (e) {
      // Labels par défaut
      _labels = [
        'panneau_stop',
        'panneau_vitesse',
        'panneau_direction',
        'panneau_interdiction',
        'panneau_obligation'
      ];
      print('⚠️ Labels par défaut utilisés');
    }
  }

  // Simulation de détection pour le mode hors ligne
  // Cette fonction sera remplacée par TensorFlow Lite une fois le modèle converti
  static Future<List<OfflineDetectionResult>> detectFromCamera(
      CameraImage cameraImage) async {
    if (!_isInitialized) {
      print('❌ Service non initialisé');
      return [];
    }

    try {
      // Simulation d'une détection améliorée
      await Future.delayed(
          Duration(milliseconds: 50)); // Simule un traitement plus rapide

      // Simulation plus réaliste avec détection fréquente
      if (_shouldSimulateDetection()) {
        return [
          OfflineDetectionResult(
            className: _getRandomLabel(),
            confidence: 0.75 +
                (DateTime.now().millisecondsSinceEpoch % 20) / 100, // 0.75-0.95
            bbox: [100.0, 100.0, 200.0, 200.0],
          )
        ];
      }

      return [];
    } catch (e) {
      print('❌ Erreur lors de la détection: $e');
      return [];
    }
  }

  // Détecter depuis des bytes d'image
  static Future<List<OfflineDetectionResult>> detectFromBytes(
      Uint8List imageBytes) async {
    if (!_isInitialized) {
      print('❌ Service non initialisé');
      return [];
    }

    try {
      // Simulation de détection sur image améliorée
      await Future.delayed(Duration(milliseconds: 100));

      if (_shouldSimulateDetection()) {
        return [
          OfflineDetectionResult(
            className: _getRandomLabel(),
            confidence: 0.70 +
                (DateTime.now().millisecondsSinceEpoch % 25) / 100, // 0.70-0.95
            bbox: [150.0, 150.0, 250.0, 250.0],
          )
        ];
      }

      return [];
    } catch (e) {
      print('❌ Erreur lors de la détection: $e');
      return [];
    }
  }

  // Utilitaires pour la simulation
  static bool _shouldSimulateDetection() {
    // FORCER la détection pour le debug - toujours retourner true
    print('🎲 Simulation forcée: TOUJOURS DÉTECTER pour debug');
    return true; // Force toujours une détection pour le debug
  }

  static String _getRandomLabel() {
    if (_labels.isEmpty) return 'panneau_vitesse_30';

    // Simulation plus réaliste : favorise certains panneaux de signalisation
    List<String> commonSigns = [
      'panneau_vitesse_30',
      'panneau_vitesse_50',
      'panneau_stop',
      'panneau_direction',
      'panneau_interdiction'
    ];

    int index =
        (DateTime.now().millisecondsSinceEpoch ~/ 1000) % commonSigns.length;
    return commonSigns[index];
  }

  // Vérifier si le service est prêt
  static bool get isReady => _isInitialized;

  // Obtenir le nombre de classes
  static int get numberOfClasses => _labels.length;

  // Obtenir toutes les classes
  static List<String> get allClasses => List.from(_labels);

  // Nettoyer les ressources
  static void dispose() {
    _isInitialized = false;
    _labels.clear();
  }
}
