import 'package:flutter/cupertino.dart';
import 'package:localstorage/localstorage.dart';

class AppSettings {
  static LocalStorage settings = LocalStorage('settings');

  static const String _easyModeKey = 'easyMode';

  void setEasyModeTrue() {
    settings
        .setItem(_easyModeKey, true)
        .then((value) => debugPrint('Set Easy Mode to True'));
  }

  void setEasyModeFalse() {
    settings
        .setItem(_easyModeKey, false)
        .then((value) => debugPrint('Set Easy Mode to False'));
  }

  bool getEasyMode() {
    debugPrint(settings.getItem(_easyModeKey).toString());
    return settings.getItem(_easyModeKey) ?? false;
  }
}
