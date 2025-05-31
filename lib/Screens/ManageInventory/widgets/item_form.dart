import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:workshop_management_system/Models/ManageInventory/item_model.dart';

class ItemForm extends StatefulWidget {
  final Item? initialItem;
  final Function(String itemName, String itemCategory, int quantity, double unitPrice) onSubmit;
  final String submitButtonText;

  const ItemForm({
    super.key,
    this.initialItem,
    required this.onSubmit,
    required this.submitButtonText,
  });

  @override
  State<ItemForm> createState() => _ItemFormState();
}

class _ItemFormState extends State<ItemForm> {
  final _formKey = GlobalKey<FormState>();
  final _itemNameController = TextEditingController();
  final _quantityController = TextEditingController();
  final _unitPriceController = TextEditingController();
  
  String _selectedCategory = 'Tools';
  final List<String> _categories = [
    'Tools',
    'Parts',
    'Materials',
    'Equipment',
    'Consumables',
    'Other'
  ];

  @override
  void initState() {
    super.initState();
    if (widget.initialItem != null) {
      _itemNameController.text = widget.initialItem!.itemName;
      _selectedCategory = widget.initialItem!.itemCategory;
      _quantityController.text = widget.initialItem!.quantity.toString();
      _unitPriceController.text = widget.initialItem!.unitPrice.toString();
    }
  }

  @override
  void dispose() {
    _itemNameController.dispose();
    _quantityController.dispose();
    _unitPriceController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final itemName = _itemNameController.text.trim();
      final quantity = int.parse(_quantityController.text);
      final unitPrice = double.parse(_unitPriceController.text);
      
      widget.onSubmit(itemName, _selectedCategory, quantity, unitPrice);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // item name
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Item Information',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _itemNameController,
                      decoration: const InputDecoration(
                        labelText: 'Item Name *',
                        hintText: 'Enter item name',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.inventory_2),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter an item name';
                        }
                        if (value.trim().length < 2) {
                          return 'Item name must be at least 2 characters';
                        }
                        return null;
                      },
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 16),
                    // dropdown-category
                    DropdownButtonFormField<String>(
                      value: _selectedCategory,
                      decoration: const InputDecoration(
                        labelText: 'Category *',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.category),
                      ),
                      items: _categories.map((category) {
                        return DropdownMenuItem(
                          value: category,
                          child: Text(category),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedCategory = value!;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select a category';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // quantity and price 
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Stock & Pricing',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        // quantity
                        Expanded(
                          flex: 1,
                          child: TextFormField(
                            controller: _quantityController,
                            decoration: const InputDecoration(
                              labelText: 'Quantity *',
                              hintText: '0',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.numbers),
                            ),
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter quantity';
                              }
                              final quantity = int.tryParse(value);
                              if (quantity == null || quantity < 0) {
                                return 'Enter valid quantity';
                              }
                              return null;
                            },
                            textInputAction: TextInputAction.next,
                          ),
                        ),
                        const SizedBox(width: 16),
                        // price
                        Expanded(
                          flex: 1,
                          child: TextFormField(
                            controller: _unitPriceController,
                            decoration: const InputDecoration(
                              labelText: 'Unit Price (RM) *',
                              hintText: '0.00',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.attach_money),
                            ),
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                            ],
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter unit price';
                              }
                              final price = double.tryParse(value);
                              if (price == null || price < 0) {
                                return 'Enter valid price';
                              }
                              return null;
                            },
                            textInputAction: TextInputAction.done,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // total display
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Total Value:',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          ValueListenableBuilder(
                            valueListenable: _quantityController,
                            builder: (context, value1, child) {
                              return ValueListenableBuilder(
                                valueListenable: _unitPriceController,
                                builder: (context, value2, child) {
                                  final quantity = int.tryParse(_quantityController.text) ?? 0;
                                  final unitPrice = double.tryParse(_unitPriceController.text) ?? 0.0;
                                  final totalValue = quantity * unitPrice;
                                  
                                  return Text(
                                    'RM ${totalValue.toStringAsFixed(2)}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).primaryColor,
                                      fontSize: 16,
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // submit button
            ElevatedButton(
              onPressed: _submitForm,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                widget.submitButtonText,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}