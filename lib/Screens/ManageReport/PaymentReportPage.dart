import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PaymentReportPage extends StatefulWidget {
  const PaymentReportPage({super.key});

  @override
  State<PaymentReportPage> createState() => _PaymentReportPageState();
}

class _PaymentReportPageState extends State<PaymentReportPage> {
  final List<Map<String, String>> _payments = [
    {
      'id': 'PAY001',
      'customer': 'Ahmad Ali',
      'method': 'Online Banking',
      'amount': '120.00',
      'status': 'Paid',
      'date': '2025-05-13',
    },
    {
      'id': 'PAY002',
      'customer': 'Nur Fatimah',
      'method': 'Debit Card',
      'amount': '250.00',
      'status': 'Failed',
      'date': '2025-05-14',
    },
    {
      'id': 'PAY003',
      'customer': 'John Lim',
      'method': 'Credit Card',
      'amount': '180.00',
      'status': 'Paid',
      'date': '2025-05-15',
    },
  ];

  String _searchText = '';
  String _statusFilter = 'All';
  DateTimeRange? _dateRange;

  List<Map<String, String>> get _filteredPayments {
    return _payments.where((payment) {
      final matchesText = payment['customer']!
              .toLowerCase()
              .contains(_searchText.toLowerCase()) ||
          payment['id']!.toLowerCase().contains(_searchText.toLowerCase());

      final matchesStatus = _statusFilter == 'All' ||
          payment['status']!.toLowerCase() == _statusFilter.toLowerCase();

      final date = DateTime.tryParse(payment['date']!);
      final matchesDate = _dateRange == null ||
          (_dateRange!.start.isBefore(date!) &&
              _dateRange!.end.isAfter(date));

      return matchesText && matchesStatus && matchesDate;
    }).toList();
  }

  Future<void> _pickDateRange() async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2024),
      lastDate: DateTime(2026),
    );
    if (picked != null) {
      setState(() => _dateRange = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateText = _dateRange == null
        ? 'All Dates'
        : '${DateFormat('yyyy-MM-dd').format(_dateRange!.start)} - ${DateFormat('yyyy-MM-dd').format(_dateRange!.end)}';

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Search by customer or payment ID',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.search),
                ),
                onChanged: (text) => setState(() => _searchText = text),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _statusFilter,
                      decoration: const InputDecoration(
                        labelText: 'Status',
                        border: OutlineInputBorder(),
                      ),
                      items: const [
                        DropdownMenuItem(value: 'All', child: Text('All')),
                        DropdownMenuItem(value: 'Paid', child: Text('Paid')),
                        DropdownMenuItem(value: 'Failed', child: Text('Failed')),
                      ],
                      onChanged: (value) {
                        setState(() => _statusFilter = value ?? 'All');
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _pickDateRange,
                      icon: const Icon(Icons.date_range),
                      label: Text(dateText, overflow: TextOverflow.ellipsis),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Expanded(
          child: _filteredPayments.isEmpty
              ? const Center(child: Text('No payments found.'))
              : ListView.builder(
                  itemCount: _filteredPayments.length,
                  itemBuilder: (context, index) {
                    final p = _filteredPayments[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      elevation: 3,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      child: ListTile(
                        title: Text('Payment ID: ${p['id']}'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Customer: ${p['customer']}'),
                            Text('Method: ${p['method']}'),
                            Text('Amount: RM ${p['amount']}'),
                            Text('Status: ${p['status']}'),
                            Text('Date: ${p['date']}'),
                          ],
                        ),
                        trailing: Icon(
                          p['status'] == 'Paid' ? Icons.check_circle : Icons.cancel,
                          color: p['status'] == 'Paid' ? Colors.green : Colors.red,
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}
