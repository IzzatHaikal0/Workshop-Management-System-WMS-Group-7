// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import '../../Controllers/ManageInventory/item_controller.dart';
import '../ManageInventory/widgets/item_form.dart';

class ItemCreateScreen extends StatelessWidget {
  final ItemController _itemController = ItemController();

  ItemCreateScreen({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Item'),
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Item Details',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              
              const SizedBox(height: 16),
              ItemForm(
                initialItemName: '',
                initialItemCategory: '',
                initialQuantity: 0,
                initialUnitPrice: 0.0,
                onSubmit: (itemName, itemCategory, quantity, unitPrice) async {
                  try {
                    await _itemController.createItem(
                      
                      itemName, 
                      itemCategory, 
                      quantity, 
                      unitPrice
                    );
                    
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Item created successfully')),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Failed to create item: $e')),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
