# � Système de Détection Locale de Panneaux

Ce système utilise votre modèle YOLOv5 `best_93.pt` pour détecter des panneaux de signalisation en local sur votre machine.

## 📋 Fonctionnalités

- ✅ Détection sur images individuelles
- ✅ Détection en temps réel via webcam
- ✅ Interface web locale
- ✅ Sauvegarde d'images annotées
- ✅ Support de 10 types de panneaux

## 🏗️ Structure

```
App/
├── detection_locale.py      # Script principal de détection
├── serveur_web_local.py     # Serveur web avec interface
├── test_systeme.py          # Tests de validation
├── config.ini               # Configuration
├── lancer_detection.bat     # Lancement rapide CLI
├── lancer_serveur_web.bat   # Lancement serveur web
├── lancer_tests.bat         # Lancement des tests
└── model/yolov5/            # Modèle YOLOv5 et dépendances
    └── best_93.pt           # Votre modèle entraîné
```

## 🚀 Démarrage Rapide

### 1. Tests du système

```bash
# Double-clic sur:
lancer_tests.bat
```

### 2. Interface Web (Recommandé)

```bash
# Double-clic sur:
lancer_serveur_web.bat
```

Puis ouvrez http://localhost:5000 dans votre navigateur.

### 3. Ligne de commande

```bash
# Double-clic sur:
lancer_detection.bat
```

## � Utilisation en ligne de commande

### Détection sur une image

```bash
python detection_locale.py --source "chemin/vers/image.jpg" --save
```

### Détection webcam temps réel

```bash
python detection_locale.py --source 0
```

### Paramètres personnalisés

```bash
python detection_locale.py --source "image.jpg" --conf 0.5 --save
```

## 🌐 Interface Web

L'interface web offre:

- 📁 Upload par glisser-déposer
- 🔍 Détection en un clic
- 📊 Résultats visuels
- 💾 Téléchargement des résultats

## 🎯 Classes Détectées

1. `panneau_stop` - Panneaux STOP
2. `panneau_vitesse_30` - Limitation 30 km/h
3. `panneau_vitesse_50` - Limitation 50 km/h
4. `panneau_vitesse_90` - Limitation 90 km/h
5. `panneau_direction_droite` - Direction droite
6. `panneau_direction_gauche` - Direction gauche
7. `panneau_interdiction_stationnement` - Interdiction stationnement
8. `panneau_obligation_droite` - Obligation droite
9. `panneau_danger_virage` - Danger virage
10. `panneau_priorite` - Priorité

## ⚙️ Configuration

Modifiez `config.ini` pour personnaliser:

- Seuils de confiance
- Taille d'image
- Paramètres webcam
- Dossiers de sortie

## 📦 Dépendances

Le système installe automatiquement:

