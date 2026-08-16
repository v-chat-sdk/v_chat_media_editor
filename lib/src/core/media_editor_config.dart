// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

/// Controls compression, thumbnail generation, and validation behavior.
class VMediaEditorConfig {
  /// Creates media-editor settings with production-safe defaults.
  const VMediaEditorConfig({
    this.maxVideoSizeMb = 100,
    this.imageQuality = 50,
    this.startCompressAt = 1_500_000,
    this.destVideoThumbFile,
  }) : assert(maxVideoSizeMb > 0, 'maxVideoSizeMb must be greater than zero'),
       assert(
         imageQuality >= 0 && imageQuality <= 100,
         'imageQuality must be between 0 and 100',
       ),
       assert(startCompressAt >= 0, 'startCompressAt cannot be negative');

  /// Maximum accepted video size in megabytes.
  ///
  /// Reserved for video compression support.
  final int maxVideoSizeMb;

  /// JPEG compression and video-thumbnail quality, from 0 to 100.
  final int imageQuality;

  /// File-size threshold, in bytes, above which images are compressed.
  final int startCompressAt;

  /// Optional destination path for generated video thumbnails.
  final String? destVideoThumbFile;
}
