import 'package:flutter/material.dart';
import 'package:workshop_management_system/Controllers/ManageInventory/item_controller.dart';
import 'package:workshop_management_system/Models/ManageInventory/item_model.dart';
import 'package:workshop_management_system/Screens/ManageInventory/manage_inventory_barrel.dart';
import 'package:workshop_management_system/Screens/ManageInventory/widgets/custom_text.dart';

class ItemListScreen extends StatefulWidget {
  const ItemListScreen({super.key});

  @override
  State<ItemListScreen> createState() => _ItemListScreenState();
}

class _ItemListScreenState extends State<ItemListScreen> {
  final ItemController _itemController = ItemController();
  String _selectedCategory = 'All';
  final TextEditingController _searchController = TextEditingController();
  String _searchText = '';

  final List<String> _categories = [
    'All',
    'Tools',
    'Parts',
    'Materials',
    'Equipment',
    'Consumables',
    'Other',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Stream<List<Item>> _getFilteredItems() {
    if (_selectedCategory == 'All') {
      return _itemController.getItemsStream();
    } else {
      return _itemController.getItemsByCategoryStream(_selectedCategory);
    }
  }

  List<Item> _filterBySearch(List<Item> items) {
    if (_searchText.isEmpty) return items;

    return items.where((item) {
      return item.itemName.toLowerCase().contains(_searchText.toLowerCase()) ||
          item.itemCategory.toLowerCase().contains(_searchText.toLowerCase());
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.arrow_back_ios,
                    color: Color(0xFF4169E1),
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      'Inventory',
                      style: MyTextStyles.bold.copyWith(
                        fontSize: 16,
                        color: Color.fromARGB(255, 0, 0, 0),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.request_page,
                    color: Color(0xFF4169E1),
                  ),
                  tooltip: 'View Requests',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const RequestListScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          // search
          Container(
            padding: const EdgeInsets.all(16.0),
            color: Colors.grey[50],
            child: Column(
              children: [
                // search
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search items...',
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: const Color.fromARGB(255, 250, 250, 250),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Color.fromARGB(255, 219, 225, 244),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Colors.grey,
                        width: 1.5,
                      ),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _searchText = value;
                    });
                  },
                ),

                const SizedBox(height: 12),
                // category filter
                SizedBox(
                  height: 40,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _categories.length,
                    itemBuilder: (context, index) {
                      final category = _categories[index];
                      final isSelected = _selectedCategory == category;

                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: FilterChip(
                          label: Text((category), style: MyTextStyles.regular),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() {
                              _selectedCategory = category;
                            });
                          },
                          backgroundColor: Colors.white,
                          selectedColor: Colors.grey[300],
                          checkmarkColor: const Color(0xFF4169E1),
                          side: BorderSide(
                            color:
                                isSelected
                                    ? Colors.grey[300]!
                                    : const Color.fromARGB(255, 219, 225, 244),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          // list
          Expanded(
            child: StreamBuilder<List<Item>>(
              stream: _getFilteredItems(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 64,
                          color: Colors.red[300],
                        ),
                        const SizedBox(height: 16),
                        Text('Error loading items', style: MyTextStyles.bold),
                        const SizedBox(height: 8),
                        Text(
                          'Please try again later',
                          style: MyTextStyles.medium,
                        ),
                      ],
                    ),
                  );
                }

                final allItems = snapshot.data ?? [];
                final filteredItems = _filterBySearch(allItems);

                if (filteredItems.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.inventory_2_outlined,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          allItems.isEmpty
                              ? 'No items found'
                              : 'No matching items',
                          style: MyTextStyles.bold,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          allItems.isEmpty
                              ? 'Add your first inventory item'
                              : 'Try adjusting your search or filter',
                          style: MyTextStyles.regular,
                        ),
                      ],
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () async {
                    setState(() {});
                  },
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16.0),
                    itemCount: filteredItems.length,
                    itemBuilder: (context, index) {
                      final item = filteredItems[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: ItemCard(
                          item: item,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => ItemDetailScreen(item: item),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ItemCreateScreen()),
          );
        },
        backgroundColor: const Color.fromARGB(255, 233, 238, 249),
        child: const Icon(Icons.add),
      ),
    );
  }
}
