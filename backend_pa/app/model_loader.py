import tensorflow as tf
import numpy as np
import os

CLASS_NAMES = ['Healthy_Leaf_Rose', 'Rose_Rust', 'Rose_sawfly_Rose_slug'] 

def load_model():
    model_path = os.path.join(os.path.dirname(__file__), 'model', 'rose_disease_model_complete.keras') 
    
    print(f"DEBUG: Path yang dicoba untuk model adalah: {model_path}")
    
    try:
        # TAMBAHKAN compile=False DI SINI
        model = tf.keras.models.load_model(model_path, compile=False)
        print("✅ Model (.keras) berhasil dimuat dengan sempurna.")
        return model
    except Exception as e:
        print(f"Gagal memuat model: {e}")
        return None
    
def predict_image(model, image_array):
    image_array = np.expand_dims(image_array, axis=0)
    
    predictions = model.predict(image_array)
    
    scores = tf.nn.softmax(predictions[0])
    
    predicted_class_index = np.argmax(scores)
    predicted_class_name = CLASS_NAMES[predicted_class_index]
    confidence = 100 * np.max(scores)
    
    return {
        "class": predicted_class_name,
        "confidence": f"{confidence:.2f}%"
    }