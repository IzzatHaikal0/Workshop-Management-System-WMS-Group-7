// lib/Models/PaymentModel.dart

class PaymentModel {
  final String name;
  final String role;
  final String status;
  final bool isPaid;

  PaymentModel({
    required this.name,
    required this.role,
    required this.status,
    required this.isPaid,
  });

  bool get isPending => status.toLowerCase() == 'pending';
}
