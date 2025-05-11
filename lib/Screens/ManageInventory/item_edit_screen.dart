// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import '../../../Controllers/ManageInventory/item_controller.dart';
import '../../Models/ManageInventory/item_model.dart';
import '../ManageInventory/widgets/item_form.dart';

class ItemEditScreen extends StatelessWidget {
  final Item item;

  const ItemEditScreen({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    // ignore: no_leading_underscores_for_local_identifiers
    final ItemController _itemController = ItemController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Item'),
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Edit Item Details',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              ItemForm(
                initialItemName: item.itemName,
                initialItemCategory: item.itemCategory,
                initialQuantity: item.quantity,
                initialUnitPrice: item.unitPrice,
                onSubmit: (itemName, itemCategory, quantity, unitPrice) async {
                  try{
                    await _itemController.updateItem(
                      item.id, 
                      itemName, 
                      itemCategory, 
                      quantity, 
                      unitPrice
                    );
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Item updated successfully')),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Failed to update item: $e')),
                    );
                  }
                } 
              ),
            ],
          ),
        ),
      ),
    );
  }
}