import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';
import 'package:travelapp/core/providers/app_providers.dart';
import 'package:travelapp/data/model/atripdetail_modal.dart';
import 'package:travelapp/data/model/blog_modal.dart';
import 'package:travelapp/data/model/trip_model.dart';
import 'package:travelapp/data/model/user_model.dart';
import 'package:travelapp/view/Intro/splash_screen.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(TripmodelAdapter());
  Hive.registerAdapter(UsermodelAdapter());
  Hive.registerAdapter(NearbyPlacemodalAdapter());
  Hive.registerAdapter(BlogModalAdapter());
  Hive.registerAdapter(ChecklistModalAdapter());
  Hive.registerAdapter(NotesModalAdapter());
  Hive.registerAdapter(PhotosModalAdapter());
  Hive.registerAdapter(ExpenceModalAdapter());
  runApp(
      MultiProvider(providers: AppProviders.providers, child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 58, 120, 235),
          ),
          useMaterial3: true,
        ),
        home: const SplashScreen());
  }
}
