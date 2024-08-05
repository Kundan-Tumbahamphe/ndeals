// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';

class Deal extends Equatable {
  const Deal({
    required this.id,
    required this.imageUrl,
    required this.title,
    required this.price,
    required this.views,
    required this.likes,
  });

  final String id;
  final String imageUrl;
  final String title;
  final int price;
  final int views;
  final int likes;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'imageUrl': imageUrl,
      'title': title,
      'price': price,
      'views': views,
      'likes': likes,
    };
  }

  factory Deal.fromMap(Map<String, dynamic> map) {
    return Deal(
      id: map['id'] as String,
      imageUrl: map['imageUrl'] as String,
      title: map['title'] as String,
      price: map['price'] as int,
      views: map['views'] as int,
      likes: map['likes'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory Deal.fromJson(String source) =>
      Deal.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  List<Object> get props {
    return [
      id,
      imageUrl,
      title,
      price,
      views,
      likes,
    ];
  }

  @override
  bool get stringify => true;
}
