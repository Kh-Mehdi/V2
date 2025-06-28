import 'dart:typed_data';
// HTTP import supprimé car on utilise maintenant TensorFlow Lite local
// import 'package:http/http.dart' as http;
import 'unified_detection_service.dart';

// Version héritée pour compatibilité - redirige vers UnifiedDetectionService
class Detection {
  final String className;
  final double confidence;
  final Map<String, double> bbox;
  final Map<String, double>? center;

  Detection({
    required this.className,
    required this.confidence,
    required this.bbox,
    this.center,
  });

  // Convertir depuis UnifiedDetectionResult
  factory Detection.fromUnified(UnifiedDetectionResult unified) {
    return Detection(
      className: unified.className,
      confidence: unified.confidence,
      bbox: {
        'x': unified.bbox.length > 0 ? unified.bbox[0] : 0.0,
        'y': unified.bbox.length > 1 ? unified.bbox[1] : 0.0,
        'width': unified.bbox.length > 2 ? unified.bbox[2] : 0.0,
        'height': unified.bbox.length > 3 ? unified.bbox[3] : 0.0,
      },
      center: {
        'x': unified.bbox.length > 0
            ? unified.bbox[0] +
                (unified.bbox.length > 2 ? unified.bbox[2] / 2 : 0)
            : 0.0,
        'y': unified.bbox.length > 1
            ? unified.bbox[1] +
                (unified.bbox.length > 3 ? unified.bbox[3] / 2 : 0)
            : 0.0,
      },
    );
  }

  factory Detection.fromJson(Map<String, dynamic> json) {
    return Detection(
      className: json['class'],
      confidence: json['confidence'].toDouble(),
      bbox: Map<String, double>.from(json['bbox']),
      center: json['center'] != null
          ? Map<String, double>.from(json['center'])
          : null,
    );
  }
}

class DetectionResponse {
  final bool success;
  final List<Detection> detections;
  final String? error;
  final String? timestamp;

  DetectionResponse({
    required this.success,
    required this.detections,
    this.error,
    this.timestamp,
  });

  factory DetectionResponse.fromJson(Map<String, dynamic> json) {
    return DetectionResponse(
      success: json['success'] ?? false,
      detections: json['detections'] != null
          ? (json['detections'] as List)
              .map((d) => Detection.fromJson(d))
              .toList()
          : [],
      error: json['error'],
      timestamp: json['timestamp'],
    );
  }
}

// Service YOLO mis à jour pour utiliser UnifiedDetectionService (local)
class YOLODetectionService {
  static const String baseUrl =
      'local://unified-service'; // Plus de serveur HTTP

  // Vérifier l'état du service (maintenant local)
  static Future<bool> checkServerHealth() async {
    try {
      // Vérifier si le service unifié est initialisé
      bool isReady = UnifiedDetectionService.isReady;
      print('Service local status: ${isReady ? "✅ Ready" : "❌ Not ready"}');
      print('Current mode: ${UnifiedDetectionService.currentMode}');
      return isReady;
    } catch (e) {
      print('Erreur lors de la vérification du service local: $e');
      return false;
    }
  }

  // Détection depuis une image (maintenant local avec TensorFlow Lite)
  static Future<DetectionResponse> detectFromImage(Uint8List imageBytes) async {
    try {
      print('🔍 Détection locale avec UnifiedDetectionService...');

      final unifiedResults =
          await UnifiedDetectionService.detectFromBytes(imageBytes);

      // Convertir les résultats vers le format legacy
      final detections = unifiedResults
          .map((result) => Detection.fromUnified(result))
          .toList();

      print('✅ Détection locale réussie: ${detections.length} objets trouvés');

      return DetectionResponse(
        success: true,
        detections: detections,
        timestamp: DateTime.now().millisecondsSinceEpoch.toString(),
      );
    } catch (e) {
      print('❌ Erreur lors de la détection locale: $e');
      return DetectionResponse(
        success: false,
        detections: [],
        error: e.toString(),
      );
    }
  }

  // Détection temps réel (maintenant local)
  static Future<DetectionResponse> detectRealtime(
    Uint8List frameBytes, {
    String? timestamp,
  }) async {
    try {
      print('🎯 Détection temps réel locale...');

      final unifiedResults =
          await UnifiedDetectionService.detectFromBytes(frameBytes);

      final detections = unifiedResults
          .map((result) => Detection.fromUnified(result))
          .toList();

      return DetectionResponse(
        success: true,
        detections: detections,
        timestamp:
            timestamp ?? DateTime.now().millisecondsSinceEpoch.toString(),
      );
    } catch (e) {
      print('❌ Erreur lors de la détection temps réel locale: $e');
      return DetectionResponse(
        success: false,
        detections: [],
        error: e.toString(),
      );
    }
  }
}
