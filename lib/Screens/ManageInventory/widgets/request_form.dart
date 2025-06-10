/*import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RequestForm extends StatefulWidget {
  final String initialItemName;
  final int initialQuantity;
  final String initialrequestBy; // workshop ID of logged-in user
  final Function(String itemName, int quantity, String requestBy, String requestTo) onSubmit;

  const RequestForm({
    super.key,
    required this.initialItemName,
    required this.initialQuantity,
    required this.initialrequestBy,
    required this.onSubmit,
  });

  @override
  State<RequestForm> createState() => _RequestFormState();
}

class _RequestFormState extends State<RequestForm> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _itemNameController;
  late TextEditingController _quantityController;

  String? _selectedRequestTo;

  // Example workshops list: Name => ID (excluding the logged-in user's workshop)
  final Map<String, String> _workshops = {
    'Mechanical Workshop': 'WS001',
    'Electrical Workshop': 'WS002',
    'Carpentry Workshop': 'WS003',
  };

  @override
  void initState() {
    super.initState();
    _itemNameController = TextEditingController(text: widget.initialItemName);
    _quantityController = TextEditingController(
        text: widget.initialQuantity == 0 ? '' : widget.initialQuantity.toString());
  }

  @override
  void dispose() {
    _itemNameController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Filter out the logged-in user's workshop
    final filteredWorkshops = _workshops..removeWhere((_, id) => id == widget.initialrequestBy);

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

          // Dropdown for requestTo (Other workshops)
          DropdownButtonFormField<String>(
            decoration: const InputDecoration(
              labelText: 'Request To',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.work),
            ),
            items: filteredWorkshops.entries.map((entry) {
              return DropdownMenuItem<String>(
                value: entry.value,
                child: Text(entry.key),
              );
            }).toList(),
            value: _selectedRequestTo,
            onChanged: (value) {
              setState(() {
                _selectedRequestTo = value;
              });
            },
            validator: (value) =>
                value == null ? 'Please select a workshop to send the request to' : null,
          ),
          const SizedBox(height: 16),

          // Submit Button
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                final itemName = _itemNameController.text;
                final quantity = int.parse(_quantityController.text);
                final requestBy = widget.initialrequestBy;
                final requestTo = _selectedRequestTo!;
                widget.onSubmit(itemName, quantity, requestBy, requestTo);
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
*/