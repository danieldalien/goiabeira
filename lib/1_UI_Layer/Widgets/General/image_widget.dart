import 'dart:io';

import 'package:flutter/material.dart';

class ImageWidget extends StatelessWidget {
  final File? imageFile;
  final String? imageUrl;
  final double? width;
  final double? height;
  const ImageWidget({
    this.imageFile,
    this.imageUrl,
    this.width,
    this.height,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return _buildImage();
  }

  Widget _buildImage() {
    if (imageFile != null) {
      return Image.file(
        imageFile!,
        fit: BoxFit.cover,
        width: width ?? double.infinity,
        height: height ?? 200,
      );
    } else if (imageUrl != null) {
      return Image.network(
        imageUrl!,
        fit: BoxFit.cover,
        width: width ?? double.infinity,
        height: height ?? 200,
      );
    } else {
      return const Placeholder();
    }
  }
}
