import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class HabitTile extends StatelessWidget {
  final String habitName;
  final VoidCallback onTap;
  final VoidCallback settingsTapped;
  final int timeSpent;
  final int timeGoal;
  final bool habitStarted;

  const HabitTile(
      {Key? key,
      required this.habitName,
      required this.onTap,
      required this.timeSpent,
      required this.habitStarted,
      required this.settingsTapped,
      required this.timeGoal})
      : super(key: key);

  //convert seconds into min:sec -> 62 seconds = 1:02 minutes

  String formatToMinSec(int totalSeconds) {
    String secs = (totalSeconds % 60).toString();
    String mins = (totalSeconds / 60).toStringAsFixed(1);

    if (secs.length == 1) {
      secs = '0' + secs;
    }

    if (mins[1] == ',') {
      mins = mins.substring(0, 1);
    }

    return mins + ':' + secs;
  }

  //calculate the progress percentage
  double percentageCompleted() {
    return timeSpent / (timeGoal * 60);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 20.0,
        right: 20.0,
        top: 20,
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.orange[200],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: onTap,
                  child: SizedBox(
                    height: 60,
                    width: 60,
                    child: Stack(children: [
                      CircularPercentIndicator(
                        radius: 30,
                        percent: percentageCompleted() <  1
                            ? percentageCompleted()
                            : 1,
                        progressColor: percentageCompleted() > 0.5
                            ? (percentageCompleted() > 0.75
                                ? Colors.green
                                : Colors.brown)
                            : Colors.purple,
                      ),
                      Center(
                          child: Icon(
                              habitStarted ? Icons.pause : Icons.play_arrow)),
                    ]),
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      habitName,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Text(
                      formatToMinSec(timeSpent) +
                          '/' +
                          timeGoal.toString() +
                          ' = ' +
                          (percentageCompleted() * 100).toStringAsFixed(0) +
                          '%',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ], //habits
                ),
              ],
            ),
            GestureDetector(
              onTap: settingsTapped,
              child: Icon(Icons.settings),
            ),
          ],
        ),
      ),
    );
  }
}
