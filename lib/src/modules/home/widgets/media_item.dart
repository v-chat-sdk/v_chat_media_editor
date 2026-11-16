// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

// Internal implementation details are not part of the exported package API.
// ignore_for_file: public_member_api_docs

import 'package:material_ui/material_ui.dart';
import 'package:v_chat_media_editor/src/modules/home/widgets/image_item.dart';
import 'package:v_chat_media_editor/src/modules/home/widgets/video_item.dart';

import '../../../../v_chat_media_editor.dart';
import 'file_item.dart';

class MediaItem extends StatelessWidget {
  final VoidCallback onCloseClicked;
  final ValueChanged<VBaseMediaRes> onDelete;
  final Future<void> Function(VBaseMediaRes item) onCrop;
  final Future<void> Function(VBaseMediaRes item) onStartDraw;
  final ValueChanged<VBaseMediaRes> onPlayVideo;
  final bool isProcessing;

  final VBaseMediaRes mediaFile;

  const MediaItem({
    super.key,
    required this.mediaFile,
    required this.onCloseClicked,
    required this.onDelete,
    required this.onCrop,
    required this.onStartDraw,
    required this.isProcessing,
    required this.onPlayVideo,
  });

  @override
  Widget build(BuildContext context) {
    if (isProcessing) {
      return const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [CircularProgressIndicator.adaptive()],
      );
    }
    if (mediaFile is VMediaImageRes) {
      return ImageItem(
        image: mediaFile as VMediaImageRes,
        onCloseClicked: onCloseClicked,
        onCrop: onCrop,
        onDelete: onDelete,
        onStartDraw: onStartDraw,
      );
    } else if (mediaFile is VMediaVideoRes) {
      return VideoItem(
        video: mediaFile as VMediaVideoRes,
        onCloseClicked: onCloseClicked,
        onPlayVideo: onPlayVideo,
        onDelete: onDelete,
      );
    } else {
      return FileItem(
        file: mediaFile as VMediaFileRes,
        onCloseClicked: onCloseClicked,
        onDelete: onDelete,
      );
    }
  }
}
