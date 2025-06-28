#!/usr/bin/env python3
"""
Serveur web local pour la détection de panneaux
Interface web simple pour tester le modèle
"""

from flask import Flask, request, jsonify, render_template_string, send_file
import os
import base64
import io
from PIL import Image
import cv2
import numpy as np
from detection_locale import DetectionLocale
import tempfile
from pathlib import Path
import json

app = Flask(__name__)

# Initialiser le détecteur
detector = None

def init_detector():
    """Initialise le détecteur"""
    global detector
    try:
        detector = DetectionLocale()
        print("✅ Détecteur initialisé")
        return True
    except Exception as e:
        print(f"❌ Erreur initialisation détecteur: {e}")
        return False

# Template HTML simple
HTML_TEMPLATE = """
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Détection Panneaux - Local</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
            background-color: #f5f5f5;
        }
        .container {
            background: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        h1 {
            color: #333;
            text-align: center;
            margin-bottom: 30px;
        }
        .upload-area {
            border: 2px dashed #ccc;
            border-radius: 10px;
            padding: 40px;
            text-align: center;
            margin-bottom: 20px;
            cursor: pointer;
            transition: border-color 0.3s;
        }
        .upload-area:hover {
            border-color: #007bff;
        }
        .upload-area.dragover {
            border-color: #007bff;
            background-color: #f8f9fa;
        }
        input[type="file"] {
            display: none;
        }
        .btn {
            background-color: #007bff;
            color: white;
            padding: 10px 20px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 16px;
            margin: 5px;
        }
        .btn:hover {
            background-color: #0056b3;
        }
        .btn:disabled {
            background-color: #ccc;
            cursor: not-allowed;
        }
        .results {
            margin-top: 30px;
        }
        .detection-item {
            background: #f8f9fa;
            padding: 15px;
            margin: 10px 0;
            border-radius: 5px;
            border-left: 4px solid #007bff;
        }
        .image-container {
            text-align: center;
            margin: 20px 0;
        }
        .image-container img {
            max-width: 100%;
            height: auto;
            border-radius: 5px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        .loading {
            display: none;
            text-align: center;
            padding: 20px;
        }
        .spinner {
            border: 4px solid #f3f3f3;
            border-top: 4px solid #007bff;
            border-radius: 50%;
            width: 40px;
            height: 40px;
            animation: spin 1s linear infinite;
            margin: 0 auto;
        }
        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }
        .status {
            padding: 10px;
            border-radius: 5px;
            margin: 10px 0;
        }
        .status.success {
            background-color: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }
        .status.error {
            background-color: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>🚦 Détection de Panneaux - Système Local</h1>
        
        <div id="status"></div>
        
        <div class="upload-area" onclick="document.getElementById('fileInput').click()">
            <p>📁 Cliquez ici ou glissez-déposez une image</p>
            <p>Formats supportés: JPG, PNG, BMP</p>
            <input type="file" id="fileInput" accept="image/*">
        </div>
        
        <div style="text-align: center;">
            <button class="btn" onclick="detectImage()" id="detectBtn" disabled>🔍 Détecter les panneaux</button>
            <button class="btn" onclick="clearResults()">🗑️ Effacer</button>
        </div>
        
        <div class="loading" id="loading">
            <div class="spinner"></div>
            <p>Détection en cours...</p>
        </div>
        
        <div class="results" id="results"></div>
    </div>

    <script>
        let selectedFile = null;
        
        // Gestion du drag & drop
        const uploadArea = document.querySelector('.upload-area');
        
        ['dragenter', 'dragover', 'dragleave', 'drop'].forEach(eventName => {
            uploadArea.addEventListener(eventName, preventDefaults, false);
        });
        
        function preventDefaults(e) {
            e.preventDefault();
            e.stopPropagation();
        }
        
        ['dragenter', 'dragover'].forEach(eventName => {
            uploadArea.addEventListener(eventName, highlight, false);
        });
        
        ['dragleave', 'drop'].forEach(eventName => {
            uploadArea.addEventListener(eventName, unhighlight, false);
        });
        
        function highlight(e) {
            uploadArea.classList.add('dragover');
        }
        
        function unhighlight(e) {
            uploadArea.classList.remove('dragover');
        }
        
        uploadArea.addEventListener('drop', handleDrop, false);
        
        function handleDrop(e) {
            const dt = e.dataTransfer;
            const files = dt.files;
            handleFiles(files);
        }
        
        // Sélection de fichier
        document.getElementById('fileInput').addEventListener('change', function(e) {
            handleFiles(e.target.files);
        });
        
        function handleFiles(files) {
            if (files.length > 0) {
                selectedFile = files[0];
                document.getElementById('detectBtn').disabled = false;
                showStatus(`Fichier sélectionné: ${selectedFile.name}`, 'success');
            }
        }
        
        function showStatus(message, type) {
            const status = document.getElementById('status');
            status.innerHTML = `<div class="status ${type}">${message}</div>`;
        }
        
        function clearResults() {
            document.getElementById('results').innerHTML = '';
            document.getElementById('status').innerHTML = '';
            selectedFile = null;
            document.getElementById('detectBtn').disabled = true;
            document.getElementById('fileInput').value = '';
        }
        
        async function detectImage() {
            if (!selectedFile) {
                showStatus('Veuillez sélectionner une image', 'error');
                return;
            }
            
            // Afficher le loading
            document.getElementById('loading').style.display = 'block';
            document.getElementById('detectBtn').disabled = true;
            
            const formData = new FormData();
            formData.append('image', selectedFile);
            
            try {
                const response = await fetch('/detect', {
                    method: 'POST',
                    body: formData
                });
                
                const result = await response.json();
                
                if (result.success) {
                    displayResults(result);
                    showStatus(`Détection terminée: ${result.detection_count} panneau(x) trouvé(s)`, 'success');
                } else {
                    showStatus(`Erreur: ${result.error}`, 'error');
                }
                
            } catch (error) {
                showStatus(`Erreur de connexion: ${error.message}`, 'error');
            } finally {
                document.getElementById('loading').style.display = 'none';
                document.getElementById('detectBtn').disabled = false;
            }
        }
        
        function displayResults(result) {
            const resultsDiv = document.getElementById('results');
            
            let html = '<h2>📊 Résultats de détection</h2>';
            
            if (result.annotated_image) {
                html += `
                    <div class="image-container">
                        <img src="data:image/jpeg;base64,${result.annotated_image}" alt="Image annotée">
                    </div>
                `;
            }
            
            if (result.detections && result.detections.length > 0) {
                html += '<h3>Panneaux détectés:</h3>';
                result.detections.forEach((detection, index) => {
                    html += `
                        <div class="detection-item">
                            <strong>${index + 1}. ${detection.class_name}</strong><br>
                            Confiance: ${(detection.confidence * 100).toFixed(1)}%<br>
                            Position: [${detection.bbox.join(', ')}]
                        </div>
                    `;
                });
            } else {
                html += '<p>Aucun panneau détecté dans cette image.</p>';
            }
            
            resultsDiv.innerHTML = html;
        }
        
        // Vérifier l'état du serveur au chargement
        window.onload = async function() {
            try {
                const response = await fetch('/status');
                const status = await response.json();
                if (status.ready) {
                    showStatus('✅ Système prêt pour la détection', 'success');
                } else {
                    showStatus('❌ Système non prêt', 'error');
                }
            } catch (error) {
                showStatus('❌ Erreur de connexion au serveur', 'error');
            }
        };
    </script>
</body>
</html>
"""

