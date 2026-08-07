import 'package:flutter/material.dart';
import 'package:first_flutter_app/models/DebitOrder.dart';
import 'package:first_flutter_app/custom_tools/logicTools.dart';

class DebitOrderPage extends StatefulWidget {
  const DebitOrderPage({super.key});

  @override
  State<DebitOrderPage> createState() => _DebitOrderPage();
}

class _DebitOrderPage extends State<DebitOrderPage> {
  List<DebitOrder> debitOrders = [
    DebitOrder(name: "Car Insurance", cost: 1200),
    DebitOrder(name: "Netflix", cost: 199),
    DebitOrder(name: "Gym", cost: 450),
  ];

  final TextEditingController debitNameController = TextEditingController();

  final TextEditingController debitCostController = TextEditingController();

  @override
  void dispose() {
    debitNameController.dispose();
    debitCostController.dispose();
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
                        "Monthly Debit Orders",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      Column(
                        children: [
                          TextField(
                            controller: debitNameController,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              labelText: "Debit Order Name",
                              hintText: "Enter the name for the debit order",
                              border: OutlineInputBorder(),
                            ),
                          ),

                          SizedBox(height: 10.0),

                          TextField(
                            controller: debitCostController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: "Monthly Expence",
                              hintText:
                                  "Enter the ecpence for the service per month",
                              border: OutlineInputBorder(),
                            ),
                          ),

                          SizedBox(height: 10.0),

                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton(
                              onPressed: () {
                                String debitName = debitNameController.text;

                                double debitCost =
                                    double.tryParse(debitCostController.text) ??
                                    0;

                                DebitOrder order = DebitOrder(
                                  name: debitName,
                                  cost: debitCost,
                                );

                                setState(() {
                                  debitOrders.add(order);
                                });

                                debitNameController.clear();
                                debitCostController.clear();
                              },

                              child: Text("Add Debit Order"),
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
                            DataColumn(label: Text("Debit Order Name")),
                            DataColumn(label: Text("Debit Order Cost")),
                            DataColumn(label: Text("Remove Debit Order")),
                          ],
                          rows: debitOrders.asMap().entries.map((entry) {
                            int index = entry.key;
                            var orderer = entry.value;

                            return DataRow(
                              cells: [
                                DataCell(Text(orderer.getName)),
                                DataCell(
                                  Text(
                                    "R ${orderer.getCost.toStringAsFixed(2)}",
                                  ),
                                ),
                                DataCell(
                                  OutlinedButton(
                                    child: const Text("Remove"),

                                    onPressed: () {
                                      setState(() {
                                        List<DebitOrder> newList = LogicTools()
                                            .debitOrderItemRemover(
                                              debitOrders,
                                              index,
                                            );

                                        debitOrders = newList;
                                      });
                                    },
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
