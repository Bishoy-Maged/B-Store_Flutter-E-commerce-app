import 'package:b_store/View/Role_based_login/Admin/Screen/add_items.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:typed_data';
import 'package:easy_localization/easy_localization.dart';
import '../../../../Services/auth_service.dart';
import '../../../../Services/product_service.dart';
import '../../login_screen.dart';

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({super.key});

  @override
  State<AdminHomeScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminHomeScreen> {
  final _authService = AuthService();
  final _productService = ProductService();

  List<Map<String, dynamic>> _products = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    try {
      setState(() => _isLoading = true);
      final products = await _productService.getAllProducts();
      setState(() {
        _products = products;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('error_loading_products'.tr(namedArgs: {'error': e.toString()}))),
        );
      }
    }
  }

  Future<void> _deleteProduct(String productId) async {
    try {
      await _productService.deleteProduct(productId);
      await _loadProducts(); // Refresh the list
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('product_deleted_success'.tr())),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('error_deleting_product'.tr(namedArgs: {'error': e.toString()}))),
        );
      }
    }
  }

  Future<void> _toggleFeatured(String productId, bool currentStatus) async {
    try {
      await _productService.updateFeaturedStatus(productId, !currentStatus);
      await _loadProducts(); // Refresh the list
      if (mounted) {
        final msgKey = !currentStatus ? 'product_featured' : 'product_unfeatured';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(msgKey.tr())),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('error_updating_product'.tr(namedArgs: {'error': e.toString()}))),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('admin_dashboard'.tr()),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadProducts,
            tooltip: 'refresh'.tr(),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await _authService.signOut();
              if (!mounted) return;
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                    (route) => false,
              );
            },
            tooltip: 'logout'.tr(),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _products.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.inventory_2_outlined, size: 100, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              'no_products_yet'.tr(),
              style: const TextStyle(fontSize: 18, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            Text(
              'tap_add_first_product'.tr(),
              style: const TextStyle(color: Colors.grey),
            ),
          ],
        ),
      )
          : RefreshIndicator(
        onRefresh: _loadProducts,
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: _products.length,
          itemBuilder: (context, index) {
            final product = _products[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 16),
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    // Product Image
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        width: 80,
                        height: 80,
                        color: Colors.grey[200],
                        child: product['imageData'] != null
                            ? Image.memory(
                          base64Decode(product['imageData']),
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.error),
                        )
                            : const Icon(Icons.image),
                      ),
                    ),
                    const SizedBox(width: 12),

                    // Product Details
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  product['name'] ?? 'unknown_product'.tr(),
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              if (product['isFeatured'] == true)
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: Colors.amber,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    'featured'.tr().toUpperCase(),
                                    style: const TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            (product['category'] ?? 'no_category'.tr()).toString(),
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '\$${(product['price'] as num?)?.toStringAsFixed(2) ?? '0.00'}',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'qty_label'.tr(namedArgs: {'count': (product['quantity'] ?? 0).toString()}),
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Action Buttons
                    Column(
                      children: [
                        IconButton(
                          icon: Icon(
                            product['isFeatured'] == true ? Icons.star : Icons.star_border,
                            color: product['isFeatured'] == true ? Colors.amber : Colors.grey,
                          ),
                          onPressed: () => _toggleFeatured(
                            product['id'],
                            product['isFeatured'] == true,
                          ),
                          tooltip: product['isFeatured'] == true
                              ? 'remove_from_featured'.tr()
                              : 'add_to_featured'.tr(),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _showDeleteDialog(product),
                          tooltip: 'delete_product'.tr(),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.teal,
        onPressed: () async {
          await Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const AddItems()),
          );
          // Refresh the list when returning from AddItems
          _loadProducts();
        },
        child: const Icon(Icons.add, color: Colors.white),
        tooltip: 'add_item'.tr(),
      ),
    );
  }

  void _showDeleteDialog(Map<String, dynamic> product) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('delete_product'.tr()),
        content: Text('delete_product_confirm'.tr(namedArgs: {'name': product['name'] ?? 'unknown_product'.tr()})),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('cancel'.tr()),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _deleteProduct(product['id']);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text('delete'.tr()),
          ),
        ],
      ),
    );
  }
}
