// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:workshop_management_system/Controllers/ManageInventory/request_controller.dart';
import 'package:workshop_management_system/Models/ManageInventory/inventory_barrel.dart';
import 'package:workshop_management_system/Screens/ManageInventory/inventory_barrel.dart';

class RequestListScreen extends StatefulWidget {
  const RequestListScreen({super.key});

  @override
  State<RequestListScreen> createState() => _RequestListScreenState();
}

class _RequestListScreenState extends State<RequestListScreen> {
  final RequestController _requestController = RequestController();
  String _selectedStatus = 'All';
  final TextEditingController _searchController = TextEditingController();
  String _searchText = '';

  final List<String> _statusOptions = [
    'All',
    'pending',
    'approved',
    'rejected'
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Stream<List<Request>> _getFilteredRequests() {
    if (_selectedStatus == 'All') {
      return _requestController.getMyRequestsStream();
    } else {
      return _requestController.getRequestsByStatusStream(_selectedStatus);
    }
  }

  List<Request> _filterBySearch(List<Request> requests) {
    if (_searchText.isEmpty) return requests;
    
    return requests.where((request) {
      return request.itemName.toLowerCase().contains(_searchText.toLowerCase());
    }).toList();
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'pending':
        return Colors.orange;
      case 'approved':
        return Colors.blue;
      case 'rejected':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Header Section (replacing AppBar)
          Container(
            padding: const EdgeInsets.only(top: 40, left: 16, right: 16, bottom: 16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.inversePrimary,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => Navigator.pop(context),
                ),
                const Expanded(
                  child: Text(
                    'My Requests',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.approval),
                  tooltip: 'Pending Approvals',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const RequestApprovalScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          // Search and Filter Section
          Container(
            padding: const EdgeInsets.all(16.0),
            color: Colors.grey[50],
            child: Column(
              children: [
                // Search Bar
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search requests...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _searchText = value;
                    });
                  },
                ),
                const SizedBox(height: 12),
                // Status Filter
                SizedBox(
                  height: 40,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _statusOptions.length,
                    itemBuilder: (context, index) {
                      final status = _statusOptions[index];
                      final isSelected = _selectedStatus == status;
                      
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: FilterChip(
                          label: Text(status == 'All' ? 'All' : status.toUpperCase()),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() {
                              _selectedStatus = status;
                            });
                          },
                          backgroundColor: Colors.white,
                          selectedColor: _getStatusColor(status).withOpacity(0.2),
                          checkmarkColor: _getStatusColor(status),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          // Requests List
          Expanded(
            child: StreamBuilder<List<Request>>(
              stream: _getFilteredRequests(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 64,
                          color: Colors.red[300],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Error loading requests',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Please try again later',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  );
                }

                final allRequests = snapshot.data ?? [];
                final filteredRequests = _filterBySearch(allRequests);

                if (filteredRequests.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.assignment_outlined,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          allRequests.isEmpty ? 'No requests found' : 'No matching requests',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          allRequests.isEmpty 
                            ? 'Create your first request' 
                            : 'Try adjusting your search or filter',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () async {
                    setState(() {});
                  },
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16.0),
                    itemCount: filteredRequests.length,
                    itemBuilder: (context, index) {
                      final request = filteredRequests[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: RequestCard(
                          request: request,
                          onTap: () {
                            _showRequestDetails(context, request);
                          },
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const RequestCreateScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showRequestDetails(BuildContext context, Request request) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(request.itemName),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Quantity: ${request.quantity}'),
            Text('Status: ${request.status.toUpperCase()}'),
            Text('Request Date: ${request.requestDate.day}/${request.requestDate.month}/${request.requestDate.year}'),
            if (request.notes != null && request.notes!.isNotEmpty)
              Text('Notes: ${request.notes}'),
            if (request.approvedDate != null)
              Text('Approved Date: ${request.approvedDate!.day}/${request.approvedDate!.month}/${request.approvedDate!.year}'),
           Text('Shipped Date: ${request.approvedDate!.day}/${request.approvedDate!.month}/${request.approvedDate!.year}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          if (request.status == 'pending' || request.status == 'rejected' || request.status == 'approved')
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                final success = await _requestController.deleteRequest(request.id!);
                if (success) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Request deleted successfully')),
                  );
                }
              },
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Delete'),
            ),
        ],
      ),
    );
  }
}