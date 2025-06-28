import requests
import json
import sys

def test_server():
    print("🔍 Test de connexion au serveur Flask...")
    
    try:
        # Test 1: Health check
        print("\n1️⃣ Test health check...")
        response = requests.get('http://localhost:5000/health', timeout=5)
        print(f"   Status Code: {response.status_code}")
        print(f"   Response: {response.text}")
        
        if response.status_code == 200:
            data = response.json()
            if data.get('model_loaded'):
                print("✅ Serveur connecté et modèle chargé!")
            else:
                print("⚠️ Serveur connecté mais modèle non chargé")
        else:
            print("❌ Erreur de statut HTTP")
            return False
            
    except requests.exceptions.ConnectionError:
        print("❌ Impossible de se connecter au serveur")
        print("💡 Assurez-vous que le serveur Flask est démarré avec: python app.py")
        return False
    except Exception as e:
        print(f"❌ Erreur: {e}")
        return False
    
    try:
        # Test 2: Test de détection avec image factice
        print("\n2️⃣ Test endpoint de détection...")
        
        # Image factice 1x1 pixel (données minimales)
        import base64
        fake_image = base64.b64encode(b'\x00\x00\x00').decode('utf-8')
        
        response = requests.post(
            'http://localhost:5000/detect',
            headers={'Content-Type': 'application/json'},
            json={'image': fake_image},
            timeout=10
        )
        
        print(f"   Status Code: {response.status_code}")
        print(f"   Response: {response.text}")
        
        if response.status_code == 200:
            print("✅ Endpoint de détection fonctionne")
        else:
            print("⚠️ Problème avec l'endpoint de détection")
            
    except Exception as e:
        print(f"❌ Erreur test détection: {e}")
    
    print("\n✅ Tests terminés!")
    return True

if __name__ == "__main__":
    test_server()
