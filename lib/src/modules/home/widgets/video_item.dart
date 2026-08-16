// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

// Internal implementation details are not part of the exported package API.
// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';

import '../../../../v_chat_media_editor.dart';
import '../../../core/platform_cache_image_widget.dart';

class VideoItem extends StatelessWidget {
  final VMediaVideoRes video;
  final VoidCallback onCloseClicked;
  final ValueChanged<VMediaVideoRes> onDelete;
  final ValueChanged<VMediaVideoRes> onPlayVideo;

  const VideoItem({
    super.key,
    required this.video,
    required this.onCloseClicked,
    required this.onDelete,
    required this.onPlayVideo,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  iconSize: 30,
                  onPressed: () => onCloseClicked(),
                  icon: const Icon(Icons.close, color: Colors.white),
                ),
                Row(
                  children: [
                    IconButton(
                      iconSize: 30,
                      onPressed: () => onDelete(video),
                      icon: const Icon(
                        Icons.delete_outline,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 3),
                    const SizedBox(width: 3),
                  ],
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: Stack(
            alignment: Alignment.center,
            children: [
              if (video.data.thumbImage != null)
                VPlatformCacheImageWidget(
                  source: video.data.thumbImage!.fileSource,
                )
              else
                Container(color: Colors.black87),
              InkWell(
                onTap: () => onPlayVideo(video),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 70,
                      width: 70,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black,
                      ),
                      child: Icon(Icons.play_arrow, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
