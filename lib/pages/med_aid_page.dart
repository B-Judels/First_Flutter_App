import 'package:flutter/material.dart';
import 'package:first_flutter_app/models/MedicalAid.dart';
import 'package:first_flutter_app/custom_tools/logicTools.dart';
import 'package:first_flutter_app/custom_tools/uiTools.dart';

class MedAidPage extends StatefulWidget {
  const MedAidPage({super.key});

  @override
  State<MedAidPage> createState() => _MedAidPage();
}

class _MedAidPage extends State<MedAidPage> {
  List<MedicalAid> medAids = [MedicalAid(name: "Discovery", costMedAid: 2500)];

  final uiTools = Uitools();

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
  Widget build(BuildContext context) {
    // 1. Calculate running medical aid totals dynamically
    double totalMedAidCost = 0;
    for (int i = 0; i < medAids.length; i++) {
      totalMedAidCost += medAids[i]
          .getMedAidCost; // Assumes getMedAidCost getter matches model
    }

    return Scaffold(
      backgroundColor: Colors.teal[100],
      appBar: AppBar(
        title: Center(
          child: Text(
            "Monthly Expense Tracker:",
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
                      const Text(
                        "Monthly Medical Aid",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      // Dynamic total display
                      Text(
                        "Total Medical Aid: R ${totalMedAidCost.toStringAsFixed(2)}",
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 10.0),

                      Column(
                        children: [
                          TextField(
                            controller: medicalAidController,
                            keyboardType: TextInputType.text,
                            decoration: const InputDecoration(
                              labelText: "Name of Medical Aid",
                              hintText: "Enter the name for the Medical Aid",
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
                                  "Enter the expense for the medical aid per month",
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 10.0),
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton(
                              onPressed: () {
                                if (medicalAidController.text.isEmpty ||
                                    medicalAidCostController.text.isEmpty)
                                  return;

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
                                });

                                medicalAidController.clear();
                                medicalAidCostController.clear();
                              },
                              style: OutlinedButton.styleFrom(
                                backgroundColor: Colors.teal[100],
                                padding: const EdgeInsets.all(12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              child: const Text("Add Medical Aid"),
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
                                DataColumn(label: Text("Medical Aid Name")),
                                DataColumn(label: Text("Medical Aid Cost")),
                                DataColumn(label: Text("Action")),
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
                                              });
                                            }),

                                            SizedBox(width: 4),

                                            uiTools.itemEditBtn(() {
                                              // Add here
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
