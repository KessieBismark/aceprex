import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'model.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._();
  static Database? _database;

  DatabaseHelper._();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, 'library.db');

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE pdfs(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            library_id INTEGER,
            title TEXT,
            author TEXT,
            description TEXT,
            pdfPath TEXT,
            imagePath TEXT
      )
    ''');
  }

  Future<int> insertPDF(PDFModel pdf) async {
    final db = await database;
    return await db.insert('pdfs', pdf.toMap());
  }

  Future<List<PDFModel>> getPDFs() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('pdfs');
    return List.generate(maps.length, (i) => PDFModel.fromMap(maps[i]));
  }

  Future<int> deletePDF(int id) async {
    final db = await database;
    return await db.delete('pdfs', where: 'id = ?', whereArgs: [id]);
  }

    Future<bool> isLibraryIdExists(int libraryId) async {
    final db = await database;
    final result = await db.rawQuery(
        'SELECT EXISTS(SELECT 1 FROM pdfs WHERE library_id = ? LIMIT 1)',
        [libraryId]);
    return Sqflite.firstIntValue(result) == 1;
  }
}
