import 'package:flutter/material.dart';
import 'package:workshop_management_system/Controllers/ManageInventory/request_controller.dart';
import 'package:workshop_management_system/Screens/ManageInventory/widgets/custom_text.dart';
import 'package:workshop_management_system/Screens/ManageInventory/widgets/request_form.dart';

/// STATEFUL WIDGET FOR ADDING A NEW REQUEST
class AddRequestPage extends StatefulWidget {
  const AddRequestPage({super.key});

  @override
  State<AddRequestPage> createState() => _AddRequestPageState();
}

class _AddRequestPageState extends State<AddRequestPage> {
  /// CONTROLLER INSTANCE TO HANDLE REQUEST LOGIC
  final RequestController _requestController = RequestController();
  bool _isLoading = false;

  /// METHOD TO HANDLE CREATE REQUEST
  Future<void> _createRequest(
    String itemName,
    int quantity,
    String? notes,
  ) async {
    setState(() => _isLoading = true);

    try {
      final newRequest = await _requestController.createRequest(
        itemName: itemName,
        quantity: quantity,
        notes: notes,
      );

      if (mounted) {
        /** SHOW SUCCESS MESSAGE AND CLOSE PAGE */
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Request created successfully',
              style: MyTextStyles.regular,
            ),
          ),
        );
        Navigator.pop(context, newRequest);
      }
    } catch (e) {
      /** DISPLAY ERROR IF FAILS */
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Error creating request: $e',
              style: MyTextStyles.regular,
            ),
          ),
        );
      }
    } finally {
      /** DISABLE LOADING SPINNER */
      if (mounted) setState(() => _isLoading = false);
    }
  }

  /// BUILD THE UI FOR THE REQUEST PAGE
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'New Request',
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
          /**BODY SECTION */
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              /** SHOW LOADER WHEN SUBMITTING */
              : RequestForm(
                /** SUBMIT FORM TO CREATE REQUEST */
                onSubmit: _createRequest,
                submitButtonText: 'Create Request',
              ),
    );
  }
}
