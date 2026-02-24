import 'package:flutter/material.dart';
import 'package:thoughts/app/app.dart';
import 'package:thoughts/app/bootstrap.dart';

/// Entry point that initializes app dependencies and starts the widget tree.
void main() async {
  await bootstrap();
  runApp(const App());
}
