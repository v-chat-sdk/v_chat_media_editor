// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:v_platform/v_platform.dart';

abstract class VAppPick {
  static bool isPicking = false;

  static Future<VPlatformFile?> getCroppedImage({
    bool isFromCamera = false,
  }) async {
    final img = await getImage(isFromCamera: isFromCamera);
    if (img != null) {
      if (VPlatforms.isMobile) {
        final croppedFile = await ImageCropper().cropImage(
          sourcePath: img.fileLocalPath!,
          compressQuality: 70,
          uiSettings: [
            AndroidUiSettings(
              toolbarTitle: 'Cropper',
              toolbarColor: Colors.deepOrange,
              toolbarWidgetColor: Colors.white,
              cropStyle: CropStyle.circle,
              aspectRatioPresets: [
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio16x9
              ],
            ),
            IOSUiSettings(
              title: 'Cropper',
              cropStyle: CropStyle.circle,
              aspectRatioPresets: [
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio16x9
              ],
            ),
          ],
          compressFormat: ImageCompressFormat.png,
        );

        if (croppedFile == null) {
          return null;
        }
        return VPlatformFile.fromPath(fileLocalPath: croppedFile.path);
      }
      return img;
    }
    return null;
  }

  static Future<VPlatformFile?> getImage({
    bool isFromCamera = false,
  }) async {
    isPicking = true;
    final FilePickerResult? pickedFile = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );
    isPicking = false;
    if (pickedFile == null) return null;
    final file = pickedFile.files.first;
    if (file.bytes != null) {
      return VPlatformFile.fromBytes(name: file.name, bytes: file.bytes!);
    }
    return VPlatformFile.fromPath(fileLocalPath: file.path!);
  }




  static Future clearPickerCache() async {
    await FilePicker.platform.clearTemporaryFiles();
  }

  static Future<VPlatformFile?> croppedImage({
    required VPlatformFile file,
  }) async {
    if (!file.isContentImage) return null;
    final CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: file.fileLocalPath!,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Cropper',
          toolbarColor: Colors.deepOrange,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false,
        ),
        IOSUiSettings(
          title: 'Cropper',
        ),
      ],
    );
    if (croppedFile != null) {
      return VPlatformFile.fromPath(
        fileLocalPath: croppedFile.path,
      );
    }
    return null;
  }
}
