import 'package:flutter/material.dart';
import 'package:first_flutter_app/uiTools.dart';

void main() {
  runApp(StartUpPage());
}

final List<String> services = [];
final List<String> debitOrders = [];

class StartUpPage extends StatelessWidget {
  const StartUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
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
                children: [
                  const Text(
                    "Insert some values to calculate and track:",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),

                  Container(
                    margin: const EdgeInsets.all(10.0),
                    width: double.maxFinite,

                    padding: const EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      color: Colors.teal[300],
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),

                        const TextField(
                          decoration: InputDecoration(
                            labelText: "Monthly Income",
                            hintText: "Enter your monthly income",
                            border: OutlineInputBorder(),
                          ),
                        ),

                        SizedBox(height: 25.0),

                        const TextField(
                          decoration: InputDecoration(
                            labelText: "Medical Aid",
                            hintText: "Enter your monthly medical aid expences",
                            border: OutlineInputBorder(),
                          ),
                        ),

                        SizedBox(height: 10.0),

                        const TextField(
                          decoration: InputDecoration(
                            labelText: "Daily Habit Expences",
                            hintText:
                                "Enter your frequent everyday spendage cost. (per day)",
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ],
                    ),
                  ),

                  Column(
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
                                const TextField(
                                  decoration: InputDecoration(
                                    labelText: "Debit Order Name",
                                    hintText:
                                        "Enter the name for the debit order",
                                    border: OutlineInputBorder(),
                                  ),
                                ),

                                SizedBox(height: 10.0),

                                const TextField(
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
                                    onPressed: () {},

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
                                dataRowColor: WidgetStateProperty.all(
                                  Colors.cyan,
                                ),
                                columns: const [
                                  DataColumn(label: Text("Debit Order Name")),
                                ],
                                rows: debitOrders.map((order) {
                                  return DataRow(
                                    cells: [DataCell(Text(order))],
                                  );
                                }).toList(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

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
                            const TextField(
                              decoration: InputDecoration(
                                labelText: "Service Name",
                                hintText: "Enter your monthly income",
                                border: OutlineInputBorder(),
                              ),
                            ),

                            SizedBox(height: 10.0),

                            const TextField(
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
                                onPressed: () {},

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
                            ],
                            rows: services.map((service) {
                              return DataRow(cells: [DataCell(Text(service))]);
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                  ),

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
                            const TextField(
                              decoration: InputDecoration(
                                labelText: "Debit Order Name",
                                hintText: "Enter the name for the debit order",
                                border: OutlineInputBorder(),
                              ),
                            ),

                            SizedBox(height: 10.0),

                            const TextField(
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
                                onPressed: () {},

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
                            ],
                            rows: debitOrders.map((order) {
                              return DataRow(cells: [DataCell(Text(order))]);
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                  ),

                  Container(
                    margin: EdgeInsets.all(10.0),
                    child: SizedBox(
                      width: double.infinity,

                      child: OutlinedButton(
                        onPressed: () {},

                        child: Text("Save and Calculate"),
                        style: OutlinedButton.styleFrom(
                          backgroundColor: Colors.lightGreen[400],
                          padding: const EdgeInsets.all(12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
