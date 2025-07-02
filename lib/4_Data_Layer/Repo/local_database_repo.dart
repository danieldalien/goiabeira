import 'package:goiabeira/3_Domain_Layer/Repo/database_repo.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class LocalDatabaseRepo<T> implements DatabaseRepository<T> {
  Database? _database;
  late final String _tableName;

  /// A function to serialize `T` into a Map for SQLite.
  @override
  final Map<String, dynamic> Function(T model) toMap;

  /// A function to deserialize a Map from SQLite into `T`.
  @override
  final T Function(Map<String, dynamic> json) fromMap;

  LocalDatabaseRepo({required this.toMap, required this.fromMap});
  @override
  Future<void> init(dynamic stockDatabaseTable) async {
    if (_database == null) {
      // Initialize the database
      if (stockDatabaseTable is Map<String, String>) {
        final dbPath = await getDatabasesPath();
        _tableName = stockDatabaseTable.keys.first;
        String table = stockDatabaseTable.values.first;
        final path = join(dbPath, _tableName);

        _database = await openDatabase(
          path,
          version: 1,
          onCreate: (db, version) async {
            await db.execute(table);
          },
        );
      } else {
        throw Exception('Invalid database table');
      }
    }
  }

  @override
  Future<void> create(T model) async {
    print('create');
    print(model.runtimeType); // Ensure values match expected types
    await _database!.insert(
      _tableName,
      toMap(model),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<T?> read(String id) async {
    final result = await _database!.query(
      _tableName,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (result.isNotEmpty) {
      return fromMap(result.first);
    }
    return null;
  }

  @override
  Future<void> update(String id, T model) async {
    await _database!.update(
      _tableName,
      toMap(model),
      where: 'id = ?',
      whereArgs: [id],
    );
  }
  //test

  @override
  Future<void> delete(String id) async {
    await _database!.delete(_tableName, where: 'id = ?', whereArgs: [id]);
  }

  @override
  Future<List<T>> readAll() async {
    final result = await _database!.query(_tableName);
    return result.map((json) => fromMap(json)).toList();
  }
}
