// lib/Screens/ManageReport/GenerateReportPage.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:csv/csv.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:open_file/open_file.dart';

class GenerateReportPage extends StatefulWidget {
  final String workshopOwnerId;
    const GenerateReportPage({super.key, required this.workshopOwnerId});
  
  @override
  State<GenerateReportPage> createState() => _GenerateReportPageState();
}

class _GenerateReportPageState extends State<GenerateReportPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _searchQuery = '';

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  Future<List<Map<String, dynamic>>> fetchUsers(String collection) async {
    final querySnapshot = await FirebaseFirestore.instance.collection(collection).get();
    return querySnapshot.docs.map((doc) {
      final data = doc.data();
      return {
        'name': '${data['firstName'] ?? ''} ${data['lastName'] ?? ''}',
        'email': data['email'] ?? '',
        'phone': data['phoneNumber'] ?? '',
        'role': collection == 'foremen' ? 'Foreman' : 'Workshop Owner',
      };
    }).toList();
  }

  Future<void> exportToCsv(List<Map<String, dynamic>> users) async {
    List<List<String>> rows = [
      ['Name', 'Email', 'Phone', 'Role'],
      ...users.map((u) => [u['name'], u['email'], u['phone'], u['role']]),
    ];
    String csv = const ListToCsvConverter().convert(rows);

    final directory = await getApplicationDocumentsDirectory();
    final path = '${directory.path}/user_report.csv';
    final file = File(path);
    await file.writeAsString(csv);

    OpenFile.open(file.path);
  }

  Future<void> exportToPdf(List<Map<String, dynamic>> users) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (context) {
          return pw.Column(
            children: [
              pw.Text("User Report", style: pw.TextStyle(fontSize: 24)),
              pw.SizedBox(height: 16),
              pw.Table.fromTextArray(
                headers: ['Name', 'Email', 'Phone', 'Role'],
                data: users.map((u) => [u['name'], u['email'], u['phone'], u['role']]).toList(),
              )
            ],
          );
        },
      ),
    );

    final directory = await getApplicationDocumentsDirectory();
    final path = '${directory.path}/user_report.pdf';
    final file = File(path);
    await file.writeAsBytes(await pdf.save());

    OpenFile.open(file.path);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Generate Report'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Foremen'),
            Tab(text: 'Workshop Owners'),
          ],
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Search by name or email',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) => setState(() {
                _searchQuery = value.toLowerCase();
              }),
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildUserList('foremen'),
                _buildUserList('workshop_owner'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserList(String collection) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: fetchUsers(collection),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

        final users = snapshot.data!
            .where((u) =>
                u['name'].toLowerCase().contains(_searchQuery) ||
                u['email'].toLowerCase().contains(_searchQuery))
            .toList();

        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  icon: const Icon(Icons.picture_as_pdf),
                  label: const Text("Export PDF"),
                  onPressed: () => exportToPdf(users),
                ),
                TextButton.icon(
                  icon: const Icon(Icons.table_chart),
                  label: const Text("Export CSV"),
                  onPressed: () => exportToCsv(users),
                ),
              ],
            ),
            Expanded(
              child: ListView.builder(
                itemCount: users.length,
                itemBuilder: (_, index) {
                  final user = users[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    child: ListTile(
                      title: Text(user['name']),
                      subtitle: Text('${user['email']} • ${user['phone']}'),
                      trailing: Text(user['role']),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
