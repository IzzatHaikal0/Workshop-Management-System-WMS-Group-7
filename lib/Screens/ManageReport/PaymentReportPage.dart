// lib/Screens/ManageReport/PaymentReportPage.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:workshop_management_system/controllers/ReportController.dart';

class PaymentReportPage extends StatelessWidget {
  const PaymentReportPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<ReportController>(context);
    final dateText = controller.dateRange == null
        ? 'All Dates'
        : '${DateFormat('yyyy-MM-dd').format(controller.dateRange!.start)} - ${DateFormat('yyyy-MM-dd').format(controller.dateRange!.end)}';
    final filteredPayments = controller.filteredPayments;

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
                onChanged: (text) => controller.searchText = text,
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: controller.statusFilter,
                      decoration: const InputDecoration(
                        labelText: 'Status',
                        border: OutlineInputBorder(),
                      ),
                      items: const [
                        DropdownMenuItem(value: 'All', child: Text('All')),
                        DropdownMenuItem(value: 'Paid', child: Text('Paid')),
                        DropdownMenuItem(value: 'Failed', child: Text('Failed')),
                      ],
                      onChanged: (value) => controller.statusFilter = value ?? 'All',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => controller.pickDateRange(context),
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
          child: filteredPayments.isEmpty
              ? const Center(child: Text('No payments found.'))
              : ListView.builder(
                  itemCount: filteredPayments.length,
                  itemBuilder: (context, index) {
                    final p = filteredPayments[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      elevation: 3,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      child: ListTile(
                        title: Text('Payment ID: ${p.id}'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Customer: ${p.customer}'),
                            Text('Method: ${p.method}'),
                            Text('Amount: RM ${p.amount.toStringAsFixed(2)}'),
                            Text('Status: ${p.status}'),
                            Text('Date: ${DateFormat('yyyy-MM-dd').format(p.date)}'),
                          ],
                        ),
                        trailing: Icon(
                          p.status == 'Paid' ? Icons.check_circle : Icons.cancel,
                          color: p.status == 'Paid' ? Colors.green : Colors.red,
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