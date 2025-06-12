import 'package:flutter/material.dart';
import 'package:workshop_management_system/Controllers/ManageInventory/item_controller.dart';
import 'package:workshop_management_system/Models/ManageInventory/item_model.dart';
import 'package:workshop_management_system/Screens/ManageInventory/inventory_barrel.dart';
import 'package:workshop_management_system/Screens/ManageInventory/widgets/custom_text.dart';

class ItemListScreen extends StatefulWidget {
  const ItemListScreen({super.key});

  @override
  State<ItemListScreen> createState() => _ItemListScreenState();
}

class _ItemListScreenState extends State<ItemListScreen> {
  final ItemController _itemController = ItemController();
  final TextEditingController _searchController = TextEditingController();
  String _searchText = '';
  String _selectedCategory = 'All';

  /// CATEGORY LISTS
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

  Widget _buildSearchAndFilterSection() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      color: Colors.grey[50],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /**SEARCH SECTION */
          TextField(
            controller: _searchController,
            onChanged: (value) {
              setState(() {
                _searchText = value;
              });
            },
            decoration: InputDecoration(
              hintText: 'Search items...',
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: const Color(0xFFFAFAFA),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFFDBE1F4)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.grey, width: 1.5),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              /**CATEGORY FILTER DROPDOWN */
              Container(
                height: 40,
                width: 150,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFFFAFAFA),
                  border: Border.all(color: const Color(0xFFDBE1F4)),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedCategory,
                    icon: const Icon(Icons.arrow_drop_down, color: Colors.grey),
                    style: MyTextStyles.medium.copyWith(
                      color: const Color(0xFF006FFD),
                      fontSize: 12,
                    ),
                    items:
                        _categories.map((String category) {
                          return DropdownMenuItem<String>(
                            value: category,
                            child: Text(category),
                          );
                        }).toList(),
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        setState(() {
                          _selectedCategory = newValue;
                        });
                      }
                    },
                  ),
                ),
              ),
              const SizedBox(width: 12),
              SizedBox(
                height: 40,
                width: 80,
                child: ElevatedButton(
                  /**ADD BUTTON */
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ItemCreateScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: const Color(0xFFFAFAFA),
                    foregroundColor: const Color(0xFF006FFD),
                    side: const BorderSide(color: Color(0xFFDBE1F4)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Add',
                    style: MyTextStyles.medium.copyWith(fontSize: 12),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          /**HEADER */
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
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.request_page,
                    color: Color(0xFF4169E1),
                  ),
                  tooltip: 'Request Items',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const RequestListScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),

          /** CALL WIDGET SEARCH, FILTER AND ADD BUTTON*/
          _buildSearchAndFilterSection(),

          /**LIST OF ITEMS*/
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
                /**IF NO MATCHING RESULTS FOR CATEGORY */
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
                  onRefresh: () async => setState(() {}),
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
                                builder: (_) => ItemDetailScreen(item: item),
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
    );
  }
}
