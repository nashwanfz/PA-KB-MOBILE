from fastapi import FastAPI, File, UploadFile, HTTPException
from fastapi.responses import JSONResponse
import uvicorn
import io
from PIL import Image
import numpy as np

from .model_loader import load_model, predict_image

app = FastAPI(title="Rose Leaf Disease Classifier API")
model = load_model()

@app.post("/predict")
async def predict(file: UploadFile = File(...)):
    if not model:
        raise HTTPException(status_code=500, detail="Model gagal dimuat")

    contents = await file.read()
    
    try:
        image = Image.open(io.BytesIO(contents))    
        image = image.convert('RGB')
        
        image = image.resize((224, 224)) 
        
        image_array = np.array(image) / 255.0
        
        prediction_result = predict_image(model, image_array)
        
        return JSONResponse(content=prediction_result)
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Terjadi kesalahan saat memproses gambar: {e}")

@app.get("/")
def read_root():
    return {"message": "Selamat datang di API Klasifikasi Penyakit Daun Mawar"}