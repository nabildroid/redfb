import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:redfb/repository/localsotre.dart';

import 'home.dart';
import 'models/post.dart';

import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';

void printHello() {
  final DateTime now = DateTime.now();
  final int isolateId = Isolate.current.hashCode;
  print("[$now] Hello, world! isolate=${isolateId} function='$printHello'");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final store = LocalStore();
  final post = await store.random();

  final int helloAlarmID = 0;
  await AndroidAlarmManager.initialize();
  runApp(App(post));
  await AndroidAlarmManager.periodic(
      const Duration(minutes: 1), helloAlarmID, printHello);
}

class App extends MaterialApp {
  App(Post? post)
      : super(
          title: "Redfb",
          home: Home(post),
          debugShowCheckedModeBanner: false,
        );
}
