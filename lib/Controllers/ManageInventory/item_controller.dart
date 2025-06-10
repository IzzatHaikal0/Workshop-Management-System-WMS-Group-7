import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:workshop_management_system/Models/ManageInventory/item_model.dart';

class ItemController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// create item
  Future<Item> createItem(
    String itemName,
    String itemCategory,
    int quantity,
    double unitPrice,
  ) async {
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

  /// get items for current user
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

  /// stream of item for current user
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

  /// get specific item by id
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

  /// update item
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

  /// delete item
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

  /// get items by category
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
