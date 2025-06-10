import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:workshop_management_system/Models/ManageInventory/inventory_barrel.dart';

class InventoryService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Get items for the current logged-in workshop owner (live stream)
  Stream<List<Item>> getItemsForCurrentOwner() {
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

  /// Create a new item (assigns to logged-in owner)
  Future<Item> createItem({
    required String itemName,
    required String itemCategory,
    required int quantity,
    required double unitPrice,
  }) async {
    final String uid = FirebaseAuth.instance.currentUser!.uid;

    try {
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
    } catch (e) {
      throw Exception('Failed to create item: $e');
    }
  }

  /// Get all items for a specific owner (one-time fetch)
  Future<List<Item>> getItemsByOwnerId(String workshopOwnerId) async {
    try {
      final snapshot =
          await _firestore
              .collection('InventoryItem')
              .where('workshopOwnerId', isEqualTo: workshopOwnerId)
              .get();

      return snapshot.docs.map((doc) => Item.fromFirestore(doc)).toList();
    } catch (e) {
      throw Exception('Failed to get items: $e');
    }
  }

  /// Stream items for a specific owner
  Stream<List<Item>> getItemsStreamByOwnerId(String workshopOwnerId) {
    return _firestore
        .collection('InventoryItem')
        .where('workshopOwnerId', isEqualTo: workshopOwnerId)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) => Item.fromFirestore(doc)).toList(),
        );
  }

  /// Get a single item by ID and verify the owner
  Future<Item?> getItemByIdAndOwner(
    String itemId,
    String workshopOwnerId,
  ) async {
    try {
      final doc =
          await _firestore.collection('InventoryItem').doc(itemId).get();
      if (doc.exists) {
        final item = Item.fromFirestore(doc);
        if (item.workshopOwnerId == workshopOwnerId) {
          return item;
        }
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get item: $e');
    }
  }

  /// Update an item after verifying ownership
  Future<Item?> updateItemByOwner({
    required String itemId,
    required String itemName,
    required String itemCategory,
    required int quantity,
    required double unitPrice,
    required String workshopOwnerId,
  }) async {
    try {
      final docRef = _firestore.collection('InventoryItem').doc(itemId);
      final doc = await docRef.get();

      if (!doc.exists || doc.data()?['workshopOwnerId'] != workshopOwnerId) {
        throw Exception('Item not found or access denied');
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

  /// Delete an item after verifying ownership
  Future<bool> deleteItemByOwner(String itemId, String workshopOwnerId) async {
    try {
      final docRef = _firestore.collection('InventoryItem').doc(itemId);
      final doc = await docRef.get();

      if (!doc.exists || doc.data()?['workshopOwnerId'] != workshopOwnerId) {
        return false;
      }

      await docRef.delete();
      return true;
    } catch (e) {
      throw Exception('Failed to delete item: $e');
    }
  }

  /// Get items by category and owner
  Stream<List<Item>> getItemsByCategoryAndOwnerStream(
    String category,
    String workshopOwnerId,
  ) {
    return _firestore
        .collection('InventoryItem')
        .where('workshopOwnerId', isEqualTo: workshopOwnerId)
        .where('itemCategory', isEqualTo: category)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) => Item.fromFirestore(doc)).toList(),
        );
  }
}
