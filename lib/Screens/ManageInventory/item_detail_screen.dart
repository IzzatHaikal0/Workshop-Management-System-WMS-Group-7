import 'package:flutter/material.dart';
import 'package:workshop_management_system/Controllers/ManageInventory/item_controller.dart';
import 'package:workshop_management_system/Models/ManageInventory/item_model.dart';
import 'package:workshop_management_system/Screens/ManageInventory/item_edit_screen.dart';

class ItemDetailScreen extends StatefulWidget {
  final Item item;

  const ItemDetailScreen({super.key, required this.item});

  @override
  State<ItemDetailScreen> createState() => _ItemDetailScreenState();
}

class _ItemDetailScreenState extends State<ItemDetailScreen> {
  final ItemController _itemController = ItemController();
  late Item _currentItem;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _currentItem = widget.item;
  }

  Future<void> _deleteItem() async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Item'),
        content: Text('Are you sure you want to delete "${_currentItem.itemName}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (shouldDelete == true && _currentItem.id != null) {
      setState(() => _isLoading = true);
      
      try {
        final success = await _itemController.deleteItem(_currentItem.id!);
        if (success && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Item deleted successfully')),
          );
          Navigator.pop(context, true); // Indicate item was deleted
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error deleting item: $e')),
          );
        }
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    }
  }

  String _formatDateTime(DateTime? dateTime) {
    if (dateTime == null) return 'Not available';
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  Color _getStockStatusColor() {
    if (_currentItem.quantity == 0) return Colors.red;
    if (_currentItem.quantity <= 5) return Colors.orange;
    return Colors.green;
  }

  String _getStockStatus() {
    if (_currentItem.quantity == 0) return 'Out of Stock';
    if (_currentItem.quantity <= 5) return 'Low Stock';
    return 'In Stock';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_currentItem.itemName),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            onPressed: _isLoading ? null : () async {
              final updatedItem = await Navigator.push<Item>(
                context,
                MaterialPageRoute(
                  builder: (context) => ItemEditScreen(item: _currentItem),
                ),
              );
              if (updatedItem != null) {
                setState(() {
                  _currentItem = updatedItem;
                });
              }
            },
            icon: const Icon(Icons.edit),
          ),
          IconButton(
            onPressed: _isLoading ? null : _deleteItem,
            icon: const Icon(Icons.delete),
            color: Colors.red,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // header for card
                  Card(
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Row(
                        children: [
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              Icons.inventory_2,
                              size: 30,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _currentItem.itemName,
                                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    // ignore: deprecated_member_use
                                    color: _getStockStatusColor().withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Text(
                                    _getStockStatus(),
                                    style: TextStyle(
                                      color: _getStockStatusColor(),
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // details
                  Card(
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Item Details',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          _buildDetailRow('Category', _currentItem.itemCategory),
                          _buildDetailRow('Quantity', _currentItem.quantity.toString()),
                          _buildDetailRow('Unit Price', 'RM ${_currentItem.unitPrice.toStringAsFixed(2)}'),
                          _buildDetailRow('Total Value', 'RM ${(_currentItem.quantity * _currentItem.unitPrice).toStringAsFixed(2)}'),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // time
                  Card(
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Timestamps',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          _buildDetailRow('Created At', _formatDateTime(_currentItem.createdAt)),
                          if (_currentItem.updatedAt != null)
                            _buildDetailRow('Last Updated', _formatDateTime(_currentItem.updatedAt)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey,
              ),
            ),
          ),
          const Text(': '),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}