import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:v_chat_media_editor/src/core/v_file.dart';
import 'package:v_chat_media_editor/v_chat_media_editor.dart';
import 'package:v_platform/v_platform.dart';

void main() {
  group('VMediaEditorConfig', () {
    test('provides safe defaults', () {
      const config = VMediaEditorConfig();

      expect(config.imageQuality, 50);
      expect(config.startCompressAt, 1_500_000);
      expect(config.maxVideoSizeMb, 100);
    });

    test('rejects invalid compression values', () {
      expect(() => VMediaEditorConfig(imageQuality: -1), throwsAssertionError);
      expect(() => VMediaEditorConfig(imageQuality: 101), throwsAssertionError);
      expect(
        () => VMediaEditorConfig(startCompressAt: -1),
        throwsAssertionError,
      );
    });
  });

  group('media models', () {
    test('exports image data and returns the source file', () {
      final file = _imageFile();
      final data = MessageImageData(fileSource: file, width: 1, height: 1);
      final result = VMediaImageRes(id: 'image-1', data: data);

      expect(result.id, 'image-1');
      expect(result.getVPlatformFile(), same(file));
      expect(result.data.width, 1);
      expect(result.data.height, 1);
    });

    test('formats video duration as hours, minutes, and seconds', () {
      final data = MessageVideoData(
        fileSource: _imageFile(),
        duration: const Duration(
          hours: 1,
          minutes: 2,
          seconds: 3,
        ).inMilliseconds,
      );

      expect(data.durationFormat, '01:02:03');
      data.duration = -1;
      expect(data.durationFormat, isNull);
    });
  });

  testWidgets('shows a useful empty state', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: VMediaEditorView(files: [])),
    );
    await tester.pumpAndSettle();

    expect(find.text('No media files to edit.'), findsOneWidget);
    expect(find.text('Close'), findsOneWidget);
  });

  testWidgets('reads image dimensions from bytes', (tester) async {
    final info = await tester.runAsync(
      () => VFileUtils.getImageInfo(fileSource: _imageFile()),
    );

    expect(info?.image.width, 1);
    expect(info?.image.height, 1);
    info?.image.dispose();
  });

  testWidgets('returns edited media when submitted', (tester) async {
    await tester.pumpWidget(
      MaterialApp(home: _EditorHost(file: _documentFile())),
    );

    await tester.tap(find.text('Open editor'));
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.send));
    await tester.pumpAndSettle();

    expect(find.text('note.txt'), findsOneWidget);
  });
}

VPlatformFile _documentFile() {
  return VPlatformFile.fromBytes(name: 'note.txt', bytes: utf8.encode('hello'));
}

VPlatformFile _imageFile() {
  return VPlatformFile.fromBytes(
    name: 'pixel.png',
    bytes: base64Decode(
      'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mNk+A8AAQUBAScY42YAAAAASUVORK5CYII=',
    ),
  );
}

class _EditorHost extends StatefulWidget {
  const _EditorHost({required this.file});

  final VPlatformFile file;

  @override
  State<_EditorHost> createState() => _EditorHostState();
}

class _EditorHostState extends State<_EditorHost> {
  String result = 'No result';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(result),
            ElevatedButton(
              onPressed: _openEditor,
              child: const Text('Open editor'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openEditor() async {
    final media = await Navigator.of(context).push<List<VBaseMediaRes>>(
      MaterialPageRoute(
        builder: (_) => VMediaEditorView(
          files: [widget.file],
          config: const VMediaEditorConfig(startCompressAt: 10_000_000),
        ),
      ),
    );
    if (!mounted || media == null) {
      return;
    }
    setState(() {
      result = media.single.getVPlatformFile().name;
    });
  }
}
