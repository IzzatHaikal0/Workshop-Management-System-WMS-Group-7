import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:workshop_management_system/Screens/ManageInventory/widgets/custom_text.dart';

/// A reusable form widget for submitting item requests
class RequestForm extends StatefulWidget {
  final Function(String itemName, int quantity, String? notes) onSubmit;
  final String submitButtonText;

  const RequestForm({
    super.key,
    required this.onSubmit,
    required this.submitButtonText,
  });

  @override
  State<RequestForm> createState() => _RequestFormState();
}

class _RequestFormState extends State<RequestForm> {
  final _formKey = GlobalKey<FormState>();
  final _itemNameController = TextEditingController();
  final _quantityController = TextEditingController();
  final _notesController = TextEditingController();

  @override
  void dispose() {
    ///Clean up controllers when widget is disposed
    _itemNameController.dispose();
    _quantityController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  ///Validates and submits the form data to the parent widget
  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final itemName = _itemNameController.text.trim();
      final quantity = int.parse(_quantityController.text);
      final notes =
          _notesController.text.trim().isEmpty
              ? null
              : _notesController.text.trim();

      widget.onSubmit(itemName, quantity, notes);
    }
  }

  /// Builds the form section header
  Widget _buildHeader() {
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Text(
        'Request Details',
        style: MyTextStyles.semiBold.copyWith(fontSize: 16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            Card(
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
                    /** Item Name Input Field */
                    TextFormField(
                      controller: _itemNameController,
                      decoration: InputDecoration(
                        labelText: 'Item Name',
                        hintText: 'Enter the item you need',
                        border: const OutlineInputBorder(),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 14,
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
                      textCapitalization: TextCapitalization.words,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      /** Quantity Input Field */
                      controller: _quantityController,
                      decoration: InputDecoration(
                        labelText: 'Quantity',
                        hintText: 'Enter quantity needed',
                        border: const OutlineInputBorder(),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 12,
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(6),
                      ],
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter a quantity';
                        }
                        final quantity = int.tryParse(value);
                        if (quantity == null || quantity <= 0) {
                          return 'Please enter a valid quantity greater than 0';
                        }
                        if (quantity > 999999) {
                          return 'Quantity cannot exceed 999,999';
                        }
                        return null;
                      },
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      /** Notes Input Field (Optional) */
                      controller: _notesController,
                      decoration: InputDecoration(
                        labelText: 'Notes (Optional)',
                        hintText: 'Additional details',
                        border: const OutlineInputBorder(),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 12,
                      ),
                      maxLines: 3,
                      maxLength: 500,
                      textInputAction: TextInputAction.done,
                      textCapitalization: TextCapitalization.sentences,
                    ),

                    const SizedBox(height: 24),
                    /** Submit Button */
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
            const SizedBox(height: 16),
            /** Info Card */
            Card(
              color: Colors.blue[50],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.blue[700], size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Your request will be submitted to other workshop.',
                        style: MyTextStyles.medium.copyWith(
                          fontSize: 10,
                          color: Color(0xFF4169E1),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
