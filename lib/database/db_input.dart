import 'package:daily_financial_recording/model/model_input.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBInput {
  static Future<Database> dbInput() async {
    final dbPath = await getDatabasesPath();
    return openDatabase(
      join(dbPath, 'input.db'),
      onCreate: (dbIn, version) {
        return dbIn.execute('''CREATE TABLE input(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      nama_project TEXT,
      date_project TEXT,
      laba_project INTEGER,
      type TEXT)''');
      },
      version: 1,
    );
  }

  Future<void> insertInput(ModelInput input) async {
    final dbIn = await DBInput.dbInput();
    await dbIn.insert(
      'input',
      input.toMap(),
      // conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<ModelInput>> getAllInput() async {
    final dbIn = await DBInput.dbInput();
    final List<Map<String, dynamic>> maps = await dbIn.query('input');

    return List.generate(maps.length, (i) => ModelInput.fromMap(maps[i]));
  }

  static Future<void> updateInput(ModelInput input) async {
    final dbIn = await DBInput.dbInput();
    await dbIn.update(
      'input',
      input.toMap(),
      where: 'id=?',
      whereArgs: [input.id],
    );
  }

  static Future<void> deleteInput(int id) async {
    final dbIn = await DBInput.dbInput();
    await dbIn.delete('input', where: 'id=?', whereArgs: [id]);
  }

  // static Future<void> deleteDatabaseFile() async {
  //   final dbPath = await getDatabasesPath();
  //   final path = join(dbPath, 'input.db');
  //   await deleteDatabase(path);
  // }
}
