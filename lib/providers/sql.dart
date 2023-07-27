// ignore_for_file: avoid_print

import 'package:cbs/providers/product_class.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;

class SQLHelper {
  static Database? _database;
  static get getDatabase async {
    if (_database != null) return _database;
    _database = await initDatabase();
    return _database;
  }

  static Future<Database> initDatabase() async {
    String path = p.join(await getDatabasesPath(), 'shopping_database.db');
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  static Future _onCreate(Database db, int verstion) async {
    Batch batch = db.batch();
    batch.execute('''
CREATE TABLE cart_items (
  documentId TEXT PRIMARY KEY,
  name TEXT,
  price DOUBLE,
  qty INTEGER,
  qntty INTEGER,
  imagesUrl TEXT,
  suppId TEXT
)
''');

    batch.execute('''
CREATE TABLE wish_items (
  documentId TEXT PRIMARY KEY,
  name TEXT,
  price DOUBLE,
  qty INTEGER,
  qntty INTEGER,
  imagesUrl TEXT,
  suppId TEXT
)
''');

    batch.commit();

    print('on create was called');
  }

  static Future insertCartItem(Product product) async {
    Database db = await getDatabase;
    await db.insert('cart_items',
        product.toMap() /*  conflictAlgorithm: ConflictAlgorithm.replace */);
    print(await db.query('cart_items'));
  }

  static Future insertWishItem(Product product) async {
    Database db = await getDatabase;
    await db.insert('wish_items', product.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    print(await db.query('wish_items'));
  }

  static Future insertNoteRaw() async {
    Database db = await getDatabase;
    await db.rawInsert('INSERT INTO notes(title, content) VALUES(?, ?)',
        ['another name', '12345678']);
    print(await db.rawQuery('SELECT * FROM notes'));
  }

  static Future removeAllItems() async {
    Database db = await getDatabase;
    await db.execute('DELETE FROM cart_items');
  }

  static Future<List<Map<String, dynamic>>> get notes async {
    Database db = await getDatabase;
    return db.query(
      'cart_items',
    );
  }

  static Future<List<Map>> loadItems() async {
    Database db = await getDatabase;
    return /* List<Map> maps = */ await db.query('cart_items');
    /*  return List.generate(maps.length, (i) {
      return Note(
        id: maps[i]['id'],
        title: maps[i]['title'],
        content: maps[i]['content'],
        description: maps[i]['description'],
      ).toMap();
    }); */
  }

/*   static Future /* <List<Map>> */ loadNotesId() async {
    Database db = await getDatabase;
    List<Map> maps = await db.rawQuery('SELECT id FROM notes');

    print(maps);
    /*  return List.generate(maps.length, (i) {
      return Note(
        id: maps[i]['id'],
        title: maps[i]['title'],
        content: maps[i]['content'],
        description: maps[i]['description'],
      ).toMap();
    }); */
  } */
/* 
  static Future<List<Map>> loadTodos() async {
    Database db = await getDatabase;
    List<Map> maps = await db.query('todos');
    return List.generate(maps.length, (i) {
      return Todo(
        id: maps[i]['id'],
        title: maps[i]['title'],
        value: maps[i]['value'],
      ).toMap();
    });
  } */
/* 
  static Future updateCartItem(Product newProduct) async {
    Database db = await getDatabase;
    await db.update('cart_items', newProduct.toMap(),
        where: 'id=?', whereArgs: [newProduct.documentId]);
  } */

  static Future updateCartItem(Product product, String status) async {
    Database db = await getDatabase;
    await db.rawUpdate('UPDATE cart_items SET qty = ? WHERE documentId = ?', [
      status == 'increment' ? product.qty + 1 : product.qty - 1,
      product.documentId
    ]);
  }

  static Future updateTodoChecked(int id, int currentValue) async {
    Database db = await getDatabase;
    await db.rawUpdate('UPDATE todos SET value = ? WHERE id = ?',
        [currentValue == 0 ? 1 : 0, id]);
  }

  static Future deleteCartItem(String id) async {
    Database db = await getDatabase;
    await db.delete('cart_items', where: 'documentId = ?', whereArgs: [id]);
  }

  static Future deleteNoteRaw(int id) async {
    Database db = await getDatabase;
    await db.rawDelete('DELETE FROM notes WHERE id = ?', [id]);
  }

  static Future deleteAllItems() async {
    Database db = await getDatabase;
    await db.rawDelete('DELETE FROM cart_items');
  }

  static Future deleteAllTodos() async {
    Database db = await getDatabase;
    await db.rawDelete('DELETE FROM todos');
  }
}
/* 
class Note {
  final int id;
  final String title;
  final String content;
  String? description;

  Note(
      {required this.id,
      required this.title,
      required this.content,
      this.description});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'description': description,
    };
  }

  @override
  String toString() {
    return 'Note{id:$id , title: $title , content:$content , description:$description}';
  }
}

class Todo {
  final int? id;
  final String title;
  int value;

  Todo({this.id, required this.title, this.value = 0});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'value': value,
    };
  }

  @override
  String toString() {
    return 'Note{id:$id , title: $title , value:$value }';
  }
}
 */