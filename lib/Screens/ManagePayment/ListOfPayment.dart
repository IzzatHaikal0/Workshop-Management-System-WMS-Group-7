import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'PaymentProcessPage.dart';

class ListOfPayment extends StatefulWidget {
  final String workshopOwnerId;

  const ListOfPayment({super.key, required this.workshopOwnerId});

  @override
  State<ListOfPayment> createState() => _ListOfPaymentState();
}

class _ListOfPaymentState extends State<ListOfPayment> {
  late Future<List<Map<String, dynamic>>> _paymentList;

  @override
  void initState() {
    super.initState();
    _paymentList = fetchCompletedPayments();
  }

  Future<List<Map<String, dynamic>>> fetchCompletedPayments() async {
    final List<Map<String, dynamic>> results = [];

    final querySnapshot = await FirebaseFirestore.instance
        .collection('WorkshopSchedule')
        .where('workshopOwnerId', isEqualTo: widget.workshopOwnerId)
        .where('status', isEqualTo: 'accepted')
        .get();

    for (final doc in querySnapshot.docs) {
      final data = doc.data();
      final foremanId = data['foremanId'];

      if (foremanId != null) {
        final foremanDoc = await FirebaseFirestore.instance
            .collection('foremen')
            .doc(foremanId)
            .get();

        if (foremanDoc.exists) {
          final foremanData = foremanDoc.data()!;
          results.add({
            'scheduleId': doc.id,
            'foremanName': '${foremanData['first_name']} ${foremanData['last_name']}',
            'jobDescription': data['jobDescription'],
            'totalHours': data['totalHours'],
            'salaryRate': data['salaryRate'],
            'isPaid': data['isPaid'] ?? false,
            'foremanId': foremanId,
            'scheduleDate': data['scheduleDate'],
            'startTime': data['startTime'],
            'endTime': data['endTime'],
          });
        }
      }
    }

    return results;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('List of Payments'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _paymentList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No payments to process."));
          }

          final payments = snapshot.data!;

          return ListView.builder(
            itemCount: payments.length,
            itemBuilder: (context, index) {
              final payment = payments[index];

              final double totalHours = payment['totalHours']?.toDouble() ?? 0;
              final double salaryRate = payment['salaryRate']?.toDouble() ?? 0;
              final double totalPayment = totalHours * salaryRate;

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                elevation: 3,
                child: ListTile(
                  title: Text(payment['foremanName']),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Job: ${payment['jobDescription']}'),
                      Text('Total Hours: ${payment['totalHours']}'),
                      Text('Rate: RM ${salaryRate.toStringAsFixed(2)}'),
                      Text('Total: RM ${totalPayment.toStringAsFixed(2)}'),
                    ],
                  ),
                  trailing: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => PaymentProcessPage(paymentData: payment),
                        ),
                      );
                    },
                    child: const Text("Pay"),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
