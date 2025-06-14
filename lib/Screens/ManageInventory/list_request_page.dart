import 'package:flutter/material.dart';
import 'package:workshop_management_system/Controllers/ManageInventory/request_controller.dart';
import 'package:workshop_management_system/Models/ManageInventory/inventory_barrel.dart';
import 'package:workshop_management_system/Screens/ManageInventory/inventory_barrel.dart';
import 'package:workshop_management_system/Screens/ManageInventory/widgets/custom_text.dart';

class ListRequestPage extends StatefulWidget {
  const ListRequestPage({super.key});

  @override
  State<ListRequestPage> createState() => _ListRequestPageState();
}

class _ListRequestPageState extends State<ListRequestPage> {
  final RequestController _requestController = RequestController();
  String _selectedStatus = 'All';
  final TextEditingController _searchController = TextEditingController();
  String _searchText = '';
  int _selectedSegment = 0;

  /// STATUS OPTIONS LISTS
  final List<String> _statusOptions = [
    'All',
    'pending',
    'accepted',
    'rejected',
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _buildTopBar(),
          _buildSegmentedHeader(),
          if (_selectedSegment == 0) ...[
            _buildSearchAndFilterSection(),
            Expanded(child: _buildMyRequestsView()),
          ] else if (_selectedSegment == 1) ...[
            Expanded(child: const IncomingRequestPage()),
          ],
        ],
      ),
    );
  }

  Widget _buildTopBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF4169E1)),
            onPressed: () => Navigator.pop(context),
          ),
          Expanded(
            child: Center(
              child: Text(
                'Request',
                style: MyTextStyles.bold.copyWith(
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  ///WIDGET FOR SEGMENTED BUTTON
  Widget _buildSegmentedHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0x1E787880),
          borderRadius: BorderRadius.circular(9),
        ),
        child: Row(
          children: [
            _buildSegmentButton(0, 'My Requests'),
            _buildSegmentButton(1, 'Others'),
          ],
        ),
      ),
    );
  }

  Widget _buildSegmentButton(int index, String label) {
    final bool isSelected = _selectedSegment == index;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedSegment = index;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(7),
            boxShadow:
                isSelected
                    ? [
                      BoxShadow(
                        color: Colors.black.withAlpha(25),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ]
                    : [],
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 13,
                color: isSelected ? Colors.black : Colors.black54,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchAndFilterSection() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      color: Colors.grey[50],
      child: Column(
        children: [
          /**SEARCH SECTION */
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search requests...',
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
          const SizedBox(height: 12),
          const SizedBox(height: 12),
          Row(
            children: [
              /**STATUS FILTER DROPDOWN */
              Container(
                height: 40,
                width: 150,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFFFAFAFA),
                  border: Border.all(color: const Color(0xFFDBE1F4)),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedStatus,
                    icon: const Icon(Icons.arrow_drop_down, color: Colors.grey),
                    style: MyTextStyles.medium.copyWith(
                      color: const Color(0xFF006FFD),
                      fontSize: 12,
                    ),
                    items:
                        _statusOptions.map((String category) {
                          return DropdownMenuItem<String>(
                            value: category,
                            child: Text(category),
                          );
                        }).toList(),
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        setState(() {
                          _selectedStatus = newValue;
                        });
                      }
                    },
                  ),
                ),
              ),
              const SizedBox(width: 12),
              SizedBox(
                height: 40,
                width: 80,
                child: ElevatedButton(
                  /**ADD BUTTON */
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const AddRequestPage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: const Color(0xFFFAFAFA),
                    foregroundColor: const Color(0xFF006FFD),
                    side: const BorderSide(color: Color(0xFFDBE1F4)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Add',
                    style: MyTextStyles.medium.copyWith(fontSize: 12),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMyRequestsView() {
    return StreamBuilder<List<Request>>(
      stream: _getFilteredRequests(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
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
                  allRequests.isEmpty
                      ? 'No requests found'
                      : 'No matching requests',
                  style: MyTextStyles.bold,
                ),
                const SizedBox(height: 8),
                Text(
                  allRequests.isEmpty
                      ? 'Create your first request'
                      : 'Try adjusting your search or filter',
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
                  onTap: () => _showRequestDetails(context, request),
                ),
              );
            },
          ),
        );
      },
    );
  }

  void _showRequestDetails(BuildContext context, Request request) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            /**SHOW DIALOG TO DISPLAY REQUEST DETAILS */
            backgroundColor: Colors.white,
            title: Text(request.itemName, style: MyTextStyles.semiBold),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Quantity: ${request.quantity}',
                  style: MyTextStyles.regular,
                ),
                Text(
                  'Status: ${request.status.toUpperCase()}',
                  style: MyTextStyles.regular,
                ),
                Text(
                  'Request Date: ${request.requestDate.day}/${request.requestDate.month}/${request.requestDate.year}',
                  style: MyTextStyles.regular,
                ),
                if (request.notes != null && request.notes!.isNotEmpty)
                  Text('Notes: ${request.notes}', style: MyTextStyles.regular),
                if (request.approvedDate != null)
                  Text(
                    'Approved Date: ${request.approvedDate!.day}/${request.approvedDate!.month}/${request.approvedDate!.year}',
                    style: MyTextStyles.regular,
                  ),
                Text(
                  request.shippedDate != null
                      ? 'Shipped Date: ${request.shippedDate!.day}/${request.shippedDate!.month}/${request.shippedDate!.year}'
                      : 'Shipped Date: Not shipped yet',
                  style: MyTextStyles.regular,
                ),
              ],
            ),
            actions: [
              /**CAN DELETE OR CLOSE THE DIALOG AS LONG*/
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close', style: MyTextStyles.regular),
              ),
              if (request.status == 'pending' ||
                  request.status == 'rejected' ||
                  request.status == 'accepted')
                TextButton(
                  onPressed: () async {
                    Navigator.pop(context);
                    final success = await _requestController.deleteRequest(
                      request.id!,
                    );
                    if (!mounted) return;
                    if (success) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Request deleted successfully',
                            style: MyTextStyles.regular,
                          ),
                        ),
                      );
                    }
                  },
                  style: TextButton.styleFrom(foregroundColor: Colors.red),
                  child: const Text('Delete', style: MyTextStyles.regular),
                ),
            ],
          ),
    );
  }
}
