import 'package:flutter/material.dart';
import 'package:freeuse_monthly_expense_tracker/custom_tools/uiTools.dart';
import 'package:freeuse_monthly_expense_tracker/pages/debit_order_page.dart';
import 'package:freeuse_monthly_expense_tracker/pages/service_page.dart';
import 'package:freeuse_monthly_expense_tracker/pages/daily_habit_page.dart';
import 'package:freeuse_monthly_expense_tracker/pages/med_aid_page.dart';
import 'package:freeuse_monthly_expense_tracker/models/DebitOrder.dart';
import 'package:freeuse_monthly_expense_tracker/models/Service.dart';
import 'package:freeuse_monthly_expense_tracker/models/MedicalAid.dart';
import 'package:freeuse_monthly_expense_tracker/models/DailyHabit.dart';
import 'package:freeuse_monthly_expense_tracker/models/UserSettings.dart';
import 'package:freeuse_monthly_expense_tracker/database/database_helper.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final uiTools = Uitools();

  bool isLoading = true;

  List<UserSettings> userSettings = [];

  List<DebitOrder> debitOrders = [];

  List<Service> services = [];

  List<MedicalAid> medicalAids = [];

  List<DailyHabit> dailyHabits = [];

  int selectedYear = DateTime.now().year;
  int selectedMonth = DateTime.now().month;

  int daysInMonth = DateTime(
    DateTime.now().year,
    DateTime.now().month + 1,
    0,
  ).day;

  Future<void> _loadDatabaseData() async {
    try {
      final db = DatabaseHelper.instance;

      final loadedUserSettings = await db.getUserSettings();
      final loadedDebitOrders = await db.getDebitOrders();
      final loadedServices = await db.getServices();
      final loadedMedicalAids = await db.getMedicalAids();
      final loadedDailyHabits = await db.getDailyHabits();

      if (!mounted) return;

      setState(() {
        userSettings = loadedUserSettings;
        debitOrders = loadedDebitOrders;
        services = loadedServices;
        medicalAids = loadedMedicalAids;
        dailyHabits = loadedDailyHabits;
        isLoading = false;
      });
    } catch (e) {
      debugPrint("Database error: $e");

      if (!mounted) return;

      setState(() {
        isLoading = false;
      });
    }
  }

  double currentMonthTotal = 0;

  double debitTotal = 0;
  double serviceTotal = 0;
  double medTotal = 0;
  double habitTotal = 0;

  Future<void> selectMonthAndYear() async {
    int tempMonth = selectedMonth;
    int tempYear = selectedYear;

    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text("Select Month and Year"),
              content: Row(
                children: [
                  // Month
                  Expanded(
                    child: DropdownButton<int>(
                      value: tempMonth,
                      isExpanded: true,
                      items: List.generate(12, (index) {
                        final monthNumber = index + 1;

                        final monthName = DateTime(2000, monthNumber);

                        return DropdownMenuItem<int>(
                          value: monthNumber,
                          child: Text(_monthName(monthName.month)),
                        );
                      }),
                      onChanged: (value) {
                        if (value != null) {
                          setDialogState(() {
                            tempMonth = value;
                          });
                        }
                      },
                    ),
                  ),

                  const SizedBox(width: 15),

                  // Year
                  Expanded(
                    child: DropdownButton<int>(
                      value: tempYear,
                      isExpanded: true,
                      items: List.generate(11, (index) {
                        final year = DateTime.now().year - 5 + index;

                        return DropdownMenuItem<int>(
                          value: year,
                          child: Text(year.toString()),
                        );
                      }),
                      onChanged: (value) {
                        if (value != null) {
                          setDialogState(() {
                            tempYear = value;
                          });
                        }
                      },
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Cancel"),
                ),

                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      selectedMonth = tempMonth;
                      selectedYear = tempYear;

                      daysInMonth = DateTime(
                        selectedYear,
                        selectedMonth + 1,
                        0,
                      ).day;
                    });

                    Navigator.pop(context);
                  },
                  child: const Text("Select"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  String _monthName(int month) {
    const months = [
      "January",
      "February",
      "March",
      "April",
      "May",
      "June",
      "July",
      "August",
      "September",
      "October",
      "November",
      "December",
    ];

    return months[month - 1];
  }

  @override
  void initState() {
    super.initState();
    _loadDatabaseData();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    double currentMonthTotal = 0;
    double debitTotal = 0;
    double serviceTotal = 0;
    double medTotal = 0;
    double habitTotal = 0;

    for (int i = 0; i < services.length; i++) {
      currentMonthTotal = services[i].getCost + currentMonthTotal;
      serviceTotal = serviceTotal + services[i].getCost;
    }

    for (int i = 0; i < debitOrders.length; i++) {
      currentMonthTotal = debitOrders[i].getCost + currentMonthTotal;
      debitTotal = debitTotal + debitOrders[i].getCost;
    }

    for (int i = 0; i < medicalAids.length; i++) {
      currentMonthTotal = medicalAids[i].getMedAidCost + currentMonthTotal;
      medTotal = medTotal + medicalAids[i].getMedAidCost;
    }

    for (int i = 0; i < dailyHabits.length; i++) {
      currentMonthTotal =
          (dailyHabits[i].getCost * daysInMonth) + currentMonthTotal;
      habitTotal = (dailyHabits[i].getCost * daysInMonth) + habitTotal;
    }

    double totalSpent = debitTotal + serviceTotal + medTotal + habitTotal;

    double endMonthPredict = userSettings.isNotEmpty
        ? userSettings[0].getIncome - totalSpent
        : 0;

    return Scaffold(
      backgroundColor: Colors.teal[100],
      appBar: AppBar(
        title: Center(
          child: Text(
            style: TextStyle(color: Colors.blueGrey[50]),
            "Monthly Expense Tracker: ",
          ),
        ),
        backgroundColor: Colors.teal[700],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.all(10.0),
                width: double.maxFinite,

                padding: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  color: Colors.teal[300],
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Current Monthly Income:",
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 13,
                          ),
                        ),
                        Text(
                          "R ${userSettings.isNotEmpty ? userSettings[0].getIncome.toStringAsFixed(2) : "0.00"}",
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 13,
                          ),
                        ),

                        SizedBox(height: 3),

                        Text(
                          "Current Monthly Expenses:",
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 13,
                          ),
                        ),
                        Text(
                          "R ${currentMonthTotal.toStringAsFixed(2)}",
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 13,
                          ),
                        ),
                        SizedBox(height: 3),

                        Text(
                          "End of Month Prediction:",
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 13,
                          ),
                        ),
                        Text(
                          "R ${endMonthPredict.toStringAsFixed(2)}",
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),

                    const Spacer(),

                    Column(
                      children: [
                        SizedBox(
                          width: 130,
                          child: uiTools.imgBtnTitleContainer2(
                            "Select Month: ${_monthName(selectedMonth)} $selectedYear",
                            "images/calendar1.png",
                            selectMonthAndYear,
                          ),
                        ),

                        const SizedBox(height: 5),

                        Text(
                          "${_monthName(selectedMonth)}: $daysInMonth days.",
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10.0),

                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: Center(
                              child: uiTools.imgBtnTitleContainer(
                                "Monthly Debit Orders",
                                "images/automatic-payment.png",
                                () async {
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const DebitOrderPage(),
                                    ),
                                  );

                                  if (!mounted) return;

                                  await _loadDatabaseData();
                                },
                              ),
                            ),
                          ),

                          SizedBox(width: 10),

                          Expanded(
                            child: Center(
                              child: uiTools.imgBtnTitleContainer(
                                "Daily habit costs",
                                "images/24-hours-service.png",
                                () async {
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const DailyHabitPage(),
                                    ),
                                  );

                                  if (!mounted) return;

                                  await _loadDatabaseData();
                                },
                              ),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 10),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: Center(
                              child: uiTools.imgBtnTitleContainer(
                                "Medical Aid",
                                "images/healthcare.png",
                                () async {
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const MedAidPage(),
                                    ),
                                  );

                                  if (!mounted) return;

                                  await _loadDatabaseData();
                                },
                              ),
                            ),
                          ),

                          SizedBox(width: 10),

                          Expanded(
                            child: Center(
                              child: uiTools.imgBtnTitleContainer(
                                "Monthly Services",
                                "images/attendant.png",
                                () async {
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const ServicePage(),
                                    ),
                                  );

                                  if (!mounted) return;

                                  await _loadDatabaseData();
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              Container(
                margin: EdgeInsets.all(10.0),
                width: double.maxFinite,

                padding: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  color: Colors.teal[300],
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
