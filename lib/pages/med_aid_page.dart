import 'package:flutter/material.dart';
import 'package:first_flutter_app/models/MedicalAid.dart';

class MedAidPage extends StatefulWidget {
  const MedAidPage({super.key});

  @override
  State<MedAidPage> createState() => _MedAidPage();
}

class _MedAidPage extends State<MedAidPage> {
  final medAids = [MedicalAid(name: "Discovery", costMedAid: 2500)];

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
    return Scaffold(
      backgroundColor: Colors.teal[100],
      appBar: AppBar(
        title: Center(
          child: Text(
            style: TextStyle(color: Colors.blueGrey[50]),
            "Monthly Expence Tracker: ",
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

                      Column(
                        children: [
                          TextField(
                            controller: medicalAidController,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              labelText: "Name of Medical Aid",
                              hintText: "Enter the name for the Medical Aid",
                              border: OutlineInputBorder(),
                            ),
                          ),

                          SizedBox(height: 10.0),

                          TextField(
                            controller: medicalAidCostController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: "Monthly Expence",
                              hintText:
                                  "Enter the ecpence for the medical aid per month",
                              border: OutlineInputBorder(),
                            ),
                          ),

                          SizedBox(height: 10.0),

                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton(
                              onPressed: () {
                                String medAidName = medicalAidController.text;
                                double medAidCost =
                                    double.tryParse(
                                      medicalAidCostController.text,
                                    ) ??
                                    0;

                                MedicalAid medAid = new MedicalAid(
                                  name: medAidName,
                                  costMedAid: medAidCost,
                                );
                                setState(() {
                                  medAids.add(medAid);
                                });

                                medicalAidController.clear();
                                medicalAidCostController.clear();
                              },

                              child: Text("Add Medical Aid"),
                              style: OutlinedButton.styleFrom(
                                backgroundColor: Colors.teal[100],
                                padding: const EdgeInsets.all(12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 15),

                      Center(
                        child: DataTable(
                          headingRowColor: WidgetStateProperty.all(
                            Colors.teal[700],
                          ),
                          dataRowColor: WidgetStateProperty.all(Colors.cyan),
                          columns: const [
                            DataColumn(label: Text("Medical Aid Name")),
                            DataColumn(label: Text("Medical Aid Cost")),
                          ],
                          rows: medAids.map((mad) {
                            return DataRow(
                              cells: [
                                DataCell(Text(mad.getName)),
                                DataCell(
                                  Text(
                                    "R ${mad.getMedAidCost.toStringAsFixed(2)}",
                                  ),
                                ),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
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
