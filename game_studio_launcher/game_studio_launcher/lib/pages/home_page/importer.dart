import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:xml/xml.dart';
import 'package:game_studio_launcher/gameItem.dart';
import 'package:process_run/cmd_run.dart';
import 'dart:io' show Platform, Process;

Future<XmlDocument> readXmLFile() async {
  String xmlString = await rootBundle.loadString('assets/games.xml');
  return XmlDocument.parse(xmlString);
}

List<GameItem> parseXmlData(XmlDocument document) {
  Iterable<XmlElement> games = document.findAllElements('game');
  List<GameItem> gameItems = [];
  for (var game in games) {
    String? name = game.findElements('name').first.firstChild!.value;
    String? description =
        game.findElements('description').first.firstChild!.value;
    String? path = game.findElements('path').first.firstChild!.value;
    String? imagePath = game.findElements('imagePath').first.firstChild!.value;

    // Print these values to the console
    if (name != null) print('Name: $name');
    if (description != null) print('Description: $description');
    if (path != null) print('Path: $path');
    if (imagePath != null) print('Image Path: $imagePath');
    gameItems.add(GameItem(
        name: name!,
        description: description!,
        path: path!,
        imagePath: imagePath!,
        isVisible: true));
  }
  return gameItems;
}

Widget _buildPopupDialog(BuildContext context, String title, var error) {
  return new AlertDialog(
    title: Text(title),
    content: new Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(error.toString()),
      ],
    ),
    actions: <Widget>[
      new TextButton(
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
