import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:early_ed/model/user_model.dart';
import 'package:early_ed/Presentation/group_screen/create_group_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

import '../../all_users/all_users_screen.dart';
import '../friend_chat_screen.dart';

class MyChat extends StatefulWidget {
  static const routeName = '/chat-screen';
  const MyChat({super.key});

  @override
  State<MyChat> createState() => _MyChatState();
}

class _MyChatState extends State<MyChat> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: const CustomAppBar(preferredSize: Size.zero, child: Text('')),
      appBar: AppBar(
        title: const Text("My Chat"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AllUsersScreen(),
                  ));
            },
            icon: const Icon(Icons.group_add_outlined),
          ),
          if (isAdelAdmin)
            IconButton(
                onPressed: () {
                  FirebaseAuth.instance.signOut();
                },
                icon: const Icon(Icons.logout_outlined)),
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection(FirebaseAuth.instance.currentUser!.uid)
            .doc('chatfield')
            .collection('chats')
            .orderBy("lastmessagedate", descending: true)
            .snapshots(),
        builder: (ctx, AsyncSnapshot<QuerySnapshot> snapShot) {
          if (snapShot.connectionState == ConnectionState.active) {
            final docs = snapShot.data!.docs
                .where((element) =>
                    element.id != FirebaseAuth.instance.currentUser!.uid)
                .toList();

            // print(docs.first.data());
            if (docs.isEmpty) {
              return const Center(
                child: Text("You have no contacts yet."),
              );
            } else {
              return ListView.builder(
                  itemCount: docs.length,
                  itemBuilder: (ctxx, index) {
                    return Column(
                      children: [
                        ListTile(
                          subtitle: Text(docs[index]['lastmessage']),
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                docs[index]['lastmessage'] != ""
                                    ? dateFromating(
                                        docs[index]['lastmessagedate'])
                                    : "",
                                style: const TextStyle(
                                    color: Colors.grey, fontSize: 12),
                              ),
                              const SizedBox(
                                height: 6,
                              ),
                              int.parse(docs[index]['messagelength']) >
                                      int.parse(docs[index]['seen'])
                                  ? Container(
                                      alignment: Alignment.center,
                                      height: 23,
                                      width: 23,
                                      padding: const EdgeInsets.all(1),
                                      decoration: BoxDecoration(
                                          color: const Color(
                                              0xFF62D366), //0xFF09B07D
                                          borderRadius:
                                              BorderRadius.circular(100)),
                                      child: Center(
                                        child: Text(
                                          "${int.parse(docs[index]['messagelength']) - int.parse(docs[index]['seen'])}",
                                          overflow: TextOverflow.visible,
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 12),
                                        ),
                                      ),
                                    )
                                  : const Text(""),
                            ],
                          ),
                          title: Text(
                            docs[index]['username'],
                          ),
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (ctx) => FriendScreen(
                                userName: docs[index]['username'],
                                imageUrl: docs[index]['image_url'],
                                userId: docs[index]['userid'],
                                seen: int.parse(docs[index]['seen']),
                                isFromProduct: false,
                                isGroup: docs[index]['isGroup'],
                              ),
                            ),
                          ),
                          leading: ElevatedButton(
                            style: ButtonStyle(
                                shape: MaterialStateProperty.all(
                                    const CircleBorder()),
                                padding:
                                    MaterialStateProperty.all(EdgeInsets.zero)),
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
                                              docs[index]['image_url']),
                                        ),
                                      ));
                            },
                            child: CircleAvatar(
                              radius: 26,
                              backgroundImage:
                                  NetworkImage(docs[index]['image_url']),
                            ),
                          ),
                          contentPadding: const EdgeInsets.only(
                              top: 10, bottom: 5, left: 4, right: 10),
                        ),
                        if (index != docs.length - 1) const Divider(),
                      ],
                    );
                  });
            }
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FirebaseAuth.instance.currentUser!.uid ==
              "bQFcj7UM1CaaJtlEN3Zz41lZe6T2"
          ? ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CreateGroupScreen(),
                    ));
              },
              child: const Text("Create group"),
            )
          : null,
    );
  }
}

String dateFromating(Timestamp x) {
  var nextday = x.toDate().add(const Duration(days: 1));
  var today = x.toDate();
  if (Timestamp.now().toDate().day +
          Timestamp.now().toDate().month +
          Timestamp.now().toDate().year ==
      today.day + today.month + today.year) {
    return DateFormat('hh:mm a').format(x.toDate());
  } else if (Timestamp.now().toDate().day +
          Timestamp.now().toDate().month +
          Timestamp.now().toDate().year ==
      nextday.day + nextday.month + nextday.year) {
    return "yesterday";
  }

  return DateFormat("dd/MM/yyyy").format(x.toDate());
}
