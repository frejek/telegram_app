import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:fimber/fimber.dart';
import 'package:telegram_app/app.dart';
import 'package:timeago/timeago.dart' as timeago;


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  // Metodo della classe Fimber del suo package
  Fimber.plantTree(DebugTree());

  timeago.setLocaleMessages('it', timeago.ItMessages());
  timeago.setLocaleMessages('en', timeago.EnMessages());

  runApp(App());
}