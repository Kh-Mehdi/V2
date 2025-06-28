import torch
import sys
import os

def convert_yolo_to_tflite():
    """Convertit le modèle YOLOv5 en TensorFlow Lite pour Flutter"""
    
    print("🔄 Conversion YOLOv5 vers TensorFlow Lite...")
    print("=" * 50)
    
    # Chemin du modèle - chemin absolu corrigé
    base_dir = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
    model_path = os.path.join(base_dir, "model", "yolov5", "best_93.pt")
    
    print(f"🔍 Recherche du modèle dans: {model_path}")
    
    if not os.path.exists(model_path):
        print(f"❌ Modèle non trouvé: {model_path}")
        # Essayer un chemin alternatif
        alt_path = os.path.join(os.path.dirname(base_dir), "model", "yolov5", "best_93.pt")
        print(f"🔍 Tentative chemin alternatif: {alt_path}")
        if os.path.exists(alt_path):
            model_path = alt_path
            print(f"✅ Modèle trouvé: {model_path}")
        else:
            print("❌ Modèle introuvable dans les emplacements standard")
            return False
    
    try:
        print(f"📁 Chargement du modèle: {model_path}")
        
        # Charger le modèle YOLOv5
        model = torch.hub.load('ultralytics/yolov5', 'custom', path=model_path, force_reload=True)
        
        print("✅ Modèle chargé avec succès")
        print("🔄 Conversion en cours...")
        
        # Exporter vers TensorFlow Lite
        export_path = model.export(
            format='tflite',  # Format TensorFlow Lite
            imgsz=640,       # Taille d'image
            optimize=True,   # Optimisations
            int8=False,      # Quantization (False pour meilleure précision)
            dynamic=False,   # Taille fixe pour mobile
        )
        
        print("✅ Conversion terminée!")
        print(f"📁 Fichier créé: {export_path}")
        
        # Copier vers le dossier Flutter assets
        flutter_assets = os.path.join("..", "interfaces", "assets")
        if not os.path.exists(flutter_assets):
            os.makedirs(flutter_assets)
        
        import shutil
        tflite_name = "best_93.tflite"
        destination = os.path.join(flutter_assets, tflite_name)
        
        if os.path.exists(export_path):
            shutil.copy2(export_path, destination)
            print(f"✅ Modèle copié vers: {destination}")
        
        print("\n🎉 CONVERSION RÉUSSIE!")
        print("=" * 50)
        print("📱 Prochaines étapes:")
        print("1. Ajouter tflite_flutter à pubspec.yaml")
        print("2. Modifier detection_service.dart")
        print("3. Tester l'application sans Flask")
        
        return True
        
    except Exception as e:
        print(f"❌ Erreur lors de la conversion: {e}")
        return False

def check_dependencies():
    """Vérifie les dépendances nécessaires"""
    print("🔍 Vérification des dépendances...")
    
    try:
        import torch
        print("✅ PyTorch installé")
    except ImportError:
        print("❌ PyTorch non installé")
        return False
    
    try:
        import ultralytics
        print("✅ Ultralytics installé")
    except ImportError:
        print("⚠️ Ultralytics non installé - installation automatique...")
        os.system("pip install ultralytics")
    
    return True

if __name__ == "__main__":
    print("🚀 CONVERSION YOLOV5 → TENSORFLOW LITE")
    print("=" * 50)
    
    if check_dependencies():
        if convert_yolo_to_tflite():
            print("\n✅ Votre modèle est prêt pour Flutter!")
        else:
            print("\n❌ Échec de la conversion")
    else:
        print("\n❌ Dépendances manquantes")
