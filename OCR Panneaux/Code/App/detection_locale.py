#!/usr/bin/env python3
"""
Script de détection locale pour les panneaux de signalisation
Utilise le modèle best_93.pt avec YOLOv5
"""

import os
import sys
import torch
import cv2
import numpy as np
from pathlib import Path
import json
import time

# Ajouter le chemin vers YOLOv5
YOLO_PATH = Path(__file__).parent / "model" / "yolov5"
sys.path.append(str(YOLO_PATH))

from models.common import DetectMultiBackend
from utils.general import non_max_suppression, scale_boxes, check_img_size
from utils.torch_utils import select_device
from utils.augmentations import letterbox

class DetectionLocale:
    def __init__(self, model_path=None, conf_thres=0.25, iou_thres=0.45):
        """
        Initialise le détecteur local
        
        Args:
            model_path: Chemin vers le modèle (par défaut: best_93.pt)
            conf_thres: Seuil de confiance
            iou_thres: Seuil IoU pour NMS
        """
        if model_path is None:
            model_path = Path(__file__).parent / "model" / "yolov5" / "best_93.pt"
        
        self.model_path = model_path
        self.conf_thres = conf_thres
        self.iou_thres = iou_thres
        self.device = select_device('cpu')  # Force CPU pour compatibilité locale
        
        # Classes de panneaux
        self.classes = [
            'panneau_stop',
            'panneau_vitesse_30', 
            'panneau_vitesse_50',
            'panneau_vitesse_90',
            'panneau_direction_droite',
            'panneau_direction_gauche', 
            'panneau_interdiction_stationnement',
            'panneau_obligation_droite',
            'panneau_danger_virage',
            'panneau_priorite'
        ]
        
        # Charger le modèle
        self.load_model()
    
    def load_model(self):
        """Charge le modèle YOLOv5"""
        try:
            print(f"Chargement du modèle depuis: {self.model_path}")
            self.model = DetectMultiBackend(self.model_path, device=self.device)
            self.stride = self.model.stride
            self.names = self.model.names
            self.imgsz = 640
            
            # Test de chargement
            self.model.warmup(imgsz=(1, 3, self.imgsz, self.imgsz))
            print("✅ Modèle chargé avec succès!")
            
        except Exception as e:
            print(f"❌ Erreur lors du chargement du modèle: {e}")
            raise e
    
    def preprocess_image(self, img):
        """Préprocesse l'image pour la détection"""
        # Redimensionner avec letterbox
        img_resized = letterbox(img, self.imgsz, stride=self.stride, auto=True)[0]
        
        # Convertir BGR to RGB et normaliser
        img_resized = img_resized.transpose((2, 0, 1))[::-1]  # HWC to CHW, BGR to RGB
        img_resized = np.ascontiguousarray(img_resized)
        
        # Convertir en tensor
        img_tensor = torch.from_numpy(img_resized).to(self.device)
        img_tensor = img_tensor.float() / 255.0  # 0 - 255 to 0.0 - 1.0
        
        if len(img_tensor.shape) == 3:
            img_tensor = img_tensor[None]  # add batch dimension
            
        return img_tensor, img_resized.shape
    
    def detect_image(self, image_path):
        """
        Détecte les panneaux dans une image
        
        Args:
            image_path: Chemin vers l'image
            
        Returns:
            dict: Résultats de détection
        """
        try:
            # Charger l'image
            img = cv2.imread(str(image_path))
            if img is None:
                raise ValueError(f"Impossible de charger l'image: {image_path}")
            
            img_original = img.copy()
            h, w = img.shape[:2]
            
            # Préprocesser
            img_tensor, processed_shape = self.preprocess_image(img)
            
            # Inférence
            with torch.no_grad():
                pred = self.model(img_tensor)
            
            # Post-traitement avec NMS
            pred = non_max_suppression(
                pred, 
                self.conf_thres, 
                self.iou_thres, 
                max_det=1000
            )
            
            # Traiter les détections
            detections = []
            
            for det in pred:
                if len(det):
                    # Redimensionner les boîtes à la taille originale
                    det[:, :4] = scale_boxes(processed_shape[1:], det[:, :4], img.shape).round()
                    
                    for *xyxy, conf, cls in det:
                        x1, y1, x2, y2 = map(int, xyxy)
                        confidence = float(conf)
                        class_id = int(cls)
                        class_name = self.classes[class_id] if class_id < len(self.classes) else f"class_{class_id}"
                        
                        detection = {
                            'bbox': [x1, y1, x2, y2],
                            'confidence': confidence,
                            'class_id': class_id,
                            'class_name': class_name
                        }
                        detections.append(detection)
            
            return {
                'image_path': str(image_path),
                'image_size': [w, h],
                'detections': detections,
                'detection_count': len(detections)
            }
            
        except Exception as e:
            print(f"❌ Erreur lors de la détection: {e}")
            return {'error': str(e)}
    
    def detect_webcam(self):
        """Détection en temps réel avec la webcam"""
        cap = cv2.VideoCapture(0)
        
        if not cap.isOpened():
            print("❌ Impossible d'ouvrir la webcam")
            return
        
        print("🎥 Détection en temps réel (Appuyez sur 'q' pour quitter)")
        
        while True:
            ret, frame = cap.read()
            if not ret:
                break
            
            # Détection sur le frame
            start_time = time.time()
            
            img_tensor, processed_shape = self.preprocess_image(frame)
            
            with torch.no_grad():
                pred = self.model(img_tensor)
            
            pred = non_max_suppression(pred, self.conf_thres, self.iou_thres)
            
            # Dessiner les détections
            for det in pred:
                if len(det):
                    det[:, :4] = scale_boxes(processed_shape[1:], det[:, :4], frame.shape).round()
                    
                    for *xyxy, conf, cls in det:
                        x1, y1, x2, y2 = map(int, xyxy)
                        confidence = float(conf)
                        class_id = int(cls)
                        class_name = self.classes[class_id] if class_id < len(self.classes) else f"class_{class_id}"
                        
                        # Dessiner la boîte
                        cv2.rectangle(frame, (x1, y1), (x2, y2), (0, 255, 0), 2)
                        
                        # Ajouter le label
                        label = f"{class_name}: {confidence:.2f}"
                        cv2.putText(frame, label, (x1, y1-10), cv2.FONT_HERSHEY_SIMPLEX, 0.5, (0, 255, 0), 2)
            
            # Afficher FPS
            fps = 1.0 / (time.time() - start_time)
            cv2.putText(frame, f"FPS: {fps:.1f}", (10, 30), cv2.FONT_HERSHEY_SIMPLEX, 1, (0, 255, 0), 2)
            
            cv2.imshow('Détection Panneaux', frame)
            
            if cv2.waitKey(1) & 0xFF == ord('q'):
                break
        
        cap.release()
        cv2.destroyAllWindows()
    
    def save_annotated_image(self, image_path, output_path=None):
        """
        Sauvegarde une image avec les détections annotées
        
        Args:
            image_path: Chemin vers l'image source
            output_path: Chemin de sortie (optionnel)
        """
        # Détection
        results = self.detect_image(image_path)
        
        if 'error' in results:
            print(f"❌ Erreur: {results['error']}")
            return None
        
        # Charger l'image
        img = cv2.imread(str(image_path))
        
        # Dessiner les détections
        for detection in results['detections']:
            x1, y1, x2, y2 = detection['bbox']
            confidence = detection['confidence']
            class_name = detection['class_name']
            
            # Dessiner la boîte
            cv2.rectangle(img, (x1, y1), (x2, y2), (0, 255, 0), 2)
            
            # Ajouter le label
            label = f"{class_name}: {confidence:.2f}"
            cv2.putText(img, label, (x1, y1-10), cv2.FONT_HERSHEY_SIMPLEX, 0.5, (0, 255, 0), 2)
        
        # Sauvegarder
        if output_path is None:
            output_path = Path(image_path).stem + "_detected.jpg"
        
        cv2.imwrite(str(output_path), img)
        print(f"✅ Image annotée sauvegardée: {output_path}")
        
        return output_path


