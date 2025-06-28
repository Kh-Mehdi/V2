import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;

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

class YOLODetectionService {
  static const String baseUrl =
      'http://localhost:5000'; // Changez l'IP si nécessaire

  static Future<bool> checkServerHealth() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/health'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['model_loaded'] == true;
      }
      return false;
    } catch (e) {
      print('Erreur de connexion au serveur: $e');
      return false;
    }
  }

  static Future<DetectionResponse> detectFromImage(Uint8List imageBytes) async {
    try {
      final base64Image = base64Encode(imageBytes);

      final response = await http
          .post(
            Uri.parse('$baseUrl/detect'),
            headers: {'Content-Type': 'application/json'},
            body: json.encode({
              'image': base64Image,
            }),
          )
          .timeout(const Duration(seconds: 10));

      final responseData = json.decode(response.body);
      return DetectionResponse.fromJson(responseData);
    } catch (e) {
      print('Erreur lors de la détection: $e');
      return DetectionResponse(
        success: false,
        detections: [],
        error: e.toString(),
      );
    }
  }

  static Future<DetectionResponse> detectRealtime(
    Uint8List frameBytes, {
    String? timestamp,
  }) async {
    try {
      final base64Frame = base64Encode(frameBytes);

      final response = await http
          .post(
            Uri.parse('$baseUrl/detect_realtime'),
            headers: {'Content-Type': 'application/json'},
            body: json.encode({
              'frame': base64Frame,
              'timestamp':
                  timestamp ?? DateTime.now().millisecondsSinceEpoch.toString(),
            }),
          )
          .timeout(const Duration(seconds: 3));

      final responseData = json.decode(response.body);
      return DetectionResponse.fromJson(responseData);
    } catch (e) {
      print('Erreur lors de la détection temps réel: $e');
      return DetectionResponse(
        success: false,
        detections: [],
        error: e.toString(),
      );
    }
  }
}
