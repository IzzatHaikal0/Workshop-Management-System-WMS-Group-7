import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:workshop_management_system/Models/ManageInventory/item_model.dart';

class ItemController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// GET CURRENT USER'S ROLE FROM FIRESTORE
  Future<String> getUserRole() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return 'unauthenticated';

    final foremanDoc = await _firestore.collection('foremen').doc(uid).get();
    if (foremanDoc.exists) return 'foreman';

    final ownerDoc =
        await _firestore.collection('workshop_owner').doc(uid).get();
    if (ownerDoc.exists) return 'workshop_owner';

    return 'unknown';
  }

  /// CREATE A NEW ITEM FOR THE WORKSHOP OWNER
  Future<Item> createItem(
    String itemName,
    String itemCategory,
    int quantity,
    double unitPrice,
  ) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) throw Exception('User not authenticated');

    final itemData = {
      'itemName': itemName,
      'itemCategory': itemCategory,
      'quantity': quantity,
      'unitPrice': unitPrice,
      'workshopOwnerId': uid,
      'createdAt': FieldValue.serverTimestamp(),
    };

    final docRef = await _firestore.collection('InventoryItem').add(itemData);
    return Item.fromFirestore(await docRef.get());
  }

  /// FETCH ALL ITEMS FOR THE CURRENT USER (ONE-TIME LOAD)
  Future<List<Item>> getItems() async {
    final String uid = FirebaseAuth.instance.currentUser!.uid;
    try {
      final snapshot =
          await _firestore
              .collection('InventoryItem')
              .where('workshopOwnerId', isEqualTo: uid)
              .get();

      return snapshot.docs.map((doc) => Item.fromFirestore(doc)).toList();
    } catch (e) {
      throw Exception('Failed to get items: $e');
    }
  }

  /// STREAM OF ALL ITEMS FOR THE CURRENT USER (REAL-TIME)
  Stream<List<Item>> getItemsStream() {
    final String uid = FirebaseAuth.instance.currentUser!.uid;
    return _firestore
        .collection('InventoryItem')
        .where('workshopOwnerId', isEqualTo: uid)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) => Item.fromFirestore(doc)).toList(),
        );
  }

  /// GET A SPECIFIC ITEM BY ID FOR CURRENT USER
  Future<Item?> getItem(String itemId) async {
    final String uid = FirebaseAuth.instance.currentUser!.uid;
    try {
      final doc =
          await _firestore.collection('InventoryItem').doc(itemId).get();
      if (doc.exists) {
        final item = Item.fromFirestore(doc);
        if (item.workshopOwnerId == uid) {
          return item;
        }
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get item: $e');
    }
  }

  /// UPDATE AN EXISTING ITEM FOR CURRENT USER
  Future<Item?> updateItem(
    String itemId,
    String itemName,
    String itemCategory,
    int quantity,
    double unitPrice,
  ) async {
    final String uid = FirebaseAuth.instance.currentUser!.uid;
    try {
      final docRef = _firestore.collection('InventoryItem').doc(itemId);
      final doc = await docRef.get();

      if (!doc.exists || doc.data()?['workshopOwnerId'] != uid) {
        throw Exception('Item not found');
      }

      final updateData = {
        'itemName': itemName,
        'itemCategory': itemCategory,
        'quantity': quantity,
        'unitPrice': unitPrice,
        'updatedAt': FieldValue.serverTimestamp(),
      };

      await docRef.update(updateData);
      return Item.fromFirestore(await docRef.get());
    } catch (e) {
      throw Exception('Failed to update item: $e');
    }
  }

  /// DELETE AN ITEM BELONGING TO CURRENT USER
  Future<bool> deleteItem(String itemId) async {
    final String uid = FirebaseAuth.instance.currentUser!.uid;

    try {
      final docRef = _firestore.collection('InventoryItem').doc(itemId);
      final doc = await docRef.get();

      if (!doc.exists || doc.data()?['workshopOwnerId'] != uid) {
        return false;
      }

      await docRef.delete();
      return true;
    } catch (e) {
      throw Exception('Failed to delete item: $e');
    }
  }

  /// STREAM ITEMS FILTERED BY CATEGORY
  Stream<List<Item>> getItemsByCategoryStream(String category) {
    final String uid = FirebaseAuth.instance.currentUser!.uid;
    return _firestore
        .collection('InventoryItem')
        .where('workshopOwnerId', isEqualTo: uid)
        .where('itemCategory', isEqualTo: category)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) => Item.fromFirestore(doc)).toList(),
        );
  }
}
