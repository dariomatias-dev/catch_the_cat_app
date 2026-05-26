import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

class AudioService {
  AudioPlayer? _bgPlayer;
  bool _muted = false;

  bool get isMuted => _muted;

  Future<void> init() async {
    try {
      _bgPlayer = AudioPlayer();
      _bgPlayer!.onPlayerStateChanged.listen((state) {
        debugPrint('[Audio] bg state: $state');
      });
      // Use loop + low volume; no setAudioContext so system defaults apply
      // (avoids AUDIOFOCUS_LOSS issues on Xiaomi/MIUI)
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

  // Volume balanced: effects softer than they were, jump reduced most
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
      // AudioFocus.none: effect players must not take focus from bg music.
      // Without this, each tap sends AUDIOFOCUS_LOSS to the bg player,
      // which releases it permanently.
      await p.setAudioContext(AudioContext(
        android: AudioContextAndroid(
          audioFocus: AndroidAudioFocus.none,
          contentType: AndroidContentType.sonification,
          usageType: AndroidUsageType.game,
        ),
      ));
      await p.setVolume(volume);
      await p.play(AssetSource(asset));
      p.onPlayerComplete.first.then((_) => p.dispose()).ignore();
    } catch (e) {
      debugPrint('[Audio] effect error ($asset): $e');
    }
  }

  void dispose() {
    _bgPlayer?.dispose();
    _bgPlayer = null;
  }
}
