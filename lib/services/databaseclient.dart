import 'package:newnippon/services/models.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:async';
import 'dart:io';

class ProductDatabaseProvider{
  ProductDatabaseProvider._();

static final ProductDatabaseProvider db = ProductDatabaseProvider._();
Database _database;
Future<Database> get database async {
    if (_database != null) return _database;
    _database = await getDatabaseInstance();
    return _database;
  }

  Future<Database> getDatabaseInstance() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, "product.db");
    return await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute("CREATE TABLE product ("
          "id integer primary key,"
          "title TEXT,"
          "price TEXT,"
          "imageurl TEXT,"
          "type TEXT"
          ")");
    });
  }

  addPersonToDatabase(Product product) async {
    final db = await database;
    var raw = await db.insert(
      "product",
      product.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return raw;
  }



  Future<List<Product>> getAllPersons() async {
    final db = await database;
    var response = await db.query("product");
    List<Product> list = response.map((c) => Product.fromMap(c)).toList();
    return list;
  }

  deletePersonWithId(int id) async {
    final db = await database;
    return db.delete("product", where: "id = ?", whereArgs: [id]);
  }

  checkproductWithId(int id) async {
    final db = await database;
    return db.query("product", where: "id = ?", whereArgs: [id]);
  }

}