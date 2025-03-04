import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:location_tracker/core/bloc_observer.dart';
import 'package:location_tracker/core/theme.dart';
import 'package:location_tracker/feature/location_tracker/view/location_tracker_page.dart';
import 'package:location_tracker/services/local_storage/hive_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await HiveManager.init();
  Bloc.observer = CustomBlocObserver();
  // Workmanager().initialize(
  //   callbackDispatcher,
  //   isInDebugMode: true,
  // );
  // Workmanager().registerPeriodicTask(
  //   "1",
  //   "locationBackgroundTask",
  //   frequency:
  //       const Duration(minutes: 5),
  // );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Location Tracker',
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      home: const LocationTrackerPage(),
    );
  }
}
