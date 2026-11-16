// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

// Internal implementation details are not part of the exported package API.
// ignore_for_file: public_member_api_docs

import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:v_platform/v_platform.dart';
import 'package:video_player/video_player.dart';

class VVideoPlayer extends StatefulWidget {
  final VPlatformFile platformFileSource;
  final String appName;

  const VVideoPlayer({
    super.key,
    required this.platformFileSource,
    required this.appName,
  });

  @override
  State<VVideoPlayer> createState() => _VVideoPlayerState();
}

class _VVideoPlayerState extends State<VVideoPlayer> {
  bool isLoading = true;
  String? _errorMessage;
  VideoPlayerController? _videoPlayerController;
  ChewieController? _chewieController;

  @override
  void initState() {
    super.initState();
    _initAndPlay();
  }

  @override
  void dispose() {
    _chewieController?.dispose();
    _videoPlayerController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.platformFileSource.isContentVideo) {
      return const Scaffold(
        body: Center(child: Text('The selected file is not a video.')),
      );
    }
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          widget.appName,
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: SafeArea(child: Center(child: _buildPlayer())),
    );
  }

  Widget _buildPlayer() {
    if (_errorMessage case final errorMessage?) {
      return Padding(
        padding: const EdgeInsets.all(24),
        child: Text(
          errorMessage,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.white),
        ),
      );
    }
    if (isLoading) {
      return const CircularProgressIndicator.adaptive();
    }
    return AspectRatio(
      aspectRatio: _videoPlayerController!.value.aspectRatio,
      child: Chewie(controller: _chewieController!),
    );
  }

  Future<void> _initAndPlay() async {
    VideoPlayerController? controller;
    try {
      final options = VideoPlayerOptions(allowBackgroundPlayback: false);
      if (widget.platformFileSource.isFromPath) {
        controller = VideoPlayerController.file(
          File(widget.platformFileSource.fileLocalPath!),
          videoPlayerOptions: options,
        );
      } else if (widget.platformFileSource.isFromBytes) {
        controller = VideoPlayerController.contentUri(
          Uri.dataFromBytes(widget.platformFileSource.getBytes),
          videoPlayerOptions: options,
        );
      } else if (widget.platformFileSource.isFromAssets) {
        controller = VideoPlayerController.asset(
          widget.platformFileSource.assetsPath!,
          videoPlayerOptions: options,
        );
      } else if (widget.platformFileSource.isFromUrl) {
        final file = VPlatforms.isMobile
            ? await DefaultCacheManager().getSingleFile(
                widget.platformFileSource.networkUrl!,
                key: widget.platformFileSource.getCachedUrlKey,
              )
            : null;
        controller = file != null
            ? VideoPlayerController.file(file, videoPlayerOptions: options)
            : VideoPlayerController.networkUrl(
                Uri.parse(widget.platformFileSource.networkUrl!),
                videoPlayerOptions: options,
              );
      }

      if (controller == null) {
        throw UnsupportedError('Unsupported video source.');
      }
      await controller.initialize();
      if (!mounted) {
        await controller.dispose();
        return;
      }
      setState(() {
        _videoPlayerController = controller;
        _chewieController = ChewieController(
          videoPlayerController: _videoPlayerController!,
          autoPlay: true,
          looping: false,
        );
        isLoading = false;
      });
    } catch (_) {
      await controller?.dispose();
      if (!mounted) {
        return;
      }
      setState(() {
        isLoading = false;
        _errorMessage = 'Unable to load this video.';
      });
    }
  }
}
