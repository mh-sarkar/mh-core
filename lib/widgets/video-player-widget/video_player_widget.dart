import 'package:flutter/material.dart';
import 'package:mh_core/utils/global.dart';
import 'package:mh_core/widgets/video-player-widget/controller.dart';
import 'package:video_player/video_player.dart';

import 'basic_overlay_widget.dart';

class VideoPlayerWidget extends StatefulWidget {
  VideoPlayerWidget({
    Key? key,
    required this.controller,
    this.videoList,
  }) : super(key: key);

  // final VideoPlayerController controller;
  MhVideoController controller;
  List<String>? videoList;

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  int currentIndex = 0;
  Future<void>? _initializeVideoPlayerFuture;
  int? _playBackTime;
  List<dynamic> resVideo = [];
  //The values that are passed when changing quality
  Duration? newCurrentPosition;
  @override
  void initState() {
    globalLogger.d(widget.controller.value, "Controller Value");
    _newPlay();
    super.initState();
  }

  _newPlay() {
    checkUrlAndGetVideoId(widget.videoList![currentIndex]).then((value) => {
          _getValuesAndPlay(value[0]['link']),
          resVideo = value,
        });
  }

  Future<bool> _clearPrevious() async {
    await widget.controller.pause();
    return true;
  }

  Future<void> _initializePlay(String videoPath) async {
    widget.controller = MhVideoController.network(initialDataSource: videoPath)
      ..setCurrentPlay(resVideo)
      ..setCurrentIndex(currentIndex);
    widget.controller.addListener(() {
      setState(() {
        _playBackTime = widget.controller.value.position.inSeconds;
      });
    });
    _initializeVideoPlayerFuture = widget.controller.initialize().then((_) {
      widget.controller.seekTo(newCurrentPosition!);
      widget.controller.play();
    });
  }

  void _getValuesAndPlay(String videoPath) {
    newCurrentPosition = widget.controller.value.position;
    _startPlay(videoPath);
    print(newCurrentPosition.toString());
  }

  Future<void> _startPlay(String videoPath) async {
    setState(() {
      _initializeVideoPlayerFuture = null;
    });
    Future.delayed(const Duration(milliseconds: 200), () {
      _clearPrevious().then((_) {
        _initializePlay(videoPath);
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _initializeVideoPlayerFuture = null;
    widget.controller.pause().then((_) {
      widget.controller.dispose();
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.controller.value.isInitialized
      ? Container(alignment: Alignment.topCenter, child: buildVideo())
      : const SizedBox(
          height: 200,
          child: Center(
            child: CircularProgressIndicator(),
          ),
        );

  Widget buildVideo() => Stack(
        children: [
          buildVideoPlayer(),
          Positioned.fill(
            child: BasicOverlayWidget(
                controller: widget.controller,
                onResolutionChanged: (val) {
                  _getValuesAndPlay(val['link']);
                },
                onNextPress: (val) {
                  globalLogger.d("Next Call $val");

                  if (val != currentIndex) {
                    currentIndex = val;
                    setState(() {});
                    _newPlay();
                  }
                },
                onPreviousPress: (val) {
                  globalLogger.d("Previous Call $val");
                  if (val != currentIndex) {
                    currentIndex = val;
                    setState(() {});
                    _newPlay();
                  }
                }),
          ),
        ],
      );

  Widget buildVideoPlayer() => AspectRatio(
        aspectRatio: widget.controller.value.aspectRatio,
        child: VideoPlayer(widget.controller),
      );
}
