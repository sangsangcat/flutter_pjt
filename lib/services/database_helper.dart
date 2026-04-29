import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/trip_destination.dart';

class DatabaseHelper {
  // 싱글톤 패턴 유지
  DatabaseHelper._init();
  static final DatabaseHelper instance = DatabaseHelper._init();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('trip_cache.db'); // DB 파일명 변경
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    // 버전을 2로 올려서 새로운 스키마 적용 (기존 user_info 제거 대응)
    return await openDatabase(path, version: 2, onCreate: _createDB, onUpgrade: _onUpgrade);
  }

  Future _createDB(Database db, int version) async {
    // 여행 상품 정보를 캐싱하기 위한 테이블 생성
    await db.execute('''
      CREATE TABLE trip_destinations (
        id INTEGER PRIMARY KEY,
        name TEXT,
        country TEXT,
        continent TEXT,
        description TEXT,
        imagePath TEXT,
        discount TEXT,
        products TEXT
      )
    ''');
  }

  // 데이터베이스 구조 변경 대응
  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('DROP TABLE IF EXISTS user_info');
      await _createDB(db, newVersion);
    }
  }

  // --- 여행지 캐시 관련 함수 ---

  // 모든 여행지 캐시 저장
  Future<void> saveDestinations(List<TripDestination> destinations) async {
    final db = await instance.database;
    await db.transaction((txn) async {
      await txn.delete('trip_destinations'); // 이전 캐시 삭제
      for (var destination in destinations) {
        await txn.insert('trip_destinations', destination.toMap());
      }
    });
  }

  // 캐시된 여행지 목록 가져오기
  Future<List<TripDestination>> getCachedDestinations() async {
    final db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query('trip_destinations');
    return maps.map((map) => TripDestination.fromDbMap(map)).toList();
  }

  // 특정 여행지 정보만 가져오기 (상세보기 캐시 활용 가능)
  Future<TripDestination?> getCachedDestination(int id) async {
    final db = await instance.database;
    final maps = await db.query('trip_destinations', where: 'id = ?', whereArgs: [id]);
    if (maps.isNotEmpty) {
      return TripDestination.fromDbMap(maps.first);
    }
    return null;
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
