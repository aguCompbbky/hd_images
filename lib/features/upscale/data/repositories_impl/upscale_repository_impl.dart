import 'package:hd_images/features/upscale/data/data_sources/local/tflite_data_source.dart';
import 'package:hd_images/features/upscale/domain/repositories/upscale_repository.dart';

class UpscaleRepositoryImpl implements UpscaleRepository {

  UpscaleRepositoryImpl({required this.tfliteDataSource});
  final TFLiteDataSource tfliteDataSource;

  @override
  Future<String> upscaleImage(String inputImagePath) {
    return tfliteDataSource.processImage(inputImagePath);
  }
}
