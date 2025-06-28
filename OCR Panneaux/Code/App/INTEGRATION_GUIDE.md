# Guide d'utilisation - Intégration du modèle YOLOv5

## Configuration et démarrage

### 1. Démarrer le serveur de détection

**Option A: Utiliser le script automatique**

```cmd
cd "c:\Users\Mehdi\Desktop\AI\V2\projets-casablanca-nextgen\OCR Panneaux\Code\App"
start_detection_server.bat
```

**Option B: Démarrage manuel**

```cmd
cd "c:\Users\Mehdi\Desktop\AI\V2\projets-casablanca-nextgen\OCR Panneaux\Code\App\back_detection"
python -m pip install -r requirements.txt
python app.py
```

### 2. Démarrer l'application Flutter

```cmd
cd "c:\Users\Mehdi\Desktop\AI\V2\projets-casablanca-nextgen\OCR Panneaux\Code\App\interfaces"
flutter pub get
flutter run
```

## Fonctionnalités intégrées

### Détection en temps réel

- Le modèle YOLOv5 avec `best_93.pt` est utilisé pour la détection
- Détection automatique toutes les 2 secondes
- Seuil de confiance configurable (actuellement 60% pour l'affichage)

### API du serveur Flask

**Endpoints disponibles:**

1. **Health Check**: `GET /health`

   - Vérifier l'état du serveur et du modèle

2. **Détection d'image**: `POST /detect`

   ```json
   {
     "image": "base64_encoded_image"
   }
   ```

3. **Détection temps réel**: `POST /detect_realtime`
   ```json
   {
     "frame": "base64_encoded_frame",
     "timestamp": "optional_timestamp"
   }
   ```

### Configuration du modèle

Le modèle est configuré avec:

- **Fichier de poids**: `best_93.pt`
- **Seuil de confiance**:
  - 0.5 pour la détection d'image
  - 0.3 pour la détection temps réel
  - 0.6 pour l'affichage dans l'app
- **Format d'entrée**: Images RGB
- **Résolution caméra**: Medium (pour de meilleures performances)

## Dépannage

### Le serveur ne démarre pas

1. Vérifier que Python est installé
2. Vérifier que `best_93.pt` est présent dans le dossier `yolov5`
3. Installer les dépendances manquantes

### L'application Flutter ne se connecte pas

1. Vérifier que le serveur Flask fonctionne sur `localhost:5000`
2. Vérifier les permissions de la caméra
3. Redémarrer le serveur Flask

### Détection imprécise

- Ajuster le seuil de confiance dans `detection_service.dart`
- Modifier la fréquence de détection dans `home_screen.dart`
- Vérifier l'éclairage et la qualité de la caméra

## Architecture

```
App/
├── back_detection/           # Serveur Flask + YOLOv5
│   ├── app.py               # API de détection
│   └── requirements.txt     # Dépendances Python
├── interfaces/              # Application Flutter
│   ├── lib/
│   │   ├── services/
│   │   │   └── detection_service.dart  # Service de communication
│   │   ├── home_screen.dart            # Écran principal avec caméra
│   │   ├── panneau_detected_screen.dart # Pop-up de détection
│   │   └── panneau_detail_screen.dart  # Détails du panneau
└── model/yolov5/           # Modèle YOLOv5
    └── best_93.pt          # Poids du modèle entraîné
```

## Commande originale intégrée

La commande `python detect.py --weights best_93.pt --source 0` a été intégrée dans le serveur Flask pour permettre:

- L'utilisation du modèle via API REST
- L'intégration avec l'application Flutter
- La détection en temps réel depuis la caméra de l'appareil mobile
