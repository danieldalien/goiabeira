abstract class DatabaseRepository<T> {
  /// A function to serialize `T` into a Map for SQLite.
  final Map<String, dynamic> Function(T model) toMap;

  /// A function to deserialize a Map from SQLite into `T`.
  final T Function(Map<String, dynamic> json) fromMap;

  DatabaseRepository({required this.toMap, required this.fromMap});

  Future<void> init(dynamic data);

  /// Inserts a new record of type [T] into the database.
  Future<void> create(T data);

  /// Reads a single record by its [id] and returns an instance of type [T].
  Future<T?> read(String id);

  /// Updates an existing record identified by [id] with new [data].
  Future<void> update(String id, T file);

  /// Deletes a record identified by [id] from the database.
  Future<void> delete(String id);

  /// Reads all records from the database and returns a list of type [T].
  Future<List<T>> readAll();
}
