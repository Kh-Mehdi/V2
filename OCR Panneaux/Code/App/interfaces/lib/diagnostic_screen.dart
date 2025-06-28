import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

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

    _addLog("🔍 Début du diagnostic...");

    // Test 1: Ping du serveur
    _addLog("1️⃣ Test de connexion au serveur Flask...");
    try {
      final response = await http.get(
        Uri.parse('http://localhost:5000/health'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(const Duration(seconds: 5));

      _addLog("   Response code: ${response.statusCode}");
      _addLog("   Response body: ${response.body}");

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['model_loaded'] == true) {
          _addLog("✅ Serveur connecté et modèle chargé!");
        } else {
          _addLog("⚠️ Serveur connecté mais modèle non chargé");
        }
      } else {
        _addLog("❌ Serveur non accessible (code: ${response.statusCode})");
      }
    } catch (e) {
      _addLog("❌ Erreur de connexion: $e");
      _addLog("💡 Le serveur Flask n'est probablement pas démarré");
    }

    // Test 2: Test avec une image factice
    _addLog("\n2️⃣ Test de détection avec image factice...");
    try {
      // Créer une image factice (1x1 pixel noir)
      List<int> fakeImageBytes = [0, 0, 0]; // RGB noir
      String base64Image = base64Encode(fakeImageBytes);

      final response = await http
          .post(
            Uri.parse('http://localhost:5000/detect'),
            headers: {'Content-Type': 'application/json'},
            body: json.encode({'image': base64Image}),
          )
          .timeout(const Duration(seconds: 10));

      _addLog("   Detection response: ${response.statusCode}");
      _addLog("   Detection body: ${response.body}");

      if (response.statusCode == 200) {
        _addLog("✅ Endpoint de détection fonctionne");
      } else {
        _addLog("❌ Erreur dans l'endpoint de détection");
      }
    } catch (e) {
      _addLog("❌ Erreur test détection: $e");
    }

    // Test 3: Vérifier les permissions caméra
    _addLog("\n3️⃣ Informations sur la caméra...");
    try {
      final cameras = await availableCameras();
      _addLog("   Nombre de caméras: ${cameras.length}");
      for (int i = 0; i < cameras.length; i++) {
        _addLog(
            "   Caméra $i: ${cameras[i].name} (${cameras[i].lensDirection})");
      }
    } catch (e) {
      _addLog("❌ Erreur accès caméra: $e");
      _addLog("💡 Vérifiez les permissions caméra dans l'app");
    }

    setState(() {
      _isChecking = false;
      _status = "Diagnostic terminé";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Diagnostic de connexion"),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _isChecking ? null : _runDiagnostic,
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Row(
                  children: [
                    if (_isChecking)
                      CircularProgressIndicator()
                    else
                      Icon(Icons.info, color: Colors.blue),
                    SizedBox(width: 10),
                    Text(_status,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            Text("Logs de diagnostic:",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Expanded(
              child: Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: SingleChildScrollView(
                  child: Text(
                    _logs.join('\n'),
                    style: TextStyle(fontFamily: 'monospace', fontSize: 12),
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.orange[200]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("🛠️ Solutions possibles:",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  Text("1. Démarrer le serveur Flask:"),
                  Text("   cd back_detection && python app.py",
                      style: TextStyle(fontFamily: 'monospace')),
                  SizedBox(height: 4),
                  Text("2. Vérifier que best_93.pt est présent"),
                  SizedBox(height: 4),
                  Text("3. Installer les dépendances Python"),
                  SizedBox(height: 4),
                  Text("4. Vérifier les permissions de la caméra"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
