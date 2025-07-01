import 'dart:io';
import 'dart:typed_data';

import 'package:goiabeira/0_Core/Enums/image_type_enum.dart';
import 'package:image_picker/image_picker.dart';

/// A service for picking images using the device's image picker.
class ImagePickerService {
  final ImagePicker picker;

  ImagePickerService({required this.picker});

  /// Picks multiple images from the gallery.
  ///
  /// If [imageType] is [ImageType.file], returns a [List<File>].
  /// Otherwise, returns a [List<Uint8List>].
  ///
  /// [imageQuality] can be adjusted to control the compression quality.
  Future<List<Object>> pickMultipleImages({
    ImageTypeEnum imageType = ImageTypeEnum.uint8List,
    int imageQuality = 100,
  }) async {
    final List<XFile> images = await picker.pickMultiImage(
      imageQuality: imageQuality,
    );

    if (imageType == ImageTypeEnum.file) {
      // Convert XFile to File.
      return images.map((image) => File(image.path)).toList();
    } else {
      // Convert XFile to Uint8List concurrently.
      return await Future.wait(images.map((image) => image.readAsBytes()));
    }
  }

  /// Picks a single image from the specified [source].
  ///
  /// If [imageType] is [ImageType.file], returns a [File].
  /// Otherwise, returns a [Uint8List].
  ///
  /// [imageQuality] controls the compression quality.
  Future<Object?> pickSingleImage({
    ImageSource source = ImageSource.gallery,
    ImageTypeEnum imageType = ImageTypeEnum.uint8List,
    int imageQuality = 100,
  }) async {
    final XFile? image = await picker.pickImage(
      imageQuality: imageQuality,
      source: source,
    );
    if (image == null) return null;

    if (imageType == ImageTypeEnum.file) {
      return File(image.path);
    } else {
      return await image.readAsBytes();
    }
  }

  /// Converts a list of [XFile] objects to a list of [File] objects.
  List<File> convertXFileListToFileList(List<XFile> xFiles) {
    return xFiles.map((xFile) => File(xFile.path)).toList();
  }
}
