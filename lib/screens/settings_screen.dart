import 'package:flutter/material.dart';
import 'package:mineslither/utils/app_settings.dart';
import 'package:mineslither/utils/sound_manager.dart';
import 'package:mineslither/widgets/app_bar.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _easyMode = false;
  bool _soundEnabled = true;
  bool _musicEnabled = true;
  double _soundVolume = 1.0;
  double _musicVolume = 0.5;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  void _loadSettings() {
    setState(() {
      _easyMode = AppSettings().getEasyMode();
      _soundEnabled = AppSettings().getSoundEnabled();
      _musicEnabled = AppSettings().getMusicEnabled();
      _soundVolume = AppSettings().getSoundVolume();
      _musicVolume = AppSettings().getMusicVolume();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const GameAppBar(),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Game Settings Section
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Game Settings',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 16),
                  SwitchListTile(
                    title: const Text('Easy Mode'),
                    subtitle: const Text('Continue after dying'),
                    value: _easyMode,
                    onChanged: (value) {
                      setState(() {
                        _easyMode = value;
                      });
                      AppSettings().setEasyMode(value);
                      SoundManager().playClickSound();
                    },
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Sound Settings Section
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Sound Settings',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 16),

                  // Sound Effects Toggle
                  SwitchListTile(
                    title: const Text('Sound Effects'),
                    subtitle: const Text('Enable game sound effects'),
                    value: _soundEnabled,
                    onChanged: (value) {
                      setState(() {
                        _soundEnabled = value;
                      });
                      AppSettings().setSoundEnabled(value);
                      if (value) {
                        SoundManager().playClickSound();
                      }
                    },
                  ),

                  // Sound Volume Slider
                  ListTile(
                    title: const Text('Sound Volume'),
                    subtitle: Slider(
                      value: _soundVolume,
                      min: 0.0,
                      max: 1.0,
                      divisions: 10,
                      label: '${(_soundVolume * 100).round()}%',
                      onChanged: _soundEnabled
                          ? (value) {
                              setState(() {
                                _soundVolume = value;
                              });
                              AppSettings().setSoundVolume(value);
                              SoundManager().setSoundVolume(value);
                            }
                          : null,
                      onChangeEnd: (value) {
                        SoundManager().playClickSound();
                      },
                    ),
                  ),

                  const Divider(),

                  // Background Music Toggle
                  SwitchListTile(
                    title: const Text('Background Music'),
                    subtitle: const Text('Enable background music'),
                    value: _musicEnabled,
                    onChanged: (value) {
                      setState(() {
                        _musicEnabled = value;
                      });
                      AppSettings().setMusicEnabled(value);
                      if (value) {
                        SoundManager().playBackgroundMusic();
                      } else {
                        SoundManager().stopBackgroundMusic();
                      }
                      SoundManager().playClickSound();
                    },
                  ),

                  // Music Volume Slider
                  ListTile(
                    title: const Text('Music Volume'),
                    subtitle: Slider(
                      value: _musicVolume,
                      min: 0.0,
                      max: 1.0,
                      divisions: 10,
                      label: '${(_musicVolume * 100).round()}%',
                      onChanged: _musicEnabled
                          ? (value) {
                              setState(() {
                                _musicVolume = value;
                              });
                              AppSettings().setMusicVolume(value);
                              SoundManager().setMusicVolume(value);
                            }
                          : null,
                      onChangeEnd: (value) {
                        SoundManager().playClickSound();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Test Sound Button
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Test Sounds',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 8,
                    children: [
                      ElevatedButton(
                        onPressed: _soundEnabled
                            ? () => SoundManager().playEatSound()
                            : null,
                        child: const Text('Eat'),
                      ),
                      ElevatedButton(
                        onPressed: _soundEnabled
                            ? () => SoundManager().playMineDefuseSound()
                            : null,
                        child: const Text('Defuse'),
                      ),
                      ElevatedButton(
                        onPressed: _soundEnabled
                            ? () => SoundManager().playMineExplodeSound()
                            : null,
                        child: const Text('Explode'),
                      ),
                      ElevatedButton(
                        onPressed: _soundEnabled
                            ? () => SoundManager().playWinSound()
                            : null,
                        child: const Text('Win'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
