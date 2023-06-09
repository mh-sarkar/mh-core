import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mh_core/widgets/video-player-widget/controller.dart';
import 'package:mh_core/widgets/video-player-widget/video_player_widget.dart';
import 'package:video_player/video_player.dart';

class LandscapeVideo extends StatefulWidget {
  const LandscapeVideo({Key? key,  this.controller}) : super(key: key);
final MhVideoController? controller;

  @override
  State<LandscapeVideo> createState() => _LandscapeVideoState();
}

class _LandscapeVideoState extends State<LandscapeVideo> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()async{
        await   SystemChrome.restoreSystemUIOverlays();

        await SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp,
          DeviceOrientation.portraitDown,
        ]);
        Navigator.pop(context, widget.controller);
        return true;
      },
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top,
          ),
          child: SizedBox(
            height: MediaQuery.of(context).size.height -
                MediaQuery.of(context).padding.top,
            width: MediaQuery.of(context).size.width,
            child: VideoPlayerWidget(
              controller: widget.controller!,
            ),
          ),
        ),
      ),
    );
  }
}
