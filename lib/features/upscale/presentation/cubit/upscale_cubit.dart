import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hd_images/features/upscale/domain/usecases/upscale_usecase.dart';
import 'package:hd_images/features/upscale/presentation/cubit/upscale_state.dart';
import 'package:image_picker/image_picker.dart';

class UpscaleCubit extends Cubit<UpscaleState> {

  UpscaleCubit({required this.upscaleUsecase}) : super(UpscaleInitial());
  final ImagePicker _picker = ImagePicker();
  final UpscaleUsecase upscaleUsecase;

  Future<void> pickImage() async {
    try {
      final image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        emit(UpscaleImageSelected(image.path));
      }
    } catch (e) {
      debugPrint('UpscaleCubit -> UpscaleError (pickImage): $e');
      emit(UpscaleError('Fotoğraf seçilirken bir hata oluştu.'));
    }
  }

  Future<void> removeSelectedImage() async {
    emit(UpscaleInitial());
  }

  Future<void> processImage(String path) async {
    emit(UpscaleProcessing(path));
    try {
      final outPath = await upscaleUsecase(path);
      emit(UpscaleSuccess(path, outPath));
    } catch (e) {
      debugPrint('UpscaleCubit -> UpscaleError (processImage): $e');
      emit(UpscaleError(e.toString(), imagePath: path));
    }
  }
}
