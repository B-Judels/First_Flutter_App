import 'package:fl_chart/fl_chart.dart';
import '../models/budget.dart';
import '../widgets/load_error.dart';
import 'package:flutter/material.dart';
import 'package:freeuse_monthly_expense_tracker/custom_tools/ui_tools.dart';
import 'package:freeuse_monthly_expense_tracker/custom_tools/budget_progress_bar.dart';
import 'package:freeuse_monthly_expense_tracker/pages/debit_order_page.dart';
import 'package:freeuse_monthly_expense_tracker/pages/service_page.dart';
import 'package:freeuse_monthly_expense_tracker/pages/daily_habit_page.dart';
import 'package:freeuse_monthly_expense_tracker/pages/med_aid_page.dart';
import 'package:freeuse_monthly_expense_tracker/models/debit_order.dart';
import 'package:freeuse_monthly_expense_tracker/models/service_model.dart';
import 'package:freeuse_monthly_expense_tracker/models/medical_aid.dart';
import 'package:freeuse_monthly_expense_tracker/models/daily_habit.dart';
import 'package:freeuse_monthly_expense_tracker/models/weekly_habit.dart';
import 'package:freeuse_monthly_expense_tracker/models/bi_weekly_habit.dart';
import 'package:freeuse_monthly_expense_tracker/models/user_settings.dart';
import 'package:freeuse_monthly_expense_tracker/database/database_helper.dart';
import 'package:freeuse_monthly_expense_tracker/pages/startup_page.dart';

class Home extends StatefulWidget {
  const Home({super.key, this.database});
  final DatabaseHelper? database;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool _showManageData = false;

  final GlobalKey _manageDataKey = GlobalKey();

  final uiTools = Uitools();

  bool isLoading = true;
  bool _loadFailed = false;
  bool _savingIncome = false;
  bool _resetting = false;
  DatabaseHelper get db => widget.database ?? DatabaseHelper.instance;

  List<UserSettings> userSettings = [];

  List<DebitOrder> debitOrders = [];

  List<Service> services = [];

  List<MedicalAid> medicalAids = [];

  List<DailyHabit> dailyHabits = [];

  List<WeeklyHabit> weeklyHabits = [];

  List<BiWeeklyHabit> biWeeklyHabits = [];

  int selectedYear = DateTime.now().year;
  int selectedMonth = DateTime.now().month;

  final TextEditingController incomeController = TextEditingController();

  int daysInMonth = DateTime(
    DateTime.now().year,
    DateTime.now().month + 1,
    0,
  ).day;

  Future<void> _loadDatabaseData() async {
    if (!mounted) return;
    setState(() {
      isLoading = true;
      _loadFailed = false;
    });
    try {
      final loadedUserSettings = await db.getUserSettings();
      if (loadedUserSettings.isEmpty) throw StateError('Missing settings');
      final loadedDebitOrders = await db.getDebitOrders();
      final loadedServices = await db.getServices();
      final loadedMedicalAids = await db.getMedicalAids();
      final loadedDailyHabits = await db.getDailyHabits();
      final loadedWeeklyHabits = await db.getWeeklyHabits();
      final loadedBiWeeklyHabits = await db.getBiWeeklyHabits();

      if (!mounted) return;

      setState(() {
        userSettings = loadedUserSettings;
        debitOrders = loadedDebitOrders;
        services = loadedServices;
        medicalAids = loadedMedicalAids;
        dailyHabits = loadedDailyHabits;
        weeklyHabits = loadedWeeklyHabits;
        biWeeklyHabits = loadedBiWeeklyHabits;
        isLoading = false;
      });
    } catch (e) {
      debugPrint("Database error: $e");

      if (!mounted) return;

      setState(() {
        isLoading = false;
        _loadFailed = true;
      });
    }
  }

  String get currency =>
      userSettings.isNotEmpty ? userSettings[0].getCurrency : "R";

