//dbms 처리 코드 추상화..
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/user_info.dart';

class DatabaseHelper {
  //생성자..내부에서만 객체 생성이 가능하다.. singleton 으로 유치하고 싶어서..
  DatabaseHelper._init();

  static final DatabaseHelper instance = DatabaseHelper._init();

  //데이터베이스 초기화..한번만 하면 된다..
  //Database 객체의 함수를 이용해서 insert/update/delete/query 를 하는데..
  //외부에서 직접 Database 객체를 사용하는 것이 아니라.. 이 Helper 클래스의 함수를 호출해서..
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('user_info.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    //각 플랫폼에 맞는 db file 저장 디렉토리 경로 획득..
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    //테이블 create...
    db.execute('''
      CREATE TABLE user_info (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT,
      email TEXT,
      profileImagePath TEXT
      )
    ''');
  }

  //위젯에서 DBMS 작업을 위해서 호출할 함수들...
  Future<void> insertOrUpdateUser(UserInfo userInfo) async {
    final db = await instance.database;

    await db.delete('user_info'); //테이블 데이터 삭제,,
    await db.insert('user_info', userInfo.toMap()); //새로운 데이터 저장..
  }

  //db 저장 데이터 획득을 위해 호출..
  Future<UserInfo?> getUser() async {
    final db = await instance.database;
    final maps = await db.query('user_info');
    if (maps.isNotEmpty) {
      return UserInfo.fromMap(maps.first);
    }
    return null;
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
