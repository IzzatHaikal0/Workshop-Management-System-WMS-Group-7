import 'package:flutter/material.dart';
import '../../Controllers/ManageInventory/item_controller.dart';
import '../../main.dart';
import '../../Models/ManageInventory/item_model.dart';
import '../ManageInventory/widgets/item_card.dart';

class ItemListScreen extends StatefulWidget {
  const ItemListScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ItemListScreenState createState() => _ItemListScreenState();
}

class _ItemListScreenState extends State<ItemListScreen> {
  final ItemController _itemController = ItemController();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Items'),
        actions: [
          /* Request button added to the AppBar
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.requestList);
            },
            icon: Icon(Icons.add_shopping_cart),
            label: Text('Request'),
            style: ElevatedButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.onPrimary,
            ),
          ),*/
          SizedBox(width: 8),
        ],
      ),
      body: StreamBuilder<List<Item>>(
        // Firebase will automatically deliver real-time updates
        stream: _itemController.getItemsStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No items found. Add one!'));
          }

          final items = snapshot.data!;

          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return ItemCard(
                item: item,
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    AppRoutes.itemDetail,
                    arguments: item,
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, AppRoutes.itemCreate);
        },
        child: Icon(Icons.add),
      ),
    );
  }
}