import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String> uploadProfileImage(String uid, File file) async {
    Reference ref = _storage.ref().child('profiles/$uid.jpg');
    await ref.putFile(file);
    return await ref.getDownloadURL();
  }

  Future<void> deleteProfileImage(String uid) async {
    try {
      await _storage.ref().child('profiles/$uid.jpg').delete();
    } catch (e) {
      // 파일이 없을 경우 대비
    }
  }
}
