# 🚀 PROCÉDURES DE LANCEMENT - SYSTÈME DÉTECTION PANNEAUX

## 📋 Prérequis et Vérifications

### 1. Structure des fichiers requise

```
OCR Panneaux/Code/App/
├── detection_locale.py          ✅ Script principal
├── serveur_web_local.py         ✅ Interface web
├── test_systeme.py              ✅ Tests
├── config.ini                   ✅ Configuration
├── lancer_tests.bat             ✅ Launcher tests
├── lancer_detection.bat         ✅ Launcher CLI
├── lancer_serveur_web.bat       ✅ Launcher web
└── model/yolov5/
    ├── best_93.pt               ⚠️  REQUIS - Votre modèle
    ├── detect.py                ✅ Script YOLOv5
    ├── models/                  ✅ Dossier models
    ├── utils/                   ✅ Dossier utils
    └── requirements.txt         ✅ Dépendances YOLOv5
```

---

## 🔧 PROCÉDURE 1: INSTALLATION INITIALE

### Étape 1.1: Vérifier Python

```cmd
# Ouvrir l'invite de commande (cmd)
python --version
```

**Résultat attendu:** `Python 3.8.x` ou plus récent

**Si Python manque:**

1. Télécharger depuis https://python.org
2. ✅ Cocher "Add Python to PATH" lors de l'installation
3. Redémarrer l'ordinateur

### Étape 1.2: Placer le modèle

```
1. Copier best_93.pt dans: OCR Panneaux/Code/App/model/yolov5/
2. Vérifier que le fichier fait ~180MB (taille typique)
```

### Étape 1.3: Premier test

```cmd
# Dans le dossier App/
double-clic sur: lancer_tests.bat
```

---

## 🧪 PROCÉDURE 2: TESTS DE VALIDATION

### Test complet automatique

```cmd
Fichier: lancer_tests.bat
Action: Double-clic
```

**Résultats attendus:**

```
✅ Imports: RÉUSSI
✅ Modèle: RÉUSSI
✅ Structure YOLOv5: RÉUSSI
✅ Initialisation: RÉUSSI
✅ Détection: RÉUSSI
✅ Webcam: RÉUSSI

📊 RÉSULTAT: 6/6 tests réussis
🎉 Tous les tests sont passés! Le système est prêt.
```

### En cas d'échec des tests

#### Problème: Imports échouent

```
❌ PyTorch non installé
```

**Solution:**

```cmd
pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cpu
pip install opencv-python numpy pillow ultralytics
```

#### Problème: Modèle non trouvé

```
❌ Le modèle best_93.pt n'est pas trouvé
```

**Solution:**

1. Vérifier le chemin: `App/model/yolov5/best_93.pt`
2. Copier le modèle au bon endroit
3. Relancer les tests

#### Problème: Structure YOLOv5

```
❌ models/common.py manquant
```

**Solution:**

```cmd
cd model/yolov5
git clone https://github.com/ultralytics/yolov5 .
# OU télécharger manuellement depuis GitHub
```

---

## 🖥️ PROCÉDURE 3: LANCEMENT INTERFACE LIGNE DE COMMANDE

### Lancement du menu interactif

```cmd
Fichier: lancer_detection.bat
Action: Double-clic
```

### Options du menu

```
1. Détection sur une image    → Analyser une photo
2. Détection webcam temps réel → Caméra en direct
3. Test du modèle            → Validation rapide
4. Installer les dépendances → Réparer le système
5. Quitter                   → Fermer
```

### Utilisation Option 1: Image

```
1. Choisir option "1"
2. Entrer le chemin complet vers l'image:
   Exemple: C:\Users\Mehdi\Desktop\photo_panneau.jpg
3. Attendre la détection (1-3 secondes)
4. Vérifier le fichier résultat: photo_panneau_detected.jpg
```

### Utilisation Option 2: Webcam

```
1. Choisir option "2"
2. Autoriser l'accès à la caméra si demandé
3. Voir la détection en temps réel
4. Appuyer sur 'q' dans la fenêtre vidéo pour quitter
```

---

## 🌐 PROCÉDURE 4: LANCEMENT INTERFACE WEB

### Démarrage du serveur

```cmd
Fichier: lancer_serveur_web.bat
Action: Double-clic
```

**Console attendue:**

```
📦 Installation de Flask...
✅ Dépendances vérifiées
✅ Modèle trouvé
🌐 Lancement du serveur web local...
📍 Le serveur sera accessible sur: http://localhost:5000
🛑 Appuyez sur Ctrl+C pour arrêter le serveur
🌐 Initialisation du serveur web local...
✅ Détecteur initialisé
✅ Serveur prêt!
📍 Ouvrez votre navigateur sur: http://localhost:5000
```

### Accès à l'interface web

```
1. Ouvrir un navigateur (Chrome, Firefox, Edge)
2. Aller sur: http://localhost:5000
3. Vérifier le message: "✅ Système prêt pour la détection"
```

### Utilisation de l'interface web

