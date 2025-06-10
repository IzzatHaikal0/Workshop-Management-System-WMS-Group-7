import '../../../Models/ManageInventory/item_model.dart';
import '../../Services/inventory_service.dart';

class ItemController {
  final InventoryDBService _inventoryDBService = InventoryDBService();

  // Create 
  Future<Item> createItem(String itemName, String itemCategory, int quantity, double unitPrice) async {
    return await _inventoryDBService.createItem(itemName, itemCategory, quantity, unitPrice);
  }

  // Read all -list
  Future<List<Item>> getItems() async {
    return await _inventoryDBService.getItems();
  }

  // Get stream of items - useful for real-time updates with Firebase
  Stream<List<Item>> getItemsStream() {
    return _inventoryDBService.itemsStream;
  }

  // Read one -detail
  Future<Item?> getItem(String id) async {
    return await _inventoryDBService.getItem(id);
  }

  // Update
  Future<Item?> updateItem(String id, String itemName, String itemCategory, int quantity, double unitPrice) async {
    return await _inventoryDBService.updateItem(id, itemName, itemCategory, quantity, unitPrice);
  }

  // Delete
  Future<bool> deleteItem(String id) async {
    return await _inventoryDBService.deleteItem(id);
  }
  
  /* Get stream of items filtered by category
  Stream<List<Item>> getItemsByCategoryStream(String category) {
    return _inventoryDBService.itemsStream.map((items) {
      return items
          .where((item) => item.itemCategory.toLowerCase() == category.toLowerCase())
          .toList();
    });
  }*/
}