import 'package:flutter/material.dart';
import 'package:things/app/app.dart';
import 'package:things/app/bootstrap.dart';

void main() async {
  await bootstrap();
  runApp(const App());
}
