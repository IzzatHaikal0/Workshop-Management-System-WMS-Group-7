import 'package:flutter/material.dart';
import 'package:workshop_management_system/Controllers/ManageInventory/item_controller.dart';
import 'package:workshop_management_system/Screens/ManageInventory/widgets/custom_text.dart';
import 'package:workshop_management_system/Screens/ManageInventory/widgets/inventory_form.dart';

/// STATEFUL WIDGET FOR ADDING A NEW INVENTORY ITEM
class AddInventoryPage extends StatefulWidget {
  const AddInventoryPage({super.key});

  @override
  State<AddInventoryPage> createState() => _AddInventoryPageState();
}

class _AddInventoryPageState extends State<AddInventoryPage> {
  /// CONTROLLER INSTANCE TO HANDLE INVENTORY LOGIC
  final ItemController _itemController = ItemController();
  bool _isLoading = false;

  /// METHOD TO HANDLE ITEM CREATION
  Future<void> _createItem(
    String itemName,
    String itemCategory,
    int quantity,
    double unitPrice,
  ) async {
    setState(() => _isLoading = true);

    try {
      /** GET CURRENT USER ROLE */
      final role = await _itemController.getUserRole();
      /** ALLOW ONLY WORKSHOP OWNERS TO CREATE ITEM */
      if (role == 'workshop_owner') {
        final newItem = await _itemController.createItem(
          itemName,
          itemCategory,
          quantity,
          unitPrice,
        );

        if (!mounted) return;
        /** SHOW SUCCESS MESSAGE AND CLOSE PAGE */
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Item created successfully',
              style: MyTextStyles.regular,
            ),
          ),
        );
        Navigator.pop(context, newItem);
      } else {
        if (!mounted) return;
        /** SHOW ACCESS DENIED MESSAGE */
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Access denied: Only workshop owners can create items.',
              style: MyTextStyles.regular,
            ),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    } catch (e) {
      /** HANDLE ERRORS */
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e', style: MyTextStyles.regular)),
        );
      }
    } finally {
      /** STOP LOADING SPINNER */
      if (mounted) setState(() => _isLoading = false);
    }
  }

  /// BUILD THE UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'New Item',
          style: MyTextStyles.bold.copyWith(
            fontSize: 16,
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
              /** LOADING SPINNER */
              : InventoryForm(onSubmit: _createItem, submitButtonText: 'Save'),
      /** FORM TO ADD ITEM */
    );
  }
}
