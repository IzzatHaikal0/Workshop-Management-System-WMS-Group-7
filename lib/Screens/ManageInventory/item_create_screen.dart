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

  Future<void> _createItem(
    String itemName,
    String itemCategory,
    int quantity,
    double unitPrice,
  ) async {
    setState(() => _isLoading = true);

    try {
      final newItem = await _itemController.createItem(
        itemName,
        itemCategory,
        quantity,
        unitPrice,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Item created successfully')),
        );
        Navigator.pop(context, newItem);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error creating item: $e')));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    const poppins = 'Poppins';

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        title: const Text(
          'New Item',
          style: TextStyle(
            fontSize: 14,
            fontFamily: poppins,
            fontWeight: FontWeight.w600,
            color: Color.fromARGB(255, 0, 0, 0),
          ),
        ),
        centerTitle: true,
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : ItemForm(onSubmit: _createItem, submitButtonText: 'Save'),
    );
  }
}
