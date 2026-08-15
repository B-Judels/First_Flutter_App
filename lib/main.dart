import 'package:flutter/material.dart';
import 'package:freeuse_monthly_expense_tracker/pages/home.dart';
import 'package:freeuse_monthly_expense_tracker/pages/StartUpPage.dart';
import 'package:freeuse_monthly_expense_tracker/database/database_helper.dart';
import 'package:freeuse_monthly_expense_tracker/custom_tools/uiTools.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Monthly Expense Tracker",
      home: NewMain(),
    );
  }
}

class NewMain extends StatelessWidget {
  NewMain({super.key});

  Future<void> _startNew(BuildContext context) async {
    final userSettings = await DatabaseHelper.instance.getUserSettings();

    if (!context.mounted) return;

    if (userSettings.isEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const StartUpPage()),
      );

      return;
    }

    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Start New?"),
          content: const Text(
            "Starting a new expense tracker will delete all "
            "previously stored data.\n\n"
            "Are you sure you want to continue?",
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text("Delete & Start New"),
            ),
          ],
        );
      },
    );

    if (shouldDelete != true) {
      return;
    }

    await DatabaseHelper.instance.deleteAllData();

    if (!context.mounted) return;

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const StartUpPage()),
    );
  }

  final uiTools = Uitools();

  Future<void> _continue(BuildContext context) async {
    final userSettings = await DatabaseHelper.instance.getUserSettings();

    if (!context.mounted) return;

    if (userSettings.isEmpty) {
      await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("No Saved Data"),
            content: const Text(
              "There is no previously stored expense tracker data. "
              "You cannot continue because there is no saved data to load.\n\n"
              "Please select \"Start New\" to create your expense tracker.",
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("OK"),
              ),
            ],
          );
        },
      );

      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const Home()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal[100],
      appBar: AppBar(
        backgroundColor: Colors.teal[700],
        title: Center(
          child: Text(
            "Monthly Expense Tracker",
            style: TextStyle(color: Colors.blueGrey[50]),
          ),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.teal[300],
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.black, width: 2),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Center(
                    child: uiTools.imgBtnTitleContainer3(
                      "Start New",
                      "images/startNew.png",
                      () async {
                        _startNew(context);
                      },
                    ),
                  ),
                  const SizedBox(height: 15),

                  Center(
                    child: uiTools.imgBtnTitleContainer3(
                      "Continue",
                      "images/continue.png",
                      () async {
                        _continue(context);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
