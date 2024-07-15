import 'dart:io';

import 'package:amir_diet/main.dart';
import 'package:amir_diet/utils/app_constants.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:simple_pip_mode/simple_pip.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../extensions/extension_util/string_extensions.dart';
import '../../extensions/extension_util/widget_extensions.dart';
import '../../models/exercise_detail_response.dart';
import '../components/count_down_progress_indicator.dart';
import '../extensions/constants.dart';
import '../extensions/extension_util/context_extensions.dart';
import '../extensions/extension_util/int_extensions.dart';
import '../extensions/system_utils.dart';
import '../extensions/widgets.dart';
import '../utils/app_colors.dart';
import '../utils/app_common.dart';

class ExerciseDurationScreen extends StatefulWidget {
  static String tag = '/ExerciseDurationScreen';
  final ExerciseDetailResponse? mExerciseModel;

  ExerciseDurationScreen(this.mExerciseModel);

  @override
  ExerciseDurationScreenState createState() => ExerciseDurationScreenState();
}

class ExerciseDurationScreenState extends State<ExerciseDurationScreen> {
  CountDownController mCountDownController = CountDownController();

  String? durationstring;
  Duration? duration1;
  late FlutterTts flutterTts;
  late VideoPlayerController _videoPlayerController1;
  ChewieController? _chewieController;
  int? bufferDelay;
  bool? isChanged = false;
  YoutubePlayerController? youtubePlayerController;
  TextEditingController? _idController;
  late TextEditingController _seekToController;
  late PlayerState _playerState;
  late YoutubeMetaData videoMetaData;
  bool _isPlayerReady = false;
  String? videoId = '';

  bool visibleOption = true;

  @override
  void initState() {
    super.initState();
    init();
    flutterTts = FlutterTts();
    initializePlayer();
  }

  init() async {
    durationstring = widget.mExerciseModel!.data!.duration.validate();
    duration1 = parseDuration(durationstring!);

    if (widget.mExerciseModel!.data!.duration != null &&
        widget.mExerciseModel!.data!.videoUrl
            .validate()
            .contains("https://youtu"))
      duration1 =
          parseDuration(widget.mExerciseModel!.data!.duration.validate());

    if (videoId != null)
      videoId = YoutubePlayer.convertUrlToId(
          widget.mExerciseModel!.data!.videoUrl.validate());
    if (videoId != null)
      youtubePlayerController = YoutubePlayerController(
        initialVideoId: videoId!,
        flags: YoutubePlayerFlags(
          mute: false,
          autoPlay: true,
          disableDragSeek: false,
          loop: false,
          isLive: false,
          forceHD: false,
          enableCaption: true,
          showLiveFullscreenButton: false,
        ),
      )..addListener(listener);
    _idController = TextEditingController();
    _seekToController = TextEditingController();
    if (youtubePlayerController != null)
      youtubePlayerController!.addListener(() {
        if (_playerState == PlayerState.playing) {
          if (isChanged == true) {
            mCountDownController.resume();
            isChanged = false;
          }
        }
        if (_playerState == PlayerState.paused) {
          mCountDownController.pause();
          flutterTts.pause();
          isChanged = true;
        }
      });
    videoMetaData = const YoutubeMetaData();
    _playerState = PlayerState.unknown;
  }

  Future<void> initializePlayer() async {
    _videoPlayerController1 = VideoPlayerController.networkUrl(
        Uri.parse(widget.mExerciseModel!.data!.videoUrl.validate()));
    await Future.wait([_videoPlayerController1.initialize()]);
    _createChewieController();
    _videoPlayerController1.addListener(() {
      // Do something based on controller state
      if (_videoPlayerController1.value.isPlaying) {
        print('Video is playing');
        if (isChanged == true) {
          mCountDownController.resume();
          isChanged = false;
        }
      } else if (_videoPlayerController1.value.isBuffering) {
        print('Video is buffering');
      } else if (_videoPlayerController1.value.isInitialized) {
        mCountDownController.pause();
        flutterTts.pause();
        isChanged = true;
      } else {
        print('Video controller is in an unknown state');
      }
    });
    setState(() {});
  }

