// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

// Internal implementation details are not part of the exported package API.
// ignore_for_file: public_member_api_docs

import 'package:material_ui/material_ui.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:v_platform/v_platform.dart';

Future<VPlatformFile?> cropImage(VPlatformFile file) async {
  if (!VPlatforms.isMobile || !file.isContentImage || !file.isFromPath) {
    return null;
  }
  final croppedFile = await ImageCropper().cropImage(
    sourcePath: file.fileLocalPath!,
    uiSettings: [
      AndroidUiSettings(
        toolbarTitle: 'Cropper',
        toolbarColor: Colors.deepOrange,
        toolbarWidgetColor: Colors.white,
        initAspectRatio: CropAspectRatioPreset.original,
        lockAspectRatio: false,
      ),
      IOSUiSettings(title: 'Cropper'),
    ],
  );
  if (croppedFile == null) {
    return null;
  }
  return VPlatformFile.fromPath(fileLocalPath: croppedFile.path);
}
