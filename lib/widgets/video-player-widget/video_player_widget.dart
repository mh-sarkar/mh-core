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
    this.onNextPress,
    this.onPreviousPress,
  }) : super(key: key);

  // final VideoPlayerController controller;
  MhVideoController controller;
  List<String>? videoList;
  Function(int)? onNextPress;
  Function(int)? onPreviousPress;

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  int currentIndex = 0;
  Future<void>? _initializeVideoPlayerFuture;
  // int? _playBackTime;
  List<dynamic> resVideo = [];
  //The values that are passed when changing quality
  Duration? newCurrentPosition;
  @override
  void initState() {
    // globalLogger.d("Eibar AMI Call Holam");

    widget.controller.dispose();

    widget.controller.setCurrentIndex(0);
    // globalLogger.d(widget.controller.value, "Controller Value");
    _newPlay(false);
    listener = () {
      // globalLogger.d("_initializePlay Listener");
      Duration duration = widget.controller.value.duration;
      Duration position = widget.controller.value.position;
      // globalLogger.d(
      //     widget.controller.currentIndex.toString() +
      //         " " +
      //         currentIndex.toString() +
      //         " " +
      //         (currentIndex == widget.controller.currentIndex).toString(),
      //     "Listen");
      // globalLogger.d(duration.inSeconds, position.inSeconds);
      if (duration.inSeconds == position.inSeconds &&
          currentIndex == widget.controller.currentIndex &&
          currentIndex < widget.videoList!.length - 1) {
        widget.controller.setCurrentIndex(currentIndex + 1);
        // if (currentIndex != widget.controller.currentIndex) {
        widget.controller.pause();
        currentIndex = widget.controller.currentIndex;
        if (mounted) setState(() {});
        widget.onNextPress!(currentIndex);
        globalLogger.d("Eibar NEW PLAY Call HOLO");

        _newPlay();
        // }
      }

      // _playBackTime = widget.controller.value.position.inSeconds;
      if (mounted) setState(() {});
    };
    super.initState();
  }

  _newPlay([bool isPlay = true]) {
    checkUrlAndGetVideoId(widget.videoList![currentIndex]).then((value) => {
          _getValuesAndPlay(value[0]['link'], isPlay),
          resVideo = value,
        });
  }

  Future<bool> _clearPrevious() async {
    await widget.controller.pause();
    return true;
  }

  late VoidCallback listener;
  Future<void> _initializePlay(String videoPath, bool isPlay) async {
    widget.controller = MhVideoController.network(initialDataSource: videoPath)
      ..setCurrentPlay(resVideo)
      ..setCurrentIndex(currentIndex);
    widget.controller.addListener(listener);
    _initializeVideoPlayerFuture = widget.controller.initialize().then((_) {
      widget.controller.seekTo(newCurrentPosition!);
      if (isPlay) {
        widget.controller.play();
      } else {
        widget.controller.pause();
      }
    });
  }

  void _getValuesAndPlay(String videoPath, bool isPlay) {
    // newCurrentPosition = widget.controller.value.position;
    newCurrentPosition = Duration.zero;
    _startPlay(videoPath, isPlay);
    print(newCurrentPosition.toString());
  }

  Future<void> _startPlay(String videoPath, bool isPlay) async {
    _initializeVideoPlayerFuture = null;
    if (mounted) setState(() {});
    Future.delayed(const Duration(milliseconds: 200), () {
      _clearPrevious().then((_) {
        _initializePlay(videoPath, isPlay);
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _initializeVideoPlayerFuture = null;

    widget.controller.pause().then((_) {
      widget.controller.removeListener(listener);
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
        fit: MediaQuery.of(context).orientation == Orientation.portrait ? StackFit.loose : StackFit.expand,
        children: [
          buildVideoPlayer(),
          Positioned.fill(
            child: BasicOverlayWidget(
                controller: widget.controller,
                videoList: widget.videoList,
                onResolutionChanged: (val) {
                  _getValuesAndPlay(val['link'], true);
                },
                onNextPress: (val) {
                  globalLogger.d("Next Call $val");
                  if (widget.onNextPress != null) widget.onNextPress!(val);

                  if (val != currentIndex) {
                    currentIndex = val;
                    setState(() {});
                    _newPlay();
                  }
                },
                onPreviousPress: (val) {
                  globalLogger.d("Previous Call $val");
                  if (widget.onPreviousPress != null) widget.onPreviousPress!(val);
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

class VideoPlayerWidgetV2 extends StatefulWidget {
  const VideoPlayerWidgetV2({
    Key? key,
    this.videoList,
    this.onNextPress,
    this.onPreviousPress,
    this.listenPosition,
  }) : super(key: key);

  // final VideoPlayerController controller;

  final List<String>? videoList;
  final Function(int)? onNextPress;
  final Function(int)? onPreviousPress;
  final Function(int)? listenPosition;

  @override
  State<VideoPlayerWidgetV2> createState() => _VideoPlayerWidgetV2State();
}

class _VideoPlayerWidgetV2State extends State<VideoPlayerWidgetV2> {
  int currentIndex = 0;
  Future<void>? _initializeVideoPlayerFuture;
  // int? _playBackTime;
  List<dynamic> resVideo = [];
  //The values that are passed when changing quality
  Duration? newCurrentPosition;
  MhVideoController? controller;
  @override
  void initState() {
    if (widget.videoList!.isNotEmpty) {
      // globalLogger.d("Eibar AMI Call Holam");

      // controller.dispose();
      // controller.

      // globalLogger.d(controller.value, "Controller Value");
      controller = MhVideoController.network(initialDataSource: widget.videoList![0])
        ..setCurrentIndex(0)
        ..initialize();
      _newPlay(false);
      // if (mounted) {
      //   setState(() {});
      // }
      listener = () {
        // globalLogger.d("_initializePlay Listener");
        Duration duration = controller!.value.duration;
        Duration position = controller!.value.position;
        if (widget.listenPosition != null) {
          widget.listenPosition!(position.inSeconds);
        }
        // globalLogger.d(
        //     controller.currentIndex.toString() +
        //         " " +
        //         currentIndex.toString() +
        //         " " +
        //         (currentIndex == controller.currentIndex).toString(),
        //     "Listen");
        // globalLogger.d(duration.inSeconds, position.inSeconds);
        if (duration.inSeconds == position.inSeconds &&
            currentIndex == controller!.currentIndex &&
            currentIndex < widget.videoList!.length - 1) {
          controller!.setCurrentIndex(currentIndex + 1);
          // if (currentIndex != controller.currentIndex) {
          controller!.pause();
          currentIndex = controller!.currentIndex;
          if (mounted) setState(() {});
          widget.onNextPress!(currentIndex);
          globalLogger.d("Eibar NEW PLAY Call HOLO");

          _newPlay();
          // }
        }

        // _playBackTime = controller.value.position.inSeconds;
        if (mounted) setState(() {});
      };
    }
    super.initState();
  }

  _newPlay([bool isPlay = true]) {
    checkUrlAndGetVideoId(widget.videoList![currentIndex]).then((value) => {
          _getValuesAndPlay(value[0]['link'], isPlay),
          resVideo = value,
        });
  }

  Future<bool> _clearPrevious() async {
    await controller!.pause();
    return true;
  }

  late VoidCallback listener;
  Future<void> _initializePlay(String videoPath, bool isPlay) async {
    controller = MhVideoController.network(initialDataSource: videoPath)
      ..setCurrentPlay(resVideo)
      ..setCurrentIndex(currentIndex);
    controller!.addListener(listener);
    _initializeVideoPlayerFuture = controller!.initialize().then((_) {
      controller!.seekTo(newCurrentPosition!);
      if (isPlay) {
        controller!.play();
      } else {
        controller!.pause();
      }
    });
  }

  void _getValuesAndPlay(String videoPath, bool isPlay) {
    // newCurrentPosition = controller!.value.position;
    newCurrentPosition = Duration.zero;
    _startPlay(videoPath, isPlay);
    print(newCurrentPosition.toString());
  }

  Future<void> _startPlay(String videoPath, bool isPlay) async {
    _initializeVideoPlayerFuture = null;
    if (mounted) setState(() {});
    Future.delayed(const Duration(milliseconds: 200), () {
      _clearPrevious().then((_) {
        _initializePlay(videoPath, isPlay);
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _initializeVideoPlayerFuture = null;

    controller!.pause().then((_) {
      controller!.setVolume(0.0);
      controller!.removeListener(listener);
      controller!.dispose();
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.videoList!.isNotEmpty
      ? controller == null
          ? const SizedBox(
              height: 200,
              child: Center(
                child: CircularProgressIndicator(),
              ))
          : controller!.value.isInitialized
              ? Container(alignment: Alignment.topCenter, child: buildVideo())
              : const SizedBox(
                  height: 200,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
      :  Container(
          height: 200,
          color: Colors.black12,
          child: const Center(
            child: Text('Couldn\'t Find any video to show'),
          ),
        );

  Widget buildVideo() => Stack(
        fit: MediaQuery.of(context).orientation == Orientation.portrait ? StackFit.loose : StackFit.expand,
        children: [
          buildVideoPlayer(),
          Positioned.fill(
            child: BasicOverlayWidget(
                controller: controller!,
                videoList: widget.videoList,
                onResolutionChanged: (val) {
                  _getValuesAndPlay(val['link'], true);
                },
                onNextPress: (val) {
                  globalLogger.d("Next Call $val and controller index ${controller!.currentIndex}");
                  if (widget.onNextPress != null) widget.onNextPress!(val);

                  if (val != currentIndex) {
                    currentIndex = val;
                    setState(() {});
                    _newPlay();
                  }
                },
                onPreviousPress: (val) {
                  globalLogger.d("Previous Call $val");
                  if (widget.onPreviousPress != null) widget.onPreviousPress!(val);
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
        aspectRatio: controller!.value.aspectRatio,
        child: VideoPlayer(controller!),
      );
}
