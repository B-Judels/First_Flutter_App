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
      backgroundColor: Colors.teal[100],
      appBar: AppBar(
        title: Center(
          child: Text(
            "Monthly Expense Tracker",
            style: TextStyle(color: Colors.blueGrey[50]),
          ),
        ),
        backgroundColor: Colors.teal[700],
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
                    color: Colors.teal[300],
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Column(
                            children: [
                              const Text(
                                "Insurance",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
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
                            decoration: const InputDecoration(
                              labelText: "Name of Insurance",
                              hintText: "Enter the name for the Insurance",
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 10.0),
                          TextField(
                            controller: medicalAidCostController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: "Monthly Expense",
                              hintText:
                                  "Enter the expense for the insurance per month",
                              border: OutlineInputBorder(),
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
                                backgroundColor: Colors.teal[100],
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
                                Colors.teal[700],
                              ),
                              dataRowColor: WidgetStateProperty.all(
                                Colors.cyan,
                              ),

                              columns: const [
                                DataColumn(label: Text("Name:")),
                                DataColumn(label: Text("Cost:")),
                                DataColumn(label: Text("Actions:")),
                              ],
                              rows: medAids.asMap().entries.map((entry) {
                                int index = entry.key;
                                var servicer = entry.value;
                                return DataRow(
                                  cells: [
                                    DataCell(Text(servicer.getName)),
                                    DataCell(
                                      Text(
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
                            backgroundColor: Colors.lightBlue[200],
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
                          child: const Text("Update"),
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
