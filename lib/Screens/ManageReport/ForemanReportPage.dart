import 'package:flutter/material.dart';

class ForemanReportPage extends StatefulWidget {
  const ForemanReportPage({super.key});

  @override
  State<ForemanReportPage> createState() => _ForemanReportPageState();
}

class _ForemanReportPageState extends State<ForemanReportPage> {
  final List<Map<String, String>> _allForemen = [
    {
      'name': 'Ahmad Bin Ali',
      'ic': '900123-01-1234',
      'phone': '012-3456789',
      'email': 'ahmad@example.com',
      'experience': '5 years',
      'specialization': 'Engine Repair',
      'status': 'Available',
    },
    {
      'name': 'Siti Nur Haliza',
      'ic': '880321-05-5678',
      'phone': '011-2223344',
      'email': 'siti@example.com',
      'experience': '3 years',
      'specialization': 'Brake & Tire Service',
      'status': 'Not Available',
    },
    {
      'name': 'John Lim',
      'ic': '910202-07-8888',
      'phone': '016-8887777',
      'email': 'john.lim@example.com',
      'experience': '8 years',
      'specialization': 'Transmission Systems',
      'status': 'Available',
    },
  ];

  String _searchText = '';

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> _filteredForemen = _allForemen.where((foreman) {
      return foreman['name']!.toLowerCase().contains(_searchText.toLowerCase()) ||
             foreman['specialization']!.toLowerCase().contains(_searchText.toLowerCase());
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Foreman Report'),
      ),
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
              onChanged: (text) {
                setState(() {
                  _searchText = text;
                });
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _filteredForemen.length,
              itemBuilder: (context, index) {
                final f = _filteredForemen[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  elevation: 3,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Name: ${f['name']}', style: const TextStyle(fontWeight: FontWeight.bold)),
                        Text('IC Number: ${f['ic']}'),
                        Text('Phone: ${f['phone']}'),
                        Text('Email: ${f['email']}'),
                        Text('Experience: ${f['experience']}'),
                        Text('Specialization: ${f['specialization']}'),
                        Text('Status: ${f['status']}'),
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
