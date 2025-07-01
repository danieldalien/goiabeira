import 'dart:typed_data';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

/// A service class that provides widgets for image picking,
/// presentation, and selection.
class MyImagePicker {
  MyImagePicker();

  /// Displays a single picture inside a decorated container.
  /// A close icon is positioned at the top right which triggers [onTapDelete] if provided.
  Widget picturePresenter({
    required BuildContext context,
    required Uint8List imageBytes,
    VoidCallback? onTapDelete,
    double height = 300,
    Color backgroundColor = Colors.blueGrey,
  }) {
    final Widget imageChild =
        imageBytes.isNotEmpty
            ? Image.memory(imageBytes, fit: BoxFit.cover)
            : const Center(child: Text('No Image'));

    return Container(
      height: imageBytes.isNotEmpty ? height : 0,
      margin: const EdgeInsets.all(15),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Stack(
        children: [
          Positioned.fill(child: imageChild),
          if (onTapDelete != null)
            Positioned(
              top: 10,
              right: 10,
              child: GestureDetector(
                onTap: onTapDelete,
                child: const Icon(Icons.close, color: Colors.red, size: 24),
              ),
            ),
        ],
      ),
    );
  }

  /// Displays multiple images in a grid format.
  /// If [imageUrlsList] is provided, network images are displayed; otherwise, images from [imageByteList] are used.
  Widget showMultipleImages({
    required List<Uint8List> imageByteList,
    required BuildContext context,
    List<String>? imageUrlsList,
    double height = 300,
  }) {
    final int itemCount =
        imageUrlsList == null ? imageByteList.length : imageUrlsList.length;
    return SizedBox(
      height: height,
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 5.0,
          crossAxisSpacing: 5.0,
        ),
        itemCount: itemCount,
        itemBuilder: (context, index) {
          return imageUrlsList == null
              ? Image.memory(imageByteList[index], fit: BoxFit.cover)
              : Image.network(imageUrlsList[index], fit: BoxFit.cover);
        },
      ),
    );
  }

  /// Presents multiple images with arrow navigation and delete functionality.
  /// When an image is deleted, [onImageDeleted] is called with the updated list.
  Widget showMultipleImagesArrowNavigation({
    required List<Uint8List> imageByteList,
    required BuildContext context,
    required ValueChanged<List<Uint8List>> onImageDeleted,
    double height = 300,
    double width = 300,
  }) {
    // Create a mutable local copy.
    final List<Uint8List> localImageList = List.from(imageByteList);
    int imageIndex = 0;

    return StatefulBuilder(
      builder: (context, setState) {
        if (localImageList.isEmpty) {
          return const SizedBox.shrink();
        }
        return SizedBox(
          height: height,
          width: width,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Image.memory(localImageList[imageIndex], fit: BoxFit.cover),
              Positioned(
                left: 0,
                child: IconButton(
                  onPressed: () {
                    setState(() {
                      imageIndex =
                          (imageIndex > 0)
                              ? imageIndex - 1
                              : localImageList.length - 1;
                    });
                  },
                  icon: const Icon(Icons.arrow_back_ios),
                ),
              ),
              Positioned(
                right: 0,
                child: IconButton(
                  onPressed: () {
                    setState(() {
                      imageIndex =
                          (imageIndex < localImageList.length - 1)
                              ? imageIndex + 1
                              : 0;
                    });
                  },
                  icon: const Icon(Icons.arrow_forward_ios),
                ),
              ),
              Positioned(
                top: 0,
                right: 0,
                child: IconButton(
                  onPressed: () {
                    setState(() {
                      localImageList.removeAt(imageIndex);
                      if (localImageList.isNotEmpty &&
                          imageIndex >= localImageList.length) {
                        imageIndex = localImageList.length - 1;
                      }
                    });
                    onImageDeleted(localImageList);
                  },
                  icon: const Icon(Icons.delete, color: Colors.red),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// Converts a list of [XFile] objects to a list of [File] objects.
  List<File> convertXFileListToFileList(List<XFile> xFiles) {
    return xFiles.map((xFile) => File(xFile.path)).toList();
  }

  /// A button that lets users select multiple images from the gallery.
  /// Selected images are converted to bytes and passed to [onImagesSelected]. Optionally, [onFilesSelected] returns File objects.
  Widget multiImageGalleryPickerButton({
    required Function(List<Uint8List>) onImagesSelected,
    required ImagePicker picker,
    Function(List<File>)? onFilesSelected,
    Color? buttonBackgroundColor,
    Color iconColor = Colors.white,
  }) {
    buttonBackgroundColor ??= const Color.fromRGBO(66, 66, 66, 1);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: buttonBackgroundColor,
          foregroundColor: Colors.grey,
          elevation: 10,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        onPressed: () async {
          final List<XFile> images = await picker.pickMultiImage(
            imageQuality: 1,
          );
          if (images.isEmpty) return;
          if (onFilesSelected != null) {
            onFilesSelected(convertXFileListToFileList(images));
          }
          // Process all images concurrently.
          final selectedImages = await Future.wait(
            images.map((xFile) => xFile.readAsBytes()),
          );
          onImagesSelected(selectedImages);
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [Icon(Icons.collections, size: 30, color: iconColor)],
          ),
        ),
      ),
    );
  }

  /// A button for selecting a single image from the gallery.
  /// The image is converted to bytes and returned via [onImagesSelected]; optionally, [onFilesSelected] returns the File.
  Widget galleryPickerButton({
    required Function(Uint8List) onImagesSelected,
    required ImagePicker picker,
    Function(List<File>)? onFilesSelected,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.grey,
          shadowColor: Colors.grey[400],
          elevation: 10,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        onPressed: () async {
          final XFile? image = await picker.pickImage(
            imageQuality: 15,
            source: ImageSource.gallery,
          );
          if (image == null) return;
          if (onFilesSelected != null) {
            onFilesSelected(convertXFileListToFileList([image]));
          }
          final Uint8List selectedImage = await image.readAsBytes();
          onImagesSelected(selectedImage);
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
          child: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [Icon(Icons.image, size: 30, color: Colors.red)],
          ),
        ),
      ),
    );
  }

  /// A button for capturing an image using the camera.
  /// The captured image is converted to bytes and passed via [onImagesSelected];
  /// optionally, [onFilesSelected] returns the File.
  Widget cameraPictureButton({
    required Function(Uint8List) onImagesSelected,
    required ImagePicker picker,
    Function(List<File>)? onFilesSelected,
    Color? buttonBackgroundColor,
    Color iconColor = Colors.white,
  }) {
    buttonBackgroundColor ??= const Color.fromRGBO(66, 66, 66, 1);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: buttonBackgroundColor,
          foregroundColor: Colors.grey,
          elevation: 10,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        onPressed: () async {
          final XFile? image = await picker.pickImage(
            imageQuality: 15,
            source: ImageSource.camera,
          );
          if (image == null) return;
          if (onFilesSelected != null) {
            onFilesSelected(convertXFileListToFileList([image]));
          }
          final Uint8List selectedImage = await image.readAsBytes();
          onImagesSelected(selectedImage);
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [Icon(Icons.camera_alt, size: 30, color: iconColor)],
          ),
        ),
      ),
    );
  }

  /// A row of buttons allowing selection from the camera or gallery.
  Widget cameraGalleryRowPicker({
    required Function(Uint8List) onCameraImageSelected,
    required Function(Uint8List) onGalleryImageSelected,
    Function(List<File>)? onFilesSelected,
    required ImagePicker picker,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        cameraPictureButton(
          onImagesSelected: onCameraImageSelected,
          picker: picker,
          onFilesSelected: onFilesSelected,
        ),
        const SizedBox(width: 10),
        galleryPickerButton(
          onImagesSelected: onGalleryImageSelected,
          picker: picker,
          onFilesSelected: onFilesSelected,
        ),
      ],
    );
  }

  /// A row of buttons for selecting images from the camera or picking multiple images from the gallery.
  Widget cameraMultiGalleryRowPicker({
    required Function(Uint8List) onCameraImageSelected,
    required Function(List<Uint8List>) onGalleryImageSelected,
    Function(List<File>)? onFilesSelected,
    required ImagePicker picker,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        cameraPictureButton(
          onImagesSelected: onCameraImageSelected,
          picker: picker,
          onFilesSelected: onFilesSelected,
        ),
        const SizedBox(width: 10),
        multiImageGalleryPickerButton(
          onImagesSelected: onGalleryImageSelected,
          picker: picker,
          onFilesSelected: onFilesSelected,
        ),
      ],
    );
  }

  /// A composite widget that allows the user to choose and present pictures from the camera or gallery.
  /// Displays a title, the currently selected images (if any), and a row of picker buttons.
  Widget pictureChooserAndPresenter({
    required BuildContext context,
    required List<Uint8List> selectedImageByteList,
    required Function(List<Uint8List>) onImageDeleted,
    required Function(List<Uint8List>) onGallerySelected,
    required Function(Uint8List) onCameraSelected,
    required ImagePicker imagePicker,
    Function(List<File>)? onFilesSelected,
    String title = 'Picture: ',
    TextStyle titleStyle = const TextStyle(fontSize: 18, color: Colors.white),
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(10),
          child: Text(title, style: titleStyle),
        ),
        if (selectedImageByteList.isNotEmpty)
          Center(
            child: showMultipleImagesArrowNavigation(
              imageByteList: selectedImageByteList,
              context: context,
              onImageDeleted: onImageDeleted,
            ),
          ),
        cameraMultiGalleryRowPicker(
          picker: imagePicker,
          onCameraImageSelected: onCameraSelected,
          onGalleryImageSelected: onGallerySelected,
          onFilesSelected: onFilesSelected,
        ),
      ],
    );
  }
}
