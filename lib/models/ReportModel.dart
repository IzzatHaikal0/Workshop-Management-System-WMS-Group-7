// lib/models/ReportModel.dart

class ReportModel {
  final String id;
  final String customer;
  final String method;
  final double amount;
  final String status;
  final DateTime date;

  // Constructor for payment records
  ReportModel.payment({
    required this.id,
    required this.customer,
    required this.method,
    required this.amount,
    required this.status,
    required this.date,
  });

  // Constructor for foreman records
  ReportModel.foreman({
    required String name,
    required String ic,
    required String phone,
    required String email,
    required String experience,
    required String specialization,
    required String status,
  })  : id = name,
        customer = ic,
        method = phone,
        amount = 0.0,
        date = DateTime.now(),
        this.status = status;
}