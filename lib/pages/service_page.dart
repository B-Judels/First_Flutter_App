import 'package:flutter/material.dart';
import 'package:first_flutter_app/models/Service.dart';

class ServicePage extends StatefulWidget {
  const ServicePage({super.key});

  @override
  State<ServicePage> createState() => _ServicePage();
}

class _ServicePage extends State<ServicePage> {
  final services = [
    Service(serviceName: "Spotify", serviceCost: 89),
    Service(serviceName: "iCloud", serviceCost: 49),
  ];

  final TextEditingController serviceNameController = TextEditingController();
  final TextEditingController serviceCostController = TextEditingController();

  @override
  void dispose() {
    serviceNameController.dispose();
    serviceCostController.dispose();
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
                        "Monthly Services",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      Column(
                        children: [
                          TextField(
                            controller: serviceNameController,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              labelText: "Service Name",
                              hintText: "Enter the name of the service",
                              border: OutlineInputBorder(),
                            ),
                          ),

                          SizedBox(height: 10.0),

                          TextField(
                            controller: serviceCostController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: "Monthly Expence",
                              hintText:
                                  "Enter the expence for the service per month",
                              border: OutlineInputBorder(),
                            ),
                          ),

                          SizedBox(height: 10.0),

                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton(
                              onPressed: () {
                                String serviceName = serviceNameController.text;
                                double serviceCost = double.parse(
                                  serviceCostController.text,
                                );

                                Service serve = new Service(
                                  serviceName: serviceName,
                                  serviceCost: serviceCost,
                                );

                                setState(() {
                                  services.add(serve);
                                });

                                serviceNameController.clear();
                                serviceCostController.clear();
                              },

                              child: Text("Add Service"),
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
                            DataColumn(label: Text("Service Name")),
                            DataColumn(label: Text("Service Cost")),
                          ],
                          rows: services.map((service) {
                            return DataRow(
                              cells: [
                                DataCell(Text(service.getName)),
                                DataCell(
                                  Text(
                                    "R ${service.getCost.toStringAsFixed(2)}",
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
