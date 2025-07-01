import 'dart:io';
import 'package:goiabeira/3_Domain_Layer/Repo/file_storage_repo.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class LocalFileStorageRepo implements FileStorageRepo<File> {
  late final Directory _appDir;

  @override
  Future<void> init() async {
    _appDir = await getApplicationDocumentsDirectory();
  }

  @override
  Future<String> createFile(File file) async {
    // Generate a unique file name by appending the current timestamp.
    final fileName =
        '${DateTime.now().millisecondsSinceEpoch}_${file.uri.pathSegments.last}';
    final savedPath = join(_appDir.path, fileName);
    await file.copy(savedPath);
    print("File copied to: $savedPath"); // For debugging
    // Return only the fileName (relative path)
    return fileName;
  }

  /// Uploads multiple files and returns a list of their saved relative paths.
  @override
  Future<List<String>> createMultipleFiles(List<File?> files) async {
    final savedPaths = <String>[];
    if (files.isEmpty) return savedPaths;

    try {
      for (var file in files) {
        if (file == null) continue;
        final savedPath = await createFile(file);
        savedPaths.add(savedPath);
      }
      return savedPaths;
    } catch (e) {
      throw Exception('Failed to create multiple files: $e');
    }
  }

  @override
  Future<File?> readFile(String relativeFilePath) async {
    // Construct the absolute path by combining _appDir and the relative file path.
    final file = File(join(_appDir.path, relativeFilePath));
    if (await file.exists()) return file;
    return null;
  }

  @override
  Future<void> updateFile(String relativeFilePath, File file) async {
    final newFile = File(join(_appDir.path, relativeFilePath));
    await file.copy(newFile.path);
  }

  @override
  Future<void> deleteFile(String relativeFilePath) async {
    final file = File(join(_appDir.path, relativeFilePath));
    await file.delete();
  }

  @override
  Future<void> deleteFiles(List<String> relativeFilePaths) async {
    List<Future> futures = [];
    for (var filePath in relativeFilePaths) {
      futures.add(deleteFile(filePath));
    }
    try {
      await Future.wait(futures);
    } catch (e) {
      print('Error deleting files: $e');
    }
  }

  @override
  Future<List<File>> readAllFiles() async {
    final files = Directory(_appDir.path).listSync();
    return files.map((file) => File(file.path)).toList();
  }
}
