import 'package:shared_preferences/shared_preferences.dart';

class AppSettings {
  static final AppSettings _instance = AppSettings._internal();
  factory AppSettings() => _instance;
  AppSettings._internal();

  static const String _easyModeKey = 'easy_mode';
  static const String _soundEnabledKey = 'sound_enabled';
  static const String _musicEnabledKey = 'music_enabled';
  static const String _soundVolumeKey = 'sound_volume';
  static const String _musicVolumeKey = 'music_volume';

  SharedPreferences? _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Easy mode (existing)
  bool getEasyMode() {
    return _prefs?.getBool(_easyModeKey) ?? false;
  }

  Future<void> setEasyMode(bool value) async {
    await _prefs?.setBool(_easyModeKey, value);
  }

  // Sound effects
  bool getSoundEnabled() {
    return _prefs?.getBool(_soundEnabledKey) ?? true;
  }

  Future<void> setSoundEnabled(bool value) async {
    await _prefs?.setBool(_soundEnabledKey, value);
  }

  // Background music
  bool getMusicEnabled() {
    return _prefs?.getBool(_musicEnabledKey) ?? true;
  }

  Future<void> setMusicEnabled(bool value) async {
    await _prefs?.setBool(_musicEnabledKey, value);
  }

  // Sound volume
  double getSoundVolume() {
    return _prefs?.getDouble(_soundVolumeKey) ?? 1.0;
  }

  Future<void> setSoundVolume(double value) async {
    await _prefs?.setDouble(_soundVolumeKey, value);
  }

  // Music volume
  double getMusicVolume() {
    return _prefs?.getDouble(_musicVolumeKey) ?? 0.5;
  }

  Future<void> setMusicVolume(double value) async {
    await _prefs?.setDouble(_musicVolumeKey, value);
  }
}
