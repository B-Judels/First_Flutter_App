import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'database/database_helper.dart';
import 'pages/loading_page.dart';
import 'pages/home.dart';
import 'pages/startup_page.dart';
import 'widgets/load_error.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  LicenseRegistry.addLicense(() async* {
    yield LicenseEntryWithLineBreaks([
      'Oswald',
    ], await rootBundle.loadString('fonts/OFL.txt'));
  });
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, this.database});
  final DatabaseHelper? database;
  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Monthly Budget Planner',
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF2F6F6D)),
      scaffoldBackgroundColor: const Color(0xFFF4F7F9),
    ),
    home: StartupRouter(database: database),
  );
}

class StartupRouter extends StatefulWidget {
  const StartupRouter({super.key, this.database});
  final DatabaseHelper? database;
  @override
  State<StartupRouter> createState() => _StartupRouterState();
}

class _StartupRouterState extends State<StartupRouter> {
  late Future<bool> _hasBudget;
  bool get _supported =>
      !kIsWeb &&
      {
        TargetPlatform.android,
        TargetPlatform.iOS,
        TargetPlatform.macOS,
      }.contains(defaultTargetPlatform);
  @override
  void initState() {
    super.initState();
    _hasBudget = _supported ? _check() : Future.value(false);
  }

  Future<bool> _check() async =>
      (await (widget.database ?? DatabaseHelper.instance).getUserSettings())
          .isNotEmpty;

  @override
  Widget build(BuildContext context) {
    if (!_supported) {
      return const Scaffold(
        body: Center(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Text(
              'Monthly Budget Planner currently supports Android, iOS, and macOS. '
              'Please use one of these platforms to store your budget.',
            ),
          ),
        ),
      );
    }
    return FutureBuilder<bool>(
      future: _hasBudget,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const LoadingPage();
        }
        if (snapshot.hasError) {
          return LoadError(
            onRetry: () => setState(() {
              _hasBudget = _check();
            }),
          );
        }
        return snapshot.data == true
            ? Home(database: widget.database)
            : StartUpPage(database: widget.database);
      },
    );
  }
}
