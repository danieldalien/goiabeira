import 'dart:io';
import 'package:goiabeira/3_Domain_Layer/Repo/file_storage_repo.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class LocalFileStorageRepo implements FileStorageRepo<File> {
  late Directory _imagesDir;
  bool _initialized = false;

  /// Ensures the images directory exists before any operation.
  Future<void> _ensureInitialized() async {
    if (_initialized) return;

    // Use Application Support (persistent, not iCloud-backed)
    final base = await getApplicationSupportDirectory();
    _imagesDir = Directory(p.join(base.path, 'images'));

    if (!await _imagesDir.exists()) {
      await _imagesDir.create(recursive: true);
    }

    _initialized = true;
  }

  @override
  Future<void> init() async => _ensureInitialized();

  /// Helper: build full absolute path from stored filename.
  String resolveAbsolutePath(String storedFileName) =>
      p.join(_imagesDir.path, storedFileName);

  /// Save a single file in persistent storage.
  @override
  Future<String> createFile(File file) async {
    await _ensureInitialized();

    // Generate unique name with timestamp and preserve extension.
    final ext = p.extension(file.path);
    final millis = DateTime.now().millisecondsSinceEpoch;
    final fileName = '${millis}_image$ext';
    final savedPath = p.join(_imagesDir.path, fileName);

    await file.copy(savedPath);
    print("File copied to: $savedPath");

    // Return only the filename (relative path).
    return fileName;
  }

  /// Save multiple files and return list of relative names.
  @override
  Future<List<String>> createMultipleFiles(List<File?> files) async {
    await _ensureInitialized();

    final savedPaths = <String>[];
    for (final f in files) {
      if (f == null) continue;
      final savedPath = await createFile(f);
      savedPaths.add(savedPath);
    }
    return savedPaths;
  }

  /// Read file by stored relative filename.
  @override
  Future<File?> readFile(String relativeFilePath) async {
    await _ensureInitialized();
    final absolutePath = resolveAbsolutePath(relativeFilePath);

    print('Reading file: $absolutePath (relative: $relativeFilePath)');

    final file = File(absolutePath);
    if (await file.exists()) return file;

    // Fallback: handle legacy .jpg.jpg case
    final fixed = relativeFilePath.replaceFirst(
      RegExp(r'(\.jpg|\.jpeg|\.png){2}$', caseSensitive: false),
      r'$1',
    );
    if (fixed != relativeFilePath) {
      final legacyFile = File(resolveAbsolutePath(fixed));
      if (await legacyFile.exists()) return legacyFile;
    }

    // Fallback: if file was accidentally stored in Documents before
    final docsDir = await getApplicationDocumentsDirectory();
    final docsPath = p.join(docsDir.path, relativeFilePath);
    final docsFile = File(docsPath);
    if (await docsFile.exists()) return docsFile;

    print('File not found: $relativeFilePath');
    return null;
  }

  /// Update an existing file.
  @override
  Future<void> updateFile(String relativeFilePath, File file) async {
    await _ensureInitialized();
    final newPath = resolveAbsolutePath(relativeFilePath);
    await file.copy(newPath);
  }

  /// Delete a single file.
  @override
  Future<void> deleteFile(String relativeFilePath) async {
    await _ensureInitialized();
    final file = File(resolveAbsolutePath(relativeFilePath));
    if (await file.exists()) {
      await file.delete();
    }
  }

  /// Delete multiple files safely.
  @override
  Future<void> deleteFiles(List<String> relativeFilePaths) async {
    await _ensureInitialized();
    try {
      await Future.wait(relativeFilePaths.map(deleteFile));
    } catch (e) {
      print('Error deleting files: $e');
    }
  }

  /// Read all files stored in the images directory.
  @override
  Future<List<File>> readAllFiles() async {
    await _ensureInitialized();
    if (!await _imagesDir.exists()) return <File>[];
    final entries = _imagesDir.listSync();
    return entries.whereType<File>().toList(growable: false);
  }
}
