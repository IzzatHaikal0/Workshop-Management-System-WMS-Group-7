/*import 'package:flutter/material.dart';
import '../../../Controllers/ManageInventory/request_controller.dart';
import '../../../Models/ManageInventory/request_model.dart';

class RequestForm extends StatefulWidget {
  final RequestController controller;
  final List<String> availableWorkshops;

  const RequestForm({
    super.key,
    required this.controller,
    required this.availableWorkshops,
  });

  @override
  // ignore: library_private_types_in_public_api
  _RequestFormState createState() => _RequestFormState();
}

class _RequestFormState extends State<RequestForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _itemNameController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  String? _selectedWorkshop;

  @override
  void dispose() {
    _itemNameController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate() && _selectedWorkshop != null) {
      final ItemRequest newRequest = ItemRequest (
        id: '', // Will be assigned by Firebase
        itemName: _itemNameController.text,
        quantity: int.parse(_quantityController.text),
        requestedBy: widget.controller.currentWorkshopId,
        requestedTo: _selectedWorkshop!,
        requestDate: DateTime.now(),
        status: 'pending',
      );

      widget.controller.createRequest(newRequest);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: _itemNameController,
            decoration: const InputDecoration(
              labelText: 'Item Name',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter an item name';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _quantityController,
            decoration: const InputDecoration(
              labelText: 'Quantity',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a quantity';
              }
              if (int.tryParse(value) == null || int.parse(value) <= 0) {
                return 'Please enter a valid quantity';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            decoration: const InputDecoration(
              labelText: 'Request To',
              border: OutlineInputBorder(),
            ),
            value: _selectedWorkshop,
            items: widget.availableWorkshops
                .map((workshop) => DropdownMenuItem(
                      value: workshop,
                      child: Text(workshop),
                    ))
                .toList(),
            onChanged: (value) {
              setState(() {
                _selectedWorkshop = value;
              });
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please select a workshop';
              }
              return null;
            },
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _submitForm,
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Text(
                  'Submit Request',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
//DON"T DELETE
/*
class RequestForm extends StatefulWidget {
  final ItemRequest? initialRequest;
  final Function(ItemRequest) onSubmit;

  const RequestForm({
    super.key,
    this.initialRequest,
    required this.onSubmit,
  });

  @override
  // ignore: library_private_types_in_public_api
  _RequestFormState createState() => _RequestFormState();
}

class _RequestFormState extends State<RequestForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _itemNameController;
  late TextEditingController _quantityController;
  String _selectedWorkshopId = '';
  List<Map<String, String>> _workshops = [];
  bool _isLoading = false;
  
  final RequestController _requestController = RequestController();

  @override
  void initState() {
    super.initState();
    _itemNameController = TextEditingController(text: widget.initialRequest?.itemName ?? '');
    _quantityController = TextEditingController(
        text: widget.initialRequest?.quantity.toString() ?? '');
    _loadWorkshops();
    
    if (widget.initialRequest != null) {
      _selectedWorkshopId = widget.initialRequest!.requestTo;
    }
  }

  Future<void> _loadWorkshops() async {
    setState(() {
      _isLoading = true;
    });
    
    //workshop table
    try {
      final workshopsSnapshot = await DatabaseService._instance
          .collection('workshops')
          .get();
      
      final List<Map<String, String>> workshops = [];
      for (var doc in workshopsSnapshot.docs) {
        workshops.add({
          'id': doc.id,
          'name': doc.data()['name'] ?? 'Unknown Workshop',
        });
      }
      
      setState(() {
        _workshops = workshops;
        if (_workshops.isNotEmpty && _selectedWorkshopId.isEmpty) {
          _selectedWorkshopId = _workshops[0]['id']!;
        }
      });
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading workshops: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _itemNameController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  //from workshop table
  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final currentUserId = FirebaseAuth.instance.currentUser?.uid;
      if (currentUserId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User not logged in')),
        );
        return;
      }

      final request = ItemRequest(
        id: widget.initialRequest!.id,
        itemName: _itemNameController.text.trim(),
        quantity: int.parse(_quantityController.text.trim()),
        requestBy: currentUserId,
        requestTo: _selectedWorkshopId,
        status: widget.initialRequest?.status ?? 'pending',
      );

      widget.onSubmit(request);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: _itemNameController,
            decoration: const InputDecoration(
              labelText: 'Item Name',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter an item name';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _quantityController,
            decoration: const InputDecoration(
              labelText: 'Quantity',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter a quantity';
              }
              try {
                int qty = int.parse(value);
                if (qty <= 0) {
                  return 'Quantity must be greater than 0';
                }
              } catch (e) {
                return 'Please enter a valid number';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            decoration: const InputDecoration(
              labelText: 'Request To',
              border: OutlineInputBorder(),
            ),
            value: _selectedWorkshopId.isNotEmpty ? _selectedWorkshopId : null,
            items: _workshops.map((workshop) {
              return DropdownMenuItem<String>(
                value: workshop['id'],
                child: Text(workshop['name']!),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _selectedWorkshopId = value!;
              });
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please select a workshop';
              }
              return null;
            },
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _submitForm,
            style: ElevatedButton.styleFrom(
              minimumSize: const Size.fromHeight(50),
            ),
            child: Text(widget.initialRequest == null ? 'Submit Request' : 'Update Request'),
          ),
        ],
      ),
    );
  }
}
*/
*/