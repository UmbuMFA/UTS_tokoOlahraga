import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
// import 'package:uts_toko_olahraga/Model/Item.dart';
import 'package:uts_toko_olahraga/Model/Barang.dart';
import 'package:uts_toko_olahraga/Model/Kategori.dart';
import 'package:uts_toko_olahraga/Model/User.dart';

class DbHelper {
  static DbHelper _dbHelper;
  static Database _database;
  DbHelper._createObject();

  Future<Database> initDb() async {
    //untuk menentukan nama database dan lokasi yg dibuat
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'toko.db';

    //create, read databases
    var itemDatabase = openDatabase(
      path,
      version: 7,
      onCreate: _createDb,
      onUpgrade:_onUpgrade,
    );
    //mengembalikan nilai object sebagai hasil dari fungsinya
    return itemDatabase;
  }

  Future<FutureOr<void>> _onUpgrade(Database db, int oldVersion, int newVersion) async {
     _createDb(db, newVersion);
  }


  //buat tabel baru dengan nama item //ditambah kode dan stock
  void _createDb(Database db, int version) async {
    var batch = db.batch();
    batch.execute('DROP TABLE IF EXISTS barang');
    batch.execute('DROP TABLE IF EXISTS kategori');
    batch.execute('DROP TABLE IF EXISTS user');
    await db.execute('''
      CREATE TABLE barang (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        kode TEXT,
        price INTEGER,
        stock INTERGER
        kategori text
        FOREIGN KEY (kategori) REFERENCE kategori (name),
          )
 ''');

 await db.execute('''
      CREATE TABLE kategori (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
          )
 ''');
    batch.execute('''
    CREATE TABLE user (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    username TEXT,
    password TEXT,
    name TEXT
    )
    ''');
    await batch.commit();
  }

  

//select databases barang
  Future<List<Map<String, dynamic>>> select() async {
    Database db = await this.initDb();
    var mapList = await db.query('barang', orderBy: 'name');
    return mapList;
  }

  
//select databases kategori
  Future<List<Map<String, dynamic>>> selectKategori() async {
    Database db = await this.initDb();
    var mapList = await db.query('kategori', orderBy: 'name');
    return mapList;
  }

  //select databases User
  Future<List<Map<String, dynamic>>> selectUser(int id) async {
    Database db = await this.initDb();
    var mapList = await db.query('user',limit: 3, where: 'id = $id');
    return mapList;
  }

//create databases barang
  Future<int> insert(Barang object) async {
    Database db = await this.initDb();
    int count = await db.insert('barang', object.toMap());
    return count;
  }

  //create databases Kategori
  Future<int> insertKategori(Barang object) async {
    Database db = await this.initDb();
    int count = await db.insert('kategori', object.toMap());
    return count;
  }

  //create databases user
  Future<int> insertUser(User user) async {
    Database db = await this.initDb();
    int count = await db.insert('user', user.toMapUser());
    return count;
  }

//update databases
  Future<int> update(Barang object) async {
    Database db = await this.initDb();
    int count = await db
        .update('barang', object.toMap(), where: 'id=?', whereArgs: [object.id]);
    return count;
  }

  //update databases
  Future<int> updateKategori(Barang object) async {
    Database db = await this.initDb();
    int count = await db
        .update('kategori', object.toMap(), where: 'id=?', whereArgs: [object.id]);
    return count;
  }

  //update databases user
  Future<int> updateUser(User user) async {
    Database db = await this.initDb();
    int count = await db
        .update('user', user.toMapUser(), where: 'id=?', whereArgs: [user.id]);
    return count;
  }

  //delete databases barang
  Future<int> delete(int id) async {
    Database db = await this.initDb();
    int count = await db.delete('barang', where: 'id=?', whereArgs: [id]);
    return count;
  }
  

  Future<int> deleteKategori(int id) async {
    Database db = await this.initDb();
    int count = await db.delete('kategori', where: 'id=?', whereArgs: [id]);
    return count;
  }

  Future<List<Barang>> getItemList() async {
    var itemMapList = await select();
    int count = itemMapList.length;
    // ignore: deprecated_member_use
    List<Barang> itemList = List<Barang>();
    for (int i = 0; i < count; i++) {
      itemList.add(Barang.fromMap(itemMapList[i]));
    }
    return itemList;
  }

  
  Future<List<Kategori>> getKategoriList() async {
    var itemMapList = await select();
    int count = itemMapList.length;
    // ignore: deprecated_member_use
    List<Kategori> itemList = List<Kategori>();
    for (int i = 0; i < count; i++) {
      itemList.add(Kategori.fromMap(itemMapList[i]));
    }
    return itemList;
  }

   Future<List<User>> getUserList(int id) async {
    var itemMapList = await selectUser(id);
    int count = itemMapList.length;
    List<User> itemList = List<User>();
    for (int i = 0; i < count; i++) {
      itemList.add(User.fromMapUser(itemMapList[i]));
    }
    return itemList;
  }

   Future<User> getLogin(String user, String password) async {
    var dbClient = await this.initDb();
    var res = await dbClient.rawQuery(
        "SELECT * FROM user WHERE username = '$user' and password = '$password'");

    if (res.length > 0) {
      return new User.fromMapUser(res.first);
    }
    return null;
  }

  Future<List<User>> getAllUser() async {
    var dbClient = await this.initDb();
    var res = await dbClient.query("user");

    List<User> list =
        res.isNotEmpty ? res.map((c) => User.fromMapUser(c)).toList() : null;
    return list;
  }


  factory DbHelper() {
    if (_dbHelper == null) {
      _dbHelper = DbHelper._createObject();
    }
    return _dbHelper;
  }
  Future<Database> get database async {
    if (_database == null) {
      _database = await initDb();
    }
    return _database;
  }
}
