import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/index.dart';

class CenterPlayButton extends StatelessWidget {
  const CenterPlayButton({
    Key? key,
    required this.backgroundColor,
    this.iconColor,
    required this.show,
    required this.isPlaying,
    required this.isFinished,
    this.onPressed,
    this.onTimeUp,
    this.timeUpInMinute,
  }) : super(key: key);

  final Color backgroundColor;
  final Color? iconColor;
  final bool show;
  final bool isPlaying, isFinished;
  final VoidCallback? onPressed;
  final VoidCallback? onTimeUp;
  final int? timeUpInMinute;

  @override
  Widget build(BuildContext context) {
    return isFinished
        ? Container()
        : Container(
            color: Colors.transparent,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                // Always set the iconSize on the IconButton, not on the Icon itself:
                // https://github.com/flutter/flutter/issues/52980
                child: isPlaying
                    ? AnimatedOpacity(
                        opacity: show ? 1.0 : 0.0,
                        duration: const Duration(milliseconds: 300),
                        child: IconButton(
                          iconSize: 32,
                          icon: Icon(Icons.pause, color: iconColor),
                          onPressed: onPressed,
                        ),
                      )
                    : Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            iconSize: 32,
                            icon: Icon(Icons.play_arrow, color: iconColor),
                            onPressed: onPressed,
                          ),
                          Text("Time left before auto end",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w400,
                                  height: 19.12 / 14.0)),
                          if (timeUpInMinute != null)
                            CountdownTimer(
                              onEnd: () {
                                if (!isFinished) {
                                  onTimeUp?.call();
                                }
                              },
                              endTime: DateTime.now().millisecondsSinceEpoch +
                                  1000 * 60 * timeUpInMinute!,
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
                          if (timeUpInMinute == null)
                            IconButton(
                              iconSize: 32,
                              icon: Icon(Icons.pause, color: iconColor),
                              onPressed: onPressed,
                            ),
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
