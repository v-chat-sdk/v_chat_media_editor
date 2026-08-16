// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.
import 'package:v_platform/v_platform.dart';

import 'message_image_data.dart';
import 'message_video_data.dart';

/// Base result returned by the media editor for an edited attachment.
abstract class VBaseMediaRes {
  /// Whether this item is currently selected in the editor carousel.
  bool isSelected = false;

  /// Stable identifier used to compare media results.
  final String id;

  /// Returns the file represented by this result.
  VPlatformFile getVPlatformFile();

  /// Creates a media result with the supplied [id].
  VBaseMediaRes({required this.id});

  @override
  bool operator ==(Object other) => other is VBaseMediaRes && id == other.id;

  @override
  int get hashCode => id.hashCode;
}

/// Edited image result with dimensions and source metadata.
class VMediaImageRes extends VBaseMediaRes {
  /// Image metadata produced by the editor.
  MessageImageData data;

  /// Creates an image result, generating an identifier when [id] is omitted.
  VMediaImageRes({String? id, required this.data})
    : super(id: id ?? DateTime.now().microsecondsSinceEpoch.toString());

  @override
  String toString() {
    return 'MediaEditorImage{data: $data }';
  }

  @override
  VPlatformFile getVPlatformFile() => data.fileSource;
}

/// Video result with duration and optional thumbnail metadata.
class VMediaVideoRes extends VBaseMediaRes {
  /// Video metadata produced by the editor.
  MessageVideoData data;

  /// Creates a video result, generating an identifier when [id] is omitted.
  VMediaVideoRes({String? id, required this.data})
    : super(id: id ?? DateTime.now().microsecondsSinceEpoch.toString());

  @override
  VPlatformFile getVPlatformFile() => data.fileSource;

  @override
  String toString() {
    return 'MediaEditorVideo{data $data}';
  }
}

/// Generic-file result for attachments that are not images or videos.
class VMediaFileRes extends VBaseMediaRes {
  /// Original file selected by the user.
  VPlatformFile data;

  @override
  VPlatformFile getVPlatformFile() => data;

  /// Creates a file result, generating an identifier when [id] is omitted.
  VMediaFileRes({String? id, required this.data})
    : super(id: id ?? DateTime.now().microsecondsSinceEpoch.toString());

  @override
  String toString() {
    return 'MediaEditorFile{data $data}';
  }
}
