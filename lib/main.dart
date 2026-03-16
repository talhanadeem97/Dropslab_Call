/// Main entry point for the Dropslab Call application.
///
/// Theme Integration (Sense Design System):
/// - `buildTheme(isLight: true)` provides the light Sense theme as the default
/// - `buildTheme(isLight: false)` provides the dark Sense theme for dark mode
/// - Both themes are defined in lib/theme/app_theme.dart and include:
///   * Material 3 color scheme with Sense's primary teal (#00A294)
///   * Component styles for buttons, input fields, app bars, chips, FABs
///   * CustomColors ThemeExtension for status/semantic colors
///   * Typography from Sense's text theme
///
/// All screens reference the theme via Theme.of(context) — no hardcoded colors.
/// Navigation logic, FluffyChat integration, AR features, and calling
/// functionality remain unchanged.
import 'package:dropslab_call/theme/app_theme.dart';
import 'package:dropslab_call/ui/app_bootstrap_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:matrix/matrix.dart';
import 'package:dropslab_call/ui/barcode_scanner.dart';
import 'package:dropslab_call/ui/login_screen.dart';
import 'package:dropslab_call/ui/scan_to_proced.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart' as sqlite;
import 'package:flutter_vodozemac/flutter_vodozemac.dart' as vod;

import 'voip/voip_service.dart';
import 'ui/call_screen.dart';

final GlobalKey<NavigatorState> appNavigatorKey = GlobalKey<NavigatorState>();
final RouteObserver<ModalRoute<void>> routeObserver = RouteObserver<ModalRoute<void>>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);

  await vod.init(wasmPath: './assets/assets/vodozemac/');

  final dir = await getApplicationSupportDirectory();
  final dbPath = '${dir.path}/matrix.sqlite';

  final client = Client(
    'Matrix VoIP Example',
    database: await MatrixSdkDatabase.init('matrix_voip_example', database: await sqlite.openDatabase(dbPath)),
    nativeImplementations: NativeImplementationsIsolate(compute, vodozemacInit: () => vod.init(wasmPath: './assets/assets/vodozemac/')),
    defaultNetworkRequestTimeout: const Duration(minutes: 30),
    enableDehydratedDevices: true,
    shareKeysWith: ShareKeysWith.all,
    convertLinebreaksInFormatting: false,
    onSoftLogout: (client) => client.refreshAccessToken(),
  );

  runApp(
    MultiProvider(
      providers: [
        Provider<Client>.value(value: client),
        ChangeNotifierProvider(create: (_) => VoipService(client)),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dropslab Call',
      navigatorKey: appNavigatorKey,
      initialRoute: AppBootstrapScreen.route,
      debugShowCheckedModeBanner: false,
      // Sense theme integration — light and dark themes from buildTheme()
      theme: buildTheme(isLight: true),
      darkTheme: buildTheme(isLight: false),
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case AppBootstrapScreen.route:
            return MaterialPageRoute(settings: settings, builder: (_) => const AppBootstrapScreen());

          case CallScreen.route:
            final room = settings.arguments;
            if (room is! Room) return null;
            return MaterialPageRoute(
              settings: settings,
              builder: (_) => CallScreen(room: room),
            );

          case LoginPage.route:
            return MaterialPageRoute(settings: settings, builder: (_) => const LoginPage());

          case ScanToProceedScreen.route:
            return MaterialPageRoute(settings: settings, builder: (_) => const ScanToProceedScreen());

          case BarcodeScanner.route:
            return MaterialPageRoute<String?>(
              settings: settings,
              builder: (_) => BarcodeScanner(formatType: settings.arguments as String),
            );

          default:
            return null;
        }
      },
      navigatorObservers: [routeObserver],
    );
  }
}
