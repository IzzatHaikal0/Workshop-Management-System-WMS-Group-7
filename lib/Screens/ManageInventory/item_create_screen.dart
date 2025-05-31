import 'package:flutter/material.dart';
import 'package:workshop_management_system/Controllers/ManageInventory/item_controller.dart';
import 'package:workshop_management_system/Screens/ManageInventory/widgets/item_form.dart';

class ItemCreateScreen extends StatefulWidget {
  const ItemCreateScreen({super.key});

  @override
  State<ItemCreateScreen> createState() => _ItemCreateScreenState();
}

class _ItemCreateScreenState extends State<ItemCreateScreen> {
  final ItemController _itemController = ItemController();
  bool _isLoading = false;

  Future<void> _createItem(String itemName, String itemCategory, int quantity, double unitPrice) async {
    setState(() => _isLoading = true);

    try {
      final newItem = await _itemController.createItem(itemName, itemCategory, quantity, unitPrice);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Item created successfully')),
        );
        Navigator.pop(context, newItem);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error creating item: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Item'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ItemForm(
              onSubmit: _createItem,
              submitButtonText: 'Create Item',
            ),
    );
  }
}