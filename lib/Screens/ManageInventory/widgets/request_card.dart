/*import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/inventory/request_model.dart';

class RequestCard extends StatefulWidget {
  final WorkshopRequest request;
  final User currentUser;
  final bool isWorkshopOwner;
  final bool canDelete;
  final Function(String)? onDelete;
  final Function(String, String)? onStatusUpdate;
  
  const RequestCard({
    super.key,
    required this.request,
    required this.currentUser,
    this.isWorkshopOwner = false,
    this.canDelete = false,
    this.onDelete,
    this.onStatusUpdate,
  });

  @override
  // ignore: library_private_types_in_public_api
  _RequestCardState createState() => _RequestCardState();
}

class _RequestCardState extends State<RequestCard> {
  bool isExpanded = false;
  
  String formatDate(String dateString) {
    final date = DateTime.parse(dateString);
    return DateFormat('MMM d, yyyy').format(date);
  }
  
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.request.title,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            widget.isWorkshopOwner
                                ? 'From: ${widget.request.requesterName}'
                                : 'To: ${widget.request.workshopOwnerName}',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        _buildStatusBadge(widget.request.status),
                        IconButton(
                          icon: Icon(
                            isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                            color: Colors.grey,
                          ),
                          onPressed: () {
                            setState(() {
                              isExpanded = !isExpanded;
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Created: ${formatDate(widget.request.createdAt)}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                    Text(
                      '${widget.request.items.length} item${widget.request.items.length != 1 ? 's' : ''}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (isExpanded)
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: Colors.grey[200]!),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.request.description.isNotEmpty) ...[
                    const Text(
                      'Description:',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.request.description,
                      style: const TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 16),
                  ],
                  
                  const Text(
                    'Items:',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: widget.request.items.length,
                    itemBuilder: (context, index) {
                      final item = widget.request.items[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(item.name),
                            Text('Qty: ${item.quantity}'),
                          ],
                        ),
                      );
                    },
                  ),
                  
                  if (widget.request.status == 'rejected' && widget.request.reason != null) ...[
                    const SizedBox(height: 16),
                    const Text(
                      'Rejection Reason:',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.request.reason!,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                  
                  const SizedBox(height: 16),
                  
                  // Action buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      if (widget.isWorkshopOwner && widget.request.status == 'pending') ...[
                        OutlinedButton.icon(
                          icon: const Icon(Icons.close, color: Colors.red),
                          label: const Text('REJECT'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.red, side: const BorderSide(color: Colors.red),
                          ),
                          onPressed: () {
                            widget.onStatusUpdate?.call(widget.request.id, 'reject');
                          },
                        ),
                        const SizedBox(width: 8),
                        OutlinedButton.icon(
                          icon: const Icon(Icons.check, color: Colors.green),
                          label: const Text('ACCEPT'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.green, side: const BorderSide(color: Colors.green),
                          ),
                          onPressed: () {
                            widget.onStatusUpdate?.call(widget.request.id, 'accept');
                          },
                        ),
                  ]
                    ]
                  )
                  ]
              )
            )
        ]
    )
    );
  }
}
*/
/*
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../Models/ManageInventory/request_model.dart';
import '../../../Controllers/ManageInventory/request_controller.dart';


class RequestCard extends StatelessWidget {
  final ItemRequest request;
  final bool isIncoming;
  final RequestController controller;

  const RequestCard({
    super.key,
    required this.request,
    required this.isIncoming,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    request.itemName,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                _buildStatusChip(request.status),
              ],
            ),
            const SizedBox(height: 8),
            Text('Quantity: ${request.quantity}'),
            const SizedBox(height: 4),
            Text(
              '${isIncoming ? 'From' : 'To'}: ${isIncoming ? request.requestedBy : request.requestedTo}',
            ),
            const SizedBox(height: 4),
            Text(
              'Date: ${DateFormat('MMM dd, yyyy').format(request.requestDate)}',
            ),
            if (isIncoming && request.status == 'pending')
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color color;
    switch (status.toLowerCase()) {
      case 'approved':
        color = Colors.green;
        break;
      case 'rejected':
        color = Colors.red;
        break;
      case 'pending':
      default:
        color = Colors.orange;
        break;
    }

    return Chip(
      label: Text(
        status.toUpperCase(),
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
        ),
      ),
      backgroundColor: color,
      padding: const EdgeInsets.symmetric(horizontal: 8),
    );
  }
}
*/