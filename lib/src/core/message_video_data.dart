// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:v_platform/v_platform.dart';

import 'message_image_data.dart';

/// Serializable video source, duration, and optional thumbnail metadata.
class MessageVideoData {
  /// Video file represented by this metadata.
  VPlatformFile fileSource;

  /// Optional generated thumbnail for the video.
  MessageImageData? thumbImage;

  /// Video duration in milliseconds, or `null` when unknown.
  int? duration;

  /// Video duration as a [Duration], or `null` when unavailable.
  Duration? get durationObj {
    final durationMilliseconds = duration;
    if (durationMilliseconds == null || durationMilliseconds < 0) {
      return null;
    }
    return Duration(milliseconds: durationMilliseconds);
  }

  /// Video duration formatted as `HH:mm:ss`, or `null` when unavailable.
  String? get durationFormat {
    final value = durationObj;
    if (value == null) return null;
    final hours = value.inHours.toString().padLeft(2, '0');
    final minutes = (value.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (value.inSeconds % 60).toString().padLeft(2, '0');
    return '$hours:$minutes:$seconds';
  }

  //<editor-fold desc="Data Methods">

  /// Creates metadata for a video attachment.
  MessageVideoData({
    required this.fileSource,
    this.thumbImage,
    required this.duration,
  });

  /// Whether the video is backed by a local filesystem path.
  bool get isFromPath => fileSource.fileLocalPath != null;

  /// Whether the video is backed by in-memory bytes.
  bool get isFromBytes => fileSource.bytes != null;

  @override
  String toString() {
    return 'MessageVideoData{fileSource: $fileSource, thumbImageSource: $thumbImage, duration: $duration}';
  }

  /// Serializes the video source, duration, and thumbnail to a map.
  Map<String, dynamic> toMap() {
    return {
      ...fileSource.toMap(),
      'duration': duration,
      'thumbImage': thumbImage?.toMap(),
    };
  }

  /// Restores video metadata from a serialized [map].
  factory MessageVideoData.fromMap(Map<String, dynamic> map) {
    return MessageVideoData(
      fileSource: VPlatformFile.fromMap(map),
      duration: map['duration'] as int?,
      thumbImage: map['thumbImage'] == null
          ? null
          : MessageImageData.fromMap(map['thumbImage'] as Map<String, dynamic>),
    );
  }

  //</editor-fold>
}
