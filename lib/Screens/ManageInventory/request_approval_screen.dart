import 'package:flutter/material.dart';
import 'package:workshop_management_system/Controllers/ManageInventory/request_controller.dart';
import 'package:workshop_management_system/Models/ManageInventory/request_model.dart';
import 'package:workshop_management_system/Screens/ManageInventory/widgets/custom_text.dart';
import 'package:workshop_management_system/Screens/ManageInventory/widgets/request_card.dart';

class RequestApprovalScreen extends StatefulWidget {
  const RequestApprovalScreen({super.key});

  @override
  State<RequestApprovalScreen> createState() => _RequestApprovalScreenState();
}

class _RequestApprovalScreenState extends State<RequestApprovalScreen> {
  final RequestController _requestController = RequestController();
  final TextEditingController _searchController = TextEditingController();
  String _searchText = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Request> _filterBySearch(List<Request> requests) {
    if (_searchText.isEmpty) return requests;

    return requests.where((request) {
      return request.itemName.toLowerCase().contains(_searchText.toLowerCase());
    }).toList();
  }

  Future<void> _handleApproval(Request request, bool isApproved) async {
    final TextEditingController notesController = TextEditingController();

    final result = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(
              isApproved ? 'Approve Request' : 'Reject Request',
              style: MyTextStyles.medium,
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Item: ${request.itemName}', style: MyTextStyles.regular),
                Text(
                  'Quantity: ${request.quantity}',
                  style: MyTextStyles.regular,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: notesController,
                  decoration: const InputDecoration(
                    labelText: 'Notes (optional)',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                style: TextButton.styleFrom(
                  foregroundColor: isApproved ? Colors.green : Colors.red,
                ),
                child: Text(isApproved ? 'Approve' : 'Reject'),
              ),
            ],
          ),
    );

    if (result == true && request.id != null) {
      try {
        if (isApproved) {
          await _requestController.approveRequest(
            request.id!,
            notesController.text,
          );
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'Request approved successfully',
                  style: MyTextStyles.regular,
                ),
              ),
            );
          }
        } else {
          await _requestController.rejectRequest(
            request.id!,
            notesController.text,
          );
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'Request rejected successfully',
                  style: MyTextStyles.regular,
                ),
              ),
            );
          }
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $e', style: MyTextStyles.regular)),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),

      body: Column(
        children: [
          // search
          Container(
            padding: const EdgeInsets.all(16.0),
            color: const Color.fromARGB(255, 250, 250, 250),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search items...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: const Color.fromARGB(255, 250, 250, 250),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Color.fromARGB(255, 219, 225, 244),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.grey, width: 1.5),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _searchText = value;
                });
              },
            ),
          ),
          // list
          Expanded(
            child: StreamBuilder<List<Request>>(
              stream: _requestController.getPendingApprovalsStream(),
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
                          style: MyTextStyles.regular,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Please try again later',
                          style: MyTextStyles.medium,
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
                          Icons.assignment_turned_in_outlined,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          allRequests.isEmpty
                              ? 'No pending approvals'
                              : 'No matching requests',
                          style: MyTextStyles.bold,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          allRequests.isEmpty
                              ? 'All requests have been processed'
                              : 'Try adjusting your search',
                          style: MyTextStyles.regular,
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
                          showApprovalActions: true,
                          onApprove: () => _handleApproval(request, true),
                          onReject: () => _handleApproval(request, false),
                          onTap: () {
                            // Show request details
                            showDialog(
                              context: context,
                              builder:
                                  (context) => AlertDialog(
                                    title: Text(
                                      request.itemName,
                                      style: MyTextStyles.bold,
                                    ),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Quantity: ${request.quantity}',
                                          style: MyTextStyles.regular,
                                        ),
                                        Text(
                                          'Request Date: ${request.requestDate.day}/${request.requestDate.month}/${request.requestDate.year}',
                                          style: MyTextStyles.regular,
                                        ),
                                        if (request.notes != null &&
                                            request.notes!.isNotEmpty)
                                          Text(
                                            'Notes: ${request.notes}',
                                            style: MyTextStyles.regular,
                                          ),
                                      ],
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: const Text(
                                          'Close',
                                          style: MyTextStyles.regular,
                                        ),
                                      ),
                                    ],
                                  ),
                            );
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
    );
  }
}
