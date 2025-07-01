import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

/// A widget that provides two buttons for picking images from the gallery
/// or capturing a new image from the camera. Selected images (as [File])
/// are displayed in a grid.
class ImagePickerWidget extends StatefulWidget {
  final List<File?> selectedImages;
  final Function(List<File>) onImagesSelected;
  const ImagePickerWidget({
    required this.onImagesSelected,
    this.selectedImages = const [],
    super.key,
  });

  @override
  State<ImagePickerWidget> createState() => _ImagePickerWidgetState();
}

class _ImagePickerWidgetState extends State<ImagePickerWidget> {
  final ImagePicker _picker = ImagePicker();
  final List<File> _selectedImages = [];

  @override
  void initState() {
    super.initState();
    if (widget.selectedImages.isNotEmpty) {
      _selectedImages.addAll(widget.selectedImages.whereType<File>());
    }
  }

  /// Picks multiple images from the gallery.
  Future<void> _pickFromGallery() async {
    try {
      final List<XFile> pickedFiles = await _picker.pickMultiImage(
        imageQuality: 80,
      );
      if (pickedFiles.isNotEmpty) {
        setState(() {
          _selectedImages.clear();
          _selectedImages.addAll(
            pickedFiles.map((xFile) => File(xFile.path)).toList(),
          );
        });
        widget.onImagesSelected(_selectedImages);
      }
    } catch (e) {
      debugPrint('Error picking images from gallery: $e');
    }
  }

  /// Captures a new image using the camera.
  Future<void> _captureFromCamera() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
      );
      if (pickedFile != null) {
        setState(() {
          _selectedImages.clear();
          _selectedImages.add(File(pickedFile.path));
        });
        widget.onImagesSelected(_selectedImages);
      }
    } catch (e) {
      debugPrint('Error capturing image from camera: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Buttons row
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton.icon(
                onPressed: _pickFromGallery,
                icon: const Icon(Icons.photo_library),
                label: const Text("Gallery"),
              ),
              ElevatedButton.icon(
                onPressed: _captureFromCamera,
                icon: const Icon(Icons.camera_alt),
                label: const Text("Camera"),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        // Display selected images in a grid view
        Expanded(
          child:
              _selectedImages.isEmpty
                  ? const Center(child: Text("No images selected"))
                  : GridView.builder(
                    padding: const EdgeInsets.all(8.0),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                        ),
                    itemCount: _selectedImages.length,
                    itemBuilder: (context, index) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.file(
                          _selectedImages[index],
                          fit: BoxFit.cover,
                        ),
                      );
                    },
                  ),
        ),
      ],
    );
  }
}
