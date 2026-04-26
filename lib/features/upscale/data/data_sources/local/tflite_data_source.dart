import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';

abstract class TFLiteDataSource {
  Future<String> processImage(String imagePath);
}

class TFLiteDataSourceImpl implements TFLiteDataSource {

  TFLiteDataSourceImpl() {
    debugPrint('[TFLite] TFLiteDataSourceImpl constructor çağrıldı.');
    _modelInitFuture = _initModel();
  }
  Interpreter? _interpreter;
  Future<void>? _modelInitFuture;

  Future<void> _initModel() async {
    debugPrint('[TFLite] _initModel() başladı.');
    try {
      // 1. Adım: Asset'ten byte okuma
      debugPrint('[TFLite] rootBundle.load başlatılıyor...');
      final byteData = await rootBundle.load('assets/models/esrgan.tflite');
      final modelBytes = byteData.buffer.asUint8List(
        byteData.offsetInBytes,
        byteData.lengthInBytes,
      );
      debugPrint('[TFLite] Asset okundu. Boyut: ${modelBytes.length} byte');

      if (modelBytes.isEmpty) {
        debugPrint('[TFLite] HATA: Model byteları boş!');
        return;
      }

      // 2. Adım: Interpreter oluşturma
      debugPrint('[TFLite] Interpreter.fromBuffer() çağrılıyor...');
      final options = InterpreterOptions()..threads = 1;
      _interpreter = Interpreter.fromBuffer(modelBytes, options: options);
      debugPrint('[TFLite] Interpreter oluşturuldu.');

      // 3. Adım: Tensor allocation
      debugPrint('[TFLite] allocateTensors() çağrılıyor...');
      _interpreter!.allocateTensors();
      debugPrint('[TFLite] Tensorlar allocated.');

      // 4. Adım: Tensor boyutlarını doğrula
      final inputTensors = _interpreter!.getInputTensors();
      final outputTensors = _interpreter!.getOutputTensors();
      debugPrint('[TFLite] Input tensor sayısı: ${inputTensors.length}');
      for (final t in inputTensors) {
        debugPrint('[TFLite]   Input: name=${t.name}, shape=${t.shape}, type=${t.type}');
      }
      debugPrint('[TFLite] Output tensor sayısı: ${outputTensors.length}');
      for (final t in outputTensors) {
        debugPrint('[TFLite]   Output: name=${t.name}, shape=${t.shape}, type=${t.type}');
      }

      debugPrint('[TFLite] Model başarıyla yüklendi! ✅');
    } on Exception catch (e, stackTrace) {
      debugPrint('[TFLite] HATA (Exception): $e');
      debugPrint('[TFLite] StackTrace: $stackTrace');
    } catch (e, stackTrace) {
      // Error veya native exception'ları da yakala
      debugPrint('[TFLite] HATA (Error/diğer): $e');
      debugPrint('[TFLite] StackTrace: $stackTrace');
    }
  }

  @override
  Future<String> processImage(String imagePath) async {
    debugPrint('[TFLite] processImage() çağrıldı. Path: $imagePath');
    _modelInitFuture ??= _initModel();
    await _modelInitFuture;

    if (_interpreter == null) {
      debugPrint('[TFLite] HATA: _interpreter null, model yüklenemedi!');
      throw Exception('TFLite Model henüz yüklenmedi veya bulunamadı.');
    }
    debugPrint('[TFLite] Interpreter hazır, işlem başlıyor...');

    final imageFile = File(imagePath);
    if (!imageFile.existsSync()) {
      debugPrint('[TFLite] HATA: Görüntü dosyası bulunamadı: $imagePath');
      throw Exception('Görüntü dosyası bulunamadı.');
    }

    final rawImage = img.decodeImage(await imageFile.readAsBytes());
    if (rawImage == null) {
      debugPrint('[TFLite] HATA: Görüntü decode edilemedi.');
      throw Exception('Fotoğraf okunamadı.');
    }
    debugPrint('[TFLite] Görüntü decode edildi: ${rawImage.width}x${rawImage.height}');

    // ESRGAN tflite modeli [1, 50, 50, 3] boyutunu kabul eder.
    final inputImage = img.copyResize(rawImage, width: 50, height: 50);
    debugPrint('[TFLite] Görüntü 50x50 olarak yeniden boyutlandırıldı.');

    // Giriş tensörü: Float32List [1 * 50 * 50 * 3]
    final inputBuffer = Float32List(1 * 50 * 50 * 3);
    var bufferIndex = 0;
    for (var y = 0; y < 50; y++) {
      for (var x = 0; x < 50; x++) {
        final pixel = inputImage.getPixelSafe(x, y);
        inputBuffer[bufferIndex++] = pixel.r / 255.0;
        inputBuffer[bufferIndex++] = pixel.g / 255.0;
        inputBuffer[bufferIndex++] = pixel.b / 255.0;
      }
    }
    final inputTensor = inputBuffer.reshape<int>([1, 50, 50, 3]);
    debugPrint('[TFLite] Input tensörü hazırlandı. Boyut: [1, 50, 50, 3]');

    // Çıkış tensörü: Float32List [1 * 200 * 200 * 3]
    final outputBuffer = Float32List(1 * 200 * 200 * 3);
    final outputTensor = outputBuffer.reshape<int>([1, 200, 200, 3]);

    try {
      debugPrint('[TFLite] interpreter.run() çağrılıyor...');
      final stopwatch = Stopwatch()..start();
      _interpreter!.run(inputTensor, outputTensor);
      stopwatch.stop();
      debugPrint('[TFLite] interpreter.run() tamamlandı. Süre: ${stopwatch.elapsedMilliseconds}ms');
    } catch (e, stackTrace) {
      debugPrint('[TFLite] Çıkarım hatası: $e');
      debugPrint('[TFLite] StackTrace: $stackTrace');
      throw Exception('Yapay zeka işlemi başarısız oldu.');
    }

    // Çıktıyı jpg dosyasına çevirme
    final upscaledImage = img.Image(width: 200, height: 200);
    for (var y = 0; y < 200; y++) {
      for (var x = 0; x < 200; x++) {
        final baseIndex = (y * 200 + x) * 3;
        final r = (outputBuffer[baseIndex] * 255.0).clamp(0, 255).toInt();
        final g = (outputBuffer[baseIndex + 1] * 255.0).clamp(0, 255).toInt();
        final b = (outputBuffer[baseIndex + 2] * 255.0).clamp(0, 255).toInt();
        upscaledImage.setPixel(x, y, img.ColorRgb8(r, g, b));
      }
    }

    final directory = await getTemporaryDirectory();
    final outPath =
        '${directory.path}/hd_image_${DateTime.now().millisecondsSinceEpoch}.jpg';
    final outFile = File(outPath);
    await outFile.writeAsBytes(img.encodeJpg(upscaledImage));

    debugPrint('[TFLite] Upscaled görüntü kaydedildi: $outPath');
    return outPath;
  }

