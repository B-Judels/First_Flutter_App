import 'package:flutter/material.dart';
import 'package:freeuse_monthly_expense_tracker/models/DebitOrder.dart';
import 'package:freeuse_monthly_expense_tracker/custom_tools/logicTools.dart';
import 'package:freeuse_monthly_expense_tracker/custom_tools/uiTools.dart';
import 'package:freeuse_monthly_expense_tracker/database/database_helper.dart';

class DebitOrderPage extends StatefulWidget {
  const DebitOrderPage({super.key});

  @override
  State<DebitOrderPage> createState() => _DebitOrderPage();
}

class _DebitOrderPage extends State<DebitOrderPage> {
  List<DebitOrder> debitOrders = [];

  int editingIndex = -1;

  bool isLoading = true;

  Future<void> _loadDatabaseData() async {
    try {
      final db = DatabaseHelper.instance;
      final loadedDebitOrders = await db.getDebitOrders();

      if (!mounted) return;

      setState(() {
        debitOrders = loadedDebitOrders;
      });
    } catch (e) {
      debugPrint("Database error: $e");

      if (!mounted) return;

      setState(() {
        isLoading = false;
      });
    }
  }

  final TextEditingController debitNameController = TextEditingController();
  final TextEditingController debitCostController = TextEditingController();

  final uiTools = Uitools();

  @override
  void dispose() {
    debitNameController.dispose();
    debitCostController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _loadDatabaseData();
  }

  @override
  Widget build(BuildContext context) {
    double totalDebitOrders = 0;
    for (int i = 0; i < debitOrders.length; i++) {
      totalDebitOrders += debitOrders[i].getCost;
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
                        "Monthly Debit Orders",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      Text(
                        "Total Debit Orders: R ${totalDebitOrders.toStringAsFixed(2)}",
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      const SizedBox(height: 10.0),

                      Column(
                        children: [
                          TextField(
                            controller: debitNameController,
                            keyboardType: TextInputType.text,
                            decoration: const InputDecoration(
                              labelText: "Debit Order Name",
                              hintText: "Enter the name for the debit order",
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 10.0),
                          TextField(
                            controller: debitCostController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: "Monthly Expense",
                              hintText:
                                  "Enter the expense for the service per month",
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 10.0),
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton(
                              onPressed: () {
                                if (debitNameController.text.isEmpty ||
                                    debitCostController.text.isEmpty)
                                  return;

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
                              style: OutlinedButton.styleFrom(
                                backgroundColor: Colors.teal[100],
                                padding: const EdgeInsets.all(12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              child: const Text("Add Debit Order"),
                            ),
                          ),
                        ],
                      ),

                      if (debitOrders.isNotEmpty) ...[
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
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          uiTools.itemRemoveBtn(() {
                                            setState(() {
                                              debitOrders = const LogicTools()
                                                  .debitOrderItemRemover(
                                                    debitOrders,
                                                    index,
                                                  );

                                              if (editingIndex == index) {
                                                editingIndex = -1;
                                                debitNameController.clear();
                                                debitCostController.clear();
                                              }
                                            });
                                          }),

                                          SizedBox(width: 4),

                                          uiTools.itemEditBtn(() {
                                            setState(() {
                                              debitNameController.text =
                                                  orderer.getName;
                                              debitCostController.text = orderer
                                                  .getCost
                                                  .toString();
                                              editingIndex = index;

                                              debitOrders.removeAt(index);
                                            });
                                          }),
                                        ],
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
                          await DatabaseHelper.instance.replaceDebitOrders(
                            debitOrders,
                          );

                          if (!mounted) return;

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Debit orders updated!"),
                            ),
                          );

                          Navigator.pop(context);
                        },
                        child: const Text("Update"),
                      ),
                    ),
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
