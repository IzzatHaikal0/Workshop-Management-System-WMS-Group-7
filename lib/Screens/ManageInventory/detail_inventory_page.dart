import 'package:flutter/material.dart';
import 'package:workshop_management_system/Controllers/ManageInventory/item_controller.dart';
import 'package:workshop_management_system/Models/ManageInventory/item_model.dart';
import 'package:workshop_management_system/Screens/ManageInventory/edit_inventory_page.dart';
import 'package:workshop_management_system/Screens/ManageInventory/widgets/custom_text.dart';

class DetailInventoryPage extends StatefulWidget {
  final Item item;

  const DetailInventoryPage({super.key, required this.item});

  @override
  State<DetailInventoryPage> createState() => _DetailInventoryPageState();
}

class _DetailInventoryPageState extends State<DetailInventoryPage> {
  final ItemController _itemController = ItemController();
  late Item _currentItem;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _currentItem = widget.item;
  }

  //BUTTON FOR DELETION
  Future<void> _deleteItem() async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            actionsAlignment: MainAxisAlignment.center,
            title: const Text(('Delete'), style: MyTextStyles.medium, textAlign: TextAlign.center,
            ),
            content: Text(
              ('Are you sure you want to delete "${_currentItem.itemName}"?'),
              style: MyTextStyles.regular, textAlign: TextAlign.center,
            ),
            //DIALOG
            actions: [
              //CANCEL ACTION BUTTON
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                style: TextButton.styleFrom(
                  foregroundColor:  Color(0xFF006FFD),
                ),
                child: const Text(('Cancel'), style: MyTextStyles.regular),
              ),
              //DELETE ACTION BUTTON
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                style: TextButton.styleFrom(foregroundColor:  Colors.white,backgroundColor: Color(0xFF006FFD),
                ),
                child: const Text('Delete', style: MyTextStyles.regular),
              ),
            ],
          ),
    );
    // HANDLE DELETE FUNCTION
    if (shouldDelete == true && _currentItem.id != null) {
      setState(() => _isLoading = true);

      try {
        final success = await _itemController.deleteItem(_currentItem.id!);
        if (success && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                ('Item deleted successfully'),
                style: MyTextStyles.regular,
              ),
            ),
          );
          Navigator.pop(context, true);
        }
      } catch (e) {
        //ERROR MESSAGE
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                ('Error deleting item: $e'),
                style: MyTextStyles.regular,
              ),
            ),
          );
        }
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    }
  }

  //DATETIME FORMAT 
  String _formatDateTime(DateTime? dateTime) {
    if (dateTime == null) return 'Not available';
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  //STOCK STATUS COLOR
  Color _getStockStatusColor() {
    if (_currentItem.quantity == 0) return Colors.red;
    if (_currentItem.quantity <= 5) return Colors.orange;
    return Colors.green;
  }

  //STOCK STATUS TEXT
  String _getStockStatus() {
    if (_currentItem.quantity == 0) return 'Out of Stock';
    if (_currentItem.quantity <= 5) return 'Low Stock';
    return 'In Stock';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _currentItem.itemName,
          style: MyTextStyles.bold.copyWith(fontSize: 16, color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        actions: [
          //EDIT ICON BUTTON
          IconButton(
            icon: const Icon(Icons.edit,  color: Color(0xFF4169E1)),
            onPressed:
                _isLoading
                    ? null
                    : () async {
                      final updatedItem = await Navigator.push<Item>(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => EditInventoryPage(item: _currentItem),
                        ),
                      );
                      if (updatedItem != null) {
                        setState(() => _currentItem = updatedItem);
                      }
                    },
          ),
          //DELETE ICON BUTTON
          IconButton(
            icon: const Icon(Icons.delete, color: Color(0xFF4169E1)),
            onPressed: _isLoading ? null : _deleteItem,
          ),
        ],
      ),
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      //BODY
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 12.0,
                ),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildHeaderCard(context),
                        const SizedBox(height: 24),
                        _buildSectionTitle(context, 'Details'),
                        const SizedBox(height: 16),
                        _buildDetailRow('Category', _currentItem.itemCategory),
                        _buildDetailRow(
                          'Quantity',
                          _currentItem.quantity.toString(),
                        ),
                        _buildDetailRow(
                          'Price Per Unit',
                          'RM ${_currentItem.unitPrice.toStringAsFixed(2)}',
                        ),
                        _buildDetailRow(
                          'Total Value',
                          'RM ${(_currentItem.quantity * _currentItem.unitPrice).toStringAsFixed(2)}',
                        ),
                        _buildDetailRow(
                          'Created At',
                          _formatDateTime(_currentItem.createdAt),
                        ),
                        if (_currentItem.updatedAt != null)
                          _buildDetailRow(
                            'Last Updated',
                            _formatDateTime(_currentItem.updatedAt),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
    );
  }
  //HEADER WIDGET
  Widget _buildHeaderCard(BuildContext context) {
    return Row(
      children: [
        ///icon
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
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
              Text(_currentItem.itemName, style: MyTextStyles.bold.copyWith()),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _getStockStatusColor().withAlpha(25),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  _getStockStatus(),
                  style: MyTextStyles.semiBold.copyWith(
                    color: _getStockStatusColor(),
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
  //SECTION TITLE
  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(title, style: MyTextStyles.bold.copyWith());
  }
  //DETAIL ROW WIDGET
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
              style: MyTextStyles.medium.copyWith(color: Colors.grey),
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
