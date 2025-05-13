import 'package:flutter/material.dart';
import 'package:workshop_management_system/Screens/ManageReport/ForemanReportPage.dart';
import 'package:workshop_management_system/Screens/ManageReport/PaymentReportPage.dart';

class ReportPage extends StatefulWidget {
  const ReportPage({super.key});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  String _selectedReport = 'Foreman Report';

  final List<String> _reportTypes = ['Foreman Report', 'Payment Report'];

  @override
  Widget build(BuildContext context) {
    Widget reportView;
    if (_selectedReport == 'Foreman Report') {
      reportView = const ForemanReportPage();
    } else {
      reportView = const PaymentReportPage();
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Report Viewer')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: DropdownButtonFormField<String>(
              value: _selectedReport,
              decoration: const InputDecoration(
                labelText: 'Select Report',
                border: OutlineInputBorder(),
              ),
              items: _reportTypes
                  .map((type) => DropdownMenuItem(value: type, child: Text(type)))
                  .toList(),
              onChanged: (value) {
                setState(() => _selectedReport = value!);
              },
            ),
          ),
          Expanded(child: reportView),
        ],
      ),
    );
  }
}