  List<PieChartSectionData> pieChartSections(
    double debitTotal,
    double serviceTotal,
    double medTotal,
    double habitTotal,
    double weeklyHabitTotal,
    double biWeeklyHabitTotal,
  ) {
    if ([
      debitTotal,
      serviceTotal,
      medTotal,
      habitTotal,
      weeklyHabitTotal,
      biWeeklyHabitTotal,
    ].any((amount) => !amount.isFinite || amount < 0)) {
      return [
        PieChartSectionData(value: 1, title: 'Review\namounts', radius: 60),
      ];
    }
    final total =
        debitTotal +
        serviceTotal +
        medTotal +
        habitTotal +
        weeklyHabitTotal +
        biWeeklyHabitTotal;

    if (total == 0) {
      return [
        PieChartSectionData(
          value: 1,
          title: "No \nExpenses",
          titleStyle: uiTools.tableHeaderStyle(),
          radius: 60,
        ),
      ];
    }

    return [
      PieChartSectionData(
        value: debitTotal,
        color: uiTools.debitOrderColor1(),
        borderSide: BorderSide(
          color: uiTools.borderColor1(),
          width: 1,
          style: BorderStyle.solid,
        ),
        title: "${((debitTotal / total) * 100).toStringAsFixed(0)}%",
        titleStyle: uiTools.tableHeaderStyle(),

        radius: 60,
      ),
      PieChartSectionData(
        value: serviceTotal,
        color: uiTools.serviceColor1(),
        borderSide: BorderSide(
          color: uiTools.borderColor1(),
          width: 1,
          style: BorderStyle.solid,
        ),
        title: "${((serviceTotal / total) * 100).toStringAsFixed(0)}%",
        titleStyle: uiTools.tableHeaderStyle(),
        radius: 60,
      ),
      PieChartSectionData(
        value: medTotal,
        color: uiTools.medicalInsuranceColor1(),
        borderSide: BorderSide(
          color: uiTools.borderColor1(),
          width: 1,
          style: BorderStyle.solid,
        ),
        title: "${((medTotal / total) * 100).toStringAsFixed(0)}%",
        titleStyle: uiTools.tableHeaderStyle(),

        radius: 60,
      ),
      PieChartSectionData(
        value: habitTotal,
        color: uiTools.dailyHabitColor1(),
        borderSide: BorderSide(
          color: uiTools.borderColor1(),
          width: 1,
          style: BorderStyle.solid,
        ),
        title: "${((habitTotal / total) * 100).toStringAsFixed(0)}%",
        titleStyle: uiTools.tableHeaderStyle(),

        radius: 60,
      ),
      PieChartSectionData(
        value: weeklyHabitTotal,
        color: uiTools.dailyHabitColor2(),
        borderSide: BorderSide(
          color: uiTools.borderColor1(),
          width: 1,
          style: BorderStyle.solid,
        ),
        title: "${((weeklyHabitTotal / total) * 100).toStringAsFixed(0)}%",
        titleStyle: uiTools.tableHeaderStyle(),
        radius: 60,
      ),
      PieChartSectionData(
        value: biWeeklyHabitTotal,
        color: uiTools.dailyHabitColor3(),
        borderSide: BorderSide(
          color: uiTools.borderColor1(),
          width: 1,
          style: BorderStyle.solid,
        ),
        title: "${((biWeeklyHabitTotal / total) * 100).toStringAsFixed(0)}%",
        titleStyle: uiTools.tableHeaderStyle(),
        radius: 60,
      ),
    ];
  }

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

