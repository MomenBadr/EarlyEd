import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../chat/friend_chat_screen.dart';

class AllUsersScreen extends StatelessWidget {
  const AllUsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Users"),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("userslist").snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            List<QueryDocumentSnapshot<Map<String, dynamic>>> docs = snapshot
                .data!.docs
                .where((element) =>
                    element.id != FirebaseAuth.instance.currentUser!.uid)
                .toList();
            return ListView.builder(
                itemCount: docs.length,
                itemBuilder: (ctxx, index) {
                  return ListTile(
                    title: Text(docs[index].data()['userName'] ?? ""),
                    leading: ElevatedButton(
                      style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all(const CircleBorder()),
                          padding: MaterialStateProperty.all(EdgeInsets.zero)),
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                                  contentPadding: EdgeInsets.zero,
                                  shape: const RoundedRectangleBorder(),
                                  content: SizedBox(
                                    height: 300,
                                    width: 300,
                                    child: Image.network(
                                        docs[index]['userImageUrl']),
                                  ),
                                ));
                      },
                      child: CircleAvatar(
                        radius: 26,
                        backgroundImage:
                            NetworkImage(docs[index]['userImageUrl']),
                      ),
                    ),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (ctx) => FriendScreen(
                          userName: docs[index]['userName'],
                          imageUrl: docs[index]['userImageUrl'],
                          userId: docs[index]['userId'],
                          seen: 0,
                          isFromProduct: true,
                          isGroup:  false,
                        ),
                      ),
                    ),
                  );
                });
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
