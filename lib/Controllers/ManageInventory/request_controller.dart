/*import '../../../Models/ManageInventory/request_model.dart';
import '../../services/database_service.dart';

class RequestController {
  final DatabaseService _databaseService = DatabaseService();
  List<ItemRequest> _incomingRequests = [];
  List<ItemRequest> _outgoingRequests = [];
  bool _isLoading = false;

  List<ItemRequest> get incomingRequests => _incomingRequests;
  List<ItemRequest> get outgoingRequests => _outgoingRequests;
  bool get isLoading => _isLoading;

  Future<void> fetchIncomingRequests(String userId) async {
    _isLoading = true;
    notifyListeners();
    
    try {
      _incomingRequests = await _databaseService.getIncomingRequests(userId);
    } catch (e) {
      print('Error fetching incoming requests: $e');
    }
    
    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchOutgoingRequests(String userId) async {
    _isLoading = true;
    notifyListeners();
    
    try {
      _outgoingRequests = await _databaseService.getOutgoingRequests(userId);
    } catch (e) {
      print('Error fetching outgoing requests: $e');
    }
    
    _isLoading = false;
    notifyListeners();
  }

  // Create 
  Future<ItemRequest> createRequest(String itemName, int quantity, /*String requestBy, String requestTo,*/ ) async {
    return await _databaseService.createRequest(itemName, quantity, /*requestBy, requestTo,*/ );
  }
  
  // Read all
  /*Future<List<ItemRequest>> getRequests() async {
    return await _databaseService.getRequest();
  }

  // Get stream of items - useful for real-time updates with Firebase
  Stream<List<ItemRequest>> getRequestStream() {
    return _databaseService.RequestStream;
  }

  // Read one
  Future<ItemRequest?> getRequest(String id) async {
    return await _databaseService.getRequest(id);
  }

  // Delete
  Future<bool> deleteRequest(String id) async {
    return await _databaseService.deleteRequest(id);
  }
  
  // get Workshop ID
  Future<List<WorkshopRequest>> getRequestsByUser(String userId) async {
    return await _databaseService.getRequestsByUser(id);
  }

  */
}
*//*
import '../../../Models/ManageInventory/request_model.dart';

class RequestController {
  Future<void> createRequest(
    String itemName,
    int quantity,
    String requestBy,
    String requestTo,
  ) async {
    // Simulated logic – you can connect to Firebase, REST API, or SQLite
    final newRequest = ItemRequest(
      itemName: itemName,
      quantity: quantity,
      requestBy: requestBy,
      requestTo: requestTo,
    );

    // Simulate saving to backend
    await Future.delayed(const Duration(seconds: 1));
    print("Request Created: ${newRequest.toJson()}");

    // If using Firebase:
    // await FirebaseFirestore.instance.collection('requests').add(newRequest.toJson());
  }

  // Optional: Fetch requests
  Future<List<WorkshopRequest>> getRequests() async {
    // Simulated fetch
    await Future.delayed(const Duration(seconds: 1));
    return [];
  }
}
*/
