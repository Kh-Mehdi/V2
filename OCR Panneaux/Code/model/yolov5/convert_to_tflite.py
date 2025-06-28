#!/usr/bin/env python
"""
Script de conversion YOLOv5 vers TensorFlow Lite
"""
import os
import shutil
from pathlib import Path

def convert_yolo_to_tflite():
    print("🔄 Début de la conversion YOLOv5 → TensorFlow Lite")
    
    try:
        # Import et conversion
        from ultralytics import YOLO
        
        model_path = "best_93.pt"
        if not os.path.exists(model_path):
            print(f"❌ Modèle {model_path} non trouvé")
            return False
            
        print(f"📁 Chargement du modèle {model_path}...")
        model = YOLO(model_path)
        
        print("🔄 Export vers TensorFlow Lite...")
        results = model.export(
            format='tflite',
            imgsz=640,
            int8=False,
            device='cpu'
        )
        
        print(f"✅ Conversion réussie: {results}")
        
        # Vérifier si le fichier existe
        tflite_file = "best_93.tflite"
        if os.path.exists(tflite_file):
            print(f"✅ Fichier TFLite créé: {tflite_file}")
            
            # Copier vers Flutter
            flutter_assets = Path("../../App/interfaces/assets")
            flutter_assets.mkdir(parents=True, exist_ok=True)
            
            target_path = flutter_assets / "best_93.tflite"
            shutil.copy2(tflite_file, target_path)
            print(f"📱 Modèle copié vers Flutter: {target_path}")
            
            if target_path.exists():
                print("✅ Installation Flutter réussie!")
                return True
            else:
                print("❌ Erreur lors de la copie vers Flutter")
                return False
        else:
            print("❌ Fichier TFLite non créé")
            return False
            
    except Exception as e:
        print(f"❌ Erreur lors de la conversion: {e}")
        import traceback
        traceback.print_exc()
        return False

if __name__ == "__main__":
    success = convert_yolo_to_tflite()
    if success:
        print("\n🎉 CONVERSION TERMINÉE AVEC SUCCÈS!")
        print("📱 Votre modèle est maintenant prêt pour Flutter!")
    else:
        print("\n❌ Échec de la conversion")
