import 'package:flutter/material.dart';
import './chart_bar.dart';
import '../models/transaction.dart';
import 'package:intl/intl.dart';

class Chart extends StatelessWidget {
  final List<Transaction> recentTransactions;

  Chart(this.recentTransactions);

  List<Map<String, Object>> get groupedTransactionValues {
    return List.generate(7, (index) {
      final weekDay = DateTime.now().subtract(
        Duration(days: index),
      );
      double totalSum = 0.0;

      recentTransactions.forEach((v) => {
            if (v.date.day == weekDay.day &&
                v.date.month == weekDay.month &&
                v.date.year == weekDay.year)
              {totalSum += v.amount}
          });

      return {
        'day': DateFormat.E().format(weekDay).substring(0, 1),
        'amount': totalSum,
      };
    }).reversed.toList();
  }

  double get totalSpending {
    double sum = 0.0;

    this.groupedTransactionValues.forEach((v) {
      sum += v['amount'];
    });

    return sum;
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
          children: this.groupedTransactionValues.map((data) {
            return Flexible(
              fit: FlexFit.tight,
              child: ChartBar(
                data['day'],
                data['amount'],
                this.totalSpending != 0.0
                    ? (data['amount'] as double) / this.totalSpending
                    : 0.0,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
