class ImageState {
  final bool isUploading;
  final String? imageUrl;
  final String? error;

  const ImageState({this.isUploading = false, this.imageUrl, this.error});

  ImageState copyWith({bool? isUploading, String? imageUrl, String? error}) {
    return ImageState(
      isUploading: isUploading ?? this.isUploading,
      imageUrl: imageUrl ?? this.imageUrl,
      error: error ?? this.error,
    );
  }
}