@app.route('/')
def index():
    """Page d'accueil"""
    return render_template_string(HTML_TEMPLATE)

@app.route('/status')
def status():
    """Statut du serveur"""
    return jsonify({
        'ready': detector is not None,
        'model_loaded': detector is not None
    })

@app.route('/detect', methods=['POST'])
def detect():
    """Endpoint de détection"""
    if detector is None:
        return jsonify({'success': False, 'error': 'Détecteur non initialisé'})
    
    if 'image' not in request.files:
        return jsonify({'success': False, 'error': 'Aucune image fournie'})
    
    file = request.files['image']
    if file.filename == '':
        return jsonify({'success': False, 'error': 'Aucun fichier sélectionné'})
    
    try:
        # Lire l'image
        image_data = file.read()
        image = Image.open(io.BytesIO(image_data))
        
        # Convertir en array numpy
        img_array = np.array(image)
        if len(img_array.shape) == 3 and img_array.shape[2] == 3:
            img_array = cv2.cvtColor(img_array, cv2.COLOR_RGB2BGR)
        
        # Sauvegarder temporairement
        with tempfile.NamedTemporaryFile(suffix='.jpg', delete=False) as tmp_file:
            cv2.imwrite(tmp_file.name, img_array)
            temp_path = tmp_file.name
        
        try:
            # Détection
            results = detector.detect_image(temp_path)
            
            if 'error' in results:
                return jsonify({'success': False, 'error': results['error']})
            
            # Créer image annotée
            img_annotated = img_array.copy()
            
            for detection in results['detections']:
                x1, y1, x2, y2 = detection['bbox']
                confidence = detection['confidence']
                class_name = detection['class_name']
                
                # Dessiner la boîte
                cv2.rectangle(img_annotated, (x1, y1), (x2, y2), (0, 255, 0), 2)
                
                # Ajouter le label
                label = f"{class_name}: {confidence:.2f}"
                cv2.putText(img_annotated, label, (x1, y1-10), 
                           cv2.FONT_HERSHEY_SIMPLEX, 0.5, (0, 255, 0), 2)
            
            # Convertir en base64
            _, buffer = cv2.imencode('.jpg', img_annotated)
            img_base64 = base64.b64encode(buffer).decode('utf-8')
            
            return jsonify({
                'success': True,
                'detection_count': results['detection_count'],
                'detections': results['detections'],
                'annotated_image': img_base64
            })
            
        finally:
            # Nettoyer le fichier temporaire
            if os.path.exists(temp_path):
                os.unlink(temp_path)
        
    except Exception as e:
        return jsonify({'success': False, 'error': str(e)})

def main():
    """Lancer le serveur"""
    print("🌐 Initialisation du serveur web local...")
    
    if not init_detector():
        print("❌ Impossible d'initialiser le détecteur")
        return
    
    print("✅ Serveur prêt!")
    print("📍 Ouvrez votre navigateur sur: http://localhost:5000")
    print("🛑 Appuyez sur Ctrl+C pour arrêter")
    
    app.run(host='127.0.0.1', port=5000, debug=False)

if __name__ == "__main__":
    main()
