import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'dart:typed_data';
import 'dart:async';
import 'widgets/camera_preview.dart';
import 'panneau_detected_screen.dart';
import 'panneau_detail_screen.dart';
import 'services/offline_detection_service.dart';
import 'diagnostic_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late CameraController _cameraController;
  bool _isCameraInitialized = false;
  bool _isDetecting = false;
  bool _offlineServiceReady = false;
  Timer? _detectionTimer;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    _initializeOfflineService();
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    _cameraController = CameraController(
      cameras.first,
      ResolutionPreset
          .medium, // Résolution plus basse pour de meilleures performances
    );
    await _cameraController.initialize();
    setState(() => _isCameraInitialized = true);

    if (_offlineServiceReady) {
      _startRealTimeDetection();
    }
  }

  Future<void> _initializeOfflineService() async {
    final isReady = await OfflineDetectionService.initialize();
    setState(() => _offlineServiceReady = isReady);

    if (!isReady) {
      _showServiceError();
    } else if (_isCameraInitialized) {
      _startRealTimeDetection();
    }
  }

  void _showServiceError() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
            'Erreur lors de l\'initialisation du service de détection hors ligne.'),
        backgroundColor: Colors.orange,
        duration: Duration(seconds: 3),
      ),
    );
  }

  void _startRealTimeDetection() {
    if (_isDetecting || !_isCameraInitialized || !_offlineServiceReady) {
      print('❌ Impossible de démarrer la détection:');
      print('   - isDetecting: $_isDetecting');
      print('   - isCameraInitialized: $_isCameraInitialized');
      print('   - offlineServiceReady: $_offlineServiceReady');
      return;
    }

    print('✅ Démarrage de la détection automatique toutes les 2 secondes...');
    _detectionTimer = Timer.periodic(const Duration(seconds: 2), (timer) async {
      if (!_isDetecting && mounted) {
        print('⏰ Déclenchement automatique de la détection...');
        await _detectFromCurrentFrame();
      }
    });
  }

  Future<void> _detectFromCurrentFrame() async {
    if (_isDetecting || !_cameraController.value.isInitialized) return;

    setState(() => _isDetecting = true);
    print('🔍 Démarrage de la détection...');

    try {
      final image = await _cameraController.takePicture();
      final bytes = await image.readAsBytes();
      print('📸 Image capturée: ${bytes.length} bytes');

      final detections = await OfflineDetectionService.detectFromBytes(bytes);
      print('🎯 Détections trouvées: ${detections.length}');

      for (final detection in detections) {
        print(
            '   - ${detection.className}: ${(detection.confidence * 100).toStringAsFixed(1)}%');
      }

      if (detections.isNotEmpty) {
        _showDetectionResults(detections);
      } else {
        print('❌ Aucune détection');
      }
    } catch (e) {
      print('❌ Erreur lors de la capture/détection: $e');
    } finally {
      if (mounted) {
        setState(() => _isDetecting = false);
      }
    }
  }

  void _showDetectionResults(List<OfflineDetectionResult> detections) {
    print('🔍 Analyse des détections...');
    for (final detection in detections) {
      print(
          '   Évaluation: ${detection.className} - ${(detection.confidence * 100).toStringAsFixed(1)}%');
      if (detection.confidence > 0.6) {
        print('✅ Détection validée! Affichage du popup...');
        // Seuil de confiance élevé pour éviter les faux positifs
        _showDetectionPopup(detection);
        break; // Afficher seulement la première détection avec haute confiance
      } else {
        print('❌ Confiance trop faible (seuil: 60%)');
      }
    }
  }

  void _showDetectionPopup(OfflineDetectionResult detection) {
    showOverlayNotification((context) {
      return PanneauDetectedScreen(
        panneauName: detection.className,
        confidence: detection.confidence,
        onDetailsPressed: () => _navigateToDetails(context, detection),
      );
    });
  }

  void _navigateToDetails(
      BuildContext context, OfflineDetectionResult detection) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PanneauDetailScreen(
          panneauName: detection.className,
          description:
              "Panneau détecté avec ${(detection.confidence * 100).toStringAsFixed(1)}% de confiance",
          confidence: detection.confidence,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _detectionTimer?.cancel();
    _cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Détection en Temps Réel"),
        actions: [
          IconButton(
            icon: Icon(Icons.settings_outlined),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => DiagnosticScreen()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Indicateur de statut
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(8),
            color: _offlineServiceReady ? Colors.blue[100] : Colors.orange[100],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  _offlineServiceReady ? Icons.offline_bolt : Icons.warning,
                  color: _offlineServiceReady ? Colors.blue : Colors.orange,
                  size: 16,
                ),
                SizedBox(width: 8),
                Text(
                  _offlineServiceReady
                      ? "🚀 Mode hors ligne - Détection locale active"
                      : "⚠️ Service de détection en cours d'initialisation",
                  style: TextStyle(
                    color: _offlineServiceReady
                        ? Colors.blue[800]
                        : Colors.orange[800],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          // Vue caméra
          Expanded(
            child: _isCameraInitialized
                ? CameraPreviewWidget(controller: _cameraController)
                : const Center(child: CircularProgressIndicator()),
          ),
          // Boutons d'action
          Container(
            padding: EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: _offlineServiceReady
                      ? () async {
                          print('🔴 TEST MANUEL FORCE');
                          await _detectFromCurrentFrame();
                        }
                      : null,
                  icon: Icon(Icons.search, color: Colors.red),
                  label: Text("TEST DÉTECTION"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red[100],
                    foregroundColor: Colors.red[800],
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: _initializeOfflineService,
                  icon: Icon(Icons.refresh),
                  label: Text("Réinitialiser"),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DiagnosticScreen()),
                    );
                  },
                  icon: Icon(Icons.bug_report),
                  label: Text("Diagnostic"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