- PyTorch (CPU)
- OpenCV
- NumPy
- Flask (pour l'interface web)
- Pillow
- Ultralytics YOLOv5

## 🔧 Dépannage

### Problème: Modèle non trouvé

```
❌ Le modèle best_93.pt n'est pas trouvé
```

**Solution**: Vérifiez que `model/yolov5/best_93.pt` existe.

### Problème: Import Error

```
❌ Module 'torch' not found
```

**Solution**: Lancez `lancer_detection.bat` option 4 pour installer les dépendances.

### Problème: Webcam inaccessible

```
❌ Impossible d'ouvrir la webcam
```

**Solution**:

- Vérifiez que la webcam n'est pas utilisée par une autre application
- Changez l'index de caméra dans `config.ini`

### Problème: Erreur de mémoire

```
❌ CUDA out of memory
```

**Solution**: Le système utilise CPU par défaut. Si vous avez modifié pour GPU, réduisez la taille d'image.

## 📈 Performance

- **CPU**: ~1-3 secondes par image
- **GPU**: ~0.1-0.5 secondes par image (si configuré)
- **Webcam**: ~10-30 FPS selon le matériel

## 🔄 Mise à jour du modèle

Pour utiliser un nouveau modèle:

1. Remplacez `model/yolov5/best_93.pt`
2. Mettez à jour les classes dans `detection_locale.py`
3. Relancez les tests

## 📞 Support

Pour les problèmes:

1. Lancez d'abord `lancer_tests.bat`
2. Vérifiez les logs d'erreur
3. Consultez la section dépannage

## 🎯 Exemples d'utilisation

### Script Python personnalisé

```python
from detection_locale import DetectionLocale

# Initialiser
detector = DetectionLocale(conf_thres=0.3)

# Détecter
results = detector.detect_image("mon_image.jpg")

# Afficher résultats
for detection in results['detections']:
    print(f"Panneau: {detection['class_name']}")
    print(f"Confiance: {detection['confidence']:.2f}")
```

### API Web

```javascript
// Upload et détection via JavaScript
const formData = new FormData();
formData.append("image", fileInput.files[0]);

fetch("/detect", {
  method: "POST",
  body: formData,
})
  .then((response) => response.json())
  .then((data) => console.log(data));
```

---

🚦 **Système prêt pour la détection locale de panneaux!** 🚦

## 📱 Application Mobile Flutter (Legacy)

- 📱 **Application mobile native** Flutter
- 🚫 **Aucun serveur requis** - fonctionne entièrement hors ligne
- 🔒 **Données privées** - traitement local uniquement
- ⚡ **Performances optimales** - pas de latence réseau

## 🎯 Modèle de Détection

- **Modèle**: YOLOv5 converti en TensorFlow Lite
- **Fichier**: `best_93.tflite`
- **Classes**: Panneaux de signalisation routière
- **Précision**: 93% (d'où le nom best_93)

## 📁 Structure du Projet

```
OCR Panneaux/Code/App/
├── interfaces/                    # Application Flutter
│   ├── lib/
│   │   ├── services/
│   │   │   ├── offline_detection_service.dart  # Service de détection
│   │   │   └── tflite_detection_service.dart   # Service TensorFlow Lite
│   │   ├── home_screen.dart       # Écran principal avec caméra
│   │   └── main.dart              # Point d'entrée
│   └── assets/
│       ├── best_93.tflite         # Modèle TensorFlow Lite
│       └── labels.txt             # Labels des classes
├── model/yolov5/                  # Modèle source YOLOv5
│   └── best_93.pt                 # Modèle PyTorch original
└── Scripts de lancement et conversion
```

## 🚀 Installation et Lancement

### 1. Conversion du Modèle (première fois)

```cmd
convert_ultralytics.bat
```

### 2. Lancement de l'Application

```cmd
launch_app.bat
```

### 3. Test Rapide

```cmd
quick_start.bat
```

## 🔧 Scripts Disponibles

| Script                    | Description                             |
| ------------------------- | --------------------------------------- |
| `launch_app.bat`          | Lance l'application Flutter principale  |
| `quick_start.bat`         | Démarrage rapide pour tests             |
| `convert_ultralytics.bat` | Convertit YOLOv5 vers TensorFlow Lite   |
| `check_tflite.bat`        | Vérifie que le modèle TFLite fonctionne |
| `test_model_*.bat`        | Scripts de test du modèle YOLOv5        |

## 📱 Utilisation

1. **Lancer l'application** avec `launch_app.bat`
2. **Autoriser la caméra** quand demandé
3. **Pointer la caméra** vers des panneaux de signalisation
4. **Détections automatiques** toutes les 2 secondes
5. **Bouton TEST DÉTECTION** pour forcer une détection

## 🎯 Détection en Temps Réel

L'application détecte automatiquement :

- Panneaux de limitation de vitesse
- Panneaux d'arrêt (STOP)
- Panneaux de direction
- Panneaux d'interdiction
- Panneaux d'obligation

## 🔧 Développement

### Technologies Utilisées

- **Flutter** 3.5+ (Application mobile)
- **Dart** (Langage de programmation)
- **TensorFlow Lite** (Inférence IA mobile)
- **YOLOv5** (Modèle de détection d'objets)
- **Camera Plugin** (Accès caméra native)

### Architecture

- **Service de Détection**: `OfflineDetectionService`
- **Service TFLite**: `TFLiteDetectionService`
- **Interface Utilisateur**: Material Design
- **Gestion d'État**: StatefulWidget
- **Traitement d'Image**: Plugin Camera + Image

## 📊 Performance

- **Vitesse de détection**: ~100-200ms par frame
- **Fréquence**: Détection toutes les 2 secondes
- **Seuil de confiance**: 60% minimum
- **Résolution**: Optimisée pour mobile (640x640)
- **Mémoire**: Optimisée pour appareils mobiles

## 🎉 Avantages de cette Version

✅ **Simplicité**: Plus de serveur à gérer  
✅ **Performance**: Traitement local ultra-rapide  
✅ **Sécurité**: Aucune donnée envoyée sur internet  
✅ **Fiabilité**: Fonctionne sans connexion  
✅ **Déploiement**: Application standalone  
✅ **Coût**: Aucun coût de serveur

## 🔍 Dépannage

### Problèmes Fréquents

**Modèle TFLite manquant:**

```cmd
convert_ultralytics.bat
```

**Erreur de compilation Android:**

- MinSDK requis: Android 8.0+ (API 26)
- Déjà configuré dans le projet

**Caméra ne fonctionne pas:**

- Vérifier les permissions caméra
- Redémarrer l'application

## 🏆 Résultat Final

Une application mobile complète de détection de panneaux qui fonctionne entièrement en local, sans dépendance externe, avec de vraies performances d'intelligence artificielle !

---

**🎯 Mission accomplie ! Plus besoin de Flask, plus besoin de serveur, juste une app mobile standalone qui marche !** 🚀