  void _createChewieController() {
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController1,
      autoPlay: true,
      looping: true,
      deviceOrientationsAfterFullScreen: [
        DeviceOrientation.portraitDown,
        DeviceOrientation.portraitUp,
      ],
      progressIndicatorDelay:
          bufferDelay != null ? Duration(milliseconds: bufferDelay!) : null,
      hideControlsTimer: const Duration(seconds: 1),
      showOptions: false,
      materialProgressColors: ChewieProgressColors(
        playedColor:
            userStore.gender == MALE ? scaffoldColorDark : primaryColor,
        handleColor:
            userStore.gender == MALE ? scaffoldColorDark : primaryColor,
        backgroundColor: textSecondaryColorGlobal,
        bufferedColor: textSecondaryColorGlobal,
      ),
      // autoInitialize: true,
    );
  }

  int currPlayIndex = 0;

  Future<void> toggleVideo() async {
    await _videoPlayerController1.pause();
    currPlayIndex += 1;
    await initializePlayer();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  dispose() {
    _videoPlayerController1.dispose();
    _chewieController?.dispose();
    if (youtubePlayerController != null) youtubePlayerController!.dispose();
    if (_idController != null) _idController!.dispose();
    _seekToController.dispose();
    super.dispose();
  }

  void exitScreen() {
    if (MediaQuery.of(context).orientation == Orientation.landscape) {
      SystemChrome.setPreferredOrientations(
          [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    }
    finish(context);
  }

  void listener() {
    if (_isPlayerReady &&
        mounted &&
        !youtubePlayerController!.value.isFullScreen) {
      setState(() {
        _playerState = youtubePlayerController!.value.playerState;
        videoMetaData = youtubePlayerController!.metadata;
      });
    }
  }

  @override
  void deactivate() {
    // Pauses video while navigating to next page.
    if (youtubePlayerController != null) youtubePlayerController!.pause();
    super.deactivate();
  }

  Duration parseDuration(String durationString) {
    List<String> components = durationString.split(':');

    int hours = int.parse(components[0]);
    int minutes = int.parse(components[1]);
    int seconds = int.parse(components[2]);

    return Duration(hours: hours, minutes: minutes, seconds: seconds);
  }

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitHours = twoDigits(duration.inHours);
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));

    return "$twoDigitHours:$twoDigitMinutes:$twoDigitSeconds";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(widget.mExerciseModel!.data!.title.validate(),
          context: context),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            widget.mExerciseModel!.data!.videoUrl
                    .validate()
                    .contains("https://youtu")
                ? AspectRatio(
                    aspectRatio: 12 / 7,
                    child: YoutubePlayerBuilder(
                      onExitFullScreen: () {
                        SystemChrome.setPreferredOrientations(
                            DeviceOrientation.values);
                      },
                      onEnterFullScreen: () {
                        youtubePlayerController!.toggleFullScreenMode();
                      },
                      player: YoutubePlayer(
                        controller: youtubePlayerController!,
                        showVideoProgressIndicator: true,
                        progressIndicatorColor: Colors.white,
                        thumbnail: cachedImage(
                                widget.mExerciseModel!.data!.exerciseImage
                                    .validate(),
                                fit: BoxFit.fill,
                                height: context.height())
                            .cornerRadiusWithClipRRect(0),
                        progressColors: ProgressBarColors(
                          playedColor: Colors.white,
                          bufferedColor: Colors.grey.shade200,
                          handleColor: Colors.white,
                          backgroundColor: Colors.grey,
                        ),
                        topActions: <Widget>[
                          if (MediaQuery.of(context).orientation ==
                              Orientation.landscape)
                            Align(
                              alignment: Alignment.topRight,
                              child: IconButton(
                                padding: EdgeInsets.only(
                                    top: context.statusBarHeight + 20),
                                icon: const Icon(Icons.close,
                                    color: Colors.white, size: 25.0),
                                onPressed: () {
                                  exitScreen();
                                },
                              ),
                            ),
                        ],
                        onReady: () {
                          _isPlayerReady = true;
                        },
                        onEnded: (data) {
                          //
                        },
                      ),
                      builder: (context, player) => WillPopScope(
                        onWillPop: () {
                          exitScreen();
                          return Future.value(true);
                        },
                        child: Scaffold(
                          body: Container(
                            height: context.height(),
                            child: Stack(
                              alignment: Alignment.topLeft,
                              children: [
                                Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    player,
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        IconButton(
                                            icon: Icon(
                                                CupertinoIcons.gobackward_10,
                                                color: Colors.white,
                                                size: 30),
                                            onPressed: () {
                                              Duration currentPosition =
                                                  youtubePlayerController!
                                                      .value.position;
                                              Duration targetPosition =
                                                  currentPosition -
                                                      const Duration(
                                                          seconds: 10);
                                              youtubePlayerController!
                                                  .seekTo(targetPosition);
                                            }).visible(!youtubePlayerController!
                                                .value.isPlaying &&
                                            _isPlayerReady),
                                        GestureDetector(
                                          onTap: () {
                                            if (_isPlayerReady) {
                                              youtubePlayerController!
                                                      .value.isPlaying
                                                  ? youtubePlayerController!
                                                      .pause()
                                                  : youtubePlayerController!
                                                      .play();
                                              setState(() {});
                                            }
                                          },
                                          child:
                                              SizedBox(height: 50, width: 50),
                                        ),
                                        IconButton(
                                            icon: Icon(
                                                CupertinoIcons.goforward_10,
                                                color: Colors.white,
                                                size: 30),
                                            onPressed: () {
                                              Duration currentPosition =
                                                  youtubePlayerController!
                                                      .value.position;
                                              Duration targetPosition =
                                                  currentPosition +
                                                      const Duration(
                                                          seconds: 10);
                                              youtubePlayerController!
                                                  .seekTo(targetPosition);
                                            }).visible(!youtubePlayerController!
                                                .value.isPlaying &&
                                            _isPlayerReady),
                                      ],
                                    ),
                                  ],
                                ).center(),
                                if (visibleOption)
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      IconButton(
                                        padding: EdgeInsets.zero,
                                        icon: const Icon(Icons.close,
                                            color: Colors.white, size: 25.0),
                                        onPressed: () {
                                          exitScreen();
                                        },
                                      ),
                                      Platform.isAndroid
                                          ? IconButton(
                                              padding: EdgeInsets.zero,
                                              onPressed: () {
                                                SimplePip(onPipEntered: () {
                                                  visibleOption = false;
                                                  setState(() {});
                                                }, onPipExited: () {
                                                  visibleOption = true;
                                                  setState(() {});
                                                }).enterPipMode();
                                              },
                                              icon: Icon(
                                                  Icons
                                                      .picture_in_picture_alt_outlined,
                                                  color: Colors.white,
                                                  size: 25.0),
                                            )
                                          : SizedBox(),
                                    ],
                                  ).paddingOnly(top: 30, left: 8, right: 8),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ))
                : AspectRatio(
                    aspectRatio: 12 / 7,
                    child: _chewieController != null &&
                            _chewieController!
                                .videoPlayerController.value.isInitialized
                        ? Chewie(controller: _chewieController!)
                        : cachedImage(
                                widget.mExerciseModel!.data!.exerciseImage
                                    .validate(),
                                fit: BoxFit.fill,
                                height: context.height())
                            .cornerRadiusWithClipRRect(0),
                  ).center(),
            34.height,
            SizedBox(
              height: 150,
              width: context.width(),
              child: CountDownProgressIndicator(
                controller: mCountDownController,
                strokeWidth: 15,
                valueColor:
                    userStore.gender == MALE ? scaffoldColorDark : primaryColor,
                backgroundColor: primaryOpacity,
                initialPosition: 0,
                duration: widget.mExerciseModel!.data!.duration.isEmptyOrNull
                    ? widget.mExerciseModel!.data!.duration!.toInt()
                    : duration1!.inSeconds,
                timeFormatter: (seconds) {
                  return Duration(seconds: seconds)
                      .toString()
                      .split('.')[0]
                      .padLeft(8, '0');
                },
                text: 'mm:ss',
                onComplete: () {
                  // toast("done");
                },
              ),
            ).center(),
            34.height,
          ],
        ).center(),
      ),
    );
  }
}
