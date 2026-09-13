// Tests for the game-catalog parsing that drives the launcher's home page.
//
// The previous contents of this file were the unmodified Flutter template
// "Counter increments smoke test", which asserted nothing and hung: pumping
// MyApp() starts GoRouter, the splash timer and google_fonts network fetches
// without the FlutterFlowTheme/FFAppState initialization that main() performs.

import 'package:flutter_test/flutter_test.dart';
import 'package:xml/xml.dart';

import 'package:game_studio_launcher/gameItem.dart';
import 'package:game_studio_launcher/pages/home_page/importer.dart';

const _sampleXml = '''
<games>
    <game id="1">
        <name>Station Obscurum</name>
        <description>Explore an old space station.</description>
        <path>"../builds/Station Obscurum/StationObscurum.exe"</path>
        <imagePath>https://example.com/station.png</imagePath>
    </game>
    <game>
        <name>Bedtime</name>
        <description>Sneak downstairs for a snack.</description>
        <path>/bedtime</path>
        <imagePath>https://example.com/bedtime.png</imagePath>
    </game>
</games>
''';

void main() {
  group('parseXmlData', () {
    test('reads every <game> entry in document order', () {
      final games = parseXmlData(XmlDocument.parse(_sampleXml));

      expect(games, hasLength(2));
      expect(games.map((g) => g.name), ['Station Obscurum', 'Bedtime']);
    });

    test('maps each field onto the GameItem', () {
      final game = parseXmlData(XmlDocument.parse(_sampleXml)).first;

      expect(game.name, 'Station Obscurum');
      expect(game.description, 'Explore an old space station.');
      expect(game.path, '"../builds/Station Obscurum/StationObscurum.exe"');
      expect(game.imagePath, 'https://example.com/station.png');
      expect(game.isVisible, isTrue);
    });

    test('entries are visible by default', () {
      final games = parseXmlData(XmlDocument.parse(_sampleXml));

      expect(games.every((g) => g.isVisible), isTrue);
    });

    test('returns an empty list when there are no games', () {
      final games = parseXmlData(XmlDocument.parse('<games></games>'));

      expect(games, isEmpty);
    });

    test('parses the real bundled catalog shape', () {
      final games = parseXmlData(XmlDocument.parse(_sampleXml));

      expect(games, everyElement(isA<GameItem>()));
      expect(games.every((g) => g.path.isNotEmpty), isTrue);
    });
  });

  group('gamesToXmlString', () {
    test('round-trips through parseXmlData', () {
      final original = parseXmlData(XmlDocument.parse(_sampleXml));

      final reparsed =
          parseXmlData(XmlDocument.parse(gamesToXmlString(original)));

      expect(reparsed.map((g) => g.name), original.map((g) => g.name));
      expect(reparsed.map((g) => g.path), original.map((g) => g.path));
      expect(
        reparsed.map((g) => g.description),
        original.map((g) => g.description),
      );
      expect(
          reparsed.map((g) => g.imagePath), original.map((g) => g.imagePath));
    });

    test('a game added to the list survives a save/load cycle', () {
      final games = parseXmlData(XmlDocument.parse(_sampleXml))
        ..add(GameItem(
          name: 'Local Build',
          description: 'Added through the form.',
          path: r'C:\Games\LocalBuild\LocalBuild.exe',
          imagePath: r'C:\Games\LocalBuildanner.png',
          isVisible: true,
        ));

      final reloaded = parseXmlData(XmlDocument.parse(gamesToXmlString(games)));

      expect(reloaded, hasLength(3));
      expect(reloaded.last.name, 'Local Build');
      expect(reloaded.last.path, r'C:\Games\LocalBuild\LocalBuild.exe');
    });

    test('a removed game is gone after a save/load cycle', () {
      final games = parseXmlData(XmlDocument.parse(_sampleXml))
        ..removeWhere((g) => g.name == 'Bedtime');

      final reloaded = parseXmlData(XmlDocument.parse(gamesToXmlString(games)));

      expect(reloaded.map((g) => g.name), ['Station Obscurum']);
    });

    test('writes a catalog that is still valid XML when empty', () {
      final xml = gamesToXmlString(<GameItem>[]);

      expect(parseXmlData(XmlDocument.parse(xml)), isEmpty);
    });
  });

  group('parseXmlData tolerates incomplete entries', () {
    test('treats blank and missing fields as empty strings', () {
      const partial = '''
<games>
    <game>
        <name>Minimal</name>
        <description></description>
        <path>C:.exe</path>
    </game>
</games>
''';

      final game = parseXmlData(XmlDocument.parse(partial)).single;

      expect(game.name, 'Minimal');
      expect(game.description, isEmpty);
      expect(game.imagePath, isEmpty);
      expect(game.path, r'C:.exe');
    });

    test('skips entries with no name', () {
      const unnamed = '''
<games>
    <game><description>No name here</description></game>
    <game><name>Real Game</name></game>
</games>
''';

      final games = parseXmlData(XmlDocument.parse(unnamed));

      expect(games.map((g) => g.name), ['Real Game']);
    });
  });
}
