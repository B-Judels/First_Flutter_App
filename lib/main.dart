import 'package:flutter/material.dart';
import 'package:freeuse_monthly_expense_tracker/pages/loading_page.dart';
import 'package:freeuse_monthly_expense_tracker/pages/home.dart';
import 'package:freeuse_monthly_expense_tracker/pages/StartUpPage.dart';
import 'package:freeuse_monthly_expense_tracker/database/database_helper.dart';
import 'package:google_fonts/google_fonts.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await GoogleFonts.pendingFonts([GoogleFonts.oswald()]);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Monthly Budget Planner",
      home: const StartupRouter(),
    );
  }
}

class StartupRouter extends StatelessWidget {
  const StartupRouter({super.key});

  Future<Widget> _checkDatabase() async {
    final userSettings = await DatabaseHelper.instance.getUserSettings();

    await Future.delayed(const Duration(seconds: 3));

    if (userSettings.isEmpty) {
      return const StartUpPage();
    }

    return const Home();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Widget>(
      future: _checkDatabase(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoadingPage();
        }

        if (snapshot.hasError) {
          return const Scaffold(
            body: Center(child: Text("Unable to load saved data.")),
          );
        }

        return snapshot.data ?? const StartUpPage();
      },
    );
  }
}
