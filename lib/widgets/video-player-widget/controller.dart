import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:html/parser.dart';
import 'package:mh_core/services/api_service.dart';
import 'package:mh_core/utils/global.dart';
import 'package:video_player/video_player.dart';
Future<List<dynamic>> checkUrlAndGetVideoId(String url) async {
  globalLogger.d(url,"URL Found");
  if (url.contains('youtu.be') || url.contains('youtube.com')) {
    globalLogger.d(1,"URL Found");

    String? videoId;
    if (url.contains('youtu.be')) {
      videoId = url.substring(url.lastIndexOf('/') + 1, url.length);
    } else if (url.contains('youtube.com')) {
      videoId = url.substring(url.lastIndexOf('watch?v=') + 8, url.length);
    }
    final linkList = [];
    final data = await ServiceAPI.genericCall(
        url: "https://10downloader.com/download?v=http://www.youtube.com/watch?v=$videoId&utm_source=000tube",
        httpMethod: HttpMethod.get,
        httpPurpose: HttpPurpose.webScraping);
    final document = parse(data);
    final listTableData = document
        .getElementsByTagName('body')[0]
        .getElementsByClassName('downloadSection')[0]
        .getElementsByClassName('downloadsTable')[0]
        .getElementsByTagName('tbody')[0]
        .getElementsByTagName('tr');
    for (var e in listTableData) {
      linkList.add({
        "quality": e.getElementsByTagName('td')[0].innerHtml,
        "link": e.getElementsByClassName('downloadBtn')[0].attributes['href'],
      });
    }

    globalLogger.d(linkList);
    return linkList;
  }
  return [
    {
      "quality": 'Auto',
      "link": url,
    }
  ];
}
class MhVideoController extends VideoPlayerController {
  // late final VideoPlayerController controller;
  // MhVideoController();

  final List<List<dynamic>> _playlist = [];
  List<dynamic> _currentPlay = [];
  int _currentIndex = -1;

  setCurrentIndex(int currentIndex) {
    _currentIndex = currentIndex;
  }

  setCurrentPlay(List<dynamic> currentPlay) {
    _currentPlay = currentPlay;
  }

  setPlayList(List<String> playList) {
    _playlist.clear();

    playList.forEach((element) async {
      _playlist.add(await checkUrlAndGetVideoId(element));
    });
  }

  int get currentIndex => _currentIndex;
  List<dynamic> get currentPlay => _currentPlay;
  List<List<dynamic>> get playList => _playlist;

  Future<List<dynamic>> checkUrlAndGetVideoId(String url) async {
    if (url.contains('youtu.be') || url.contains('youtube.com')) {
      String? videoId;
      if (url.contains('youtu.be')) {
        videoId = url.substring(url.lastIndexOf('/') + 1, url.length);
      } else if (url.contains('youtube.com')) {
        videoId = url.substring(url.lastIndexOf('watch?v=') + 8, url.length);
      }
      final linkList = [];
      final data = await ServiceAPI.genericCall(
          url: "https://10downloader.com/download?v=http://www.youtube.com/watch?v=$videoId&utm_source=000tube",
          httpMethod: HttpMethod.get,
          httpPurpose: HttpPurpose.webScraping);
      final document = parse(data);
      final listTableData = document
          .getElementsByTagName('body')[0]
          .getElementsByClassName('downloadSection')[0]
          .getElementsByClassName('downloadsTable')[0]
          .getElementsByTagName('tbody')[0]
          .getElementsByTagName('tr');
      for (var e in listTableData) {
        linkList.add({
          "quality": e.getElementsByTagName('td')[0].innerHtml,
          "link": e.getElementsByClassName('downloadBtn')[0].attributes['href'],
        });
      }

      globalLogger.d(linkList);
      return linkList;
    }
    return [
      {
        "quality": 'Auto',
        "link": url,
      }
    ];
  }

  MhVideoController.asset({
    required String initialDataSource,
    String? package,
    Future<ClosedCaptionFile>? closedCaptionFile,
    VideoPlayerOptions? videoPlayerOptions,
  }) : super.asset(
          initialDataSource,
          package: package,
          closedCaptionFile: closedCaptionFile,
          videoPlayerOptions: videoPlayerOptions,
        );

  MhVideoController.network({
    required String initialDataSource,
    VideoFormat? formatHint,
    Future<ClosedCaptionFile>? closedCaptionFile,
    VideoPlayerOptions? videoPlayerOptions,
    Map<String, String> httpHeaders = const <String, String>{},
  }) : super.network(
          initialDataSource,
          formatHint: formatHint,
          closedCaptionFile: closedCaptionFile,
          videoPlayerOptions: videoPlayerOptions,
          httpHeaders: httpHeaders,
        );

  MhVideoController.file({
    required File initialFile,
    Future<ClosedCaptionFile>? closedCaptionFile,
    VideoPlayerOptions? videoPlayerOptions,
    Map<String, String> httpHeaders = const <String, String>{},
  }) : super.file(
          initialFile,
          closedCaptionFile: closedCaptionFile,
          videoPlayerOptions: videoPlayerOptions,
          httpHeaders: httpHeaders,
        );

  MhVideoController.contentUri({
    required Uri contentUri,
    Future<ClosedCaptionFile>? closedCaptionFile,
    VideoPlayerOptions? videoPlayerOptions,
  }) : super.contentUri(
          contentUri,
          closedCaptionFile: closedCaptionFile,
          videoPlayerOptions: videoPlayerOptions,
        );

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
  bool _creationDispatched = false;
  static final List<VoidCallback?> _emptyListeners = List<VoidCallback?>.filled(0, null);
  List<VoidCallback?> _listeners = _emptyListeners;
  int _count = 0;

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
