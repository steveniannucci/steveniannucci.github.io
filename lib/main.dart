// main.dart

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'my_app.dart';

void main() {
  runApp(
    ProviderScope(
      child: MyApp(),
    ),
  );
}