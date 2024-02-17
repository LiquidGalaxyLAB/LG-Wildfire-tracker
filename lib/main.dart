import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutterapp/screens/flutter_req_screen.dart';
import 'package:get_it/get_it.dart';
import 'package:flutterapp/screens/lg_settings_sreen.dart';
import 'package:flutterapp/screens/nasa_screen.dart';
import 'package:flutterapp/screens/splash_screen.dart';
import 'package:flutterapp/services/file_service.dart';
import 'package:flutterapp/services/lg_service.dart';
import 'package:flutterapp/services/lg_settings_service.dart';
import 'package:flutterapp/services/local_storage_service.dart';
import 'package:flutterapp/services/nasa/nasa_service.dart';
import 'package:flutterapp/services/ssh_service.dart';
import 'package:flutterapp/utils/theme.dart';

/// Registers all services into the application.
void setupServices() {
  GetIt.I.registerLazySingleton(() => LocalStorageService());
  GetIt.I.registerLazySingleton(() => SSHService());
  GetIt.I.registerLazySingleton(() => LGService());
  GetIt.I.registerLazySingleton(() => FileService());
  GetIt.I.registerLazySingleton(() => LGSettingsService());
  GetIt.I.registerLazySingleton(() => NASAService());
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
      home: const FlutterReqPage(),
      initialRoute: '/',
      routes: {
        // '/': (context) => const HomePage(),
        '/splash': (context) => const SplashScreenPage(),
        '/nasa': (context) => const NasaApiPage(),
        '/settings': (context) => const SettingsPage(),
      },
    );
  }
}
