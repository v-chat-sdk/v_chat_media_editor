import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:v_chat_media_editor/v_chat_media_editor.dart';
import 'package:v_platform/v_platform.dart';

void main() {
  runApp(const MediaEditorExampleApp());
}

class MediaEditorExampleApp extends StatelessWidget {
  const MediaEditorExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'V Chat Media Editor',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const MediaEditorExamplePage(),
    );
  }
}

class MediaEditorExamplePage extends StatefulWidget {
  const MediaEditorExamplePage({super.key});

  @override
  State<MediaEditorExamplePage> createState() => _MediaEditorExamplePageState();
}

class _MediaEditorExamplePageState extends State<MediaEditorExamplePage> {
  List<VBaseMediaRes> _editedMedia = const [];
  bool _isPicking = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('V Chat Media Editor')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            Text(
              'Preview and edit attachments before sending them.',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            const Text(
              'Select one or more images, videos, or files. Image crop and '
              'drawing actions are available where the platform supports them.',
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: _isPicking ? null : _pickMedia,
              icon: _isPicking
                  ? const SizedBox.square(
                      dimension: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.add_photo_alternate_outlined),
              label: Text(_isPicking ? 'Opening picker…' : 'Select media'),
            ),
            const SizedBox(height: 24),
            if (_editedMedia.isEmpty)
              const Card(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Text('Edited media will appear here.'),
                ),
              )
            else ...[
              Text(
                'Editor result',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              ..._editedMedia.map(_buildResultTile),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildResultTile(VBaseMediaRes media) {
    final file = media.getVPlatformFile();
    final (icon, details) = switch (media) {
      VMediaImageRes image => (
        Icons.image_outlined,
        '${image.data.width} × ${image.data.height}',
      ),
      VMediaVideoRes video => (
        Icons.videocam_outlined,
        video.data.durationFormat ?? 'Video',
      ),
      _ => (Icons.insert_drive_file_outlined, 'File'),
    };
    return Card(
      child: ListTile(
        leading: Icon(icon),
        title: Text(file.name),
        subtitle: Text(details),
      ),
    );
  }

  Future<void> _pickMedia() async {
    setState(() {
      _isPicking = true;
    });
    try {
      final selection = await FilePicker.pickFiles(type: FileType.any);
      if (!mounted || selection.isEmpty) {
        return;
      }
      final files = await Future.wait(selection.map(_toPlatformFile));
      if (!mounted) {
        return;
      }
      final result = await Navigator.of(context).push<List<VBaseMediaRes>>(
        MaterialPageRoute(builder: (_) => VMediaEditorView(files: files)),
      );
      if (!mounted || result == null) {
        return;
      }
      setState(() {
        _editedMedia = result;
      });
    } catch (_) {
      if (mounted) {
        _showMessage('Unable to open the file picker.');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isPicking = false;
        });
      }
    }
  }

  Future<VPlatformFile> _toPlatformFile(PlatformFile file) async {
    final path = file.path;
    if (path != null) {
      return VPlatformFile.fromPath(fileLocalPath: path);
    }
    final bytes = await file.readAsBytes();
    return VPlatformFile.fromBytes(name: file.name, bytes: bytes);
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}
