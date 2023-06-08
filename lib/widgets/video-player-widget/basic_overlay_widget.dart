import 'dart:async';
import 'package:mh_core/utils/color/custom_color.dart';
import 'package:mh_core/utils/constant.dart';
import 'package:mh_core/utils/global.dart';
import 'package:mh_core/widgets/video-player-widget/controller.dart';
import '../divider/custom_divider.dart';
import '../video-player-widget/landscape_video.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import 'package:perfect_volume_control/perfect_volume_control.dart';

class BasicOverlayWidget extends StatefulWidget {
  BasicOverlayWidget({
    Key? key,
    required this.controller,
    required this.onResolutionChanged,
    required this.onNextPress,
    required this.onPreviousPress,
     this.videoList,
    this.volumeBarActiveTime = 3,
    this.showOverlayTime = 3,
  }) : super(key: key);

  MhVideoController controller;
  int volumeBarActiveTime;
  int showOverlayTime;
  Function(dynamic) onResolutionChanged;
  Function(int) onNextPress;
  Function(int) onPreviousPress;
  List<String>? videoList;
  @override
  State<BasicOverlayWidget> createState() => _BasicOverlayWidgetState();
}

class _BasicOverlayWidgetState extends State<BasicOverlayWidget> {
  int sliderValue = 8;
  bool showVolumeSlider = false;
  bool showOverlay = false;
  Timer? volumeSliderShowTimer;
  Timer? showOverlayTimer;
  double? previousVolume;
  double? nowVolume;

  @override
  void initState() {
    widget.controller.value.isPlaying ? showOverlay = false : showOverlay = true;
    PerfectVolumeControl.hideUI = true;
    PerfectVolumeControl.setVolume(.8);
    super.initState();
  }

