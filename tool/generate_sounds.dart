// Run: dart run tool/generate_sounds.dart
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

const _sr = 44100; // sample rate

void main() {
  Directory('assets/audio').createSync(recursive: true);

  _save('assets/audio/cat_jump.wav', _catJump());
  _save('assets/audio/barrier_placed.wav', _barrier());
  _save('assets/audio/win.wav', _win());
  _save('assets/audio/lose.wav', _lose());
  _save('assets/audio/background_music.wav', _background());

  stderr.writeln('Done.');
}

// ── Synthesizers ──────────────────────────────────────────────

List<double> _catJump() {
  const dur = 0.28;
  final n = (_sr * dur).round();
  return List.generate(n, (i) {
    final t = i / _sr;
    final p = t / dur;
    final freq = 250 + 750 * p; // sweep 250→1000 Hz
    final env = sin(pi * p); // bell shape
    return sin(2 * pi * freq * t) * env * 0.7;
  });
}

List<double> _barrier() {
  const dur = 0.22;
  final n = (_sr * dur).round();
  return List.generate(n, (i) {
    final t = i / _sr;
    final thud = sin(2 * pi * 75 * t) * exp(-t * 22); // low thud
    final click = sin(2 * pi * 1400 * t) * exp(-t * 90) * 0.35; // click
    return (thud + click) * 0.75;
  });
}

List<double> _win() {
  // C5 E5 G5 C6 ascending arpeggio
  final freqs = [523.25, 659.25, 783.99, 1046.50];
  const step = 0.18; // seconds per note
  final total = step * freqs.length + 0.4;
  final n = (_sr * total).round();
  return List.generate(n, (i) {
    final t = i / _sr;
    double s = 0;
    for (var ni = 0; ni < freqs.length; ni++) {
      final onset = ni * step;
      if (t < onset) continue;
      final nt = t - onset;
      final env = exp(-nt * 3.5);
      s += sin(2 * pi * freqs[ni] * t) * env * 0.28;
    }
    return s.clamp(-1.0, 1.0);
  });
}

List<double> _lose() {
  // G4 E4 C4 descending
  final freqs = [392.0, 329.63, 261.63];
  const step = 0.32;
  final total = step * freqs.length + 0.25;
  final n = (_sr * total).round();
  return List.generate(n, (i) {
    final t = i / _sr;
    double s = 0;
    for (var ni = 0; ni < freqs.length; ni++) {
      final onset = ni * step;
      if (t < onset) continue;
      final nt = t - onset;
      final env = exp(-nt * 2.2);
      s += sin(2 * pi * freqs[ni] * t) * env * 0.28;
    }
    return s.clamp(-1.0, 1.0);
  });
}

List<double> _background() {
  // 4s chiptune loop: triangle lead + square bass, C major, 120 BPM (8 beats)
  const beatDur = 60.0 / 120.0; // 0.5 s per beat
  const totalDur = 4.0;
  final n = (_sr * totalDur).round();

  // Quarter-note melody (beat, hz)
  final melody = [
    (0, 523.25), // C5
    (1, 659.25), // E5
    (2, 783.99), // G5
    (3, 659.25), // E5
    (4, 587.33), // D5
    (5, 523.25), // C5
    (6, 392.00), // G4
    (7, 523.25), // C5
  ];

  // Half-note bass (beat, hz)
  final bass = [
    (0, 130.81), // C3
    (2, 196.00), // G3
    (4, 174.61), // F3
    (6, 196.00), // G3
  ];

  double tri(double t, double f) {
    final phase = (t * f) % 1.0;
    return phase < 0.5 ? 4 * phase - 1 : 3 - 4 * phase;
  }

  double sqr(double t, double f) => sin(2 * pi * f * t) >= 0 ? 1.0 : -1.0;

  return List.generate(n, (i) {
    final t = i / _sr;
    double s = 0;

    for (final note in melody) {
      final onset = note.$1 * beatDur;
      if (t < onset) continue;
      final nt = t - onset;
      if (nt >= beatDur) continue;
      final env = (nt < 0.02 ? nt / 0.02 : 1.0) * exp(-nt * 7);
      s += tri(t, note.$2) * env * 0.40;
    }

    for (final note in bass) {
      final onset = note.$1 * beatDur;
      if (t < onset) continue;
      final nt = t - onset;
      if (nt >= beatDur * 2) continue;
      final env = exp(-nt * 3);
      s += sqr(t, note.$2) * env * 0.18;
    }

    return s.clamp(-1.0, 1.0);
  });
}

// ── WAV writer ────────────────────────────────────────────────

void _save(String path, List<double> samples) {
  final pcm = ByteData(samples.length * 2);
  for (var i = 0; i < samples.length; i++) {
    final v = (samples[i] * 32767).round().clamp(-32768, 32767);
    pcm.setInt16(i * 2, v, Endian.little);
  }
  final data = pcm.buffer.asUint8List();

  final hdr = ByteData(44);
  void str(int off, String s) {
    for (var k = 0; k < s.length; k++) {
      hdr.setUint8(off + k, s.codeUnitAt(k));
    }
  }

  str(0, 'RIFF');
  hdr.setUint32(4, 36 + data.length, Endian.little);
  str(8, 'WAVE');
  str(12, 'fmt ');
  hdr.setUint32(16, 16, Endian.little);
  hdr.setUint16(20, 1, Endian.little); // PCM
  hdr.setUint16(22, 1, Endian.little); // mono
  hdr.setUint32(24, _sr, Endian.little);
  hdr.setUint32(28, _sr * 2, Endian.little);
  hdr.setUint16(32, 2, Endian.little);
  hdr.setUint16(34, 16, Endian.little);
  str(36, 'data');
  hdr.setUint32(40, data.length, Endian.little);

  final bytes = <int>[
    ...hdr.buffer.asUint8List(),
    ...data,
  ];
  File(path).writeAsBytesSync(bytes);

  final kb = (File(path).lengthSync() / 1024).toStringAsFixed(0);
  stderr.writeln('  $path (${kb}KB)');
}
