import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tasker/widget/home.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:tasker/widget/settings.dart';

Future<void> main() async {
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tasker',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Scaffold(
      appBar: AppBar(
        title: const Text("Tasker"),
        centerTitle: true,
      ),
        body: HomePage(),
        drawer: const Drawer(
          child: Settings()
        ),
      ),
    );
  }
}
