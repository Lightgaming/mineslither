import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:mineslither/utils/app_settings.dart';

class SoundManager {
  static final SoundManager _instance = SoundManager._internal();
  factory SoundManager() => _instance;
  SoundManager._internal();

  final AudioPlayer _audioPlayer = AudioPlayer();
  final AudioPlayer _backgroundPlayer = AudioPlayer();

  // Sound effect methods
  Future<void> playEatSound() async {
    if (!AppSettings().getSoundEnabled()) return;
    try {
      await _audioPlayer.play(AssetSource('sounds/eat.wav'));
    } catch (e) {
      debugPrint('Error playing eat sound: $e');
    }
  }

  Future<void> playGameOverSound() async {
    if (!AppSettings().getSoundEnabled()) return;
    try {
      await _audioPlayer.play(AssetSource('sounds/game_over.wav'));
    } catch (e) {
      debugPrint('Error playing game over sound: $e');
    }
  }

  Future<void> playMineExplodeSound() async {
    if (!AppSettings().getSoundEnabled()) return;
    try {
      await _audioPlayer.play(AssetSource('sounds/mine_explode.wav'));
    } catch (e) {
      debugPrint('Error playing mine explode sound: $e');
    }
  }

  Future<void> playMineDefuseSound() async {
    if (!AppSettings().getSoundEnabled()) return;
    try {
      await _audioPlayer.play(AssetSource('sounds/mine_defuse.wav'));
    } catch (e) {
      debugPrint('Error playing mine defuse sound: $e');
    }
  }

  Future<void> playClickSound() async {
    if (!AppSettings().getSoundEnabled()) return;
    try {
      await _audioPlayer.play(AssetSource('sounds/click.wav'));
    } catch (e) {
      debugPrint('Error playing click sound: $e');
    }
  }

  Future<void> playWinSound() async {
    if (!AppSettings().getSoundEnabled()) return;
    try {
      await _audioPlayer.play(AssetSource('sounds/win.wav'));
    } catch (e) {
      debugPrint('Error playing win sound: $e');
    }
  }

  Future<void> playMoveSound() async {
    if (!AppSettings().getSoundEnabled()) return;
    try {
      await _audioPlayer.play(AssetSource('sounds/move.wav'));
    } catch (e) {
      debugPrint('Error playing move sound: $e');
    }
  }

  // Background music methods
  Future<void> playBackgroundMusic() async {
    if (!AppSettings().getMusicEnabled()) return;
    try {
      await _backgroundPlayer.play(AssetSource('sounds/background_music.mp3'));
      await _backgroundPlayer.setReleaseMode(ReleaseMode.loop);
      await _backgroundPlayer
          .setVolume(0.3); // Lower volume for background music
    } catch (e) {
      debugPrint('Error playing background music: $e');
    }
  }

  Future<void> stopBackgroundMusic() async {
    try {
      await _backgroundPlayer.stop();
    } catch (e) {
      debugPrint('Error stopping background music: $e');
    }
  }

  Future<void> pauseBackgroundMusic() async {
    try {
      await _backgroundPlayer.pause();
    } catch (e) {
      debugPrint('Error pausing background music: $e');
    }
  }

  Future<void> resumeBackgroundMusic() async {
    try {
      await _backgroundPlayer.resume();
    } catch (e) {
      debugPrint('Error resuming background music: $e');
    }
  }

  // Volume control
  Future<void> setSoundVolume(double volume) async {
    try {
      await _audioPlayer.setVolume(volume);
    } catch (e) {
      debugPrint('Error setting sound volume: $e');
    }
  }

  Future<void> setMusicVolume(double volume) async {
    try {
      await _backgroundPlayer.setVolume(volume);
    } catch (e) {
      debugPrint('Error setting music volume: $e');
    }
  }

  // Cleanup
  Future<void> dispose() async {
    await _audioPlayer.dispose();
    await _backgroundPlayer.dispose();
  }
}
