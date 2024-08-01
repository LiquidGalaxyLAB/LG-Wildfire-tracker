import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:wildfiretracker/screens/gencat_screen.dart';
import 'package:wildfiretracker/screens/info_screen.dart';
import 'package:wildfiretracker/screens/lg_settings_sreen.dart';
import 'package:wildfiretracker/screens/nasa_screen.dart';
import 'package:wildfiretracker/screens/preciesly_usa_forest_fire_risk.dart';
import 'package:wildfiretracker/screens/splash_screen.dart';
import 'package:wildfiretracker/services/file_service.dart';
import 'package:wildfiretracker/services/gencat/gencat_service.dart';
import 'package:wildfiretracker/services/lg_service.dart';
import 'package:wildfiretracker/services/lg_settings_service.dart';
import 'package:wildfiretracker/services/local_storage_service.dart';
import 'package:wildfiretracker/services/nasa/nasa_service.dart';
import 'package:wildfiretracker/services/precisely/precisely_service.dart';
import 'package:wildfiretracker/services/ssh_service.dart';
import 'package:wildfiretracker/utils/theme.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';


/// Registers all services into the application.
void setupServices() {
  GetIt.I.registerLazySingleton(() => LocalStorageService());
  GetIt.I.registerLazySingleton(() => SSHService());
  GetIt.I.registerLazySingleton(() => LGService());
  GetIt.I.registerLazySingleton(() => FileService());
  GetIt.I.registerLazySingleton(() => LGSettingsService());
  GetIt.I.registerLazySingleton(() => NASAService());
  GetIt.I.registerLazySingleton(() => GencatService());
  GetIt.I.registerLazySingleton(() => PreciselyService());
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupServices();

  await GetIt.I<LocalStorageService>().loadStorage();

  await dotenv.load();

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
      builder: (context, child) => ResponsiveBreakpoints.builder(
        child: child!,
        breakpoints: [
          const Breakpoint(start: 0, end: 450, name: MOBILE),
          const Breakpoint(start: 451, end: 800, name: TABLET),
          const Breakpoint(start: 801, end: 1920, name: DESKTOP),
          const Breakpoint(start: 1921, end: double.infinity, name: '4K'),
        ],
      ),
      theme: ThemeData(
        primaryTextTheme: GoogleFonts.racingSansOneTextTheme(),
        textTheme: GoogleFonts.racingSansOneTextTheme(),
        canvasColor: Colors.transparent,
        primarySwatch: MaterialColor(
          ThemeColors.backgroundColorHex,
          ThemeColors.backgroundColorMaterial,
        ),
        scaffoldBackgroundColor: ThemeColors.backgroundColor,
        colorScheme: ColorScheme.fromSeed(seedColor: ThemeColors.defaultPaltetteColor),
        useMaterial3: true,
      ),
      home: const SplashScreenPage(),
      initialRoute: '/',
      routes: {
        // '/': (context) => const HomePage(),
        '/splash': (context) => const SplashScreenPage(),
        '/nasa': (context) => NasaApiPage(),
        '/settings': (context) => const SettingsPage(),
        '/gencat': (context) => const GencatPage(),
        '/precisely-usa-forest-fire-risk': (context) => const PreciselyUsaForestFireRisk(),
        '/info': (context) => InfoScreen(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
