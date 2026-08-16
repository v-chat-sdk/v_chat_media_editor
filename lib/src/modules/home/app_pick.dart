// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

// Internal implementation details are not part of the exported package API.
// ignore_for_file: public_member_api_docs

import 'package:v_platform/v_platform.dart';

import 'app_pick_stub.dart'
    if (dart.library.io) 'app_pick_io.dart'
    as platform_pick;

abstract class VAppPick {
  static Future<VPlatformFile?> croppedImage({required VPlatformFile file}) =>
      platform_pick.cropImage(file);
}
