import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_project/util/habit_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

int _selectedIndex = 0;

class _HomePageState extends State<HomePage> {
  //firebase state
  final User = FirebaseAuth.instance.currentUser!;
  //overall habit summary
  List habitList = [
    //[ habitName, habitStarted, timespent(sec), timegoal(min)]
    ['Exercise', false, 0, 10],
    ['Read', false, 0, 10],
    ['Mediate', false, 0, 10],
    ['Code', false, 0, 10],
  ];
  void habitStarted(int index) {
    //note what the start time is

    var startTime = DateTime.now();
    //habit started or stopped
    int elapsedTime = habitList[index][2];
    setState(() {
      habitList[index][1] = !habitList[index][1];
    });

    if (habitList[index][1]) {
      //keep the time going!
      Timer.periodic(Duration(seconds: 1), (timer) {
        //check when the user has stopped the timer
        setState(() {
          if (!habitList[index][1]) {
            timer.cancel();
          }
          //calculate the time elasped by comparing current time and sart time
          var currentTime = DateTime.now();
          habitList[index][2] = elapsedTime +
              currentTime.second -
              startTime.second +
              60 * (currentTime.minute - startTime.minute) +
              60 * 60 * (currentTime.hour - startTime.hour);
        });
      });
    }
  }

  void settingsOpened(int index) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Setting for ' + habitList[index][0]),
          );
        });
  }

  void _onTap(int index) {
    _selectedIndex = index;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        drawer: Drawer(
          backgroundColor: Colors.orange[400],
          child: ListView(
            children: [
              DrawerHeader(
                decoration: const BoxDecoration(color: Colors.orange),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('user'),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
              ListTile(
                title: const Text('Setting'),
                onTap: () {
                  // Update the state of the app
                  // ...
                  // Then close the drawer
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Faq'),
                onTap: () {
                  // Update the state of the app
                  // ...
                  // Then close the drawer
                  Navigator.pop(context);
                },
              ),
              Padding(
                padding: const EdgeInsets.all(25.0),
                child: MaterialButton(
                  onPressed: () {
                    FirebaseAuth.instance.signOut();
                  },
                  child: const Text('Sign out'),
                  color: Colors.blue,
                ),
              ),
            ],
          ),
        ),
        backgroundColor: Colors.orange[400],
        appBar: AppBar(
          backgroundColor: Colors.orange[900],
          title: Text("welcome to ${User.email!}"),
        ),
        body: ListView.builder(
          itemCount: habitList.length,
          itemBuilder: ((context, index) {
            return HabitTile(
              habitName: habitList[index][0],
              onTap: () {
                habitStarted(index);
              },
              settingsTapped: () {
                settingsOpened(index);
              },
              habitStarted: habitList[index][1],
              timeSpent: habitList[index][2],
              timeGoal: habitList[index][3],
            );
          }),
        ),
      ),
    );
  }
}
