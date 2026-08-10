import 'package:flutter/material.dart';
import 'package:first_flutter_app/models/Service.dart';
import 'package:first_flutter_app/custom_tools/logicTools.dart';
import 'package:first_flutter_app/custom_tools/uiTools.dart';

class ServicePage extends StatefulWidget {
  const ServicePage({super.key});

  @override
  State<ServicePage> createState() => _ServicePage();
}

class _ServicePage extends State<ServicePage> {
  List<Service> services = [
    Service(serviceName: "Spotify", serviceCost: 89),
    Service(serviceName: "iCloud", serviceCost: 49),
  ];

  final TextEditingController serviceNameController = TextEditingController();
  final TextEditingController serviceCostController = TextEditingController();

  final uiTools = Uitools();

  @override
  void dispose() {
    serviceNameController.dispose();
    serviceCostController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Dynamically calculate total service costs on every widget build
    double totalServiceCost = 0;
    for (int i = 0; i < services.length; i++) {
      totalServiceCost +=
          services[i].getCost; // Assumes getCost matches your model getter
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
                        "Monthly Services",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      // Running total indicator block
                      Text(
                        "Total Services: R ${totalServiceCost.toStringAsFixed(2)}",
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
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
                                    serviceCostController.text.isEmpty)
                                  return;

                                String serviceName = serviceNameController.text;
                                // FIXED: Changed double.parse to tryParse to stop user input format crashes
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
                                  services.add(serve);
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
                              child: const Text("Add Service"),
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
                                DataColumn(label: Text("Service Name")),
                                DataColumn(label: Text("Service Cost")),
                                DataColumn(label: Text("Action")),
                              ],
                              rows: services.asMap().entries.map((entry) {
                                int index = entry.key;
                                var servicer = entry.value;
                                return DataRow(
                                  cells: [
                                    DataCell(Text(servicer.getName)),
                                    DataCell(
                                      Text(
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
