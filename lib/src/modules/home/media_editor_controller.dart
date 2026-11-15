// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

// Internal implementation details are not part of the exported package API.
// ignore_for_file: public_member_api_docs

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:v_platform/v_platform.dart';

import '../../core/core.dart';
import '../../core/v_file.dart';
import '../pinter/image_pinter_view.dart';
import '../video_editor/v_video_player.dart';
import 'app_pick.dart';

class MediaEditorController extends ValueNotifier<int> {
  MediaEditorController(this.platformFiles, this.config) : super(0) {
    unawaited(_init());
  }

  final List<VPlatformFile> platformFiles;
  final mediaFiles = <VBaseMediaRes>[];
  final VMediaEditorConfig config;
  bool isLoading = true;
  bool isCompressing = false;
  bool _isDisposed = false;

  int currentImageIndex = 0;

  final pageController = PageController();

  void onEmptyPress(BuildContext context) {
    Navigator.pop(context);
  }

  void onDelete(VBaseMediaRes item, BuildContext context) {
    mediaFiles.remove(item);
    if (mediaFiles.isEmpty) {
      return Navigator.pop(context);
    }
    if (currentImageIndex >= mediaFiles.length) {
      currentImageIndex = mediaFiles.length - 1;
    }
    for (final mediaFile in mediaFiles) {
      mediaFile.isSelected = false;
    }
    mediaFiles[currentImageIndex].isSelected = true;
    if (pageController.hasClients) {
      pageController.jumpToPage(currentImageIndex);
    }
    _updateScreen();
  }

  Future<void> onCrop(VMediaImageRes item) async {
    final res = await VAppPick.croppedImage(file: item.data.fileSource);
    if (res != null) {
      item.data.fileSource = res;
      _updateScreen();
    }
  }

  Future<void> onStartDraw(VBaseMediaRes item, BuildContext context) async {
    if (item is VMediaImageRes) {
      final editedFile = await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) =>
              ImagePinterView(platformFileSource: item.data.fileSource),
        ),
      ) as VPlatformFile?;
      if (editedFile != null) {
        item.data.fileSource = editedFile;
      }
    }
    _updateScreen();
  }

  @override
  void dispose() {
    if (_isDisposed) {
      return;
    }
    _isDisposed = true;
    pageController.dispose();
    super.dispose();
  }

  void changeImageIndex(int index) {
    if (index < 0 || index >= mediaFiles.length) {
      return;
    }
    currentImageIndex = index;
    if (pageController.hasClients && pageController.page?.round() != index) {
      pageController.jumpToPage(index);
    }
    for (final element in mediaFiles) {
      element.isSelected = false;
    }
    mediaFiles[index].isSelected = true;
    _updateScreen();
  }

  void _updateScreen() {
    if (!_isDisposed) {
      value++;
    }
  }

  Future<void> _init() async {
    for (final f in platformFiles) {
      if (f.getMediaType == VSupportedFilesType.image) {
        final mImage = VMediaImageRes(
          data: MessageImageData(fileSource: f, width: -1, height: -1),
        );
        mediaFiles.add(mImage);
      } else if (f.getMediaType == VSupportedFilesType.video) {
        MessageImageData? thumb;
        if (f.fileLocalPath != null) {
          thumb = await _getThumb(
            videoPath: f.fileLocalPath!,
            quality: config.imageQuality,
          );
        }
        final mFile = VMediaVideoRes(
          data: MessageVideoData(
            fileSource: f,
            duration: null,
            thumbImage: thumb,
          ),
        );
        mediaFiles.add(mFile);
      } else {
        mediaFiles.add(VMediaFileRes(data: f));
      }
    }
    if (mediaFiles.isNotEmpty) {
      mediaFiles.first.isSelected = true;
      await startCompressImagesIfNeed(notify: false);
    }
    isLoading = false;
    _updateScreen();
  }

  Future<MessageImageData?> _getThumb({
    required String videoPath,
    required int quality,
  }) async {
    return VFileUtils.getVideoThumb(
      quality: quality,
      destFile: config.destVideoThumbFile,
      fileSource: VPlatformFile.fromPath(fileLocalPath: videoPath),
    );
  }

  void onPlayVideo(VBaseMediaRes item, BuildContext context) {
    if (item is VMediaVideoRes) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => VVideoPlayer(
            platformFileSource: item.data.fileSource,
            appName: 'media_editor',
          ),
        ),
      );
    }
  }

  Future<void> startCompressImagesIfNeed({bool notify = true}) async {
    for (final f in mediaFiles) {
      if (f is VMediaImageRes) {
        f.data.fileSource = await VFileUtils.compressImage(
          fileSource: f.data.fileSource,
          compressAt: config.startCompressAt,
          quality: config.imageQuality,
        );
      }
    }
    if (notify) {
      _updateScreen();
    }
  }

  Future<void> onSubmitData(BuildContext context) async {
    if (isCompressing || mediaFiles.isEmpty) {
      return;
    }
    isCompressing = true;
    _updateScreen();
    try {
      for (final f in mediaFiles) {
        if (f is VMediaImageRes && (f.data.isFromPath || f.data.isFromBytes)) {
          final data = await VFileUtils.getImageInfo(
            fileSource: f.data.fileSource,
          );
          f.data.width = data.image.width;
          f.data.height = data.image.height;
        } else if (f is VMediaVideoRes) {
          f.data.duration = await VFileUtils.getVideoDurationMill(
            f.data.fileSource,
          );
        }
      }
      if (!context.mounted) {
        return;
      }
      Navigator.pop(context, List<VBaseMediaRes>.unmodifiable(mediaFiles));
    } finally {
      isCompressing = false;
      _updateScreen();
    }
  }
}
