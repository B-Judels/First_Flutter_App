import 'package:flutter/material.dart';

class BudgetProgressBar extends StatelessWidget {
  final double income;
  final double expenses;

  const BudgetProgressBar({
    super.key,
    required this.income,
    required this.expenses,
  });

  @override
  Widget build(BuildContext context) {
    final bool isOverspent = expenses > income;
    final double remainingIncome = income - expenses;
    final double deficit = expenses - income;

    return LayoutBuilder(
      builder: (context, constraints) {
        final double maxWidth = constraints.maxWidth;

        final double totalBasis = isOverspent ? expenses : income;
        final double firstSegmentBasis = isOverspent ? income : expenses;
        final double secondSegmentBasis = isOverspent
            ? deficit
            : remainingIncome;

        final int firstFlex = totalBasis > 0
            ? ((firstSegmentBasis / totalBasis) * 10000).toInt()
            : 0;
        final int secondFlex = totalBasis > 0
            ? ((secondSegmentBasis / totalBasis) * 10000).toInt()
            : 0;

        List<Widget> barSegments = [];

        if (firstFlex > 0) {
          barSegments.add(
            Expanded(
              flex: firstFlex,
              child: Container(color: Colors.red[400]),
            ),
          );
        }

        if (secondFlex > 0) {
          barSegments.add(
            Expanded(
              flex: secondFlex,
              child: Container(
                color: isOverspent ? Colors.red[900] : Colors.green[400],
              ),
            ),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 16,
              width: maxWidth,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        color: Colors.grey[300],
                        child: Row(children: barSegments),
                      ),
                    ),
                  ),

                  Positioned.fill(
                    child: IgnorePointer(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.black, width: 1.5),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Expenses: \$${expenses.toStringAsFixed(2)}',
                  style: TextStyle(
                    color: Colors.red[400],
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  isOverspent
                      ? 'Remaining: -\$${deficit.toStringAsFixed(2)}'
                      : 'Remaining: \$${remainingIncome.toStringAsFixed(2)}',
                  style: TextStyle(
                    color: isOverspent ? Colors.red[900] : Colors.green[400],
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
