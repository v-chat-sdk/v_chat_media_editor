// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

// Internal implementation details are not part of the exported package API.
// ignore_for_file: public_member_api_docs

import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:fc_native_video_thumbnail/fc_native_video_thumbnail.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path/path.dart';

import 'package:v_platform/v_platform.dart';
import 'package:video_player/video_player.dart';

import 'message_image_data.dart';

abstract class VFileUtils {
  static final _fcNativeVideoThumbnail = FcNativeVideoThumbnail();

  static Future<MessageImageData?> getVideoThumb({
    required VPlatformFile fileSource,
    int maxWidth = 600,
    int quality = 70,
    String? destFile,
  }) async {
    try {
      if (fileSource.isFromBytes || fileSource.isFromUrl) {
        return null;
      }
      final outputPath =
          destFile ??
          join(
            Directory.systemTemp.path,
            '${DateTime.now().microsecondsSinceEpoch}.png',
          );

      final didCreateThumbnail = await _fcNativeVideoThumbnail
          .saveThumbnailToFile(
            srcFile: fileSource.fileLocalPath!,
            width: maxWidth,
            quality: quality,
            destFile: outputPath,
            height: maxWidth,
          );

      if (!didCreateThumbnail) {
        return null;
      }

      final thumbImageData = await getImageInfo(
        fileSource: VPlatformFile.fromPath(fileLocalPath: outputPath),
      );

      return MessageImageData(
        fileSource: VPlatformFile.fromPath(fileLocalPath: outputPath),
        width: thumbImageData.image.width,
        height: thumbImageData.image.height,
      );
    } catch (_) {
      return null;
    }
  }

  static Future<int?> getVideoDurationMill(VPlatformFile file) async {
    if (!file.isFromPath) {
      return null;
    }

    final controller = VideoPlayerController.file(File(file.fileLocalPath!));
    try {
      await controller.initialize();
      return controller.value.duration.inMilliseconds;
    } finally {
      await controller.dispose();
    }
  }

  /// Compresses path-based images larger than [compressAt] bytes.
  ///
  /// Unsupported platforms and failed compression return the original file.
  static Future<VPlatformFile> compressImage({
    required VPlatformFile fileSource,
    required int compressAt,
    required int quality,
  }) async {
    if (!fileSource.isFromPath) {
      return fileSource;
    }
    try {
      if (fileSource.fileSize <= compressAt) {
        return fileSource;
      }

      final outputPath = join(
        Directory.systemTemp.path,
        '${DateTime.now().microsecondsSinceEpoch}.jpeg',
      );
      final compressionQuality = quality.clamp(0, 100).toInt();
      final compressedFile = await FlutterImageCompress.compressAndGetFile(
        fileSource.fileLocalPath!,
        outputPath,
        quality: compressionQuality,
      );
      if (compressedFile == null) {
        return fileSource;
      }

      return VPlatformFile.fromPath(fileLocalPath: compressedFile.path);
    } catch (_) {
      return fileSource;
    }
  }

  static Future<ImageInfo> getImageInfo({
    required VPlatformFile fileSource,
  }) async {
    final Uint8List imageBytes;
    if (fileSource.isFromBytes) {
      imageBytes = Uint8List.fromList(fileSource.bytes!);
    } else if (fileSource.isFromPath) {
      imageBytes = await File(fileSource.fileLocalPath!).readAsBytes();
    } else {
      throw UnsupportedError('Image dimensions require file bytes or a path.');
    }

    final codec = await ui.instantiateImageCodec(imageBytes);
    try {
      final frame = await codec.getNextFrame();
      return ImageInfo(image: frame.image);
    } finally {
      codec.dispose();
    }
  }
}
