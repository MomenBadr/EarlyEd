import 'package:cloud_firestore/cloud_firestore.dart';

class NewsModel {
  static const String collectionName = 'news';
  String? id,
      details,imageUrl;

  NewsModel(
      {this.id,
        this.details,
        this.imageUrl,
        });

  NewsModel.fromFireStore(Map<String, dynamic> data)
      : this(
      id: data['id'],
      imageUrl: data['imageUrl'],
      details: data['details']);

  Map<String, dynamic> toFireStore() {
    return {
      'id': id,
      'imageUrl': imageUrl,
      'details': details,
      'order':Timestamp.now(),
    };
  }
}