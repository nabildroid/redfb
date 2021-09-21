import 'package:flutter/material.dart';
import 'package:redfb/repository/localsotre.dart';

import 'home.dart';

void main() async {
  runApp(App());
}

class App extends MaterialApp {
  App()
      : super(
          title: "Redfb",
          home: Home(),
          debugShowCheckedModeBanner: false,
        );
}
