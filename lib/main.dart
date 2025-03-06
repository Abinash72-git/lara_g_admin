import 'package:flutter/material.dart';
import 'package:lara_g_admin/app.dart';
import 'package:lara_g_admin/config/app_intialize.dart';

Future<void> main() async {
  await AppInitialize.start();
  runApp( MyApp());
}