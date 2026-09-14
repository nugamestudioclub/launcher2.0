import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:xml/xml.dart';
import 'package:game_studio_launcher/gameItem.dart';
import 'dart:io' show Platform, Process;

Future<XmlDocument> readXmLFile() async {
  String xmlString = await rootBundle.loadString('assets/games.xml');
  return XmlDocument.parse(xmlString);
}

/// Text of the first [tag] child of [game], or '' when absent or empty.
///
/// Reading `firstChild!.value` instead would throw on an entry that leaves a
/// field blank (`<description></description>`), which games added through the
/// in-app form can easily do.
String _childText(XmlElement game, String tag) {
  final matches = game.findElements(tag);
  return matches.isEmpty ? '' : matches.first.innerText.trim();
}

List<GameItem> parseXmlData(XmlDocument document) {
  Iterable<XmlElement> games = document.findAllElements('game');
  List<GameItem> gameItems = [];
  for (var game in games) {
    final name = _childText(game, 'name');
    // An unnamed entry has nothing to show in the list, so skip it rather than
    // rendering a blank card.
    if (name.isEmpty) {
      continue;
    }
    gameItems.add(GameItem(
        name: name,
        description: _childText(game, 'description'),
        path: _childText(game, 'path'),
        imagePath: _childText(game, 'imagePath'),
        isVisible: true));
  }
  return gameItems;
}

/// Serializes [games] back into the same shape as `assets/games.xml`.
///
/// `isVisible` is deliberately not written out: it is transient
/// show/hide state for the sidebar filter, not part of the catalog.
String gamesToXmlString(List<GameItem> games) {
  final builder = XmlBuilder();
  builder.processing('xml', 'version="1.0"');
  builder.element('games', nest: () {
    for (final game in games) {
      builder.element('game', nest: () {
        builder.element('name', nest: game.name);
        builder.element('description', nest: game.description);
        builder.element('path', nest: game.path);
        builder.element('imagePath', nest: game.imagePath);
      });
    }
  });
  return builder.buildDocument().toXmlString(pretty: true, indent: '    ');
}

Widget _buildPopupDialog(BuildContext context, String title, var error) {
  return AlertDialog(
    title: Text(title),
    content: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(error.toString()),
      ],
    ),
    actions: <Widget>[
      TextButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: const Text('Close', style: TextStyle(color: Colors.black)),
      ),
    ],
  );
}

void launchApp(String path, BuildContext context) async {
  try {
    if (Platform.isWindows) {
      // Launch Notepad on Windows
      await Process.run(path, []);
      showDialog(
        context: context,
        builder: (BuildContext context) => _buildPopupDialog(
            context, "Launching Application!", "Launching at $path"),
      );
    } else if (Platform.isMacOS) {
      // Launch TextEdit on macOS
      await Process.run('open', ['-n', path]);
      showDialog(
        context: context,
        builder: (BuildContext context) => _buildPopupDialog(
            context, "Launching Application!", "Launching at $path"),
      );
    } else if (Platform.isLinux) {
      // Example for Linux, launching 'gedit'
      await Process.run(path, ['']);
      showDialog(
        context: context,
        builder: (BuildContext context) => _buildPopupDialog(
            context, "Launching Application!", "Launching at $path"),
      );
    }
  } catch (e) {
    showDialog(
      context: context,
      builder: (BuildContext context) =>
          _buildPopupDialog(context, "Failed to Launch Application", e),
    );
  }
}
