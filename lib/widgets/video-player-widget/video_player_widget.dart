import 'package:flutter/material.dart';
import 'package:mh_core/utils/global.dart';
import 'package:mh_core/widgets/video-player-widget/controller.dart';
import 'package:video_player/video_player.dart';

import 'basic_overlay_widget.dart';

class VideoPlayerWidget extends StatefulWidget {
   VideoPlayerWidget({
    Key? key,
    required this.controller,
  }) : super(key: key);

  // final VideoPlayerController controller;
   MhVideoController controller;

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  int currentIndex = 0;

  @override
  void initState(){
    final list = widget.controller.playList;
    widget.controller = MhVideoController.network(initialDataSource: list[currentIndex][0]['link']);
    globalLogger.d(widget.controller.value, "Controller Value");
    super.initState();
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
            ),
          ),
        ],
      );

  Widget buildVideoPlayer() => AspectRatio(
        aspectRatio: widget.controller.value.aspectRatio,
        child: VideoPlayer(widget.controller),
      );
}
