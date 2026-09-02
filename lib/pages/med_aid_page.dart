import 'package:flutter/material.dart';
import 'package:freeuse_monthly_expense_tracker/models/MedicalAid.dart';
import 'package:freeuse_monthly_expense_tracker/custom_tools/logicTools.dart';
import 'package:freeuse_monthly_expense_tracker/custom_tools/uiTools.dart';
import 'package:freeuse_monthly_expense_tracker/database/database_helper.dart';

class MedAidPage extends StatefulWidget {
  const MedAidPage({super.key});

  @override
  State<MedAidPage> createState() => _MedAidPage();
}

class _MedAidPage extends State<MedAidPage> {
  List<MedicalAid> medAids = [];

  final uiTools = Uitools();

  int editingIndex = -1;

  bool isLoading = true;

  bool showInfo = false;

  Future<void> _loadDatabaseData() async {
    try {
      final db = DatabaseHelper.instance;
      final loadedMedAids = await db.getMedicalAids();

      if (!mounted) return;

      setState(() {
        medAids = loadedMedAids;
      });
    } catch (e) {
      debugPrint("Database error: $e");

      if (!mounted) return;

      setState(() {
        isLoading = false;
      });
    }
  }

  final TextEditingController medicalAidController = TextEditingController();
  final TextEditingController medicalAidCostController =
      TextEditingController();

  @override
  void dispose() {
    medicalAidController.dispose();
    medicalAidCostController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _loadDatabaseData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: uiTools.pageBackgroundColor1(),
      appBar: AppBar(
        title: Center(
          child: Text(
            "Monthly Budget Planner",
            style: TextStyle(color: uiTools.titleColor1()),
          ),
        ),
        backgroundColor: uiTools.appBarColor1(),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(2.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.all(10),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: uiTools.sectionHeaderColor1(),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Column(
                            children: [
                              Text(
                                "Insurance",
                                style: uiTools.sectionTitleStyle(),
                              ),
                            ],
                          ),
                          Spacer(),

                          uiTools.infoButton(
                            showInfo: showInfo,
                            onPressed: () {
                              setState(() {
                                showInfo = !showInfo;
                              });
                            },
                          ),
                        ],
                      ),

                      uiTools.infoContainer(
                        showInfo: showInfo,
                        infoText:
                            "Any Insurance, for example\n"
                            "Health Insurance/Medical Aid, Car Insurance,\n "
                            "Home Insurance, etc.",
                      ),

                      const SizedBox(height: 10.0),

                      Column(
                        children: [
                          TextField(
                            controller: medicalAidController,
                            keyboardType: TextInputType.text,
                            decoration: uiTools.inputDecoration(
                              labelText: "Name of Insurance",
                              hintText: "Enter the name for the Insurance",
                            ),
                          ),
                          const SizedBox(height: 10.0),
                          TextField(
                            controller: medicalAidCostController,
                            keyboardType: TextInputType.number,
                            decoration: uiTools.inputDecoration(
                              labelText: "Monthly Expense",
                              hintText:
                                  "Enter the expense for the insurance per month",
                            ),
                          ),
                          const SizedBox(height: 10.0),
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton(
                              onPressed: () {
                                if (medicalAidController.text.isEmpty ||
                                    medicalAidCostController.text.isEmpty) {
                                  return;
                                }

                                String medAidName = medicalAidController.text;

                                double medAidCost =
                                    double.tryParse(
                                      medicalAidCostController.text,
                                    ) ??
                                    0;

                                MedicalAid medAid = MedicalAid(
                                  name: medAidName,
                                  costMedAid: medAidCost,
                                );

                                setState(() {
                                  medAids.add(medAid);

                                  editingIndex = -1;

                                  medicalAidController.clear();
                                  medicalAidCostController.clear();
                                });
                              },
                              style: OutlinedButton.styleFrom(
                                backgroundColor: uiTools.pageBackgroundColor1(),
                                padding: const EdgeInsets.all(12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              child: Text(
                                editingIndex == -1
                                    ? "Add Insurance"
                                    : "Update Insurance",
                              ),
                            ),
                          ),
                        ],
                      ),

                      if (medAids.isNotEmpty) ...[
                        const SizedBox(height: 15),
                        Center(
                          child: SizedBox(
                            width: double.infinity,
                            child: DataTable(
                              headingRowColor: WidgetStateProperty.all(
                                uiTools.appBarColor1(),
                              ),
                              dataRowColor: WidgetStateProperty.all(
                                uiTools.tableRowColor1(),
                              ),

                              columns: [
                                DataColumn(
                                  label: Text(
                                    style: uiTools.tableHeaderStyle(),
                                    "Name:",
                                  ),
                                  headingRowAlignment: MainAxisAlignment.start,
                                ),

                                DataColumn(
                                  label: Text(
                                    style: uiTools.tableHeaderStyle(),
                                    "Cost:",
                                  ),
                                  headingRowAlignment: MainAxisAlignment.start,
                                ),

                                DataColumn(
                                  columnWidth: FixedColumnWidth(125),
                                  label: Text(
                                    style: uiTools.tableHeaderStyle(),
                                    "Actions:",
                                  ),
                                  headingRowAlignment: MainAxisAlignment.start,
                                ),
                              ],
                              rows: medAids.asMap().entries.map((entry) {
                                int index = entry.key;
                                var servicer = entry.value;
                                return DataRow(
                                  cells: [
                                    DataCell(
                                      Text(
                                        style: uiTools.tableTextStyle(),
                                        servicer.getName,
                                      ),
                                    ),
                                    DataCell(
                                      Text(
                                        style: uiTools.tableTextStyle(),
                                        "R ${servicer.getMedAidCost.toStringAsFixed(2)}",
                                      ),
                                    ),
                                    DataCell(
                                      Center(
                                        child: Row(
                                          children: [
                                            uiTools.itemRemoveBtn(() {
                                              setState(() {
                                                medAids = const LogicTools()
                                                    .medAidItemRemover(
                                                      medAids,
                                                      index,
                                                    );

                                                if (editingIndex == index) {
                                                  editingIndex = -1;
                                                  medicalAidController.clear();
                                                  medicalAidCostController
                                                      .clear();
                                                }
                                              });
                                            }),

                                            SizedBox(width: 4),

                                            uiTools.itemEditBtn(() {
                                              setState(() {
                                                medicalAidController.text =
                                                    servicer.getName;
                                                medicalAidCostController.text =
                                                    servicer.getMedAidCost
                                                        .toString();
                                                editingIndex = index;

                                                medAids.removeAt(index);
                                              });
                                            }),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

                SizedBox(height: 20),

                if (editingIndex == -1) ...[
                  SizedBox(height: 20),

                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            backgroundColor: uiTools.appBarColor(),
                          ),
                          onPressed: () async {
                            try {
                              await DatabaseHelper.instance.replaceMedicalAids(
                                medAids,
                              );

                              if (!mounted) return;

                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Insurance updated!"),
                                ),
                              );
                            } catch (e) {
                              debugPrint("Error updating Insurance: $e");

                              if (!mounted) return;

                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Failed to update Insurance."),
                                ),
                              );
                            }

                            Navigator.pop(context);
                          },
                          child: const Text(
                            "Update",
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
