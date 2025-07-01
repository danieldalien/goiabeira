abstract class FileStorageRepo<T> {
  Future<void> init();

  /// Creates and stores a file containing the given data.
  Future<String> createFile(T file);

  Future<List<String>> createMultipleFiles(List<T> files);

  /// Reads the file at the given [filePath] and returns its data.
  Future<T?> readFile(String filePath);

  /// Updates the file at the given [filePath] with new [file].
  Future<void> updateFile(String filePath, T file);

  /// Deletes the file at the given [filePath].
  Future<void> deleteFile(String filePath);

  Future<void> deleteFiles(List<String> filePaths);

  /// Reads all files in the storage directory and returns their data.
  Future<List<T>> readAllFiles();
}
