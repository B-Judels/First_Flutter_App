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

  final uiTools = Uitools();

  int editingIndex = -1;

  bool isLoading = true;

  bool showInfo = false;

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

  final TextEditingController debitOrderNameController =
      TextEditingController();
  final TextEditingController debitOrderCostController =
      TextEditingController();

  @override
  void dispose() {
    debitOrderNameController.dispose();
    debitOrderCostController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _loadDatabaseData();
  }

  @override
  Widget build(BuildContext context) {
    double totalDebitOrderCost = 0;
    for (int i = 0; i < debitOrders.length; i++) {
      totalDebitOrderCost += debitOrders[i].getCost;
    }

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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Debit Orders",
                                style: uiTools.sectionTitleStyle(),
                              ),

                              Text(
                                "Total Debit Orders: R ${totalDebitOrderCost.toStringAsFixed(2)}",
                                style: uiTools.summaryTextStyle(),
                              ),
                            ],
                          ),
                          const Spacer(),

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
                            "Debit orders are fixed recurring monthly "
                            "payments that are automatically deducted from "
                            "your account, such as loan repayments, "
                            "subscriptions, or rent.",
                      ),

                      const SizedBox(height: 10.0),

                      Column(
                        children: [
                          TextField(
                            controller: debitOrderNameController,
                            keyboardType: TextInputType.text,
                            decoration: uiTools.inputDecoration(
                              labelText: "Debit Order Name",
                              hintText: "Enter the name of the debit order",
                            ),
                          ),
                          const SizedBox(height: 10.0),
                          TextField(
                            controller: debitOrderCostController,
                            keyboardType: TextInputType.number,
                            decoration: uiTools.inputDecoration(
                              labelText: "Monthly Expense",
                              hintText:
                                  "Enter the expense for the debit order per month",
                            ),
                          ),
                          const SizedBox(height: 10.0),
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton(
                              onPressed: () {
                                if (debitOrderNameController.text.isEmpty ||
                                    debitOrderCostController.text.isEmpty) {
                                  return;
                                }

                                String debitOrderName =
                                    debitOrderNameController.text;

                                double debitOrderCost =
                                    double.tryParse(
                                      debitOrderCostController.text,
                                    ) ??
                                    0;

                                DebitOrder debOrder = DebitOrder(
                                  name: debitOrderName,
                                  cost: debitOrderCost,
                                );

                                setState(() {
                                  if (editingIndex != -1) {
                                    debitOrders.insert(editingIndex, debOrder);

                                    editingIndex = -1;
                                  } else {
                                    debitOrders.add(debOrder);
                                  }

                                  debitOrderNameController.clear();
                                  debitOrderCostController.clear();
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
                                editingIndex != -1
                                    ? "Update Debit Order"
                                    : "Add Debit Order",
                              ),
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
                              rows: debitOrders.asMap().entries.map((entry) {
                                int index = entry.key;
                                var order = entry.value;
                                return DataRow(
                                  cells: [
                                    DataCell(
                                      Text(
                                        style: uiTools.tableTextStyle(),
                                        order.getName,
                                      ),
                                    ),
                                    DataCell(
                                      Text(
                                        style: uiTools.tableTextStyle(),
                                        "R ${order.getCost.toStringAsFixed(2)}",
                                      ),
                                    ),
                                    DataCell(
                                      Center(
                                        child: Row(
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
                                                  debitOrderNameController
                                                      .clear();
                                                  debitOrderCostController
                                                      .clear();
                                                }
                                              });
                                            }),

                                            const SizedBox(width: 4),

                                            uiTools.itemEditBtn(() {
                                              setState(() {
                                                debitOrderNameController.text =
                                                    order.getName;
                                                debitOrderCostController.text =
                                                    order.getCost.toString();
                                                editingIndex = index;

                                                debitOrders.removeAt(index);
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

                const SizedBox(height: 20),

                if (editingIndex == -1) ...[
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
                              await DatabaseHelper.instance.replaceDebitOrders(
                                debitOrders,
                              );

                              if (!mounted) return;

                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Debit orders updated!"),
                                ),
                              );
                            } catch (e) {
                              debugPrint("Error updating debit orders: $e");

                              if (!mounted) return;

                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    "Failed to update debit orders.",
                                  ),
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
