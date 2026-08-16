// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:v_platform/v_platform.dart';

/// Serializable image source and pixel-dimension metadata.
class MessageImageData {
  /// Image file represented by this metadata.
  VPlatformFile fileSource;

  /// Image width in pixels, or a negative value while it is unknown.
  int width;

  /// Image height in pixels, or a negative value while it is unknown.
  int height;

  //<editor-fold desc="Data Methods">

  /// Creates image metadata for [fileSource].
  MessageImageData({
    required this.fileSource,
    required this.width,
    required this.height,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MessageImageData &&
          runtimeType == other.runtimeType &&
          fileSource == other.fileSource &&
          width == other.width &&
          height == other.height);

  @override
  int get hashCode => fileSource.hashCode ^ width.hashCode ^ height.hashCode;

  @override
  String toString() {
    return 'MessageImageData{ fileSource: $fileSource, width: $width, height: $height,}';
  }

  /// Whether the image is backed by a local filesystem path.
  bool get isFromPath => fileSource.fileLocalPath != null;

  /// Whether the image is backed by in-memory bytes.
  bool get isFromBytes => fileSource.bytes != null;

  /// Returns a copy with the supplied fields replaced.
  MessageImageData copyWith({
    VPlatformFile? fileSource,
    int? width,
    int? height,
  }) {
    return MessageImageData(
      fileSource: fileSource ?? this.fileSource,
      width: width ?? this.width,
      height: height ?? this.height,
    );
  }

  /// Serializes the image source and dimensions to a map.
  Map<String, dynamic> toMap() {
    return {...fileSource.toMap(), 'width': width, 'height': height};
  }

  /// Restores image metadata from a serialized [map].
  factory MessageImageData.fromMap(Map<String, dynamic> map) {
    return MessageImageData(
      fileSource: VPlatformFile.fromMap(map),
      width: map['width'] as int,
      height: map['height'] as int,
    );
  }

  /// Creates placeholder image metadata backed by a Picsum URL.
  ///
  /// [high] is retained for backward compatibility and represents the height.
  factory MessageImageData.fromFakeData({
    required int high,
    required int width,
  }) {
    return MessageImageData(
      fileSource: VPlatformFile.fromUrl(
        networkUrl: "https://picsum.photos/$width/$high",
      ),
      width: width,
      height: high,
    );
  }

  //</editor-fold>
}
