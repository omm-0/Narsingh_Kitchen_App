import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../data/dummy_data.dart';
import '../../models/product_model.dart';
import '../../models/category_model.dart';

class ProductService {
  static final ProductService instance = ProductService._();
  ProductService._();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<CategoryModel> get _fallbackCategories => [
    CategoryModel(
      id: 'fallback-fast-food',
      title: 'Fast Food',
      image: '🍔',
      color: const Color(0xFFE53935),
    ),
    CategoryModel(
      id: 'fallback-tiffin',
      title: 'Tiffin',
      image: '🍱',
      color: const Color(0xFFFF9800),
    ),
    CategoryModel(
      id: 'fallback-spices',
      title: 'Spices',
      image: '🌶️',
      color: const Color(0xFF795548),
    ),
  ];

  List<ProductModel> get _fallbackPopularProducts => [
    DummyData.fastFoodItems.first,
    DummyData.todayTiffinMeal,
  ];

  // ── Categories ──────────────────────────────────────────────────────────
  Stream<List<CategoryModel>> getCategories() {
    return _firestore.collection('categories').snapshots().map((snapshot) {
      final categories = snapshot.docs
          .map((doc) => CategoryModel.fromFirestore(doc.data(), doc.id))
          .toList();
      return categories.isEmpty ? _fallbackCategories : categories;
    });
  }

  Stream<List<CategoryModel>> getCategoriesWithFallback() {
    return getCategories().map(
      (categories) => categories.isEmpty ? _fallbackCategories : categories,
    );
  }

  // ── Products ─────────────────────────────────────────────────────────────
  Stream<List<ProductModel>> getPopularProducts() {
    return _firestore
        .collection('products')
        .where('isPopular', isEqualTo: true)
        .snapshots()
        .map((snapshot) {
          final products = snapshot.docs
              .map((doc) => ProductModel.fromFirestore(doc.data(), doc.id))
              .toList();
          return products.isEmpty ? _fallbackPopularProducts : products;
        });
  }

  Stream<List<ProductModel>> getProducts(ProductKind kind) {
    return _firestore
        .collection('products')
        .where('kind', isEqualTo: kind.name)
        .snapshots()
        .map((snapshot) {
          final products = snapshot.docs
              .map((doc) => ProductModel.fromFirestore(doc.data(), doc.id))
              .toList();
          return products.isEmpty ? _fallbackProductsForKind(kind) : products;
        });
  }

  Stream<List<ProductModel>> getProductsWithFallback(ProductKind kind) {
    return getProducts(kind).map(
      (products) =>
          products.isEmpty ? _fallbackProductsForKind(kind) : products,
    );
  }

  // Helper to add dummy data for testing (optional)
  Future<void> seedDummyData() async {
    // Add categories
    final categories = [
      {'title': 'Fast Food', 'image': '🍔', 'color': 0xFFE53935},
      {'title': 'Tiffin', 'image': '🍱', 'color': 0xFFFF9800},
      {'title': 'Spices', 'image': '🌶️', 'color': 0xFF795548},
    ];

    for (var cat in categories) {
      await _firestore.collection('categories').add(cat);
    }

    // Add popular products
    final products = [
      {
        'name': 'Paneer Burger',
        'emoji': '🍔',
        'kind': 'fastFood',
        'price': 250.0,
        'rating': 4.8,
        'tag': 'Best Seller',
        'subtitle': 'Creamy paneer with spicy mayo',
        'isPopular': true,
      },
      {
        'name': 'Special Dal Tiffin',
        'emoji': '🍱',
        'kind': 'tiffinMeal',
        'price': 120.0,
        'rating': 4.9,
        'tag': 'Top Rated',
        'subtitle': 'Homestyle dal with rotis',
        'isPopular': true,
      },
    ];

    for (var prod in products) {
      await _firestore.collection('products').add(prod);
    }
  }

  // ── Admin CRUD ──────────────────────────────────────────────────────────
  Future<void> addProduct(ProductModel product) async {
    await _firestore.collection('products').add(product.toFirestore());
  }

  Future<void> updateProduct(ProductModel product) async {
    await _firestore
        .collection('products')
        .doc(product.id)
        .update(product.toFirestore());
  }

  Future<void> deleteProduct(String productId) async {
    await _firestore.collection('products').doc(productId).delete();
  }

  List<ProductModel> _fallbackProductsForKind(ProductKind kind) {
    switch (kind) {
      case ProductKind.fastFood:
        return DummyData.fastFoodItems;
      case ProductKind.tiffinMeal:
        return [DummyData.todayTiffinMeal];
      case ProductKind.spice:
        return DummyData.spiceItems;
    }
  }
}
