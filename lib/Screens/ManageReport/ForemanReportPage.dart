// lib/Screens/ManageReport/ForemanReportPage.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:workshop_management_system/controllers/ReportController.dart';

class ForemanReportPage extends StatelessWidget {
  const ForemanReportPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<ReportController>(context);
    final filteredForemen = controller.filteredForemen;

    return Scaffold(
      appBar: AppBar(title: const Text('Foreman Report')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Search by name or specialization',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (text) => controller.searchText = text,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredForemen.length,
              itemBuilder: (context, index) {
                final f = filteredForemen[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  elevation: 3,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Name: ${f.id}', style: const TextStyle(fontWeight: FontWeight.bold)),
                        Text('IC Number: ${f.customer}'),
                        Text('Phone: ${f.method}'),
                        Text('Status: ${f.status}'),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}