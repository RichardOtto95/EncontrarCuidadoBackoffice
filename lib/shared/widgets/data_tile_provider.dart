import 'package:flutter/cupertino.dart';

class DataTileProvider extends ChangeNotifier {
  String _stateSelected = '';

  String get stateSelected => _stateSelected;

  setStateSelected(stateSelected) {
    _stateSelected = stateSelected;
    notifyListeners();
  }

  String _citySelected = '';

  String get citySelected => _citySelected;

  setCitySelected(citySelected) {
    _citySelected = citySelected;
    notifyListeners();
  }
}
