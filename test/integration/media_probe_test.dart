import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:postcrate/core/media/media_probe.dart';

/// Runs the real native media probe on a device or simulator:
/// `flutter test test/integration/media_probe_test.dart -d DEVICE \
///   --dart-define=VIDEO=/path/to/vertical.mp4 --dart-define=PDF=/path/to/two-pages.pdf`
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  const videoPath = String.fromEnvironment('VIDEO');
  const pdfPath = String.fromEnvironment('PDF');
  const probe = MediaProbe();

  testWidgets('probes a 1080x1920 H.264/AAC video', (tester) async {
    final info = (await probe.probe(File(videoPath)))!;
    // ignore: avoid_print
    print('VIDEO ${info.toJson()}');
    expect(info.container, 'MPEG-4');
    expect(info.videoCodec, anyOf('avc1', 'video/avc'));
    expect(info.audioCodec, anyOf('mp4a', 'aac', 'audio/mp4a-latm'));
    expect(info.displaySize, (1080, 1920));
    expect(info.durationMs, closeTo(12000, 200));
    expect(info.frameRate, closeTo(30, 0.5));
    expect(info.sampleRate, 48000);
    expect(info.channels, 2);
    expect(info.bitrate, greaterThan(0));
  }, skip: videoPath.isEmpty);

  testWidgets('renders a video frame', (tester) async {
    final out = File('${Directory.systemTemp.path}/probe-frame.jpg');
    if (out.existsSync()) out.deleteSync();
    expect(await probe.thumbnail(File(videoPath), out, atMs: 1000), isTrue);
    expect(out.lengthSync(), greaterThan(1000));
  }, skip: videoPath.isEmpty);

  testWidgets('probes a PDF and renders its first page', (tester) async {
    final info = (await probe.probe(File(pdfPath)))!;
    // ignore: avoid_print
    print('PDF ${info.toJson()}');
    expect(info.container, 'PDF');
    expect(info.pageCount, 2);
    final out = File('${Directory.systemTemp.path}/probe-page.jpg');
    expect(await probe.thumbnail(File(pdfPath), out), isTrue);
  }, skip: pdfPath.isEmpty);
}
