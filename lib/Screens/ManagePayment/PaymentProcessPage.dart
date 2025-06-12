import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PaymentProcessPage extends StatelessWidget {
  final Map<String, dynamic> paymentData;

  const PaymentProcessPage({super.key, required this.paymentData});

  @override
  Widget build(BuildContext context) {
    final String foremanName = paymentData['foremanName'];
    final String jobDescription = paymentData['jobDescription'];
    final double totalHours = paymentData['totalHours']?.toDouble() ?? 0;
    final double salaryRate = paymentData['salaryRate']?.toDouble() ?? 0;
    final double totalPay = totalHours * salaryRate;

    final Timestamp? scheduleDate = paymentData['scheduleDate'];
    final Timestamp? startTime = paymentData['startTime'];
    final Timestamp? endTime = paymentData['endTime'];

    final dateFormat = DateFormat('yyyy-MM-dd HH:mm');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Card(
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Foreman Name: $foremanName', style: TextStyle(fontSize: 16)),
                const SizedBox(height: 10),
                Text('Job Description: $jobDescription'),
                const SizedBox(height: 10),
                if (scheduleDate != null)
                  Text('Schedule Date: ${dateFormat.format(scheduleDate.toDate())}'),
                const SizedBox(height: 10),
                if (startTime != null)
                  Text('Start Time: ${dateFormat.format(startTime.toDate())}'),
                if (endTime != null)
                  Text('End Time: ${dateFormat.format(endTime.toDate())}'),
                const SizedBox(height: 10),
                Text('Total Hours: $totalHours'),
                Text('Pay Rate: RM $salaryRate'),
                const Divider(height: 20),
                Text(
                  'Total Payment: RM ${totalPay.toStringAsFixed(2)}',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const SizedBox(height: 30),
                Center(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // handle payment confirmation here
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Payment process not implemented")),
                      );
                    },
                    icon: const Icon(Icons.payment),
                    label: const Text("Confirm Payment"),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
