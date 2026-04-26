import 'package:hd_images/features/upscale/domain/repositories/upscale_repository.dart';

class UpscaleUsecase {

  UpscaleUsecase(this.repository);
  final UpscaleRepository repository;

  Future<String> call(String inputImagePath) {
    return repository.upscaleImage(inputImagePath);
  }
}
