import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'dart:typed_data';
import 'services/unified_detection_service.dart';
import 'utils/detection_popup_utils.dart';

class DiagnosticScreen extends StatefulWidget {
  @override
  _DiagnosticScreenState createState() => _DiagnosticScreenState();
}

class _DiagnosticScreenState extends State<DiagnosticScreen> {
  String _status = "Vérification en cours...";
  bool _isChecking = false;
  List<String> _logs = [];

  @override
  void initState() {
    super.initState();
    _runDiagnostic();
  }

  void _addLog(String message) {
    setState(() {
      _logs.add("${DateTime.now().toString().substring(11, 19)}: $message");
    });
    print(message);
  }

  Future<void> _runDiagnostic() async {
    setState(() {
      _isChecking = true;
      _logs.clear();
    });

    _addLog("🔍 Début du diagnostic du système local...");

    // Test 1: Vérification du service unifié
    _addLog("1️⃣ Test du service de détection unifié...");
    try {
      bool serviceReady = UnifiedDetectionService.isReady;
      if (serviceReady) {
        _addLog("   ✅ Service de détection: ACTIF");
        _addLog("   📊 Mode actuel: ${UnifiedDetectionService.currentMode}");
        _addLog(
            "   🏷️ Classes disponibles: ${UnifiedDetectionService.availableLabels.length}");
      } else {
        _addLog("   ❌ Service de détection: INACTIF");
        _addLog("   🔄 Tentative d'initialisation...");

        bool initResult = await UnifiedDetectionService.initialize();
        if (initResult) {
          _addLog("   ✅ Initialisation réussie!");
          _addLog("   📊 Mode: ${UnifiedDetectionService.currentMode}");
        } else {
          _addLog("   ❌ Échec de l'initialisation");
        }
      }
    } catch (e) {
      _addLog("   ❌ Erreur service: $e");
    }

    // Test 2: Test de détection avec données fictives
    _addLog("\\n2️⃣ Test de détection avec image factice...");
    try {
      // Créer des données d'image factices (1x1 pixel en RGBA)
      Uint8List fakeImageData =
          Uint8List.fromList([255, 0, 0, 255]); // Pixel rouge
      final results =
          await UnifiedDetectionService.detectFromBytes(fakeImageData);

      _addLog("   ✅ Test de détection exécuté");
      _addLog("   📊 Résultats: ${results.length} détections");

      for (var result in results) {
        _addLog(
            "   🎯 ${result.className}: ${(result.confidence * 100).toStringAsFixed(1)}% (${result.source})");
        
        // Afficher popup si confiance élevée
        if (result.confidence > 0.6) {
          _addLog("   ✅ Confiance élevée - Affichage du popup de détection");
          // Délai pour que l'utilisateur puisse lire les logs
          Future.delayed(Duration(seconds: 1), () {
            if (mounted) {
              DetectionPopupUtils.showDetectionDialog(context, result);
            }
          });
          break; // Afficher seulement la première détection
        }
      }
      
      if (results.isEmpty) {
        _addLog("   ℹ️ Aucune détection dans cette tentative");
      }
    } catch (e) {
      _addLog("   ❌ Erreur test détection: $e");
    }

    // Test 3: Informations sur la caméra
    _addLog("\\n3️⃣ Informations sur la caméra...");
    try {
      final cameras = await availableCameras();
      _addLog("   📱 Caméras détectées: ${cameras.length}");

      for (int i = 0; i < cameras.length; i++) {
        final camera = cameras[i];
        _addLog("   📷 Caméra $i: ${camera.name}");
        _addLog("      Direction: ${camera.lensDirection}");
      }
    } catch (e) {
      _addLog("   ❌ Erreur caméra: $e");
    }

    // Test 4: Vérification des assets
    _addLog("\\n4️⃣ Vérification des assets...");
    try {
      // Test de chargement des labels
      var labels = UnifiedDetectionService.availableLabels;
      _addLog("   🏷️ Labels chargés: ${labels.length}");
      _addLog(
          "   📋 Classes: ${labels.take(3).join(', ')}${labels.length > 3 ? '...' : ''}");
    } catch (e) {
      _addLog("   ❌ Erreur assets: $e");
    }

    // Résumé final
    _addLog("\\n✅ Diagnostic terminé!");

    setState(() {
      _isChecking = false;
      if (UnifiedDetectionService.isReady) {
        _status =
            "✅ Système opérationnel - Mode: ${UnifiedDetectionService.currentMode}";
      } else {
        _status = "⚠️ Problèmes détectés - Vérifiez les logs";
      }
    });
  }

  Future<void> _testDetectionWithPopup() async {
    _addLog("🧪 Test manuel de détection avec popup...");
    
    try {
      // Forcer une détection pour le test
      Uint8List testData = Uint8List.fromList([255, 255, 255, 255]);
      final results = await UnifiedDetectionService.detectFromBytes(testData);
      
      if (results.isNotEmpty) {
        _addLog("   ✅ Détection trouvée pour le test");
        DetectionPopupUtils.showDetectionDialog(context, results.first);
      } else {
        // Créer une détection factice pour le test
        final fakeDetection = UnifiedDetectionResult(
          className: 'panneau_stop',
          confidence: 0.85,
          bbox: [100.0, 100.0, 200.0, 200.0],
          source: 'test',
        );
        _addLog("   🧪 Création d'une détection factice pour le test");
        DetectionPopupUtils.showDetectionDialog(context, fakeDetection);
      }
    } catch (e) {
      _addLog("   ❌ Erreur test popup: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Diagnostic Système'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status principal
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _isChecking
                    ? Colors.orange.shade100
                    : _status.startsWith('✅')
                        ? Colors.green.shade100
                        : Colors.red.shade100,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: _isChecking
                      ? Colors.orange
                      : _status.startsWith('✅')
                          ? Colors.green
                          : Colors.red,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'État du Système',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    _status,
                    style: TextStyle(fontSize: 16),
                  ),
                  if (_isChecking)
                    Padding(
                      padding: EdgeInsets.only(top: 8),
                      child: LinearProgressIndicator(),
                    ),
                ],
              ),
            ),

            SizedBox(height: 20),

            // Boutons de contrôle
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                ElevatedButton.icon(
                  onPressed: _isChecking ? null : _runDiagnostic,
                  icon: Icon(Icons.refresh),
                  label: Text('Relancer le diagnostic'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    setState(() {
                      _logs.clear();
                    });
                  },
                  icon: Icon(Icons.clear),
                  label: Text('Effacer les logs'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey,
                    foregroundColor: Colors.white,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: _isChecking ? null : _testDetectionWithPopup,
                  icon: Icon(Icons.visibility),
                  label: Text('Test Popup'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),

            SizedBox(height: 20),

            // Logs
            Text(
              'Logs de Diagnostic',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),

            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ListView.builder(
                  itemCount: _logs.length,
                  itemBuilder: (context, index) {
                    String log = _logs[index];
                    Color textColor = Colors.black;

                    if (log.contains('✅')) {
                      textColor = Colors.green.shade700;
                    } else if (log.contains('❌')) {
                      textColor = Colors.red.shade700;
                    } else if (log.contains('⚠️')) {
                      textColor = Colors.orange.shade700;
                    } else if (log.contains('🔍') ||
                        log.contains('1️⃣') ||
                        log.contains('2️⃣') ||
                        log.contains('3️⃣') ||
                        log.contains('4️⃣')) {
                      textColor = Colors.blue.shade700;
                    }

                    return Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                      child: Text(
                        log,
                        style: TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 12,
                          color: textColor,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
