import 'package:flutter/material.dart';
import 'package:workshop_management_system/Controllers/ManageInventory/request_controller.dart';
import 'package:workshop_management_system/Screens/ManageInventory/widgets/request_form.dart';

class RequestCreateScreen extends StatefulWidget {
  const RequestCreateScreen({super.key});

  @override
  State<RequestCreateScreen> createState() => _RequestCreateScreenState();
}

class _RequestCreateScreenState extends State<RequestCreateScreen> {
  final RequestController _requestController = RequestController();
  bool _isLoading = false;

  Future<void> _createRequest(String itemName, int quantity, String? notes) async {
    setState(() => _isLoading = true);

    try {
      final newRequest = await _requestController.createRequest(
        itemName: itemName,
        quantity: quantity,
        notes: notes,
      );
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Request created successfully')),
        );
        Navigator.pop(context, newRequest);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error creating request: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create New Request'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RequestForm(
              onSubmit: _createRequest,
              submitButtonText: 'Create Request',
            ),
    );
  }
}
