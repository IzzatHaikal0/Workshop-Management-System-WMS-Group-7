import 'package:flutter/material.dart';
import 'package:workshop_management_system/Models/ManageInventory/request_model.dart';
import 'package:workshop_management_system/Screens/ManageInventory/widgets/custom_text.dart';

class RequestCard extends StatelessWidget {
  final Request request;
  final VoidCallback? onTap;
  final bool showApprovalActions;
  final VoidCallback? onApprove;
  final VoidCallback? onReject;

  const RequestCard({
    super.key,
    required this.request,
    this.onTap,
    this.showApprovalActions = false,
    this.onApprove,
    this.onReject,
  });
  /* RETURN DATE FORMAT (dd,mm,yyyy) */
  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(width: 12),

                  /* REQUEST DETAILS */
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          request.itemName,
                          style: MyTextStyles.bold.copyWith(fontSize: 14),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const SizedBox(width: 4),
                            Text(
                              'Qty: ${request.quantity}',
                              style: MyTextStyles.medium.copyWith(
                                fontSize: 10,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              /* REQUESTED DATE, APPROVED DATE */
              Row(
                children: [
                  Icon(Icons.calendar_today, size: 14, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Text(
                    'Requested: ${_formatDate(request.requestDate)}',
                    style: MyTextStyles.semiBold.copyWith(
                      fontSize: 10,
                      color: Colors.grey[600],
                    ),
                  ),
                  if (request.approvedDate != null) ...[
                    const SizedBox(width: 16),
                    Icon(
                      Icons.event_available,
                      size: 14,
                      color: Colors.grey[600],
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Processed: ${_formatDate(request.approvedDate!)}',
                      style: MyTextStyles.semiBold.copyWith(
                        fontSize: 10,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ],
              ),

              /* NOTES */
              if (request.notes != null && request.notes!.isNotEmpty) ...[
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF4169E1).withAlpha(25),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    request.notes!,
                    style: MyTextStyles.medium.copyWith(fontSize: 12),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],

              /* ACCEPT/APPROVE ACTION */
              if (showApprovalActions && request.status == 'pending') ...[
                const SizedBox(height: 12),
                const Divider(height: 1),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: onApprove,
                        style: TextButton.styleFrom(
                          foregroundColor: Color(0xFF006FFD),
                        ),
                        child: const Text(('Accept'), style: MyTextStyles.bold),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextButton(
                        onPressed: onReject,
                        style: TextButton.styleFrom(
                          foregroundColor: Color(0xFF006FFD),
                        ),
                        child: const Text(('Reject'), style: MyTextStyles.bold),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
