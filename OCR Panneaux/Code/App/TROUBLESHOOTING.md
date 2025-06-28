# 🔧 GUIDE DE DÉPANNAGE - Connexion Caméra/Modèle

## Problème: "La caméra de l'appli ne se connecte pas au modèle"

### ✅ Solutions étape par étape :

## 1. VÉRIFIER LE SERVEUR FLASK

### Option A: Utiliser le script automatique

```cmd
cd "c:\Users\Mehdi\Desktop\AI\V2\projets-casablanca-nextgen\OCR Panneaux\Code\App"
start_detection_server.bat
```

### Option B: Démarrage manuel

```cmd
cd "c:\Users\Mehdi\Desktop\AI\V2\projets-casablanca-nextgen\OCR Panneaux\Code\App\back_detection"
python app.py
```

**Le serveur doit afficher:**

```
Démarrage du serveur de détection...
Modèle chargé avec succès!
Serveur prêt!
* Running on http://0.0.0.0:5000
```

## 2. TESTER LA CONNEXION

### Dans un nouveau terminal:

```cmd
cd "c:\Users\Mehdi\Desktop\AI\V2\projets-casablanca-nextgen\OCR Panneaux\Code\App\back_detection"
python test_server.py
```

**Résultat attendu:**

```
✅ Serveur connecté et modèle chargé!
✅ Endpoint de détection fonctionne
```

## 3. DANS L'APPLICATION FLUTTER

1. **Ouvrir l'app** et aller à l'écran principal
2. **Vérifier l'indicateur de statut** en haut:

   - 🟢 Vert = "Serveur connecté - Détection active"
   - 🔴 Rouge = "Serveur déconnecté"

3. **Utiliser le diagnostic intégré:**
   - Cliquer sur l'icône ⚙️ en haut à droite
   - Ou cliquer sur "Diagnostic" en bas

## 4. PROBLÈMES COURANTS & SOLUTIONS

### ❌ "Serveur déconnecté"

**Solutions:**

- Vérifier que le serveur Flask est démarré
- Redémarrer le serveur Flask
- Cliquer sur "Reconnexion" dans l'app

### ❌ "Modèle non chargé"

**Solutions:**

- Vérifier que `best_93.pt` existe dans `model/yolov5/`
- Redémarrer le serveur Flask
- Vérifier les dépendances Python

### ❌ "Erreur caméra"

**Solutions:**

- Autoriser l'accès à la caméra dans les paramètres
- Redémarrer l'application
- Vérifier qu'aucune autre app utilise la caméra

### ❌ "Pas de détection"

**Solutions:**

- Pointer la caméra vers un panneau clair
- Améliorer l'éclairage
- Ajuster le seuil de confiance dans le code

## 5. LOGS DE DÉBOGAGE

### Serveur Flask:

- Regarder la console où `python app.py` s'exécute
- Erreurs communes: Modèle non trouvé, dépendances manquantes

### Application Flutter:

- Utiliser `flutter logs` pour voir les erreurs
- Vérifier les messages dans la console

## 6. CONFIGURATION RÉSEAU

**Port utilisé:** `localhost:5000`
**Endpoints:**

- Health: `GET http://localhost:5000/health`
- Détection: `POST http://localhost:5000/detect`
- Temps réel: `POST http://localhost:5000/detect_realtime`

## 7. VÉRIFICATION FINALE

### Test complet:

1. ✅ Serveur Flask démarré
2. ✅ Modèle chargé (best_93.pt)
3. ✅ Application Flutter lancée
4. ✅ Permissions caméra accordées
5. ✅ Indicateur vert dans l'app
6. ✅ Détection fonctionne

### Commande de test rapide:

```cmd
curl http://localhost:5000/health
```

**Réponse attendue:**

```json
{ "status": "healthy", "model_loaded": true }
```

---

🆘 **Si le problème persiste:**

1. Utiliser l'écran de diagnostic dans l'app
2. Vérifier les logs détaillés
3. Redémarrer complètement le système
