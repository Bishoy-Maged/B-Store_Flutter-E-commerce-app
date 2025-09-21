import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ProductService {
  final FirebaseFirestore _db;

  ProductService({FirebaseFirestore? db}) : _db = db ?? FirebaseFirestore.instance;

  // Add a new product to Firestore
  Future<void> addProduct({
    required String name,
    required double price,
    required String category,
    required String size,
    required String color,
    required double discount,
    required String description,
    required int quantity,
    required String imageData,
  }) async {
    try {
      await _db.collection('products').add({
        'name': name,
        'price': price,
        'category': category,
        'size': size,
        'color': color,
        'discount': discount,
        'description': description,
        'quantity': quantity,
        'imageData': imageData, // Store base64 image data
        'isFeatured': false,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to add product: $e');
    }
  }

  // Get all products
  Future<List<Map<String, dynamic>>> getAllProducts() async {
    try {
      final snapshot = await _db
          .collection('products')
          .orderBy('createdAt', descending: true)
          .get()
          .timeout(const Duration(seconds: 10));
      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return data;
      }).toList();
    } catch (e) {
      throw Exception('Failed to fetch products: $e');
    }
  }

  // Get featured products
  Future<List<Map<String, dynamic>>> getFeaturedProducts() async {
    try {
      final snapshot = await _db.collection('products').where('isFeatured', isEqualTo: true).get();
      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return data;
      }).toList();
    } catch (e) {
      throw Exception('Failed to fetch featured products: $e');
    }
  }

  // Delete a product
  Future<void> deleteProduct(String productId) async {
    try {
      await _db.collection('products').doc(productId).delete();
    } catch (e) {
      throw Exception('Failed to delete product: $e');
    }
  }

  // Update product featured status
  Future<void> updateFeaturedStatus(String productId, bool isFeatured) async {
    try {
      await _db.collection('products').doc(productId).update({
        'isFeatured': isFeatured,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to update product: $e');
    }
  }
}
