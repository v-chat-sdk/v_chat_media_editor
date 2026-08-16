// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

// Internal implementation details are not part of the exported package API.
// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';
import 'package:v_platform/v_platform.dart';

import '../../../../v_chat_media_editor.dart';
import '../../../core/platform_cache_image_widget.dart';

class ImageItem extends StatelessWidget {
  final VMediaImageRes image;
  final VoidCallback onCloseClicked;
  final ValueChanged<VMediaImageRes> onDelete;
  final Future<void> Function(VMediaImageRes item) onCrop;
  final Future<void> Function(VMediaImageRes item) onStartDraw;

  const ImageItem({
    super.key,
    required this.image,
    required this.onCloseClicked,
    required this.onDelete,
    required this.onCrop,
    required this.onStartDraw,
  });

  @override
  Widget build(BuildContext context) {
    final canCrop = VPlatforms.isMobile && image.data.isFromPath;
    final canDraw =
        !VPlatforms.isWeb && (image.data.isFromPath || image.data.isFromBytes);
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
                  onPressed: onCloseClicked,
                  icon: const Icon(Icons.close, color: Colors.white),
                ),
                Row(
                  children: [
                    IconButton(
                      iconSize: 30,
                      onPressed: () => onDelete(image),
                      icon: const Icon(
                        Icons.delete_outline,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 3),
                    IconButton(
                      iconSize: 30,
                      onPressed: canCrop ? () => onCrop(image) : null,
                      icon: Icon(
                        Icons.crop,
                        color: canCrop ? Colors.white : Colors.grey,
                      ),
                    ),
                    const SizedBox(width: 3),
                    IconButton(
                      iconSize: 30,
                      onPressed: canDraw ? () => onStartDraw(image) : null,
                      icon: Icon(
                        Icons.edit,
                        color: canDraw ? Colors.white : Colors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: VPlatformCacheImageWidget(
            source: image.data.fileSource,
            fit: BoxFit.cover,
          ),
        ),
      ],
    );
  }
}
