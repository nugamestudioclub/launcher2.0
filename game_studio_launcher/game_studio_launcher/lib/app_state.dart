import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'flutter_flow/flutter_flow_util.dart';
import 'dart:convert';

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
              print("Can't decode persisted json. Error: $e.");
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
  set GamesShown(List<String> _value) {
    _GamesShown = _value;
  }

  void addToGamesShown(String _value) {
    _GamesShown.add(_value);
  }

  void removeFromGamesShown(String _value) {
    _GamesShown.remove(_value);
  }

  void removeAtIndexFromGamesShown(int _index) {
    _GamesShown.removeAt(_index);
  }

  void updateGamesShownAtIndex(
    int _index,
    String Function(String) updateFn,
  ) {
    _GamesShown[_index] = updateFn(_GamesShown[_index]);
  }

  void insertAtIndexInGamesShown(int _index, String _value) {
    _GamesShown.insert(_index, _value);
  }

  List<dynamic> _GamesData = [
    jsonDecode(
        '{\"Name\":\"Station Obscurum\",\"Description\":\"Test description\",\"Path\":\"C://path/to/location\"}')
  ];
  List<dynamic> get GamesData => _GamesData;
  set GamesData(List<dynamic> _value) {
    _GamesData = _value;
    prefs.setStringList(
        'ff_GamesData', _value.map((x) => jsonEncode(x)).toList());
  }

  void addToGamesData(dynamic _value) {
    _GamesData.add(_value);
    prefs.setStringList(
        'ff_GamesData', _GamesData.map((x) => jsonEncode(x)).toList());
  }

  void removeFromGamesData(dynamic _value) {
    _GamesData.remove(_value);
    prefs.setStringList(
        'ff_GamesData', _GamesData.map((x) => jsonEncode(x)).toList());
  }

  void removeAtIndexFromGamesData(int _index) {
    _GamesData.removeAt(_index);
    prefs.setStringList(
        'ff_GamesData', _GamesData.map((x) => jsonEncode(x)).toList());
  }

  void updateGamesDataAtIndex(
    int _index,
    dynamic Function(dynamic) updateFn,
  ) {
    _GamesData[_index] = updateFn(_GamesData[_index]);
    prefs.setStringList(
        'ff_GamesData', _GamesData.map((x) => jsonEncode(x)).toList());
  }

  void insertAtIndexInGamesData(int _index, dynamic _value) {
    _GamesData.insert(_index, _value);
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
