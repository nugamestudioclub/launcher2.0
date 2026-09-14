import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'flutter_flow/flutter_flow_util.dart';

class FFAppState extends ChangeNotifier {
  static FFAppState _instance = FFAppState._internal();

  factory FFAppState() {
    return _instance;
  }

  FFAppState._internal();

  static void reset() {
    _instance = FFAppState._internal();
  }

  Future initializePersistedState() async {
    prefs = await SharedPreferences.getInstance();
    _safeInit(() {
      _GamesData = prefs.getStringList('ff_GamesData')?.map((x) {
            try {
              return jsonDecode(x);
            } catch (e) {
              return {};
            }
          }).toList() ??
          _GamesData;
    });
  }

  void update(VoidCallback callback) {
    callback();
    notifyListeners();
  }

  late SharedPreferences prefs;

  List<String> _GamesShown = [];
  List<String> get GamesShown => _GamesShown;
  set GamesShown(List<String> value) {
    _GamesShown = value;
  }

  void addToGamesShown(String value) {
    _GamesShown.add(value);
  }

  void removeFromGamesShown(String value) {
    _GamesShown.remove(value);
  }

  void removeAtIndexFromGamesShown(int index) {
    _GamesShown.removeAt(index);
  }

  void updateGamesShownAtIndex(
    int index,
    String Function(String) updateFn,
  ) {
    _GamesShown[index] = updateFn(_GamesShown[index]);
  }

  void insertAtIndexInGamesShown(int index, String value) {
    _GamesShown.insert(index, value);
  }

  List<dynamic> _GamesData = [
    jsonDecode(
        '{"Name":"Station Obscurum","Description":"Test description","Path":"C://path/to/location"}')
  ];
  List<dynamic> get GamesData => _GamesData;
  set GamesData(List<dynamic> value) {
    _GamesData = value;
    prefs.setStringList(
        'ff_GamesData', value.map((x) => jsonEncode(x)).toList());
  }

  void addToGamesData(dynamic value) {
    _GamesData.add(value);
    prefs.setStringList(
        'ff_GamesData', _GamesData.map((x) => jsonEncode(x)).toList());
  }

  void removeFromGamesData(dynamic value) {
    _GamesData.remove(value);
    prefs.setStringList(
        'ff_GamesData', _GamesData.map((x) => jsonEncode(x)).toList());
  }

  void removeAtIndexFromGamesData(int index) {
    _GamesData.removeAt(index);
    prefs.setStringList(
        'ff_GamesData', _GamesData.map((x) => jsonEncode(x)).toList());
  }

  void updateGamesDataAtIndex(
    int index,
    dynamic Function(dynamic) updateFn,
  ) {
    _GamesData[index] = updateFn(_GamesData[index]);
    prefs.setStringList(
        'ff_GamesData', _GamesData.map((x) => jsonEncode(x)).toList());
  }

  void insertAtIndexInGamesData(int index, dynamic value) {
    _GamesData.insert(index, value);
    prefs.setStringList(
        'ff_GamesData', _GamesData.map((x) => jsonEncode(x)).toList());
  }
}

LatLng? _latLngFromString(String? val) {
  if (val == null) {
    return null;
  }
  final split = val.split(',');
  final lat = double.parse(split.first);
  final lng = double.parse(split.last);
  return LatLng(lat, lng);
}

void _safeInit(Function() initializeField) {
  try {
    initializeField();
  } catch (_) {}
}

Future _safeInitAsync(Function() initializeField) async {
  try {
    await initializeField();
  } catch (_) {}
}
