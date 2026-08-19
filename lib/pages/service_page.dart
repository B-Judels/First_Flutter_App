import 'package:flutter/material.dart';
import 'package:freeuse_monthly_expense_tracker/models/Service.dart';
import 'package:freeuse_monthly_expense_tracker/custom_tools/logicTools.dart';
import 'package:freeuse_monthly_expense_tracker/custom_tools/uiTools.dart';
import 'package:freeuse_monthly_expense_tracker/database/database_helper.dart';

class ServicePage extends StatefulWidget {
  const ServicePage({super.key});

  @override
  State<ServicePage> createState() => _ServicePage();
}

class _ServicePage extends State<ServicePage> {
  List<Service> services = [];

  bool isLoading = true;

  bool showInfo = false;

  Future<void> _loadDatabaseData() async {
    try {
      final db = DatabaseHelper.instance;
      final loadedServices = await db.getServices();

      if (!mounted) return;

      setState(() {
        services = loadedServices;
      });
    } catch (e) {
      debugPrint("Database error: $e");

      if (!mounted) return;

      setState(() {
        isLoading = false;
      });
    }
  }

  final TextEditingController serviceNameController = TextEditingController();
  final TextEditingController serviceCostController = TextEditingController();

  final uiTools = Uitools();

  int editingIndex = -1;

  @override
  void dispose() {
    serviceNameController.dispose();
    serviceCostController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _loadDatabaseData();
  }

  @override
  Widget build(BuildContext context) {
    double totalServiceCost = 0;
    for (int i = 0; i < services.length; i++) {
      totalServiceCost += services[i].getCost;
    }

    return Scaffold(
      backgroundColor: Colors.teal[100],
      appBar: AppBar(
        title: Center(
          child: Text(
            "Monthly Budget Planner",
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
                                "Monthly Services",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              Text(
                                "Total Services: R ${totalServiceCost.toStringAsFixed(2)}",
                                style: const TextStyle(
                                  fontSize: 12,
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
                            "Services are recurring monthly expenses such as "
                            "Electricity Bill, Internet Bill, Cellphone Contracts, "
                            "Water Bill, Monthly Class Fees, etc.",
                      ),

                      const SizedBox(height: 10.0),

                      Column(
                        children: [
                          TextField(
                            controller: serviceNameController,
                            keyboardType: TextInputType.text,
                            decoration: const InputDecoration(
                              labelText: "Service Name",
                              hintText: "Enter the name of the service",
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 10.0),
                          TextField(
                            controller: serviceCostController,
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
                                if (serviceNameController.text.isEmpty ||
                                    serviceCostController.text.isEmpty) {
                                  return;
                                }

                                String serviceName = serviceNameController.text;

                                double serviceCost =
                                    double.tryParse(
                                      serviceCostController.text,
                                    ) ??
                                    0;

                                Service serve = Service(
                                  serviceName: serviceName,
                                  serviceCost: serviceCost,
                                );

                                setState(() {
                                  if (editingIndex != -1) {
                                    services.insert(editingIndex, serve);

                                    editingIndex = -1;
                                  } else {
                                    services.add(serve);
                                  }
                                });

                                serviceNameController.clear();
                                serviceCostController.clear();
                              },
                              style: OutlinedButton.styleFrom(
                                backgroundColor: Colors.teal[100],
                                padding: const EdgeInsets.all(12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              child: Text(
                                editingIndex != -1
                                    ? "Update Service"
                                    : "Add Service",
                              ),
                            ),
                          ),
                        ],
                      ),

                      if (services.isNotEmpty) ...[
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
                                DataColumn(
                                  label: Text(
                                    style: TextStyle(fontSize: 12),
                                    "Name:",
                                  ),
                                  headingRowAlignment: MainAxisAlignment.start,
                                ),

                                DataColumn(
                                  label: Text(
                                    style: TextStyle(fontSize: 12),
                                    "Cost:",
                                  ),
                                  headingRowAlignment: MainAxisAlignment.start,
                                ),

                                DataColumn(
                                  columnWidth: FixedColumnWidth(125),
                                  label: Text(
                                    style: TextStyle(fontSize: 12),
                                    "Actions:",
                                  ),
                                  headingRowAlignment: MainAxisAlignment.start,
                                ),
                              ],
                              rows: services.asMap().entries.map((entry) {
                                int index = entry.key;
                                var servicer = entry.value;
                                return DataRow(
                                  cells: [
                                    DataCell(
                                      Text(
                                        style: TextStyle(fontSize: 12),
                                        servicer.getName,
                                      ),
                                    ),
                                    DataCell(
                                      Text(
                                        style: TextStyle(fontSize: 12),
                                        "R ${servicer.getCost.toStringAsFixed(2)}",
                                      ),
                                    ),
                                    DataCell(
                                      Center(
                                        child: Row(
                                          children: [
                                            uiTools.itemRemoveBtn(() {
                                              setState(() {
                                                services = const LogicTools()
                                                    .serviceItemRemover(
                                                      services,
                                                      index,
                                                    );

                                                if (editingIndex == index) {
                                                  editingIndex = -1;
                                                  serviceNameController.clear();
                                                  serviceCostController.clear();
                                                }
                                              });
                                            }),

                                            SizedBox(width: 4),

                                            uiTools.itemEditBtn(() {
                                              setState(() {
                                                serviceNameController.text =
                                                    servicer.getName;
                                                serviceCostController.text =
                                                    servicer.getCost.toString();
                                                editingIndex = index;

                                                services.removeAt(index);
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
                  const SizedBox(height: 20),

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
                              await DatabaseHelper.instance.replaceServices(
                                services,
                              );

                              if (!mounted) return;

                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Services updated!"),
                                ),
                              );
                            } catch (e) {
                              debugPrint("Error updating services: $e");

                              if (!mounted) return;

                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Failed to update services."),
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
