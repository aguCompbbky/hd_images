abstract class UpscaleState {}

class UpscaleInitial extends UpscaleState {}

class UpscaleImageSelected extends UpscaleState {
  UpscaleImageSelected(this.imagePath);
  final String imagePath;
}

class UpscaleProcessing extends UpscaleState {
  UpscaleProcessing(this.imagePath);
  final String imagePath;
}

class UpscaleSuccess extends UpscaleState {
  UpscaleSuccess(this.originalImagePath, this.upscaledImagePath);
  final String originalImagePath;
  final String upscaledImagePath;
}

class UpscaleError extends UpscaleState {
  UpscaleError(this.message, {this.imagePath});
  final String message;
  final String? imagePath;
}
