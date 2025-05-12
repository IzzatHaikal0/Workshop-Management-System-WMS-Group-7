import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ItemForm extends StatefulWidget {
  final String initialItemName;
  final String initialItemCategory;
  final int initialQuantity;
  final double initialUnitPrice;
  final Function(String itemName, String itemCategory, int quantity, double unitPrice) onSubmit;

  const ItemForm({
    super.key,
    required this.initialItemName,
    required this.initialItemCategory,
    required this.initialQuantity,
    required this.initialUnitPrice,
    required this.onSubmit,
  });

  @override
  State<ItemForm> createState() => _ItemFormState();
}

class _ItemFormState extends State<ItemForm> {
  final _formKey = GlobalKey<FormState>();
  
  late TextEditingController _itemNameController;
  late TextEditingController _itemCategoryController;
  late TextEditingController _quantityController;
  late TextEditingController _unitPriceController;
  
  @override
  void initState() {
    super.initState();
    _itemNameController = TextEditingController(text: widget.initialItemName);
    _itemCategoryController = TextEditingController(text: widget.initialItemCategory);
    _quantityController = TextEditingController(text: widget.initialQuantity==0 ? '': widget.initialQuantity.toString());
    _unitPriceController = TextEditingController(text: widget.initialUnitPrice.toString());
  }
  
  @override
  void dispose() {
    _itemNameController.dispose();
    _itemCategoryController.dispose();
    _quantityController.dispose();
    _unitPriceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Item Name Field
          TextFormField(
            controller: _itemNameController,
            decoration: const InputDecoration(
              labelText: 'Item Name',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.inventory),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter an item name';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          
          // Item Category Field
          TextFormField(
            controller: _itemCategoryController,
            decoration: const InputDecoration(
              labelText: 'Item Category',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.category),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter an item category';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          
          // Quantity Field
          TextFormField(
            controller: _quantityController,
            decoration: const InputDecoration(
              labelText: 'Quantity',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.numbers),
            ),
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
            ],
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a quantity';
              }
              if (int.tryParse(value) == null) {
                return 'Please enter a valid number';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          
          // Unit Price Field
          TextFormField(
            controller: _unitPriceController,
            decoration: const InputDecoration(
              labelText: 'Unit Price',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.attach_money),
            ),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
            ],
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a unit price';
              }
              if (double.tryParse(value) == null) {
                return 'Please enter a valid price';
              }
              return null;
            },
          ),
          const SizedBox(height: 24),
          
          // Submit Button
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                final itemName = _itemNameController.text;
                final itemCategory = _itemCategoryController.text;
                final quantity = int.parse(_quantityController.text);
                final unitPrice = double.parse(_unitPriceController.text);
                
                widget.onSubmit(itemName, itemCategory, quantity, unitPrice);
              }
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              foregroundColor: Theme.of(context).colorScheme.onPrimary,
              backgroundColor: const Color.fromARGB(255, 4, 0, 252),
            ),
            child: const Text(
              'Save',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}