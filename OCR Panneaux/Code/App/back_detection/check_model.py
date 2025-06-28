import os
import sys

def check_model_path():
    print("=== VERIFICATION DU MODELE YOLOV5 ===")
    
    # Chemin actuel
    current_dir = os.path.dirname(__file__)
    print(f"Répertoire du script: {current_dir}")
    
    # Différents chemins possibles
    paths_to_check = [
        os.path.join(current_dir, '..', '..', 'model', 'yolov5', 'best_93.pt'),
        os.path.join(current_dir, '..', 'model', 'yolov5', 'best_93.pt'),
        os.path.join(current_dir, '..', '..', '..', 'model', 'yolov5', 'best_93.pt'),
    ]
    
    print("\nVérification des chemins possibles:")
    model_found = False
    correct_path = None
    
    for i, path in enumerate(paths_to_check, 1):
        abs_path = os.path.abspath(path)
        exists = os.path.exists(path)
        print(f"{i}. {abs_path}")
        print(f"   Existe: {'✓' if exists else '✗'}")
        
        if exists and not model_found:
            model_found = True
            correct_path = path
            print(f"   *** MODELE TROUVE! ***")
        print()
    
    if model_found:
        print(f"✅ Modèle trouvé à: {os.path.abspath(correct_path)}")
        return correct_path
    else:
        print("❌ Modèle non trouvé dans aucun emplacement")
        return None

if __name__ == "__main__":
    model_path = check_model_path()
    
    if model_path:
        print("\n=== TEST DE CHARGEMENT ===")
        try:
            # Test minimal de chargement
            print("Tentative de chargement du modèle...")
            import torch
            # Simple vérification que le fichier peut être lu
            with open(model_path, 'rb') as f:
                f.read(1024)  # Lire les premiers 1024 bytes
            print("✅ Le fichier modèle peut être lu correctement")
        except ImportError:
            print("⚠️ PyTorch non installé, impossible de tester le chargement complet")
        except Exception as e:
            print(f"❌ Erreur lors de la lecture du modèle: {e}")
    else:
        print("\n🛠️ SOLUTION:")
        print("1. Vérifiez que best_93.pt est dans le bon dossier")
        print("2. Chemin attendu: projets-casablanca-nextgen/OCR Panneaux/Code/model/yolov5/best_93.pt")
