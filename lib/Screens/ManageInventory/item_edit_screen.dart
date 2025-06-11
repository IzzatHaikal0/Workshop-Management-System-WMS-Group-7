import 'package:flutter/material.dart';
import 'package:workshop_management_system/Controllers/ManageInventory/item_controller.dart';
import 'package:workshop_management_system/Models/ManageInventory/item_model.dart';
import 'package:workshop_management_system/Screens/ManageInventory/widgets/custom_text.dart';
import 'package:workshop_management_system/Screens/ManageInventory/widgets/item_form.dart';

class ItemEditScreen extends StatefulWidget {
  final Item item;

  const ItemEditScreen({super.key, required this.item});

  @override
  State<ItemEditScreen> createState() => _ItemEditScreenState();
}

class _ItemEditScreenState extends State<ItemEditScreen> {
  final ItemController _itemController = ItemController();
  bool _isLoading = false;

  Future<void> _updateItem(
    String itemName,
    String itemCategory,
    int quantity,
    double unitPrice,
  ) async {
    if (widget.item.id == null) return;

    setState(() => _isLoading = true);

    try {
      final updatedItem = await _itemController.updateItem(
        widget.item.id!,
        itemName,
        itemCategory,
        quantity,
        unitPrice,
      );

      if (mounted && updatedItem != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Item updated successfully')),
        );
        Navigator.pop(context, updatedItem);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error updating item: $e')));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit Item',
          style: MyTextStyles.bold.copyWith(
            fontSize: 14,
            color: Color.fromARGB(255, 0, 0, 0),
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      ),
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : ItemForm(
                /** EDIT ITEM BUTTON, USE ITEM FORM WIDGET */
                initialItem: widget.item,
                onSubmit: _updateItem,
                submitButtonText: 'Update Item',
              ),
    );
  }
}
