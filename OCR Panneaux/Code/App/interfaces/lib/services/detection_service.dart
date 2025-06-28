import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:camera/camera.dart';

class DetectionResult {
  final String className;
  final double confidence;
  final Map<String, double> bbox;
  final Map<String, double>? center;

  DetectionResult({
    required this.className,
    required this.confidence,
    required this.bbox,
    this.center,
  });

  factory DetectionResult.fromJson(Map<String, dynamic> json) {
    return DetectionResult(
      className: json['class'] ?? '',
      confidence: (json['confidence'] ?? 0.0).toDouble(),
      bbox: Map<String, double>.from(json['bbox'] ?? {}),
      center: json['center'] != null
          ? Map<String, double>.from(json['center'])
          : null,
    );
  }
}

class DetectionService {
  static const String baseUrl = 'http://localhost:5000';

  // Debug mode pour plus de logs
  static bool debugMode = true;

  static void _log(String message) {
    if (debugMode) {
      print('[DetectionService] $message');
    }
  }

  // Test de connexion au serveur
  static Future<bool> checkServerHealth() async {
    try {
      _log('Tentative de connexion à $baseUrl/health...');
      final response = await http.get(
        Uri.parse('$baseUrl/health'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(const Duration(seconds: 5));

      _log('Response status: ${response.statusCode}');
      _log('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        bool modelLoaded = data['model_loaded'] == true;
        _log('Model loaded: $modelLoaded');
        return modelLoaded;
      }
      _log('Server returned status: ${response.statusCode}');
      return false;
    } catch (e) {
      _log('Erreur de connexion au serveur: $e');
      return false;
    }
  }

  // Détection sur une image
  static Future<List<DetectionResult>> detectFromImage(
      Uint8List imageBytes) async {
    try {
      // Encoder l'image en base64
      String base64Image = base64Encode(imageBytes);

      final response = await http
          .post(
            Uri.parse('$baseUrl/detect'),
            headers: {'Content-Type': 'application/json'},
            body: json.encode({
              'image': base64Image,
            }),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          List<DetectionResult> results = [];
          for (var detection in data['detections']) {
            results.add(DetectionResult.fromJson(detection));
          }
          return results;
        }
      }

      throw Exception('Erreur de détection: ${response.body}');
    } catch (e) {
      print('Erreur lors de la détection: $e');
      throw Exception('Impossible de se connecter au serveur de détection');
    }
  }

  // Détection en temps réel depuis la caméra
  static Future<List<DetectionResult>> detectRealtime(Uint8List frameBytes,
      {String? timestamp}) async {
    try {
      String base64Frame = base64Encode(frameBytes);

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

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          List<DetectionResult> results = [];
          for (var detection in data['detections']) {
            results.add(DetectionResult.fromJson(detection));
          }
          return results;
        }
      }

      return [];
    } catch (e) {
      print('Erreur détection temps réel: $e');
      return [];
    }
  }

  // Convertir CameraImage en Uint8List
  static Uint8List convertCameraImageToBytes(CameraImage image) {
    try {
      if (image.format.group == ImageFormatGroup.yuv420) {
        return _convertYUV420ToBytes(image);
      } else if (image.format.group == ImageFormatGroup.bgra8888) {
        return _convertBGRA8888ToBytes(image);
      } else {
        throw UnsupportedError(
            'Format d\'image non supporté: ${image.format.group}');
      }
    } catch (e) {
      print('Erreur conversion image: $e');
      return Uint8List(0);
    }
  }

  static Uint8List _convertYUV420ToBytes(CameraImage image) {
    final int width = image.width;
    final int height = image.height;
    final int uvRowStride = image.planes[1].bytesPerRow;
    final int uvPixelStride = image.planes[1].bytesPerPixel!;

    // Créer une image RGB
    var img = List<int>.filled(width * height * 3, 0);

    for (int x = 0; x < width; x++) {
      for (int y = 0; y < height; y++) {
        final int uvIndex =
            uvPixelStride * (x / 2).floor() + uvRowStride * (y / 2).floor();
        final int index = y * width + x;

        final yp = image.planes[0].bytes[index];
        final up = image.planes[1].bytes[uvIndex];
        final vp = image.planes[2].bytes[uvIndex];

        // Conversion YUV vers RGB
        int r = (yp + vp * 1436 / 1024 - 179).round().clamp(0, 255);
        int g = (yp - up * 46549 / 131072 + 44 - vp * 93604 / 131072 + 91)
            .round()
            .clamp(0, 255);
        int b = (yp + up * 1814 / 1024 - 227).round().clamp(0, 255);

        img[index * 3] = r;
        img[index * 3 + 1] = g;
        img[index * 3 + 2] = b;
      }
    }

    return Uint8List.fromList(img);
  }

  static Uint8List _convertBGRA8888ToBytes(CameraImage image) {
    return image.planes[0].bytes;
  }
}
