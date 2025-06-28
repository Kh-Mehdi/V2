from flask import Flask, request, jsonify
from flask_cors import CORS
import cv2
import torch
import numpy as np
import base64
import io
from PIL import Image
import sys
import os

# Ajouter le chemin vers YOLOv5
sys.path.append(os.path.join(os.path.dirname(__file__), '..', '..', 'model', 'yolov5'))

app = Flask(__name__)
CORS(app)

# Charger le modèle YOLOv5
# Essayer plusieurs chemins possibles
possible_paths = [
    os.path.join(os.path.dirname(__file__), '..', '..', 'model', 'yolov5', 'best_93.pt'),
    os.path.join(os.path.dirname(__file__), '..', 'model', 'yolov5', 'best_93.pt'),
    os.path.join(os.path.dirname(__file__), '..', '..', '..', 'model', 'yolov5', 'best_93.pt'),
]

model_path = None
for path in possible_paths:
    if os.path.exists(path):
        model_path = path
        break

if model_path is None:
    print("ERREUR: Impossible de trouver le fichier best_93.pt")
    print("Chemins vérifiés:")
    for path in possible_paths:
        print(f"  - {os.path.abspath(path)}")
    exit(1)

print(f"Chemin du script: {os.path.dirname(__file__)}")
print(f"Chemin du modèle trouvé: {os.path.abspath(model_path)}")
model = None

def load_model():
    global model
    try:
        # Charger le modèle personnalisé
        model = torch.hub.load('ultralytics/yolov5', 'custom', path=model_path, force_reload=True)
        model.eval()
        print("Modèle chargé avec succès!")
        return True
    except Exception as e:
        print(f"Erreur lors du chargement du modèle: {e}")
        return False

@app.route('/health', methods=['GET'])
def health_check():
    return jsonify({"status": "healthy", "model_loaded": model is not None})

@app.route('/detect', methods=['POST'])
def detect_signs():
    try:
        if model is None:
            return jsonify({"error": "Modèle non chargé"}), 500
        
        # Récupérer l'image depuis la requête
        data = request.get_json()
        
        if 'image' not in data:
            return jsonify({"error": "Aucune image fournie"}), 400
        
        # Décoder l'image base64
        image_data = base64.b64decode(data['image'])
        image = Image.open(io.BytesIO(image_data))
        
        # Convertir en format numpy array
        image_np = np.array(image)
        
        # Faire la détection
        results = model(image_np)
        
        # Extraire les résultats
        detections = []
        for *box, conf, cls in results.xyxy[0].cpu().numpy():
            if conf > 0.5:  # Seuil de confiance
                detection = {
                    "class": model.names[int(cls)],
                    "confidence": float(conf),
                    "bbox": [float(x) for x in box]
                }
                detections.append(detection)
        
        return jsonify({
            "success": True,
            "detections": detections,
            "count": len(detections)
        })
        
    except Exception as e:
        return jsonify({"error": str(e)}), 500

@app.route('/detect_realtime', methods=['POST'])
def detect_realtime():
    """Endpoint pour la détection en temps réel depuis la caméra"""
    try:
        if model is None:
            return jsonify({"error": "Modèle non chargé"}), 500
        
        # Récupérer les données de l'image
        data = request.get_json()
        
        if 'frame' not in data:
            return jsonify({"error": "Aucune frame fournie"}), 400
        
        # Décoder l'image base64
        frame_data = base64.b64decode(data['frame'])
        image = Image.open(io.BytesIO(frame_data))
        image_np = np.array(image)
        
        # Faire la détection
        results = model(image_np)
        
        # Extraire les résultats avec plus de détails
        detections = []
        for *box, conf, cls in results.xyxy[0].cpu().numpy():
            if conf > 0.3:  # Seuil plus bas pour temps réel
                x1, y1, x2, y2 = box
                detection = {
                    "class": model.names[int(cls)],
                    "confidence": float(conf),
                    "bbox": {
                        "x1": float(x1),
                        "y1": float(y1),
                        "x2": float(x2),
                        "y2": float(y2),
                        "width": float(x2 - x1),
                        "height": float(y2 - y1)
                    },
                    "center": {
                        "x": float((x1 + x2) / 2),
                        "y": float((y1 + y2) / 2)
                    }
                }
                detections.append(detection)
        
        return jsonify({
            "success": True,
            "detections": detections,
            "timestamp": data.get('timestamp', None)
        })
        
    except Exception as e:
        return jsonify({"error": str(e)}), 500

if __name__ == '__main__':
    print("Démarrage du serveur de détection...")
    
    # Charger le modèle au démarrage
    if load_model():
        print("Serveur prêt!")
        app.run(host='0.0.0.0', port=5000, debug=True)
    else:
        print("Impossible de démarrer le serveur - modèle non chargé")
