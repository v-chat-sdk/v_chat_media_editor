// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

class VMediaEditorConfig {
  const VMediaEditorConfig({
    this.maxVideoSizeMb = 100,
    this.imageQuality = 50,
    this.startCompressAt = 1500 * 1000,
    this.destVideoThumbFile  ,
  });

  ///in future this will works for video compress
  final int maxVideoSizeMb;

  ///compress image Quality
  final int imageQuality;

  ///send the image bytes where the compress should works
  ///default to 1500 * 1000 which 2.5MB if the image bigger than 2.5MB the compress will start!
  final int startCompressAt;

  ///when the video thumbnail put the fill where it should place the output image!
  final String? destVideoThumbFile;
}
