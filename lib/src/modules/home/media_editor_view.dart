// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:material_ui/material_ui.dart';
import 'package:v_chat_media_editor/src/modules/home/widgets/horz_media_item.dart';
import 'package:v_chat_media_editor/src/modules/home/widgets/media_item.dart';
import 'package:v_platform/v_platform.dart';

import '../../core/core.dart';
import 'media_editor_controller.dart';

/// Full-screen editor for previewing and preparing attachment results.
class VMediaEditorView extends StatefulWidget {
  /// Files shown in the editor.
  final List<VPlatformFile> files;

  /// Compression and thumbnail settings applied during editing.
  final VMediaEditorConfig config;

  /// Creates a media editor for [files].
  const VMediaEditorView({
    super.key,
    required this.files,
    this.config = const VMediaEditorConfig(),
  });

  @override
  State<VMediaEditorView> createState() => _VMediaEditorViewState();
}

class _VMediaEditorViewState extends State<VMediaEditorView> {
  late final MediaEditorController controller;

  @override
  void initState() {
    super.initState();
    controller = MediaEditorController(widget.files, widget.config);
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: controller,
      builder: (context, value, child) {
        if (!controller.isLoading && controller.mediaFiles.isEmpty) {
          return Scaffold(
            body: SafeArea(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('No media files to edit.'),
                    const SizedBox(height: 12),
                    TextButton(
                      onPressed: () => controller.onEmptyPress(context),
                      child: const Text('Close'),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
        return Scaffold(
          floatingActionButton:
              controller.isLoading || controller.mediaFiles.isEmpty
              ? null
              : FloatingActionButton.small(
                  elevation: 0,
                  onPressed: controller.isCompressing
                      ? null
                      : () => controller.onSubmitData(context),
                  child: controller.isCompressing
                      ? const CupertinoActivityIndicator()
                      : const Icon(Icons.send),
                ),
          backgroundColor: Colors.black26,
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: PageView.builder(
                    onPageChanged: controller.changeImageIndex,
                    controller: controller.pageController,
                    itemBuilder: (BuildContext context, int index) {
                      return MediaItem(
                        mediaFile: controller.mediaFiles[index],
                        onCloseClicked: () => controller.onEmptyPress(context),
                        onDelete: (item) => controller.onDelete(item, context),
                        onCrop: (item) =>
                            controller.onCrop(item as VMediaImageRes),
                        onPlayVideo: (item) =>
                            controller.onPlayVideo(item, context),
                        onStartDraw: (item) async {
                          if (item is VMediaImageRes) {
                            await controller.onStartDraw(item, context);
                          }
                        },
                        isProcessing: controller.isLoading,
                      );
                    },
                    itemCount: controller.mediaFiles.length,
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  height: MediaQuery.of(context).size.height * .08,
                  child: ListView.separated(
                    padding: const EdgeInsets.all(5),
                    scrollDirection: Axis.horizontal,
                    separatorBuilder: (context, index) =>
                        const SizedBox(width: 5),
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          controller.changeImageIndex(index);
                        },
                        child: HorizontalMediaItem(
                          mediaFile: controller.mediaFiles[index],
                          isLoading: controller.isLoading,
                        ),
                      );
                    },
                    itemCount: controller.mediaFiles.length,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
