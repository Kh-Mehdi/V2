import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:camera/camera.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;

class DetectionResult {
  final String className;
  final double confidence;
  final List<double> bbox;

  DetectionResult({
    required this.className,
    required this.confidence,
    required this.bbox,
  });
}

class TFLiteDetectionService {
  static Interpreter? _interpreter;
  static List<String>? _labels;
  static bool _isInitialized = false;

  // Initialiser le modèle TensorFlow Lite
  static Future<bool> initialize() async {
    try {
      print('🔄 Initialisation du modèle TensorFlow Lite...');

      // Charger le modèle
      _interpreter = await Interpreter.fromAsset('assets/best_93.tflite');

      // Charger les labels (classes de panneaux)
      await _loadLabels();

      _isInitialized = true;
      print('✅ Modèle TensorFlow Lite initialisé avec succès');
      return true;
    } catch (e) {
      print('❌ Erreur lors de l\'initialisation: $e');
      return false;
    }
  }

  static Future<void> _loadLabels() async {
    try {
      // Essayer de charger les labels depuis assets
      String labelsData = await rootBundle.loadString('assets/labels.txt');
      _labels =
          labelsData.split('\n').where((label) => label.isNotEmpty).toList();
    } catch (e) {
      // Labels par défaut si le fichier n'existe pas
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

  // Vérifier si le service est prêt
  static bool get isReady => _isInitialized && _interpreter != null;

  // Détecter les objets dans une image de caméra
  static Future<List<DetectionResult>> detectFromCamera(
      CameraImage cameraImage) async {
    if (!isReady) {
      print('❌ Service non initialisé');
      return [];
    }

    try {
      // Convertir CameraImage en format compatible
      var inputImage = _processCameraImage(cameraImage);

      // Préparer les tenseurs d'entrée et de sortie
      var input = _preprocessImage(inputImage);
      var output = List.filled(1 * 25200 * 85, 0.0).reshape([1, 25200, 85]);

      // Exécuter l'inférence
      _interpreter!.run(input, output);

      // Post-traiter les résultats
      return _postProcessResults(output);
    } catch (e) {
      print('❌ Erreur lors de la détection: $e');
      return [];
    }
  }

  // Détecter depuis des bytes d'image
  static Future<List<DetectionResult>> detectFromBytes(
      Uint8List imageBytes) async {
    if (!isReady) {
      print('❌ Service non initialisé');
      return [];
    }

    try {
      // Décoder l'image
      img.Image? image = img.decodeImage(imageBytes);
      if (image == null) return [];

      // Redimensionner à 640x640 (taille YOLOv5)
      image = img.copyResize(image, width: 640, height: 640);

      // Préparer l'entrée
      var input = _imageToInput(image);
      var output = List.filled(1 * 25200 * 85, 0.0).reshape([1, 25200, 85]);

      // Exécuter l'inférence
      _interpreter!.run(input, output);

      // Post-traiter les résultats
      return _postProcessResults(output);
    } catch (e) {
      print('❌ Erreur lors de la détection: $e');
      return [];
    }
  }

  // Convertir CameraImage en format utilisable
  static img.Image _processCameraImage(CameraImage cameraImage) {
    // Conversion simplifiée - à adapter selon le format de votre caméra
    var bytes = cameraImage.planes[0].bytes;
    return img.Image.fromBytes(
      width: cameraImage.width,
      height: cameraImage.height,
      bytes: bytes.buffer,
      format: img.Format.uint8,
    );
  }

  // Préprocesser l'image pour le modèle
  static List<List<List<List<double>>>> _imageToInput(img.Image image) {
    var input = List.generate(
      1,
      (i) => List.generate(
        640,
        (y) => List.generate(
          640,
          (x) => List.generate(3, (c) => 0.0),
        ),
      ),
    );

    for (int y = 0; y < 640; y++) {
      for (int x = 0; x < 640; x++) {
        var pixel = image.getPixel(x, y);
        input[0][y][x][0] = pixel.r / 255.0; // R
        input[0][y][x][1] = pixel.g / 255.0; // G
        input[0][y][x][2] = pixel.b / 255.0; // B
      }
    }

    return input;
  }

  // Préprocesser l'image de la caméra
  static List<List<List<List<double>>>> _preprocessImage(img.Image image) {
    // Redimensionner l'image à 640x640
    var resized = img.copyResize(image, width: 640, height: 640);
    return _imageToInput(resized);
  }

  // Post-traiter les résultats du modèle
  static List<DetectionResult> _postProcessResults(List output) {
    List<DetectionResult> detections = [];

    double confidenceThreshold = 0.5;

    try {
      // Parcourir les détections
      for (int i = 0; i < 25200; i++) {
        var detection = output[0][i];

        // Vérifier la confiance
        double objectness = detection[4];
        if (objectness < confidenceThreshold) continue;

        // Extraire les coordonnées
        double x = detection[0];
        double y = detection[1];
        double w = detection[2];
        double h = detection[3];

        // Trouver la classe avec la plus haute probabilité
        double maxClassProb = 0.0;
        int maxClassIndex = 0;

        for (int j = 5; j < 85; j++) {
          double classProb = detection[j];
          if (classProb > maxClassProb) {
            maxClassProb = classProb;
            maxClassIndex = j - 5;
          }
        }

        double finalConfidence = objectness * maxClassProb;
        if (finalConfidence < confidenceThreshold) continue;

        // Créer le résultat
        String className = maxClassIndex < _labels!.length
            ? _labels![maxClassIndex]
            : 'Unknown';

        detections.add(DetectionResult(
          className: className,
          confidence: finalConfidence,
          bbox: [x - w / 2, y - h / 2, x + w / 2, y + h / 2],
        ));
      }
    } catch (e) {
      print('❌ Erreur post-processing: $e');
    }

    return detections;
  }

  // Nettoyer les ressources
  static void dispose() {
    _interpreter?.close();
    _interpreter = null;
    _isInitialized = false;
  }
}
