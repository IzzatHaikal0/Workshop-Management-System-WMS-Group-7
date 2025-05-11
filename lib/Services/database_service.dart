
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:workshop_management_system/Models/ManageInventory/item_model.dart';
//import 'package:workshop_management_system/Models/ManageInventory/request_model.dart';



class DatabaseService {
  // Singleton pattern
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();
  
  // Firestore collection references
  final CollectionReference _itemsCollection = 
      FirebaseFirestore.instance.collection('Inventory_Item');
  //final CollectionReference _requestsCollection =
      //FirebaseFirestore.instance.collection('Request');
  
  // ITEM OPERATIONS
  
  // Create item
  Future<Item> createItem(String itemName, String itemCategory, int quantity, double unitPrice) async {
    final now = DateTime.now();
    final item = Item(
      id: '', // Firestore will generate ID
      itemName: itemName,
      itemCategory: itemCategory,
      quantity: quantity,
      unitPrice: unitPrice,
      createdAt: now,
      updatedAt: now,
    );
    
    // Add to Firestore
    final docRef = await _itemsCollection.add(item.toJson());
    
    // Return item with the Firestore document ID
    return item.copyWith(id: docRef.id);
  }

  // Read all items (stream)
  Stream<List<Item>> get itemsStream {
    return _itemsCollection
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return Item.fromJson({...data, 'id': doc.id});
      }).toList();
    });
  }

  // Read all items
  Future<List<Item>> getItems() async {
    final snapshot = await _itemsCollection
        .orderBy('createdAt', descending: true)
        .get();
    
    return snapshot.docs.map((doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      return Item.fromJson({...data, 'id': doc.id});
    }).toList();
  }

  // Read one item
  Future<Item?> getItem(String id) async {
    final docSnapshot = await _itemsCollection.doc(id).get();
    
    if (docSnapshot.exists) {
      Map<String, dynamic> data = docSnapshot.data() as Map<String, dynamic>;
      return Item.fromJson({...data, 'id': docSnapshot.id});
    }
    
    return null;
  }

  // Update item
  Future<Item?> updateItem(String id, String itemName, String itemCategory, int quantity, double unitPrice) async {
    final now = DateTime.now();
    
    await _itemsCollection.doc(id).update({
      'itemName': itemName,
      'itemCategory': itemCategory,
      'quantity': quantity,
      'unitPrice': unitPrice,
      'updatedAt': now.toIso8601String(),
    });
    
    // Fetch the updated document
    final updatedDoc = await _itemsCollection.doc(id).get();
    Map<String, dynamic> data = updatedDoc.data() as Map<String, dynamic>;
    return Item.fromJson({...data, 'id': id});
  }

  // Delete item
  Future<bool> deleteItem(String id) async {
    await _itemsCollection.doc(id).delete();
    return true;
  }

  
  // REQUEST OPERATIONS
  
  // Create request
  /*Future<ItemRequest> createRequest(String itemName, int quantity, String requestedBy, String requestedTo, String status) async {
    final now = DateTime.now();
    final request = ItemRequest(
      id: '',
      itemName: itemName,
      quantity: quantity,
      requestedBy: requestedBy,
      requestedTo: requestedTo,
      requestDate: now,
      status: status,
    );
    
    // Add to Firestore
    final docRef = await _requestsCollection.add(request.toJson());
    
    // Return request with the Firestore document ID
    return request.copyWith(id: docRef.id);
  }

  // Read all requests (stream)
  Stream<List<ItemRequest>> get requestsStream {
    return _requestsCollection
        .orderBy('requestDate', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return ItemRequest.fromJson({...data, 'id': doc.id});
      }).toList();
    });
  }

  // Read all requests
  Future<List<ItemRequest>> getRequests() async {
    final snapshot = await _requestsCollection
        .orderBy('requestDate', descending: true)
        .get();
    
    return snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      return ItemRequest.fromJson({...data, 'id': doc.id});
    }).toList();
  }

  // Read one request
  Future<ItemRequest?> getRequest(String id) async {
    final docSnapshot = await _requestsCollection.doc(id).get();
    
    if (docSnapshot.exists) {
      final data = docSnapshot.data() as Map<String, dynamic>;
      return ItemRequest.fromJson({...data, 'id': docSnapshot.id});
    }
    
    return null;
  }

  // Delete request
  Future<bool> deleteRequest(String id) async {
    await _requestsCollection.doc(id).delete();
    return true;
  }

  // Get incoming requests for a specific user
  Future<List<ItemRequest>> getIncomingRequests(String userId) async {
    final snapshot = await _requestsCollection
        .where('requestedTo', isEqualTo: userId)
        .orderBy('requestDate', descending: true)
        .get();
        
    return snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      return ItemRequest.fromJson({...data, 'id': doc.id});
    }).toList();
  }
  
  // Get outgoing requests for a specific user
  Future<List<ItemRequest>> getOutgoingRequests(String userId) async {
    final snapshot = await _requestsCollection
        .where('requestedBy', isEqualTo: userId)
        .orderBy('requestDate', descending: true)
        .get();

    return snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      return ItemRequest.fromJson({...data, 'id': doc.id});
    }).toList();
  }
*/

}


