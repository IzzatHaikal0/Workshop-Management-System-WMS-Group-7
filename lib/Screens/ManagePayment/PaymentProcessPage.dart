import 'package:flutter/material.dart';

class PaymentProcessPage extends StatelessWidget {
  final String name;
  final int workingHours;
  final double ratePerHour;

  const PaymentProcessPage({
    super.key,
    required this.name,
    required this.workingHours,
    required this.ratePerHour,
  });

  @override
  Widget build(BuildContext context) {
    final double totalPayment = workingHours * ratePerHour;

    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(color: Colors.black),
        title: const Text('Payment', style: TextStyle(color: Colors.black)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: Icon(Icons.notifications_none, color: Colors.black),
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 32),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.grey,
                    blurRadius: 6,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(
                    child: Text(
                      'Payment Details',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(name.toUpperCase(), style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  _buildRow('Working hour', '$workingHours hours'),
                  _buildRow('Rate per hour', 'RM ${ratePerHour.toStringAsFixed(2)}'),
                  const Divider(),
                  _buildRow('Total payment', 'RM ${totalPayment.toStringAsFixed(2)}'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: () {
              // Payment confirmation logic here
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Payment confirmed!')),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Confirm payment', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
