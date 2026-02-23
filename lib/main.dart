import 'package:flutter/material.dart';
import 'package:thoughts/app/app.dart';
import 'package:thoughts/app/bootstrap.dart';

void main() async {
  await bootstrap();
  runApp(const App());
}
