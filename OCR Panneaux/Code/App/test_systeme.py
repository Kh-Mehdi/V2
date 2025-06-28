#!/usr/bin/env python3
"""
Script de test pour vérifier le système de détection locale
"""

import sys
import os
from pathlib import Path
import time

def test_imports():
    """Test des imports nécessaires"""
    print("🧪 Test des imports...")
    
    try:
        import torch
        print(f"✅ PyTorch: {torch.__version__}")
    except ImportError:
        print("❌ PyTorch non installé")
        return False
    
    try:
        import cv2
        print(f"✅ OpenCV: {cv2.__version__}")
    except ImportError:
        print("❌ OpenCV non installé")
        return False
    
    try:
        import numpy as np
        print(f"✅ NumPy: {np.__version__}")
    except ImportError:
        print("❌ NumPy non installé")
        return False
    
    return True

def test_model_file():
    """Test de la présence du modèle"""
    print("\n📁 Test du modèle...")
    
    model_path = Path("model/yolov5/best_93.pt")
    if model_path.exists():
        size_mb = model_path.stat().st_size / (1024 * 1024)
        print(f"✅ Modèle trouvé: {model_path} ({size_mb:.1f} MB)")
        return True
    else:
        print(f"❌ Modèle non trouvé: {model_path}")
        return False

def test_yolov5_structure():
    """Test de la structure YOLOv5"""
    print("\n🏗️ Test structure YOLOv5...")
    
    yolo_path = Path("model/yolov5")
    if not yolo_path.exists():
        print(f"❌ Dossier YOLOv5 non trouvé: {yolo_path}")
        return False
    
    required_files = [
        "detect.py",
        "models/common.py", 
        "utils/general.py",
        "utils/torch_utils.py"
    ]
    
    for file in required_files:
        file_path = yolo_path / file
        if file_path.exists():
            print(f"✅ {file}")
        else:
            print(f"❌ {file} manquant")
            return False
    
    return True

def test_detector_init():
    """Test d'initialisation du détecteur"""
    print("\n🔧 Test initialisation détecteur...")
    
    try:
        from detection_locale import DetectionLocale
        
        print("⏳ Chargement du modèle...")
        start_time = time.time()
        
        detector = DetectionLocale()
        
        load_time = time.time() - start_time
        print(f"✅ Détecteur initialisé en {load_time:.2f}s")
        print(f"✅ Classes disponibles: {len(detector.classes)}")
        
        for i, cls in enumerate(detector.classes):
            print(f"   {i}: {cls}")
        
        return True
        
    except Exception as e:
        print(f"❌ Erreur initialisation: {e}")
        return False

def test_sample_detection():
    """Test de détection sur une image de test"""
    print("\n🎯 Test détection...")
    
    try:
        from detection_locale import DetectionLocale
        import cv2
        import numpy as np
        
        # Créer une image de test simple
        test_image = np.zeros((480, 640, 3), dtype=np.uint8)
        test_image.fill(128)  # Gris
        
        # Ajouter du texte pour simuler un panneau
        cv2.putText(test_image, "TEST", (250, 240), 
                   cv2.FONT_HERSHEY_SIMPLEX, 3, (255, 255, 255), 4)
        
        # Sauvegarder temporairement
        test_path = "test_image.jpg"
        cv2.imwrite(test_path, test_image)
        
        # Test de détection
        detector = DetectionLocale()
        results = detector.detect_image(test_path)
        
        # Nettoyer
        os.remove(test_path)
        
        if 'error' in results:
            print(f"❌ Erreur détection: {results['error']}")
            return False
        
        print(f"✅ Détection effectuée")
        print(f"   Détections: {results['detection_count']}")
        print(f"   Taille image: {results['image_size']}")
        
        return True
        
    except Exception as e:
        print(f"❌ Erreur test détection: {e}")
        return False

def test_webcam():
    """Test rapide de la webcam"""
    print("\n📹 Test webcam...")
    
    try:
        import cv2
        
        cap = cv2.VideoCapture(0)
        if cap.isOpened():
            ret, frame = cap.read()
            cap.release()
            
            if ret:
                print(f"✅ Webcam accessible ({frame.shape})")
                return True
            else:
                print("❌ Impossible de lire depuis la webcam")
                return False
        else:
            print("❌ Impossible d'ouvrir la webcam")
            return False
            
    except Exception as e:
        print(f"❌ Erreur webcam: {e}")
        return False

def main():
    """Fonction principale de test"""
    print("=" * 50)
    print("🚦 TEST SYSTÈME DÉTECTION LOCALE")
    print("=" * 50)
    
    tests = [
        ("Imports", test_imports),
        ("Modèle", test_model_file), 
        ("Structure YOLOv5", test_yolov5_structure),
        ("Initialisation", test_detector_init),
        ("Détection", test_sample_detection),
        ("Webcam", test_webcam)
    ]
    
    passed = 0
    total = len(tests)
    
    for test_name, test_func in tests:
        print(f"\n{'='*20} {test_name} {'='*20}")
        
        try:
            if test_func():
                passed += 1
                print(f"✅ {test_name}: RÉUSSI")
            else:
                print(f"❌ {test_name}: ÉCHEC")
        except Exception as e:
            print(f"❌ {test_name}: ERREUR - {e}")
    
    print("\n" + "=" * 50)
    print(f"📊 RÉSULTAT: {passed}/{total} tests réussis")
    
    if passed == total:
        print("🎉 Tous les tests sont passés! Le système est prêt.")
    else:
        print("⚠️ Certains tests ont échoué. Vérifiez la configuration.")
    
    print("=" * 50)
    
    return passed == total

if __name__ == "__main__":
    success = main()
    if not success:
        sys.exit(1)
