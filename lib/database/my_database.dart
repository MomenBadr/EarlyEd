import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:early_ed/model/news_model.dart';
import 'package:early_ed/model/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

FirebaseAuth auth = FirebaseAuth.instance;
FirebaseFirestore firestore = FirebaseFirestore.instance;
FirebaseStorage storage = FirebaseStorage.instance;

class MyDataBase {
  static CollectionReference<UserModel> getUsersCollection() {
    return firestore
        .collection(UserModel.collectionName)
        .withConverter<UserModel>(
            fromFirestore: (doc, _) => UserModel.fromFireStore(doc.data()!),
            toFirestore: (user, options) => user.toFireStore());
  }

  static CollectionReference<NewsModel> getNewsCollection() {
    return firestore
        .collection(NewsModel.collectionName)
        .withConverter<NewsModel>(
            fromFirestore: (doc, _) => NewsModel.fromFireStore(doc.data()!),
            toFirestore: (user, options) => user.toFireStore());
  }

  static Future<UserModel?> getUserById(String uid) async {
    var collection = getUsersCollection();
    var docRef = collection.doc(uid);
    var res = await docRef.get();
    return res.data();
  }

  static updateGrades(String userId, String grades, List<String> newGrades) {
    CollectionReference ref = getUsersCollection();
    ref.doc(userId).update({grades: newGrades});
  }

  static Future<void> updateNewsPicture(File file, String newsId) async {
    try {
      final ext = file.path.split('.').last;
      final ref = storage.ref().child('news_pictures/${auth.currentUser!.uid}.$ext');
      await ref.putFile(file, SettableMetadata(contentType: 'image/$ext'));
      final downloadUrl = await ref.getDownloadURL();
      await firestore.collection('news').doc(newsId).update({'imageUrl': downloadUrl});
    } catch (error) {
      log('Error updating news picture: $error');
    }
  }

  static updateNewsDetails(String newsId, String details) {
    CollectionReference ref = getNewsCollection();
    ref.doc(newsId).update({'details': details});
  }

  static Stream<QuerySnapshot<UserModel>>
  listenForStudentsRealTimeUpdatesDependingOnLevel(int level) {
    // Listen for realtime update
    return getUsersCollection()
        .where('level', isEqualTo: level)
        .where('type', isEqualTo: 'st')
        .snapshots();
  }

  static updateAttendance(String userId, String month, List newAttendance) {
    CollectionReference ref = getUsersCollection();
    ref.doc(userId).update({month: newAttendance});
  }

  static Future<void> addNews(NewsModel news) {
    var newsCollection = getNewsCollection();
    var doc = newsCollection.doc(); //create new doc
    news.id = doc.id;
    news;
    return doc.set(news); // get doc -> then set //update
  }

  static Future<void> addNewsImage(NewsModel news, File file) async {
    final ext = file.path.split('.').last;
    log('Extensions: $ext');
    final ref = storage.ref().child('news_pictures/${news.id}.$ext');
    await ref
        .putFile(file, SettableMetadata(contentType: 'image/$ext'))
        .then((p0) {
      log('Data Transferred: ${p0.bytesTransferred / 1000} kb');
    });
    String image = await ref.getDownloadURL();
    await firestore.collection('news').doc(news.id).update({'imageUrl': image});
  }
}