
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class FlutterStorageHelper{
  final _storage = FlutterSecureStorage();


  Future<dynamic> read(String storageKey) async {
    final val = await _storage.read(
      key: storageKey
    );
    return val;
  }

  void deleteAll() async {
    await _storage.deleteAll(
    
    );
  
  }

  void addNewItem(String key, String value) async {
    await _storage.write(
      key: key,
      value: value,
    );
  }
}