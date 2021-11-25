import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/index.dart';

class CenterPlayButton extends StatefulWidget {
  const CenterPlayButton({
    Key? key,
    required this.backgroundColor,
    this.iconColor,
    required this.show,
    required this.isPlaying,
    required this.isFinished,
    this.onPressed,
    this.onTimeUp,
    this.timeUpInSecond,
    this.onTick,
  }) : super(key: key);

  final Color backgroundColor;
  final Color? iconColor;
  final bool show;
  final bool isPlaying;
  final bool isFinished;
  final VoidCallback? onPressed;
  final VoidCallback? onTimeUp;
  final int? timeUpInSecond;
  final VoidCallback? onTick;

  @override
  State<CenterPlayButton> createState() => _CenterPlayButtonState();
}

class _CenterPlayButtonState extends State<CenterPlayButton> {
  late CountdownTimerController? controller;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = CountdownTimerController(
      onEnd: onEndCallback,
      endTime:
          DateTime.now().millisecondsSinceEpoch + 1000 * widget.timeUpInSecond!,
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    controller?.dispose();
    super.dispose();
  }

  void onEndCallback() {
    if (!widget.isFinished) {
      widget.onTimeUp?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.isFinished
        ? Container()
        : Container(
            color: Colors.transparent,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                // Always set the iconSize on the IconButton, not on the Icon itself:
                // https://github.com/flutter/flutter/issues/52980
                child: widget.isPlaying
                    ? AnimatedOpacity(
                        opacity: widget.show ? 1.0 : 0.0,
                        duration: const Duration(milliseconds: 300),
                        child: IconButton(
                          iconSize: 32,
                          icon: Icon(Icons.pause, color: widget.iconColor),
                          onPressed: () {
                            if (widget.onPressed != null) {
                              widget.onPressed!();
                            }
                            if (controller != null) {
                              final endTime =
                                  DateTime.now().millisecondsSinceEpoch +
                                      1000 * widget.timeUpInSecond!;
                              controller?.endTime = endTime;
                              controller?.start();
                              setState(() {});
                            }
                          },
                        ),
                      )
                    : Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                              iconSize: 32,
                              icon: Icon(Icons.play_arrow,
                                  color: widget.iconColor),
                              onPressed: () {
                                final endTime =
                                    DateTime.now().millisecondsSinceEpoch +
                                        1000 * widget.timeUpInSecond! * 60 * 60;
                                controller?.endTime = endTime;

                                controller?.start();
                                if (widget.onPressed == null) {
                                  return;
                                }
                                widget.onPressed!();
                                setState(() {});
                              }),
                          Text("Time left before auto end",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w400,
                                  height: 19.12 / 14.0)),
                          if (widget.timeUpInSecond != null)
                            CountdownTimer(
                              controller: controller,
                              widgetBuilder:
                                  (context, CurrentRemainingTime? time) {
                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 16),
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                      getRemainingTimeFormat(time),
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.w400,
                                          height: 19.12 / 14.0),
                                    ),
                                  ),
                                );
                              },
                            ),
                          if (widget.timeUpInSecond == null)
                            IconButton(
                                iconSize: 32,
                                icon:
                                    Icon(Icons.pause, color: widget.iconColor),
                                onPressed: widget.onPressed),
                        ],
                      ),
              ),
            ),
          );
  }

  String getRemainingTimeFormat(CurrentRemainingTime? time) {
    // var hourInSecond = time?.hours ?? 0;
    var minuteInSecond = time?.min ?? 0;
    var second = time?.sec ?? 0;
    return "$minuteInSecond:$second";
  }
}
