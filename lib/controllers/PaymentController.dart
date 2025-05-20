import 'package:flutter/material.dart';
import '../Models/PaymentModel.dart';

class PaymentController {
  // Sample hardcoded list of payments
  List<PaymentModel> getPayments() {
    return [
      PaymentModel(name: 'Ahmad Albab bin Mahmud', role: 'Foreman', status: 'Pending', isPaid: false),
      PaymentModel(name: 'ali haidar bin ali baba', role: 'Foreman', status: 'Pending', isPaid: false),
      PaymentModel(name: 'abdul kamil bin kamal', role: 'Foreman', status: 'Completed', isPaid: true),
    ];
  }

  // Method to calculate total payment based on hours and rate
  double calculateTotalPayment(int hours, double rate) {
    return hours * rate;
  }

  // Method to show confirmation of payment
  void confirmPayment(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Payment confirmed!')),
    );

    // TODO: Implement actual logic to update payment status in a database or state
  }
}
