import 'package:flutter/material.dart';

class CategoryModel {
  final String id;
  final String title;
  final String image; // Can be emoji or asset path
  final Color color;

  CategoryModel({
    required this.id,
    required this.title,
    required this.image,
    required this.color,
  });

  factory CategoryModel.fromFirestore(Map<String, dynamic> json, String docId) {
    return CategoryModel(
      id: docId,
      title: json['title'] ?? '',
      image: json['image'] ?? '🍔',
      color: Color(json['color'] ?? 0xFFE53935),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'image': image,
      'color': color.value,
    };
  }
}
