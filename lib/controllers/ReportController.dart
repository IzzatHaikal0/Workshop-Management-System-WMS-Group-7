// lib/controllers/ReportController.dart

import 'package:flutter/material.dart';
import '../models/ReportModel.dart';

class ReportController extends ChangeNotifier {
  final List<ReportModel> _payments = [
    ReportModel.payment(
      id: 'PAY001',
      customer: 'Ahmad Ali',
      method: 'Online Banking',
      amount: 120.0,
      status: 'Paid',
      date: DateTime.parse('2025-05-13'),
    ),
    ReportModel.payment(
      id: 'PAY002',
      customer: 'Nur Fatimah',
      method: 'Debit Card',
      amount: 250.0,
      status: 'Failed',
      date: DateTime.parse('2025-05-14'),
    ),
    ReportModel.payment(
      id: 'PAY003',
      customer: 'John Lim',
      method: 'Credit Card',
      amount: 180.0,
      status: 'Paid',
      date: DateTime.parse('2025-05-15'),
    ),
  ];

  final List<ReportModel> _foremen = [
    ReportModel.foreman(
      name: 'Ahmad Bin Ali',
      ic: '900123-01-1234',
      phone: '012-3456789',
      email: 'ahmad@example.com',
      experience: '5 years',
      specialization: 'Engine Repair',
      status: 'Available',
    ),
    ReportModel.foreman(
      name: 'Siti Nur Haliza',
      ic: '880321-05-5678',
      phone: '011-2223344',
      email: 'siti@example.com',
      experience: '3 years',
      specialization: 'Brake & Tire Service',
      status: 'Not Available',
    ),
    ReportModel.foreman(
      name: 'John Lim',
      ic: '910202-07-8888',
      phone: '016-8887777',
      email: 'john.lim@example.com',
      experience: '8 years',
      specialization: 'Transmission Systems',
      status: 'Available',
    ),
  ];

  String _searchText = '';
  String _statusFilter = 'All';
  DateTimeRange? _dateRange;

  // Getters and setters
  String get searchText => _searchText;
  set searchText(String v) { _searchText = v; notifyListeners(); }

  String get statusFilter => _statusFilter;
  set statusFilter(String v) { _statusFilter = v; notifyListeners(); }

  DateTimeRange? get dateRange => _dateRange;
  set dateRange(DateTimeRange? v) { _dateRange = v; notifyListeners(); }

  // Method to pick date range
  Future<void> pickDateRange(BuildContext context) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) dateRange = picked;
  }

  // Filtered payment list
  List<ReportModel> get filteredPayments => _payments.where((p) {
        final matchesText = p.customer.toLowerCase().contains(_searchText.toLowerCase()) ||
            p.id.toLowerCase().contains(_searchText.toLowerCase());
        final matchesStatus = _statusFilter == 'All' || p.status.toLowerCase() == _statusFilter.toLowerCase();
        final matchesDate = _dateRange == null ||
            (_dateRange!.start.isBefore(p.date) && _dateRange!.end.isAfter(p.date));
        return matchesText && matchesStatus && matchesDate;
      }).toList();

  // Filtered foremen list
  List<ReportModel> get filteredForemen => _foremen.where((f) {
        final matchesText = f.id.toLowerCase().contains(_searchText.toLowerCase()) ||
            f.method.toLowerCase().contains(_searchText.toLowerCase());
        return matchesText;
      }).toList();
}