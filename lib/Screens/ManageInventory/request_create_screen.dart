// ignore_for_file: use_build_context_synchronously
/*
import 'package:flutter/material.dart';
import '../../Controllers/ManageInventory/request_controller.dart';
import '../ManageInventory/widgets/request_form.dart';

class RequestCreateScreen extends StatelessWidget {
  final RequestController _requestController = RequestController();

  RequestCreateScreen({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create New Request'),
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Request Details',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              
              const SizedBox(height: 16),
              RequestForm(
                initialItemName: '',
                initialQuantity: 0,
                initialRequestTo: '',
                onSubmit: (itemName, quantity, requestBy, requestTo) async {
                  try {
                    await _requestController.createRequest(
                      
                      itemName, 
                      quantity,
                      requestBy, 
                      requestTo
                    );
                    
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Request submitted successfully')),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Failed to create new request: $e')),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
*//*
// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import '../../Controllers/ManageInventory/request_controller.dart';
import '../ManageInventory/widgets/request_form.dart';

class RequestCreateScreen extends StatelessWidget {
  final RequestController _requestController = RequestController();

  // Simulated logged-in workshop ID
  final String loggedInWorkshopId = 'WS001';

  RequestCreateScreen({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create New Request'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Request Details',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              
              RequestForm(
                initialItemName: '',
                initialQuantity: 0,
                initialrequestBy: loggedInWorkshopId,
                onSubmit: (itemName, quantity, requestBy, requestTo) async {
                  try {
                    await _requestController.createRequest(
                      itemName, 
                      quantity,
                      requestBy, 
                      requestTo
                    );
                    
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Request submitted successfully')),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Failed to create new request: $e')),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
*/