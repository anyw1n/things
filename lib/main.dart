import 'package:flutter/material.dart';
import 'package:things/app.dart';
import 'package:things/bootstrap.dart';

void main() async {
  await bootstrap();
  runApp(const App());
}
