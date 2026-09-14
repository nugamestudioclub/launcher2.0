import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:xml/xml.dart';

import 'gameItem.dart';
import 'pages/home_page/importer.dart';

/// Read/write access to the list of games the launcher shows.
///
/// `assets/games.xml` ships inside the application bundle and is read-only at
/// runtime, so it cannot be the file that add/remove writes to. Instead it acts
/// as the seed: the first time the launcher starts it is copied to a writable
/// per-user file, and every later read and write uses that copy.
class GameCatalog {
  GameCatalog._();

  static const String _fileName = 'games.xml';
  static const String _bundledCatalog = 'assets/$_fileName';

  /// The writable catalog, under the per-user application-support directory
  /// (`%APPDATA%\<app>\games.xml` on Windows).
  static Future<File> catalogFile() async {
    final directory = await getApplicationSupportDirectory();
    return File('${directory.path}${Platform.pathSeparator}$_fileName');
  }

  /// Loads the catalog, seeding it from the bundled asset on first run.
  ///
  /// A missing or unreadable user file falls back to the bundled catalog so a
  /// bad edit leaves the launcher usable rather than empty.
  static Future<List<GameItem>> load() async {
    final file = await catalogFile();

    if (!await file.exists()) {
      await _seedFromBundle(file);
    }

    try {
      return parseXmlData(XmlDocument.parse(await file.readAsString()));
    } catch (e) {
      return _loadBundled();
    }
  }

  /// Writes [games] to the user catalog, replacing its contents.
  static Future<void> save(List<GameItem> games) async {
    final file = await catalogFile();
    await file.parent.create(recursive: true);
    await file.writeAsString(gamesToXmlString(games));
  }

  static Future<void> _seedFromBundle(File file) async {
    try {
      await file.parent.create(recursive: true);
      await file.writeAsString(await rootBundle.loadString(_bundledCatalog));
    } catch (e) {}
  }

  static Future<List<GameItem>> _loadBundled() async {
    try {
      final bundled = await rootBundle.loadString(_bundledCatalog);
      return parseXmlData(XmlDocument.parse(bundled));
    } catch (e) {
      return <GameItem>[];
    }
  }
}
