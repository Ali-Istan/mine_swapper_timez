// import 'package:flutter/material.dart';
// import 'dart:math';
//
// import 'screen/mine_sweeper.dart';
//
// void main() => runApp(MyApp());
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Minesweeper',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: Minesweeper(),
//     );
//   }
// }

import 'package:flutter/material.dart';

import 'game_activity.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: GameActivity(),
    );
  }
}