```
1. Glisser-déposer une image OU cliquer "📁 Cliquez ici"
2. Sélectionner une image (JPG, PNG, BMP)
3. Cliquer "🔍 Détecter les panneaux"
4. Attendre le résultat (1-3 secondes)
5. Voir l'image annotée et les détections trouvées
```

---

## ⚡ PROCÉDURE 5: UTILISATION AVANCÉE

### Ligne de commande directe

```cmd
# Détection image avec seuil personnalisé
python detection_locale.py --source "image.jpg" --conf 0.5 --save

# Webcam avec seuil bas (plus sensible)
python detection_locale.py --source 0 --conf 0.15

# Modèle personnalisé
python detection_locale.py --source "image.jpg" --model "autre_modele.pt"
```

### Serveur web direct

```cmd
python serveur_web_local.py
```

### Configuration personnalisée

Modifier `config.ini`:

```ini
[MODEL]
confidence_threshold = 0.3  # Plus/moins sensible
image_size = 640            # Taille traitement

[SERVER]
port = 8080                 # Changer le port web
```

---

## 🔧 PROCÉDURE 6: DÉPANNAGE

### Test de diagnostic complet

```cmd
python test_systeme.py
```

### Réinstallation des dépendances

```cmd
# PyTorch CPU
pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cpu

# OpenCV et utilitaires
pip install opencv-python numpy pillow

# YOLOv5 et web
pip install ultralytics flask

# Dans model/yolov5/
pip install -r requirements.txt
```

### Problèmes fréquents et solutions

#### "Module not found"

```cmd
pip install --upgrade [nom_module]
```

#### "Permission denied"

```cmd
# Lancer cmd en tant qu'administrateur
# OU utiliser --user
pip install --user [package]
```

#### "CUDA out of memory"

```python
# Dans detection_locale.py, ligne 42:
self.device = select_device('cpu')  # Forcer CPU
```

#### Webcam ne fonctionne pas

```python
# Tester différents index de caméra
cap = cv2.VideoCapture(1)  # Au lieu de 0
```

#### Port 5000 occupé

```python
# Dans serveur_web_local.py, dernière ligne:
app.run(host='127.0.0.1', port=8080, debug=False)
```

---

## 📊 PROCÉDURE 7: VALIDATION FONCTIONNEMENT

### Checklist de validation complète

#### ✅ Tests système

- [ ] `lancer_tests.bat` → 6/6 tests réussis
- [ ] Python détecté
- [ ] Modèle chargé (best_93.pt)
- [ ] Classes définies (10 panneaux)

#### ✅ Interface CLI

- [ ] `lancer_detection.bat` → Menu affiché
- [ ] Test image → Image annotée créée
- [ ] Test webcam → Fenêtre vidéo ouverte
- [ ] Détections affichées en temps réel

#### ✅ Interface Web

- [ ] `lancer_serveur_web.bat` → Serveur démarré
- [ ] http://localhost:5000 → Page accessible
- [ ] Upload image → Résultat affiché
- [ ] Détections annotées visibles

#### ✅ Performance

- [ ] Détection image: < 5 secondes
- [ ] Webcam: > 10 FPS
- [ ] Mémoire: < 2GB RAM utilisée

### Types de panneaux testés

```
✅ panneau_stop
✅ panneau_vitesse_30/50/90
✅ panneau_direction_droite/gauche
✅ panneau_interdiction_stationnement
✅ panneau_obligation_droite
✅ panneau_danger_virage
✅ panneau_priorite
```

---

## 🚀 PROCÉDURE 8: UTILISATION QUOTIDIENNE

### Démarrage rapide recommandé

```
1. Double-clic: lancer_serveur_web.bat
2. Ouvrir: http://localhost:5000
3. Glisser image → Détecter
4. Ctrl+C dans console pour arrêter
```

### Pour développement/test

```
1. Double-clic: lancer_tests.bat (validation)
2. Double-clic: lancer_detection.bat (tests CLI)
3. Modifier config.ini si besoin
```

### Sauvegarde recommandée

```
Sauvegarder régulièrement:
- model/yolov5/best_93.pt (votre modèle)
- config.ini (vos paramètres)
- detection_locale.py (vos modifications)
```

---

## 📞 PROCÉDURE 9: SUPPORT ET MAINTENANCE

### Logs et debugging

```cmd
# Verbose mode
python detection_locale.py --source image.jpg --conf 0.25 > log.txt 2>&1

# Test serveur web
python serveur_web_local.py > serveur_log.txt 2>&1
```

### Monitoring performance

```python
# Ajouter dans detection_locale.py pour mesurer temps
import time
start = time.time()
# ... code détection ...
print(f"Temps détection: {time.time() - start:.2f}s")
```

### Mise à jour modèle

```
1. Remplacer model/yolov5/best_93.pt
2. Modifier classes dans detection_locale.py si nécessaire
3. Lancer lancer_tests.bat pour valider
4. Tester avec images connues
```

---

🎯 **SYSTÈME PRÊT À L'EMPLOI!**

**Pour démarrer immédiatement:**

1. `lancer_tests.bat` (validation)
2. `lancer_serveur_web.bat` (interface web)
3. Ouvrir http://localhost:5000
4. Profiter de la détection! 🚦
