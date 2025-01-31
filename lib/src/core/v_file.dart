// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:fc_native_video_thumbnail/fc_native_video_thumbnail.dart';
import 'package:flutter/material.dart';
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
      final destFile = join(
        Directory.systemTemp.path,
        "${DateTime.now().microsecondsSinceEpoch}.png",
      );

      final thumbPath = await _fcNativeVideoThumbnail.getVideoThumbnail(
        srcFile: fileSource.fileLocalPath!,
        width: maxWidth,
        quality: quality,
        destFile: destFile,
        height: maxWidth,
      );

      if (thumbPath == false) {
        return null;
      }

      final thumbImageData = await getImageInfo(
        fileSource: VPlatformFile.fromPath(
          fileLocalPath: destFile,
        ),
      );

      return MessageImageData(
        fileSource: VPlatformFile.fromPath(fileLocalPath: destFile),
        width: thumbImageData.image.width,
        height: thumbImageData.image.height,
      );
    } catch (err) {
      print(err);
      return null;
    }
  }

  static Future<int?> getVideoDurationMill(VPlatformFile file) async {
    if (file.isFromPath) {
      final controller = VideoPlayerController.file(
        File(file.fileLocalPath!),
      );
      await controller.initialize();
      final value = controller.value.duration.inMilliseconds;
      controller.dispose();
      return value;
    }
    return null;
  }

  //This is a function called "compressImage" that takes in a VPlatformFile object representing an image file and compresses it
  // if it is larger than a certain size (specified by the "compressAt" parameter). The compression is done using the FlutterNativeImage
  // library, which takes in the file path of the image and a quality parameter (defaulting to 50). If the resulting file is smaller than the specified size,
  // the original file is returned. Otherwise, the compressed file is returned as a new VPlatformFile object.
  static Future<VPlatformFile> compressImage({
    required VPlatformFile fileSource,
    required int compressAt,
    required int quality,
  }) async {
    if (!fileSource.isFromPath) {
      return fileSource;
    }
    VPlatformFile compressedFileSource = fileSource;
    try {
      if (compressedFileSource.fileSize > compressAt) {
        final temp = join(
          Directory.systemTemp.path,
          "${DateTime.now().microsecondsSinceEpoch}",
        );
        final compressedFile = await FlutterImageCompress.compressAndGetFile(
          fileSource.fileLocalPath!,
          "$temp.jpeg",
        );
        if (compressedFile == null) {
          return fileSource;
        }

        compressedFileSource =
            VPlatformFile.fromPath(fileLocalPath: compressedFile.path);
      }
    } catch (err) {
      print(err);
    }
    return compressedFileSource;
  }

  static Future<ImageInfo> getImageInfo({
    required VPlatformFile fileSource,
  }) async {
    final Image image = fileSource.isFromBytes
        ? Image.memory(Uint8List.fromList(fileSource.bytes!))
        : Image.file(File(fileSource.fileLocalPath!));
    final completer = Completer<ImageInfo>();
    final listener = ImageStreamListener((info, _) => completer.complete(info));
    image.image.resolve(const ImageConfiguration()).addListener(listener);
    return completer.future;
  }
}