  Future<void> _startNew(BuildContext context) async {
    if (_savingIncome || _resetting) return;
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

    if (shouldDelete != true) return;

    if (_resetting || !context.mounted) return;
    setState(() => _resetting = true);
    try {
      await db.deleteAllData();
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Unable to reset. Please retry.')),
        );
      }
      return;
    } finally {
      if (mounted) setState(() => _resetting = false);
    }

    if (!context.mounted) return;

    Navigator.pushReplacement(
      context,
      uiTools.smoothPageRoute(StartUpPage(database: widget.database)),
    );
  }

  @override
  void dispose() {
    incomeController.dispose();
    super.dispose();
  }

  Future<void> _updateIncome() async {
    if (_savingIncome || _resetting) return;
    final error = amountError(incomeController.text, income: true);
    if (error != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error)));
      return;
    }
    final settings = UserSettings(
      userIncome: double.parse(incomeController.text.trim()),
      currency: currency,
    );
    setState(() => _savingIncome = true);
    try {
      final confirm = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Update income?'),
          content: Text(
            'Update monthly income to $currency ${settings.userIncome.toStringAsFixed(2)}?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Update'),
            ),
          ],
        ),
      );
      if (confirm != true || !mounted) return;
      await db.replaceUserSettings([settings]);
      if (!mounted) return;
      setState(() => userSettings = [settings]);
      incomeController.clear();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Income updated!')));
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Unable to save income. Please retry.')),
        );
      }
    } finally {
      if (mounted) setState(() => _savingIncome = false);
    }
  }

  @override
  void initState() {
    super.initState();
    _loadDatabaseData();
  }

  @override
  Widget build(BuildContext context) {
    if (_loadFailed) return LoadError(onRetry: _loadDatabaseData);
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final debitTotal = monthlyProjection(
      debitOrders.map((e) => e.getCost),
      ExpenseCategory.debitOrders,
      daysInMonth,
    );
    final serviceTotal = monthlyProjection(
      services.map((e) => e.getCost),
      ExpenseCategory.services,
      daysInMonth,
    );
    final medTotal = monthlyProjection(
      medicalAids.map((e) => e.getMedAidCost),
      ExpenseCategory.insurance,
      daysInMonth,
    );
    final habitTotal = monthlyProjection(
      dailyHabits.map((e) => e.getCost),
      ExpenseCategory.daily,
      daysInMonth,
    );
    final weeklyHabitTotal = monthlyProjection(
      weeklyHabits.map((e) => e.getCost),
      ExpenseCategory.weekly,
      daysInMonth,
    );
    final biWeeklyHabitTotal = monthlyProjection(
      biWeeklyHabits.map((e) => e.getCost),
      ExpenseCategory.biweekly,
      daysInMonth,
    );
    double totalSpent =
        debitTotal +
        serviceTotal +
        medTotal +
        habitTotal +
        weeklyHabitTotal +
        biWeeklyHabitTotal;

    double endMonthPredict = userSettings.isNotEmpty
        ? userSettings[0].getIncome - totalSpent
        : 0;

    return Scaffold(
      backgroundColor: uiTools.pageBackgroundColor1(),
      appBar: AppBar(
        iconTheme: IconThemeData(color: uiTools.appBarIconColor()),
        title: Center(
          child: Text(
            style: uiTools.appBarTitleStyle(),
            "Monthly Budget Planner",
          ),
        ),
        backgroundColor: uiTools.appBarColor1(),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(2.0),
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.all(8.0),
                  width: double.maxFinite,

                  padding: const EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    color: uiTools.cardColor1(),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: uiTools.borderColor1(), width: 2),
                  ),
                  child: Column(
                    children: [
                      Center(
                        child: Text(
                          style: uiTools.sectionTitleStyle(),
                          "Total Monthly Expenses:",
                        ),
                      ),

                      SizedBox(height: 5),

                      Wrap(
                        alignment: WrapAlignment.spaceBetween,
                        spacing: 16,
                        runSpacing: 12,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 10),

                              Text(
                                "Current Monthly Income:",
                                style: uiTools.summaryTextStyle(),
                              ),
                              Text(
                                "$currency ${userSettings.isNotEmpty ? userSettings[0].getIncome.toStringAsFixed(2) : "0.00"}",
                                style: uiTools.summaryTextStyle(),
                              ),

                              SizedBox(height: 5),

                              Text(
                                "Current Monthly Expenses:",
                                style: uiTools.summaryTextStyle(),
                              ),
                              Text(
                                "$currency ${totalSpent.toStringAsFixed(2)}",
                                style: uiTools.summaryTextStyle(),
                              ),
                              SizedBox(height: 5),

                              Text(
                                "End of Month Prediction:",
                                style: uiTools.summaryTextStyle(),
                              ),
                              Text(
                                "$currency ${endMonthPredict.toStringAsFixed(2)}",
                                style: uiTools.summaryTextStyle(),
                              ),
                            ],
                          ),

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
                                style: uiTools.bodyTextStyle(),
                              ),
                            ],
                          ),
                        ],
                      ),

                      Center(
                        child: Text(
                          "Spend & Save ratio:",
                          style: uiTools.summaryTextStyle(),
                        ),
                      ),

                      BudgetProgressBar(
                        currency: currency,
                        income: userSettings[0].getIncome,
                        expenses: totalSpent,
                      ),

                      SizedBox(height: 5),

                      Container(
                        width: double.infinity,
                        height: 2,
                        decoration: BoxDecoration(
                          color: uiTools.mutedTextColor(),
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),

                      SizedBox(height: 10),

                      Center(
                        child: Text(
                          style: uiTools.sectionTitleStyle(),
                          "Monthly Expenses Per Category:",
                        ),
                      ),

                      SizedBox(height: 10),

                      SizedBox(
                        height: 270,
                        child: Row(
                          children: [
                            Expanded(
                              flex: 4,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Container(
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        color: uiTools.dailyHabitColor1(),
                                        borderRadius: BorderRadius.circular(5),
                                        border: Border.all(
                                          color: uiTools.borderColor1(),
                                          width: 1,
                                        ),
                                      ),
                                      child: Center(
                                        child: Text(
                                          style: uiTools.tableHeaderStyle(),
                                          "Daily Habits Total:\n$currency${habitTotal.toStringAsFixed(2)}",
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                  ),

                                  SizedBox(height: 5),

                                  Expanded(
                                    child: Container(
                                      width: double.infinity,
                                      margin: const EdgeInsets.only(bottom: 4),
                                      decoration: BoxDecoration(
                                        color: uiTools.dailyHabitColor2(),
                                        borderRadius: BorderRadius.circular(5),
                                        border: Border.all(
                                          color: uiTools.borderColor1(),
                                          width: 1,
                                        ),
                                      ),
                                      child: Center(
                                        child: Text(
                                          style: uiTools.tableHeaderStyle(),
                                          "Weekly Habits Total:\n$currency${weeklyHabitTotal.toStringAsFixed(2)}",
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                  ),

                                  Expanded(
                                    child: Container(
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        color: uiTools.dailyHabitColor3(),
                                        borderRadius: BorderRadius.circular(5),
                                        border: Border.all(
                                          color: uiTools.borderColor1(),
                                          width: 1,
                                        ),
                                      ),
                                      child: Center(
                                        child: Text(
                                          style: uiTools.tableHeaderStyle(),
                                          "Bi-Weekly Habits\n Total: $currency${biWeeklyHabitTotal.toStringAsFixed(2)}",
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                  ),

                                  SizedBox(height: 5),

                                  Expanded(
                                    child: Container(
                                      width: double.infinity,

                                      margin: const EdgeInsets.only(bottom: 4),
                                      decoration: BoxDecoration(
                                        color: uiTools.debitOrderColor1(),
                                        borderRadius: BorderRadius.circular(5),
                                        border: Border.all(
                                          color: uiTools.borderColor1(),
                                          width: 1,
                                        ),
                                      ),
                                      child: Center(
                                        child: Text(
                                          style: uiTools.tableHeaderStyle(),
                                          "Debit Total:\n$currency${debitTotal.toStringAsFixed(2)}",
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                  ),

                                  Expanded(
                                    child: Container(
                                      width: double.infinity,
                                      margin: const EdgeInsets.only(bottom: 4),
                                      decoration: BoxDecoration(
                                        color: uiTools.serviceColor1(),
                                        borderRadius: BorderRadius.circular(5),
                                        border: Border.all(
                                          color: uiTools.borderColor1(),
                                          width: 1,
                                        ),
                                      ),
                                      child: Center(
                                        child: Text(
                                          style: uiTools.tableHeaderStyle(),
                                          "Service Total:\n$currency${serviceTotal.toStringAsFixed(2)}",
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                  ),

                                  Expanded(
                                    child: Container(
                                      width: double.infinity,
                                      margin: const EdgeInsets.only(bottom: 4),
                                      decoration: BoxDecoration(
                                        color: uiTools.medicalInsuranceColor1(),
                                        borderRadius: BorderRadius.circular(5),
                                        border: Border.all(
                                          color: uiTools.borderColor1(),
                                          width: 1,
                                        ),
                                      ),
                                      child: Center(
                                        child: Text(
                                          style: uiTools.tableHeaderStyle(),
                                          "Insurance Total:\n$currency${medTotal.toStringAsFixed(2)}",
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(width: 8),

                            Container(
                              width: 2,
                              height: 200,
                              decoration: BoxDecoration(
                                color: uiTools.mutedTextColor(),
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),

                            const SizedBox(width: 8),

                            Expanded(
                              flex: 5,
                              child: Center(
                                child: SizedBox(
                                  width: 160,
                                  height: 160,
                                  child: PieChart(
                                    PieChartData(
                                      sectionsSpace: 1,
                                      sections: pieChartSections(
                                        debitTotal,
                                        serviceTotal,
                                        medTotal,
                                        habitTotal,
                                        weeklyHabitTotal,
                                        biWeeklyHabitTotal,
                                      ),
                                      centerSpaceRadius: 20,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                Container(
                  margin: const EdgeInsets.all(2.0),
                  width: double.maxFinite,
                  padding: const EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    color: uiTools.sectionHeaderColor1(),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Row(
                    children: [
                      Text("Manage Data:", style: uiTools.sectionTitleStyle()),

                      const Spacer(),
                      uiTools.burgerMenuBtn(() {
                        setState(() {
                          _showManageData = !_showManageData;
                        });

                        if (_showManageData) {
                          Future.delayed(const Duration(milliseconds: 450), () {
                            if (!context.mounted) return;
                            if (!mounted) return;

                            final targetContext = _manageDataKey.currentContext;

                            if (targetContext != null) {
                              Scrollable.ensureVisible(
                                targetContext,
                                duration: const Duration(milliseconds: 500),
                                curve: Curves.easeInOut,
                                alignment: 1.0,
                              );
                            }
                          });
                        }
                      }, _showManageData),
                    ],
                  ),
                ),

                AnimatedSize(
                  duration: const Duration(milliseconds: 350),
                  curve: Curves.easeInOut,
                  child: _showManageData
                      ? Container(
                          key: _manageDataKey,
                          child: Column(
                            children: [
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(10.0),

                                child: Center(
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,

                                    children: [
                                      SizedBox(height: 5),

                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Expanded(
                                            child: Center(
                                              child: uiTools.imgBtnTitleContainer(
                                                "Debit Orders",
                                                "images/automatic-payment.png",
                                                () async {
                                                  await Navigator.push(
                                                    context,
                                                    uiTools.smoothPageRoute(
                                                      DebitOrderPage(
                                                        database:
                                                            widget.database,
                                                      ),
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
                                              child: uiTools
                                                  .imgBtnTitleContainer(
                                                    "Services",
                                                    "images/attendant.png",
                                                    () async {
                                                      await Navigator.push(
                                                        context,
                                                        uiTools.smoothPageRoute(
                                                          ServicePage(
                                                            database:
                                                                widget.database,
                                                          ),
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Expanded(
                                            child: Center(
                                              child: uiTools
                                                  .imgBtnTitleContainer(
                                                    "Insurances",
                                                    "images/healthcare.png",
                                                    () async {
                                                      await Navigator.push(
                                                        context,
                                                        uiTools.smoothPageRoute(
                                                          MedAidPage(
                                                            database:
                                                                widget.database,
                                                          ),
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
                                                "Habits",
                                                "images/24-hours-service.png",
                                                () async {
                                                  await Navigator.push(
                                                    context,
                                                    uiTools.smoothPageRoute(
                                                      DailyHabitPage(
                                                        database:
                                                            widget.database,
                                                        month: DateTime(
                                                          selectedYear,
                                                          selectedMonth,
                                                        ),
                                                      ),
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
                                margin: EdgeInsets.all(10),
                                width: double.infinity,
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: uiTools.cardColor1(),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: uiTools.borderColor1(),
                                    width: 2,
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    TextField(
                                      controller: incomeController,
                                      keyboardType: TextInputType.number,
                                      decoration: uiTools.inputDecoration(
                                        labelText: "Monthly Income",
                                        hintText: "Update your monthly income",
                                      ),
                                    ),

                                    SizedBox(height: 10),

                                    SizedBox(
                                      width: double.infinity,

                                      child: OutlinedButton(
                                        style: OutlinedButton.styleFrom(
                                          backgroundColor: uiTools
                                              .pageBackgroundColor1(),
                                        ),
                                        onPressed: _savingIncome
                                            ? null
                                            : _updateIncome,
                                        child: Text("Update"),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              SizedBox(height: 15),

                              Container(
                                margin: EdgeInsets.all(10),
                                child: SizedBox(
                                  width: double.infinity,

                                  child: OutlinedButton(
                                    style: OutlinedButton.styleFrom(
                                      backgroundColor: uiTools.appBarColor(),
                                    ),
                                    onPressed: () async {
                                      await _startNew(context);
                                    },
                                    child: const Text(
                                      "Reset & Start New",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),

                              SizedBox(height: 15),
                            ],
                          ),
                        )
                      : const SizedBox.shrink(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
