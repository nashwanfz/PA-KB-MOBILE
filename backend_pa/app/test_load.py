import tensorflow as tf
import os

model_path = os.path.join('model', 'rose_disease_model_complete.keras')

print(f"Mencoba memuat model dari: {model_path}")
print(f"Versi TensorFlow: {tf.__version__}")

try:
    model = tf.keras.models.load_model(model_path, compile=False)
    print("Model berhasil dimuat!")
    
    print("\nModel Summary")
    model.summary()

except Exception as e:
    print(f"Gagal memuat model. Error: {e}")
