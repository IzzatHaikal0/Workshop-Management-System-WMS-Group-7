import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:workshop_management_system/Models/ManageInventory/request_model.dart';

class RequestController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// CREATE NEW INVENTORY REQUEST BY CURRENT USER
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
        'notes': notes ?? '',
      };

      final docRef = await _firestore
          .collection('InventoryRequest')
          .add(requestData);
      return Request.fromFirestore(await docRef.get());
    } catch (e) {
      throw Exception('Failed to create request: $e');
    }
  }

  /// STREAM ALL REQUESTS CREATED BY CURRENT USER
  Stream<List<Request>> getMyRequestsStream() {
    final String? uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return Stream.value([]);

    return _firestore
        .collection('InventoryRequest')
        .where('requestedBy', isEqualTo: uid)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) => Request.fromFirestore(doc)).toList(),
        );
  }

  /// STREAM ALL PENDING REQUESTS FOR APPROVAL (EXCLUDING CURRENT USER)
  Stream<List<Request>> getPendingApprovalsStream() {
    return _firestore
        .collection('InventoryRequest')
        .where('status', isEqualTo: 'pending')
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) => Request.fromFirestore(doc)).toList(),
        );
  }

  /// STREAM USER'S REQUESTS FILTERED BY STATUS (E.G., PENDING, ACCEPTED)
  Stream<List<Request>> getRequestsByStatusStream(String status) {
    final String? uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return Stream.value([]);

    return _firestore
        .collection('InventoryRequest')
        .where('requestedBy', isEqualTo: uid)
        .where('status', isEqualTo: status)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) => Request.fromFirestore(doc)).toList(),
        );
  }

  /// APPROVE REQUEST IF NOT REQUESTED BY THE SAME USER
  Future<Request?> acceptRequest(String requestId, String? notes) async {
    final String? uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) throw Exception('User not authenticated');
    final docRef = _firestore.collection('InventoryRequest').doc(requestId);
    try {
      final doc = await docRef.get();
      if (!doc.exists) throw Exception('Request not found');

      final request = Request.fromFirestore(doc);
      if (request.requestedBy == uid) {
        throw Exception('You cannot accept your own request');
      }

      await docRef.update({
        'status': 'accepted',
        'approvedBy': uid,
        'approvedDate': FieldValue.serverTimestamp(),

        if (notes != null && notes.isNotEmpty) 'approvalNotes': notes,
      });

      await Future.delayed(Duration(milliseconds: 500));
      final updatedDoc = await docRef.get();
      final updatedRequest = Request.fromFirestore(updatedDoc);

      final approvedDate = updatedRequest.approvedDate;
      if (approvedDate != null) {
        final shippedDate = approvedDate.add(Duration(days: 7));
        await docRef.update({'shippedDate': Timestamp.fromDate(shippedDate)});
      }
      return Request.fromFirestore(await docRef.get());
    } catch (e) {
      throw Exception('Failed to approve request: $e');
    }
  }

  /// REJECT REQUEST IF NOT CREATED BY SAME USER
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

  /// DELETE USER'S OWN REQUEST IF STATUS IS PENDING / REJECTED / ACCEPTED
  Future<bool> deleteRequest(String requestId) async {
    final String? uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) throw Exception('User not authenticated');

    try {
      final docRef = _firestore.collection('InventoryRequest').doc(requestId);
      final doc = await docRef.get();
      if (!doc.exists) return false;

      final request = Request.fromFirestore(doc);
      if (request.requestedBy != uid ||
          !(request.status == 'pending' ||
              request.status == 'rejected' ||
              request.status == 'accepted')) {
        return false;
      }
      await docRef.delete();
      return true;
    } catch (e) {
      throw Exception('Failed to delete request: $e');
    }
  }

  /// FETCH SINGLE REQUEST BY ID
  Future<Request?> getRequest(String requestId) async {
    try {
      final doc =
          await _firestore.collection('InventoryRequest').doc(requestId).get();
      return doc.exists ? Request.fromFirestore(doc) : null;
    } catch (e) {
      throw Exception('Failed to get request: $e');
    }
  }
}
