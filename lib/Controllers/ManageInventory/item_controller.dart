import '../../../Models/ManageInventory/item_model.dart';
import '../../Services/database_service.dart';

class ItemController {
  final DatabaseService _databaseService = DatabaseService();

  // Create 
  Future<Item> createItem(String itemName, String itemCategory, int quantity, double unitPrice) async {
    return await _databaseService.createItem(itemName, itemCategory, quantity, unitPrice);
  }

  // Read all -list
  Future<List<Item>> getItems() async {
    return await _databaseService.getItems();
  }

  // Get stream of items - useful for real-time updates with Firebase
  Stream<List<Item>> getItemsStream() {
    return _databaseService.itemsStream;
  }

  // Read one -detail
  Future<Item?> getItem(String id) async {
    return await _databaseService.getItem(id);
  }

  // Update
  Future<Item?> updateItem(String id, String itemName, String itemCategory, int quantity, double unitPrice) async {
    return await _databaseService.updateItem(id, itemName, itemCategory, quantity, unitPrice);
  }

  // Delete
  Future<bool> deleteItem(String id) async {
    return await _databaseService.deleteItem(id);
  }
  
  /* Get stream of items filtered by category
  Stream<List<Item>> getItemsByCategoryStream(String category) {
    return _databaseService.itemsStream.map((items) {
      return items
          .where((item) => item.itemCategory.toLowerCase() == category.toLowerCase())
          .toList();
    });
  }*/
}