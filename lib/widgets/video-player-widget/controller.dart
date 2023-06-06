import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:video_player/video_player.dart';

class MhVideoController  extends VideoPlayerController{
  // late final VideoPlayerController controller;
  // MhVideoController();

  MhVideoController.asset(String dataSource,
      {String? package, Future<ClosedCaptionFile>? closedCaptionFile, VideoPlayerOptions? videoPlayerOptions}) : super.asset(dataSource,
      package: package, closedCaptionFile: closedCaptionFile, videoPlayerOptions: videoPlayerOptions);

  MhVideoController.network(String dataSource,
      {VideoFormat? formatHint,
        Future<ClosedCaptionFile>? closedCaptionFile,
        VideoPlayerOptions? videoPlayerOptions,
        Map<String, String> httpHeaders = const <String, String>{},
      }) : super.network(dataSource,
      formatHint: formatHint,
      closedCaptionFile: closedCaptionFile,
      videoPlayerOptions: videoPlayerOptions,
      httpHeaders:httpHeaders) ;

  MhVideoController.file(File file,
      {
        Future<ClosedCaptionFile>? closedCaptionFile,
        VideoPlayerOptions? videoPlayerOptions,
        Map<String, String> httpHeaders = const <String, String>{},
      }) : super.file(file,
      closedCaptionFile: closedCaptionFile,
      videoPlayerOptions: videoPlayerOptions,
      httpHeaders:httpHeaders);


  MhVideoController.contentUri(Uri contentUri,Future<ClosedCaptionFile>? closedCaptionFile,
      VideoPlayerOptions? videoPlayerOptions, ) : super.contentUri(contentUri,
    closedCaptionFile: closedCaptionFile,
    videoPlayerOptions: videoPlayerOptions,);

  @override
  // TODO: implement textureId
  int get textureId => super.textureId;

  @override
  Future<void> dispose() {
    // TODO: implement dispose
    return super.dispose();
  }

  @override
  Future<void> initialize() {
    // TODO: implement initialize
    return super.initialize();
  }

  @override
  Future<void> play() {
    // TODO: implement play
    return super.play();
  }

  @override
  Future<void> pause() {
    // TODO: implement pause
    return super.pause();
  }

  @override
  Future<void> setLooping(bool looping) {
    // TODO: implement setLooping
    return super.setLooping(looping);
  }

  @override
  Future<void> setVolume(double volume) {
    // TODO: implement setVolume
    return super.setVolume(volume);
  }

  @override
  Future<void> setPlaybackSpeed(double speed) {
    // TODO: implement setPlaybackSpeed
    return super.setPlaybackSpeed(speed);
  }

  @override
  void setCaptionOffset(Duration offset) {
    // TODO: implement setCaptionOffset
    super.setCaptionOffset(offset);
  }
  @override
  Future<void> setClosedCaptionFile(Future<ClosedCaptionFile>? closedCaptionFile) {
    // TODO: implement setClosedCaptionFile
    return super.setClosedCaptionFile(closedCaptionFile);
  }

  @override
  // TODO: implement closedCaptionFile
  Future<ClosedCaptionFile>? get closedCaptionFile => super.closedCaptionFile;

  @override
  void addListener(VoidCallback listener) {
    // TODO: implement addListener
    super.addListener(listener);
  }

  @override
  void removeListener(VoidCallback listener) {
    // TODO: implement removeListener
    super.removeListener(listener);
  }

  @override
  Future<void> seekTo(Duration position) {
    // TODO: implement seekTo
    return super.seekTo(position);
  }

  @override
  // TODO: implement position
  Future<Duration?> get position => super.position;

}
