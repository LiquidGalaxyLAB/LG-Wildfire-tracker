import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:wildfiretracker/screens/example1_screen.dart';
import 'package:wildfiretracker/screens/nasa_screen.dart';
import 'package:wildfiretracker/screens/splash_screen.dart';
import 'package:wildfiretracker/services/file_service.dart';
import 'package:wildfiretracker/services/lg_service.dart';
import 'package:wildfiretracker/services/lg_settings_service.dart';
import 'package:wildfiretracker/services/local_storage_service.dart';
import 'package:wildfiretracker/services/settings_service.dart';
import 'package:wildfiretracker/services/ssh_service.dart';
import 'package:wildfiretracker/utils/theme.dart';

/// Registers all services into the application.
void setupServices() {
  GetIt.I.registerLazySingleton(() => LocalStorageService());
  GetIt.I.registerLazySingleton(() => SettingsService());
  GetIt.I.registerLazySingleton(() => SSHService());
  GetIt.I.registerLazySingleton(() => LGService());
  GetIt.I.registerLazySingleton(() => FileService());
  GetIt.I.registerLazySingleton(() => LGSettingsService());
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupServices();

  await GetIt.I<LocalStorageService>().loadStorage();

  GetIt.I<SSHService>().init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  /// Sets the Liquid Galaxy logos into the rig.
  void setLogos() async {
    try {
      await GetIt.I<LGService>().setLogos();
    } catch (e) {
      print(e);
      if (kDebugMode) {
        print(e);
      }
    }
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    setLogos();
    return MaterialApp(
      title: 'Wildfire Tracker',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a blue toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        canvasColor: Colors.transparent,
        primarySwatch: MaterialColor(
          ThemeColors.backgroundColorHex,
          ThemeColors.backgroundColorMaterial,
        ),
        scaffoldBackgroundColor: ThemeColors.backgroundColor,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const SplashScreenPage(),
      initialRoute: '/',
      routes: {
        // '/': (context) => const HomePage(),
        '/splash': (context) => const SplashScreenPage(),
        '/nasa': (context) => const NasaApiPage(),
      },
    );
  }
}