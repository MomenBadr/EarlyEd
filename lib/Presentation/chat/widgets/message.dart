import 'package:firebase_auth/firebase_auth.dart';

import 'message_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Messages extends StatefulWidget {
  final String friendId;
  final String myId;
  final int seen;
  final bool isGroup;

  const Messages({
    required this.friendId,
    required this.myId,
    required this.seen,
    required this.isGroup,
    super.key,
  });

  @override
  MessagesState createState() => MessagesState();
}

class MessagesState extends State<Messages> {
  int seen = 0;

  @override
  void initState() {
    seen = widget.seen;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection(widget.myId)
          .doc('chatfield')
          .collection('chats')
          .doc(widget.friendId)
          .collection('chat')
          .orderBy('createdAt', descending: true)
          .snapshots(),
      builder: (ctx, snapShot) {
        if (snapShot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        final docs = snapShot.data!.docs;

        if (docs.isNotEmpty && docs.length != seen) {
          seen = docs.length;
          // FirebaseFirestore.instance
          //     .collection(widget.friendId)
          //     .doc('chatfield')
          //     .collection('chats')
          //     .doc(widget.myId)
          //     .collection('chat')
          //     .orderBy('createdAt', descending: true)
          //     .get()
          //     .then((data) {

          // });
          void updateGroupMessageLength() async {
            FirebaseFirestore.instance
                .collection(widget.myId)
                .doc('chatfield')
                .collection('chats')
                .doc(widget.friendId)
                .update(
              {
                'messagelength': "${docs.length}",
                'seen': "${docs.length}",
              },
            );

            await FirebaseFirestore.instance
                .collection(FirebaseAuth.instance.currentUser!.uid)
                .doc('chatfield')
                .collection('chats')
                .doc(widget.friendId)
                .get()
                .then((groupData) async {
              var groupMembers =
                  List.from(groupData.data()!['group_members'] ?? []);
              for (var element in groupMembers) {
                FirebaseFirestore.instance
                    .collection(element)
                    .doc('chatfield')
                    .collection('chats')
                    .doc(widget.friendId)
                    .update(
                  {
                    'messagelength': "${docs.length}",
                  },
                );
              }
            });
          }

          if (widget.isGroup) {
            updateGroupMessageLength();
          } else {
            FirebaseFirestore.instance
                .collection(widget.friendId)
                .doc('chatfield')
                .collection('chats')
                .doc(widget.myId)
                .update(
              {
                'messagelength': "${docs.length}",
              },
            );
            FirebaseFirestore.instance
                .collection(widget.myId)
                .doc('chatfield')
                .collection('chats')
                .doc(widget.friendId)
                .update(
              {
                'messagelength': "${docs.length}",
                'seen': "${docs.length}",
              },
            );
          }
        }

        return Scrollbar(
          thickness: 20,
          interactive: true,

          // hoverThickness: 15,
          // showTrackOnHover: true,
          // isAlwaysShown: true,
          child: ListView.builder(
            reverse: true,
            itemCount: docs.length,
            itemBuilder: (ctx, index) {
              if (docs[index]['hide'] == true) {
                return const SizedBox();
              }
              Timestamp currentItem = docs[index]['createdAt'];
              Timestamp nextItem =
                  docs[index == docs.length - 1 ? index : index + 1]
                      ['createdAt'];

              DateTime timeNow = DateTime.now();
              DateTime x = currentItem.toDate().add(const Duration(days: 1));
              if (index == docs.length - 1) {
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: day(
                          timeNow.day + timeNow.month + timeNow.year ==
                                  currentItem.toDate().day +
                                      currentItem.toDate().month +
                                      currentItem.toDate().year
                              ? "today"
                              : timeNow.day + timeNow.month + timeNow.year ==
                                      x.day + x.month + x.year
                                  ? "yesterday"
                                  : DateFormat("dd MMM yyyy").format(
                                      docs[index]['createdAt'].toDate()),
                          ctx),
                    ),
                    MessageBubble(
                      docs[index]['text'],
                      docs[index]['userId'] == widget.myId,
                      docs[index]['createdAt'],
                      docs[index].id,
                      widget.myId,
                      widget.friendId,
                      docs.firstWhere((element) {
                            var item = element.data() as Map;
                            return item['hide'] == false;
                          }).id ==
                          docs[index].id,
                      key: ValueKey(docs[index].id),
                      senderName:
                          widget.isGroup ? docs[index]['senderName'] : '',
                    ),
                  ],
                );
              }
              if (currentItem.toDate().day +
                      currentItem.toDate().month +
                      currentItem.toDate().year !=
                  nextItem.toDate().day +
                      nextItem.toDate().month +
                      nextItem.toDate().year) {
                return Column(
                  children: [
                    day(
                        timeNow.day + timeNow.month + timeNow.year ==
                                currentItem.toDate().day +
                                    currentItem.toDate().month +
                                    currentItem.toDate().year
                            ? "today"
                            : timeNow.day + timeNow.month + timeNow.year ==
                                    x.day + x.month + x.year
                                ? "yesterday"
                                : DateFormat("dd MMM yyyy")
                                    .format(docs[index]['createdAt'].toDate()),
                        ctx),
                    MessageBubble(
                      docs[index]['text'],
                      docs[index]['userId'] == widget.myId,
                      docs[index]['createdAt'],
                      docs[index].id,
                      widget.myId,
                      widget.friendId,
                      index == 0,
                      key: ValueKey(docs[index].id),
                      senderName:
                          widget.isGroup ? docs[index]['senderName'] : '',
                    ),
                  ],
                );
              }
              return MessageBubble(
                docs[index]['text'],
                docs[index]['userId'] == widget.myId,
                docs[index]['createdAt'],
                docs[index].id,
                widget.myId,
                widget.friendId,
                index == 0,
                key: ValueKey(docs[index].id),
                senderName: widget.isGroup ? docs[index]['senderName'] : '',
              );
            },
          ),
        );
      },
    );
  }

  Widget day(String msg, BuildContext ctx) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: Colors.black87, borderRadius: BorderRadius.circular(10)),
          child: Text(
            msg,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}
