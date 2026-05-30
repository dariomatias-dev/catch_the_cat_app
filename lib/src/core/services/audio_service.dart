import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/widgets.dart';

class AudioService with WidgetsBindingObserver {
  AudioPlayer? _bgPlayer;
  bool _muted = false;

  bool get isMuted => _muted;

  Future<void> init() async {
    WidgetsBinding.instance.addObserver(this);

    try {
      _bgPlayer = AudioPlayer();
      _bgPlayer!.onPlayerStateChanged.listen((state) {
        debugPrint('[Audio] bg state: $state');
      });

      await _bgPlayer!.setReleaseMode(ReleaseMode.loop);
      await _bgPlayer!.setVolume(0.3);
      await _bgPlayer!.play(AssetSource('audio/background_music.wav'));
    } catch (e) {
      debugPrint('[Audio] bg init error: $e');
    }
  }

  void setMuted(bool muted) {
    _muted = muted;

    if (muted) {
      _bgPlayer?.pause();
    } else {
      _bgPlayer?.resume();
    }
  }

  Future<void> playCatJump() => _effect('audio/cat_jump.wav', volume: 0.45);

  Future<void> playBarrierPlaced() =>
      _effect('audio/barrier_placed.wav', volume: 0.55);

  Future<void> playWin() async {
    await _bgPlayer?.pause();

    await _effect('audio/win.wav', volume: 0.75);
  }

  Future<void> playLose() async {
    await _bgPlayer?.pause();

    await _effect('audio/lose.wav', volume: 0.75);
  }

  Future<void> resumeBackground() async {
    if (_muted) return;

    try {
      await _bgPlayer?.resume();
    } catch (e) {
      debugPrint('[Audio] resume error: $e');
    }
  }

  Future<void> _effect(String asset, {double volume = 1.0}) async {
    if (_muted) return;
    try {
      final p = AudioPlayer();

      await p.setAudioContext(
        AudioContext(
          android: AudioContextAndroid(
            audioFocus: AndroidAudioFocus.none,
            contentType: AndroidContentType.sonification,
            usageType: AndroidUsageType.game,
          ),
        ),
      );
      await p.setVolume(volume);
      await p.play(AssetSource(asset));

      p.onPlayerComplete.first.then((_) => p.dispose()).ignore();
    } catch (e) {
      debugPrint('[Audio] effect error ($asset): $e');
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.hidden) {
      _bgPlayer?.pause();
    } else if (state == AppLifecycleState.resumed) {
      if (!_muted) _bgPlayer?.resume();
    }
  }

  void dispose() {
    WidgetsBinding.instance.removeObserver(this);

    _bgPlayer?.dispose();
    _bgPlayer = null;
  }
}
