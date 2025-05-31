import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:workshop_management_system/Models/ManageInventory/request_model.dart';

class RequestController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // create request
  Future<Request> createRequest({
    required String itemName,
    required int quantity,
    String? notes,
  }) async {
    final String uid = FirebaseAuth.instance.currentUser!.uid;

    try {
      final requestData = {
        'itemName': itemName,
        'quantity': quantity,
        'requestedBy': uid,
        'status': 'pending',
        'requestDate': FieldValue.serverTimestamp(),
        'notes': 'Out of stock, need urgently. Please approve ASAP.',
      };

      final docRef = await _firestore.collection('InventoryRequest').add(requestData);
      return Request.fromFirestore(await docRef.get());
    } catch (e) {
      throw Exception('Failed to create request: $e');
    }
  }

  //Stream all requests - current user
  Stream<List<Request>> getMyRequestsStream() {
    final String? uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return Stream.value([]);

    return _firestore
        .collection('InventoryRequest')
        .where('requestedBy', isEqualTo: uid)
        
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Request.fromFirestore(doc)).toList());
  }

  //Stream pending approvals - other user
  Stream<List<Request>> getPendingApprovalsStream() {
    return _firestore
        .collection('InventoryRequest')
        .where('status', isEqualTo: 'pending')
        
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Request.fromFirestore(doc)).toList());
  }

  // Stream requests by status - current user
  Stream<List<Request>> getRequestsByStatusStream(String status) {
    final String? uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return Stream.value([]);

    return _firestore
        .collection('InventoryRequest')
        .where('requestedBy', isEqualTo: uid)
        .where('status', isEqualTo: status)
        
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Request.fromFirestore(doc)).toList());
  }

  // approve request
  Future<Request?> approveRequest(String requestId, String? notes) async {
    final String? uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) throw Exception('User not authenticated');

    try {
      final docRef = _firestore.collection('InventoryRequest').doc(requestId);
      final doc = await docRef.get();
      if (!doc.exists) throw Exception('Request not found');

      final request = Request.fromFirestore(doc);
      if (request.requestedBy == uid) {
        throw Exception('You cannot approve your own request');
      }

      final shippedDate = DateTime.now().add(Duration(days: 7));
      
      final updateData = {
        'status': 'approved',
        'approvedBy': uid,
        'approvedDate': FieldValue.serverTimestamp(),
        'shippedDate': Timestamp.fromDate(shippedDate),
        if (notes != null && notes.isNotEmpty) 'approvalNotes': notes,
      };

      await docRef.update(updateData);
      return Request.fromFirestore(await docRef.get());
    } catch (e) {
      throw Exception('Failed to approve request: $e');
    }
  }

  // reject request
  Future<Request?> rejectRequest(String requestId, String? notes) async {
    final String? uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) throw Exception('User not authenticated');

    try {
      final docRef = _firestore.collection('InventoryRequest').doc(requestId);
      final doc = await docRef.get();
      if (!doc.exists) throw Exception('Request not found');

      final request = Request.fromFirestore(doc);
      if (request.requestedBy == uid) {
        throw Exception('You cannot reject your own request');
      }

      final updateData = {
        'status': 'rejected',
        'approvedBy': uid,
        'approvedDate': FieldValue.serverTimestamp(),
        if (notes != null && notes.isNotEmpty) 'rejectionNotes': notes,
      };

      await docRef.update(updateData);
      return Request.fromFirestore(await docRef.get());
    } catch (e) {
      throw Exception('Failed to reject request: $e');
    }
  }


  // Delete pending request by current user
  Future<bool> deleteRequest(String requestId) async {
    final String? uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) throw Exception('User not authenticated');

    try {
      final docRef = _firestore.collection('InventoryRequest').doc(requestId);
      final doc = await docRef.get();
      if (!doc.exists) return false;

      final request = Request.fromFirestore(doc);
      if (request.requestedBy != uid || 
        !(request.status == 'pending' || request.status == 'rejected'|| request.status == 'approved')){
      return false;
    }
      await docRef.delete();
      return true;
    } catch (e) {
      throw Exception('Failed to delete request: $e');
    }
  }

  // get request by id
  Future<Request?> getRequest(String requestId) async {
    try {
      final doc = await _firestore.collection('InventoryRequest').doc(requestId).get();
      return doc.exists ? Request.fromFirestore(doc) : null;
    } catch (e) {
      throw Exception('Failed to get request: $e');
    }
  }
}
