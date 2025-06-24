import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/drink_entry.dart';

class DrinkStorage {
  static const _key = 'drink_entries';

  // Tüm içecek kayıtlarını yükle
  static Future<List<DrinkEntry>> loadEntries() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getStringList(_key) ?? [];
    return data.map((e) => DrinkEntry.fromMap(jsonDecode(e))).toList();
  }

  // Yeni bir içecek kaydı ekle
  static Future<void> addEntry(DrinkEntry entry) async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getStringList(_key) ?? [];
    data.add(jsonEncode(entry.toMap()));
    await prefs.setStringList(_key, data);
  }

  // Tüm kayıtları sil (isteğe bağlı)
  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}