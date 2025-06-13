import 'package:daily_financial_recording/model/model_account.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBAccount {
  static Future<Database> dbAccount() async {
    final dbPath = await getDatabasesPath();
    return openDatabase(
      join(dbPath, 'account.db'),
      onCreate: (db, version) {
        return db.execute('''CREATE TABLE account(
          id INTEGER PRIMARY KEY AUTOINCREMENT, 
          nama TEXT, 
          phone INTEGER, 
          email TEXT,
          password TEXT)''');
      },
      version: 1,
    );
  }

  Future<void> insertAccount(ModelAccount account) async {
    final db = await DBAccount.dbAccount();
    final existing = await db.query(
      'account',
      where: 'email = ? OR phone = ?',
      whereArgs: [account.email, account.phone],
    );
    if (existing.isNotEmpty) {
      throw Exception('Email or phone number already exists');
    }
    await db.insert(
      'account',
      account.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<ModelAccount>> getAllAccount() async {
    final db = await DBAccount.dbAccount();
    final List<Map<String, dynamic>> maps = await db.query('account');
    return List.generate(maps.length, (i) => ModelAccount.fromMap(maps[i]));
  }
}
