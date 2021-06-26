import '/widgets/chart_bar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/transaction.dart';

class Chart extends StatelessWidget {
  final List<Transaction> recentTransactions;

  Chart(this.recentTransactions);

  List<Map<String, Object>> get groupedTransactionValues {
    return List.generate(7, (index) {
      final weekDay = DateTime.now().subtract(Duration(days: index));
      int totalSum = 0;
      for (int i = 0; i < recentTransactions.length; i++) {
        if (recentTransactions[i].date.day == weekDay.day &&
            recentTransactions[i].date.month == weekDay.month &&
            recentTransactions[i].date.year == weekDay.year) {
          totalSum += recentTransactions[i].amount;
        }
      }
      return {
        'day': DateFormat.E().format(weekDay).substring(0, 2),
        'amount': totalSum
      }; // important format function
    }).reversed.toList();
  }

  // double get totalSpending {
  //   return groupedTransactionValues.fold(0.0, (sum, item) {
  //     return sum += item['amount'];
  //   });
  // }

  double get totalSpending {
    double temp = 0.0;
    for (int i = 0; i < groupedTransactionValues.length; i++) {
      temp += (groupedTransactionValues[i]['amount'] as int).toDouble();
    }
    return temp;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      margin: EdgeInsets.all(20),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            ...groupedTransactionValues.map((data) {
              return Flexible(
                fit: FlexFit.tight,
                child: ChartBar(
                  spentAmount: data['amount'],
                  spentPercent: totalSpending == 0.0
                      ? 0.0
                      : (data['amount'] as int).toDouble() / totalSpending,
                  weekDayLabel: data['day'],
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}
