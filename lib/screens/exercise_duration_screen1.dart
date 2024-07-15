import 'dart:io';

import 'package:amir_diet/utils/app_constants.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:amir_diet/extensions/extension_util/context_extensions.dart';
import 'package:simple_pip_mode/simple_pip.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../extensions/extension_util/string_extensions.dart';
import '../../extensions/extension_util/widget_extensions.dart';
import '../../models/exercise_detail_response.dart';
import '../components/count_down_progress_indicator1.dart';
import '../extensions/colors.dart';
import '../extensions/constants.dart';
import '../extensions/extension_util/int_extensions.dart';
import '../extensions/extension_util/list_extensions.dart';
import '../extensions/system_utils.dart';
import '../extensions/text_styles.dart';
import '../extensions/time_formatter.dart';
import '../extensions/widgets.dart';
import '../main.dart';
import '../models/models.dart';
import '../utils/app_colors.dart';
import '../utils/app_common.dart';

class ExerciseDurationScreen1 extends StatefulWidget {
  static String tag = '/ExerciseDurationScreen';
  final ExerciseDetailResponse? mExerciseModel;

  ExerciseDurationScreen1(this.mExerciseModel);

  @override
  ExerciseDurationScreen1State createState() => ExerciseDurationScreen1State();
}

class ExerciseDurationScreen1State extends State<ExerciseDurationScreen1> {
  CountDownController1 mCountDownController1 = CountDownController1();

  Duration? duration;
  FlutterTts? flutterTts;
  int i = 0;
  int? mLength;
  Workout? _workout;
  Tabata? _tabata;

  List<String>? mExTime = [];
  List<String>? mRestTime = [];
  late VideoPlayerController _videoPlayerController1;
  ChewieController? _chewieController;
  int? bufferDelay;
  YoutubePlayerController? youtubePlayerController;
  late TextEditingController _idController;
  late TextEditingController _seekToController;
  late PlayerState? _playerState;
  late YoutubeMetaData videoMetaData;
  bool _isPlayerReady = false;
  String? videoId = '';

  bool visibleOption = true;
  bool? isChanged = false;

  @override
  initState() {
    super.initState();
    if (widget.mExerciseModel!.data!.sets != null) {
      widget.mExerciseModel!.data!.sets!.forEachIndexed((element, index) {
        mExTime!.add(element.time.toString());
        mRestTime!.add(element.rest.toString());
        setState(() {});
      });
      _tabata = Tabata(
          sets: 1,
          reps: widget.mExerciseModel!.data!.sets!.length,
          startDelay: Duration(seconds: 3),
          exerciseTime: mExTime,
          restTime: mRestTime,
          breakTime: Duration(seconds: 60),
          status:
              widget.mExerciseModel!.data!.based == "reps" ? "reps" : "second");
    }

    initializePlayer();

    init();

    if (videoId != null)
      videoId = YoutubePlayer.convertUrlToId(
          widget.mExerciseModel!.data!.videoUrl.validate());
    if (flutterTts != null) flutterTts!.awaitSpeakCompletion(true);
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
            _workout!.resetTimer();
            isChanged = false;
          }
        }
        if (_playerState == PlayerState.paused) {
          _workout!.pause();
          if (flutterTts != null) flutterTts!.pause();
          isChanged = true;
        }
      });
    videoMetaData = const YoutubeMetaData();
    _playerState = PlayerState.unknown;
  }

  init() async {
    //
    if (widget.mExerciseModel!.data!.sets != null) {
      mLength = widget.mExerciseModel!.data!.sets!.length - 1;
    }
    _workout = Workout(_tabata!, _onWorkoutChanged);
    _start();
  }

  @override
  dispose() {
    _workout!.dispose();
    _videoPlayerController1.dispose();
    if (youtubePlayerController != null) youtubePlayerController!.dispose();
    _idController.dispose();
    _seekToController.dispose();
    _chewieController?.dispose();
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
          _workout!.resetTimer();
          isChanged = false;
        }
      } else if (_videoPlayerController1.value.isBuffering) {
        print('Video is buffering');
      } else if (_videoPlayerController1.value.isInitialized) {
        _workout!.pause();
        if (flutterTts != null) flutterTts!.pause();
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

  _onWorkoutChanged() {
    if (_workout!.step == WorkoutState.finished) {
      finish(context);
    }

    this.setState(() {});
  }

  _start() {
    _workout!.start();
  }

  Widget dividerHorizontalLine({bool? isSmall = false}) {
    return Container(
      height: isSmall == true ? 40 : 65,
      width: 4,
      color: whiteColor,
    );
  }

  Widget mSetText(String value, {String? value2}) {
    return Text(value, style: boldTextStyle(size: 18)).center();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  Duration parseDuration(String durationString) {
    List<String> components = durationString.split(':');

    int hours = int.parse(components[0]);
    int minutes = int.parse(components[1]);
    int seconds = int.parse(components[2]);

    return Duration(hours: hours, minutes: minutes, seconds: seconds);
  }

  Widget mData(List<Sets> strings) {
    List<Widget> list = [];
    for (var i = 0; i < strings.length; i++) {
      list.add(new Text(strings[i].time.toString()));
    }
    return new Row(children: list);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(widget.mExerciseModel!.data!.title.validate(),
          context: context),
      body: SingleChildScrollView(
        child: Column(
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
                  ),
            30.height,
            if (widget.mExerciseModel!.data!.sets != null)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      Text(
                          '${_workout!.rep}/${widget.mExerciseModel!.data!.sets!.length.toString()}',
                          style: boldTextStyle(size: 18)),
                      Text(
                        languages.lblSets,
                        style: secondaryTextStyle(),
                      )
                    ],
                  ),
                  Column(
                    children: [
                      _workout!.rep >= 1
                          ? mSetText(
                              widget.mExerciseModel!.data!.based == "reps"
                                  ? widget.mExerciseModel!.data!
                                      .sets![_workout!.rep - 1].reps
                                      .toString()
                                  : widget.mExerciseModel!.data!
                                      .sets![_workout!.rep - 1].time
                                      .toString())
                          : mSetText("-"),
                      Text(
                        widget.mExerciseModel!.data!.based == "reps"
                            ? languages.lblReps
                            : languages.lblSecond,
                        style: secondaryTextStyle(),
                      )
                    ],
                  ),
                ],
              ).paddingSymmetric(horizontal: 16),
            50.height,
            Container(
                child: FittedBox(
                    child: Text(formatTime1(_workout!.timeLeft),
                        style: boldTextStyle(size: 110)))),
            16.height,
          ],
        ).center(),
      ),
    );
  }
}