def main():
    """Fonction principale"""
    import argparse
    
    parser = argparse.ArgumentParser(description='Détection locale de panneaux')
    parser.add_argument('--source', type=str, help='Chemin vers image ou webcam (0)')
    parser.add_argument('--model', type=str, help='Chemin vers le modèle')
    parser.add_argument('--conf', type=float, default=0.25, help='Seuil de confiance')
    parser.add_argument('--save', action='store_true', help='Sauvegarder image annotée')
    
    args = parser.parse_args()
    
    # Initialiser le détecteur
    detector = DetectionLocale(
        model_path=args.model,
        conf_thres=args.conf
    )
    
    if args.source:
        if args.source == '0' or args.source.isdigit():
            # Webcam
            detector.detect_webcam()
        else:
            # Image
            results = detector.detect_image(args.source)
            
            if 'error' not in results:
                print(f"\n📊 Résultats de détection:")
                print(f"Image: {results['image_path']}")
                print(f"Détections trouvées: {results['detection_count']}")
                
                for i, detection in enumerate(results['detections']):
                    print(f"  {i+1}. {detection['class_name']} - Confiance: {detection['confidence']:.2f}")
                
                if args.save:
                    detector.save_annotated_image(args.source)
            else:
                print(f"❌ Erreur: {results['error']}")
    else:
        print("Utilisation:")
        print("  python detection_locale.py --source image.jpg --save")
        print("  python detection_locale.py --source 0  # webcam")


if __name__ == "__main__":
    main()
