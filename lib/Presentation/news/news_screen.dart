import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:early_ed/model/news_model.dart';
import 'package:early_ed/Presentation/news/add_news.dart';
import 'package:early_ed/Presentation/news/news_widget.dart';
import 'package:flutter/material.dart';

import '../../helpers/helper.dart';

class NewsScreen extends StatelessWidget {
  const NewsScreen({super.key, required this.canEdit});

  final bool canEdit;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 100,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(25),
                bottomLeft: Radius.circular(25)),
          ),
          title: Column(children: [
            Image.asset("assets/images/EARLYED.png",
                width: 150, height: 100, fit: BoxFit.fill)
          ]),
          centerTitle: true,
          backgroundColor: Colors.lightBlue,
        ),
        body: Container(
            decoration: const BoxDecoration(color: Colors.white10),
            child: Column(children: [
              Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                  alignment: Alignment.center,
                  child: const Text("NEWS",
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 30,
                          color: Colors.black))),
              Expanded(
                  child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('news')
                    .orderBy('order', descending: true)
                    .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                        child: SizedBox(
                            width: 40,
                            height: 40,
                            child: CircularProgressIndicator()));
                  }
                  return ListView(
                    children: snapshot.data!.docs.map((document) {
                      return NewsWidget(
                          news: NewsModel(
                              imageUrl: document['imageUrl'],
                              id: document['id'],
                              details: document['details']),
                          canEdit: canEdit);
                    }).toList(),
                  );
                },
              ))
            ])),
        floatingActionButton: canEdit
            ? IconButton(
                //only if Admin
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AddNews(
                                canEdit: canEdit,
                              )));
                },
                icon: const Icon(Icons.add_circle),
                iconSize: 40)
            : null);
  }
}

late List<NewsModel> all;
