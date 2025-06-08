import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:workshop_management_system/Models/ManageInventory/item_model.dart';
import 'package:workshop_management_system/Screens/ManageInventory/widgets/custom_text.dart';

class ItemForm extends StatefulWidget {
  final Item? initialItem;
  final Function(String, String, int, double) onSubmit;
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

  final _categories = [
    'Tools',
    'Parts',
    'Materials',
    'Equipment',
    'Consumables',
    'Other',
  ];

  @override
  void initState() {
    super.initState();
    final item = widget.initialItem;
    if (item != null) {
      _itemNameController.text = item.itemName;
      _selectedCategory = item.itemCategory;
      _quantityController.text = item.quantity.toString();
      _unitPriceController.text = item.unitPrice.toString();
    }
  }

  @override
  void dispose() {
    _itemNameController.dispose();
    _quantityController.dispose();
    _unitPriceController.dispose();
    super.dispose();
  }

  void _resetForm() {
    _formKey.currentState?.reset();
    _itemNameController.clear();
    _quantityController.clear();
    _unitPriceController.clear();
    setState(() => _selectedCategory = 'Tools');
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final name = _itemNameController.text.trim();
      final qty = int.parse(_quantityController.text);
      final price = double.parse(_unitPriceController.text);
      widget.onSubmit(name, _selectedCategory, qty, price);
    }
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Item Information',
            style: MyTextStyles.semiBold.copyWith(fontSize: 16),
          ),
          TextButton(
            onPressed: _resetForm,
            child: const Text(
              'Clear All',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color.fromARGB(255, 7, 35, 241),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required String? Function(String?) validator,
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: const OutlineInputBorder(),
      ),
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      style: const TextStyle(fontFamily: 'Poppins', fontSize: 14),
      validator: validator,
    );
  }

  Widget _buildTotalValue() {
    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: _quantityController,
      builder: (context, qtyVal, _) {
        return ValueListenableBuilder<TextEditingValue>(
          valueListenable: _unitPriceController,
          builder: (context, priceVal, _) {
            final qty = int.tryParse(qtyVal.text) ?? 0;
            final price = double.tryParse(priceVal.text) ?? 0.0;
            final total = (qty * price).toStringAsFixed(2);

            /// to
            return Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF4169E1).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total Value:',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Poppins',
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    'RM $total',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4169E1),
                      fontSize: 14,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildHeader(),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _itemNameController,
                  label: 'Item Name',
                  hint: 'Enter item name',
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter an item name';
                    }
                    if (value.trim().length < 2) {
                      return 'Item name must be at least 2 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _selectedCategory,
                  items:
                      _categories.map((cat) {
                        return DropdownMenuItem(
                          value: cat,
                          child: Text(
                            cat,
                            style: const TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 12,
                            ),
                          ),
                        );
                      }).toList(),
                  decoration: const InputDecoration(
                    labelText: 'Category',
                    border: OutlineInputBorder(),
                  ),
                  style: const TextStyle(fontFamily: 'Poppins', fontSize: 12),
                  onChanged:
                      (value) => setState(() => _selectedCategory = value!),
                  validator:
                      (value) =>
                          (value == null || value.isEmpty)
                              ? 'Select a category'
                              : null,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _buildTextField(
                        controller: _quantityController,
                        label: 'Quantity',
                        hint: '0',
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        validator: (value) {
                          final qty = int.tryParse(value ?? '');
                          if (value == null || value.isEmpty) {
                            return 'Enter quantity';
                          }
                          if (qty == null || qty < 0) {
                            return 'Enter valid quantity';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildTextField(
                        controller: _unitPriceController,
                        label: 'Unit Price (RM)',
                        hint: '0.00',
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                            RegExp(r'^\d*\.?\d{0,2}'),
                          ),
                        ],
                        validator: (value) {
                          final price = double.tryParse(value ?? '');
                          if (value == null || value.isEmpty) {
                            return 'Enter unit price';
                          }
                          if (price == null || price < 0) {
                            return 'Enter valid price';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildTotalValue(),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4169E1),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    widget.submitButtonText,
                    style: MyTextStyles.bold.copyWith(fontSize: 14),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