  void showOverlayStartTimer() {
    const oneSec = Duration(seconds: 1);
    print('timer called..................................');
    showOverlayTimer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (widget.showOverlayTime == 0) {
          if (mounted) {
            setState(() {
              showOverlay = false;
              timer.cancel();
              showOverlayResetTimer();
            });
          }
        } else {
          if (mounted) {
            setState(() {
              widget.showOverlayTime--;
              print(widget.showOverlayTime.toString() + '...................');
            });
          }
        }
      },
    );
  }

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    volumeSliderShowTimer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (widget.volumeBarActiveTime == 0) {
          if (mounted) {
            setState(() {
              showVolumeSlider = false;
              timer.cancel();
              resetTimer();
            });
          }
        } else {
          if (mounted) {
            setState(() {
              widget.volumeBarActiveTime--;
            });
          }
        }
      },
    );
  }

  resetTimer() {
    widget.volumeBarActiveTime = 3;
    setState(() {});
  }

  showOverlayResetTimer() {
    widget.showOverlayTime = 3;
    print('cancel ......................................');
    setState(() {});
  }

  @override
  void dispose() {
    // TODO: implement dispose
    if (volumeSliderShowTimer != null) {
      volumeSliderShowTimer!.cancel();
    }
    if (showOverlayTimer != null) {
      showOverlayTimer!.cancel();
    }
    super.dispose();
  }

  _onTapDown(TapDownDetails details) {
    // globalLogger.d(details.localPosition.dx, details.globalPosition.dx);
    // var x = details.globalPosition.dx;
    // var y = details.globalPosition.dy;
    // // or user the local position method to get the offset
    // print(details.localPosition);
    // print("tap down " + x.toString() + ", " + y.toString());

    if (details.localPosition.dx < 150) {
      widget.controller.seekTo(Duration(seconds: widget.controller.value.position.inSeconds - 10));
    } else if (details.localPosition.dx >= 150 && details.localPosition.dx <= 250) {
      widget.controller.value.isPlaying ? widget.controller.pause() : widget.controller.play();
    } else if (details.localPosition.dx > 250) {
      widget.controller.seekTo(Duration(seconds: widget.controller.value.position.inSeconds + 10));
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        setState(() {
          showOverlay = !showOverlay;
          if (showOverlay) {
            showOverlayStartTimer();
          } else if (!showOverlay) {
            showVolumeSlider = false;
          } else if (!showOverlay && showOverlayTimer != null) {
            showOverlayTimer!.cancel();
            showOverlayResetTimer();
          }
        });
      },
      onDoubleTapDown: (TapDownDetails details) => _onTapDown(details),
      child: showOverlay
          ? Stack(
              clipBehavior: Clip.none,
              children: [

                buildPlay(),
                if(widget.controller.currentIndex>0)
                  buildPrevious(),
                if(widget.controller.currentIndex<widget.videoList!.length-1)
                  buildNext(),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: buildIndicator(),
                ),
                Positioned(
                  right: 12,
                  bottom: 10,
                  child: buildBottomContain(),
                ),
              ],
            )
          : const SizedBox(),
    );
  }

  Widget buildIndicator() {
    return VideoProgressIndicator(
      allowScrubbing: true,
      widget.controller,
    );
  }

  Widget buildPrevious() {
    return GestureDetector(
      onTap: () {
        globalLogger.d("Previous Pressed");
        globalLogger.d(widget.controller.currentIndex);
        if (widget.controller.currentIndex > 0) {
          widget.onPreviousPress(widget.controller.currentIndex - 1);
        }
      },
      child: Container(
        alignment: Alignment.centerLeft,
        child: const Padding(
          padding: EdgeInsets.only(left: 20),
          child: CircleAvatar(
            radius: 18,
            backgroundColor: Colors.white54,
            child: Icon(
              Icons.keyboard_arrow_left_outlined,
              color: Colors.black87,
              size: 30,
            ),
          ),
        ),
      ),
    );
  }

  Widget buildPlay() {
    return Container(
      alignment: Alignment.center,
      color: Colors.black26,
      child: InkWell(
        onTap: () {
          widget.controller.value.isPlaying ? widget.controller.pause() : widget.controller.play();
          if (showOverlay && showOverlayTimer != null) {
            showOverlayTimer!.cancel();
            showOverlayResetTimer();
            showOverlayStartTimer();
          } else {
            showOverlayStartTimer();
          }
          setState(() {});
        },
        child: CircleAvatar(
          radius: 30,
          backgroundColor: Colors.white54,
          child: Icon(
            widget.controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
            color: Colors.black87,
            size: 35,
          ),
        ),
      ),
    );
  }

  Widget buildNext() {
    return GestureDetector(
      onTap: () {
        // globalLogger.d("Next Pressed");
        // globalLogger.d(widget.controller.currentIndex);
        // globalLogger.d(widget.videoList!.length - 1);
        // globalLogger.d(widget.controller.currentIndex< widget.videoList!.length - 1);
        if (widget.controller.currentIndex < widget.videoList!.length - 1) {
          widget.onPreviousPress(widget.controller.currentIndex + 1);
        }
      },
      child: Container(
        alignment: Alignment.centerRight,
        child: const Padding(
          padding: EdgeInsets.only(right: 20),
          child: CircleAvatar(
            radius: 18,
            backgroundColor: Colors.white54,
            child: Icon(
              Icons.keyboard_arrow_right_outlined,
              color: Colors.black87,
              size: 30,
            ),
          ),
        ),
      ),
    );
  }

  Widget buildBottomContain() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            setState(() {
              buildBottomSheet();
            });
          },
          child: const SizedBox(
            height: 30,
            width: 30,
            child: Icon(
              Icons.settings,
              color: Colors.white,
              size: 22,
            ),
          ),
        ),
        space1R,
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () async {
            PerfectVolumeControl.hideUI = true;
            if (!showVolumeSlider) {
              showVolumeSlider = true;
              previousVolume = await PerfectVolumeControl.getVolume();
              startTimer();
            } else {
              if (sliderValue == 0 && previousVolume != null && (previousVolume! * 10).ceil() != sliderValue) {
                PerfectVolumeControl.setVolume(previousVolume!);
                sliderValue = (previousVolume! * 10).ceil();
                nowVolume = previousVolume;
              } else if (sliderValue == 10 && previousVolume != null && (previousVolume! * 10).ceil() != sliderValue) {
                PerfectVolumeControl.setVolume(0);
                sliderValue = 0;
                nowVolume = 0;
              } else {
                if (previousVolume != null) {
                  if (previousVolume != 0.0) {
                    PerfectVolumeControl.setVolume(0);
                    sliderValue = 0;
                    nowVolume = 0;
                  } else if (previousVolume == 0.0) {
                    PerfectVolumeControl.setVolume(1);
                    sliderValue = 10;
                    nowVolume = 1.0;
                  } else {
                    PerfectVolumeControl.setVolume(previousVolume!);
                    sliderValue = (previousVolume! * 10).ceil();
                    nowVolume = previousVolume;
                  }
                }
                resetTimer();
              }
            }
            setState(() {});
          },
          child: buildSound(),
        ),
        space1R,
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () async {
            if (MediaQuery.of(context).orientation == Orientation.portrait) {
              SystemChrome.setPreferredOrientations([
                DeviceOrientation.landscapeRight,
                DeviceOrientation.landscapeLeft,
              ]);
              widget.controller = await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => LandscapeVideo(
                          controller: widget.controller,
                        )),
              );
            } else {
              SystemChrome.setPreferredOrientations([
                DeviceOrientation.portraitUp,
                DeviceOrientation.portraitDown,
              ]).then((value) => Navigator.pop(context));
            }
          },
          child: SizedBox(
            height: 30,
            width: 30,
            child: Icon(
              MediaQuery.of(context).orientation == Orientation.landscape ? Icons.fullscreen_exit : Icons.fullscreen,
              color: Colors.white,
              size: 25,
            ),
          ),
        ),
      ],
    );
  }

  Widget buildSound() {
    return Container(
      height: showVolumeSlider ? 130 : 30,
      width: 30,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: showVolumeSlider ? Colors.white54 : Colors.transparent,
      ),
      child: Column(
        children: [
          if (showVolumeSlider) space2C,
          if (showVolumeSlider)
            SizedBox(
              height: 96,
              child: buildSlider(),
            ),
          if (!showVolumeSlider) space1C,
          Icon(
            sliderValue == 0 ? Icons.volume_mute : Icons.volume_up,
            color: showVolumeSlider ? Colors.black : Colors.white,
            size: 22,
          ),
        ],
      ),
    );
  }

  Widget buildSlider() {
    return RotatedBox(
      quarterTurns: 3,
      child: SliderTheme(
        data: SliderTheme.of(context).copyWith(
            trackHeight: 2,
            // thumbShape: SliderComponentShape.noThumb,
            overlayShape: SliderComponentShape.noOverlay,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 5)),
        child: Slider(
          value: sliderValue.toDouble(),
          max: 10,
          min: 0,
          onChangeStart: (value) {
            resetTimer();
            setState(() {});
          },
          onChangeEnd: (value) {
            resetTimer();
          },
          activeColor: Colors.black,
          inactiveColor: Colors.black26,
          onChanged: (newValue) {
            PerfectVolumeControl.hideUI = true;
            resetTimer();
            setState(() {
              sliderValue = newValue.toInt();
              PerfectVolumeControl.setVolume(sliderValue == 0
                  ? 0.0
                  : sliderValue == 1
                      ? 0.1
                      : sliderValue == 2
                          ? 0.2
                          : sliderValue == 3
                              ? 0.3
                              : sliderValue == 4
                                  ? 0.4
                                  : sliderValue == 5
                                      ? 0.5
                                      : sliderValue == 6
                                          ? 0.6
                                          : sliderValue == 7
                                              ? 0.7
                                              : sliderValue == 8
                                                  ? 0.8
                                                  : sliderValue == 9
                                                      ? 0.9
                                                      : 1.0);

              previousVolume = sliderValue / 10;
            });
          },
        ),
      ),
    );
  }

  void buildBottomSheet() {
    showModalBottomSheet(
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
      ),
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              space2C,
              Container(
                height: 5,
                width: 60,
                color: Colors.grey.withOpacity(.40),
              ),
              space4C,
              if (MediaQuery.of(context).orientation == Orientation.landscape)
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: List.generate(widget.controller.currentPlay.length, (index) {
                        return GestureDetector(
                          onTap: () {
                            // setState(() {
                            //   regulationSelectedIndex = index;
                            // });
                            if (widget.controller.currentIndex != index) {
                              widget.controller.setCurrentIndex(index);
                              widget.onResolutionChanged(widget.controller.currentPlay[index]);
                            }
                            Navigator.pop(context);
                          },
                          child: Container(
                            color: Colors.white,
                            child: buildRegulationItem(
                              title: widget.controller.currentPlay[index]['quality'],
                              index: index,
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                ),
              if (!(MediaQuery.of(context).orientation == Orientation.landscape))
                Column(
                  children: List.generate(widget.controller.currentPlay.length, (index) {
                    return GestureDetector(
                      onTap: () {
                        // setState(() {
                        //   regulationSelectedIndex = index;
                        // });
                        if (widget.controller.currentIndex != index) {
                          widget.controller.setCurrentIndex(index);
                          widget.onResolutionChanged(widget.controller.currentPlay[index]);
                        }
                        Navigator.pop(context);
                      },
                      child: Container(
                        color: Colors.white,
                        child: buildRegulationItem(
                          title: widget.controller.currentPlay[index]['quality'],
                          index: index,
                        ),
                      ),
                    );
                  }),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget buildRegulationItem({required String title, required int index}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            children: [
              Text(
                title,
                style: widget.controller.currentIndex == index
                    ? TextStyle(
                        color: CustomColor.kPrimaryColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      )
                    : const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        color: Colors.black,
                      ),
              ),
            ],
          ),
        ),
        const MyDivider(height: .5),
      ],
    );
  }
}
