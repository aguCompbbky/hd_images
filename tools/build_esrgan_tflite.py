import tensorflow as tf
import tensorflow_hub as hub
from pathlib import Path

print("TF version:", tf.__version__)

model = hub.load("https://tfhub.dev/captain-pool/esrgan-tf2/1")
concrete_func = model.signatures[tf.saved_model.DEFAULT_SERVING_SIGNATURE_DEF_KEY]

@tf.function(input_signature=[tf.TensorSpec(shape=[1, 50, 50, 3], dtype=tf.float32)])
def f(input_tensor):
    return concrete_func(input_tensor)

converter = tf.lite.TFLiteConverter.from_concrete_functions(
    [f.get_concrete_function()], model
)
converter.optimizations = [tf.lite.Optimize.DEFAULT]
tflite_model = converter.convert()

out_path = Path("assets/models/esrgan.tflite")
out_path.parent.mkdir(parents=True, exist_ok=True)
out_path.write_bytes(tflite_model)

print(f"Model written to: {out_path} ({out_path.stat().st_size} bytes)")