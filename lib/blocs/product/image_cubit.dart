import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ma_so_thue/blocs/product/image_state.dart';
import 'package:ma_so_thue/data/upload_image/image_picker_service.dart';

class ImageCubit extends Cubit<ImageState> {
  final ImagePickerService _imageService;
  ImageCubit(this._imageService) : super(const ImageState());
  Future<void> pickAndUploadImage() async {
    try {
      final image = await _imageService.pickImage(ImageSource.gallery);
      if (image == null) return;

      emit(state.copyWith(isUploading: true, error: null));
      final url = await _imageService.uploadToCloudinary(image);
      print('duong dan : $url');
      emit(state.copyWith(isUploading: false, imageUrl: url));
    } catch (e) {
      rethrow;
    }
  }
}
