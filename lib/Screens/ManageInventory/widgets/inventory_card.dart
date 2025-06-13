import 'package:flutter/material.dart';
import 'package:workshop_management_system/Models/ManageInventory/item_model.dart';
import 'package:workshop_management_system/Screens/ManageInventory/widgets/custom_text.dart';

class InventoryCard extends StatelessWidget {
  final Item item;
  final VoidCallback onTap;

  const InventoryCard({super.key, required this.item, required this.onTap});
  /*  RETURN STOCK COLOR BASED ON QUANTITY LEVEL*/
  Color _getStockStatusColor() {
    if (item.quantity == 0) return Colors.red;
    if (item.quantity <= 5) return Colors.orange;
    return Colors.green;
  }

  /* RETURN TEXT LABEL BASED ON STOCK LEVEL */
  String _getStockStatus() {
    if (item.quantity == 0) return 'Out of Stock';
    if (item.quantity <= 5) return 'Low Stock';
    return 'In Stock';
  }

  /*  RETURN ICON BASED ON ITEM CATEGORY*/
  IconData _getCategoryIcon() {
    switch (item.itemCategory.toLowerCase()) {
      case 'tools':
        return Icons.build;
      case 'parts':
        return Icons.precision_manufacturing;
      case 'materials':
        return Icons.inventory;
      case 'equipment':
        return Icons.construction;
      case 'consumables':
        return Icons.local_gas_station;
      case 'other':
        return Icons.category;
      default:
        return Icons.inventory_2;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              /* CATEGORY ICON */
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withAlpha(25),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  _getCategoryIcon(),
                  color: Theme.of(context).primaryColor,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),

              /* ITEM DETAILS */
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      /* ITEM NAME */
                      item.itemName,
                      style: MyTextStyles.bold.copyWith(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),

                    /* ITEM CATEGORY */
                    Text(
                      item.itemCategory,
                      style: MyTextStyles.regular.copyWith(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 8),

                    /* STOCK STATUS AND QTY */
                    Row(
                      children: [
                        /* BADGE CONTAINER */
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: _getStockStatusColor().withAlpha(25),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            _getStockStatus(),
                            style: MyTextStyles.semiBold.copyWith(
                              color: _getStockStatusColor(),
                              fontSize: 11,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          /* QUANTITY */
                          'Qty: ${item.quantity}',
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

              /* PRICE AND TOTAL */
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    /* PRICE PER UNIT */
                    'RM ${item.unitPrice.toStringAsFixed(2)}',
                    style: MyTextStyles.semiBold.copyWith(
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    /* TOTAL = PRICE * QTY */
                    'Total: RM ${(item.quantity * item.unitPrice).toStringAsFixed(2)}',
                    style: MyTextStyles.regular.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                  /* ICON TO VIEW ITEM DETAILS */
                  const SizedBox(height: 8),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: Colors.grey[400],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
