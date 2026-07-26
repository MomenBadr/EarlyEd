import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NewMessages extends StatefulWidget {
  final String friendId;
  final bool? isFromProduct;
  final bool isGroup;

  const NewMessages({
    super.key,
    required this.friendId,
    this.isFromProduct,
    this.isGroup = false,
  });

  @override
  NewMessagesState createState() => NewMessagesState();
}

class NewMessagesState extends State<NewMessages> {
  final _controller = TextEditingController();
  String _enteredMessage = "";
  bool? _isFromProduct;

  @override
  void initState() {
    _isFromProduct = widget.isFromProduct;
    super.initState();
  }

  Future<void> addContact(
    String message,
  ) async {
    await FirebaseFirestore.instance
        .collection('userslist')
        .doc(widget.friendId)
        .get()
        .then((document) {
      FirebaseFirestore.instance
          .collection(FirebaseAuth.instance.currentUser!.uid)
          .doc('chatfield')
          .collection('chats')
          .doc(widget.friendId)
          .set(
        {
          'userid': document.data()!['userId'],
          'username': document.data()!['userName'],
          'image_url': document.data()!['userImageUrl'],
          'messagelength': "1",
          'seen': "1",
          'lastmessage': message,
          'lastmessagedate': Timestamp.now(),
          'isGroup': false,
        },
      );
      FirebaseFirestore.instance
          .collection('userslist')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get()
          .then((value) {
        FirebaseFirestore.instance
            .collection(widget.friendId)
            .doc('chatfield')
            .collection('chats')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .set(
          {
            'userid': value.data()!['userId'],
            'username': value.data()!['userName'],
            'image_url': value.data()!['userImageUrl'],
            'messagelength': "1",
            'seen': "0",
            'lastmessage': message,
            'lastmessagedate': Timestamp.now(),
            'isGroup': false,
          },
        );
      });
    });
  }

  // void fromGroup(String msg) async {
  //   await FirebaseFirestore.instance
  //       .collection(FirebaseAuth.instance.currentUser!.uid)
  //       .doc('chatfield')
  //       .collection('chats')
  //       .doc(widget.friendId)
  //       .get()
  //       .then((groupData) async {
  //     var groupMemebers = groupData.data()!['group_members'] ?? [];
  //     for (var member in groupMemebers) {
  //       FirebaseFirestore.instance
  //           .collection(member)
  //           .doc('chatfield')
  //           .collection('chats')
  //           .doc(widget.friendId)
  //           .collection('chat')
  //           .add(
  //         {
  //           'text': msg,
  //           'createdAt': Timestamp.now(),
  //           'userId': FirebaseAuth.instance.currentUser!.uid,
  //           'hide': false,
  //         },
  //       );
  //     }
  //   });
  // }
  _sendGroupMessage(String msg) async {
    DocumentSnapshot<Map<String, dynamic>> data = await FirebaseFirestore
        .instance
        .collection('userslist')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    String userName = data.data()?['userName'] ?? 'unKnown';
    await FirebaseFirestore.instance
        .collection(FirebaseAuth.instance.currentUser!.uid)
        .doc('chatfield')
        .collection('chats')
        .doc(widget.friendId)
        .get()
        .then((groupData) async {
      var groupMembers = List.from(groupData.data()!['group_members'] ?? []);
      FirebaseFirestore.instance
          .collection(FirebaseAuth.instance.currentUser!.uid)
          .doc('chatfield')
          .collection('chats')
          .doc(widget.friendId)
          .update(
        {
          'senderName': userName,
          'lastmessage': msg,
          'lastmessagedate': Timestamp.now(),
        },
      );
      FirebaseFirestore.instance
          .collection(FirebaseAuth.instance.currentUser!.uid)
          .doc('chatfield')
          .collection('chats')
          .doc(widget.friendId)
          .collection('chat')
          .add(
        {
          'text': msg,
          'createdAt': Timestamp.now(),
          'userId': FirebaseAuth.instance.currentUser!.uid,
          'hide': false,
          'senderName': userName,
        },
      ).then((refrence) {
        for (var element in groupMembers) {
          if (element != FirebaseAuth.instance.currentUser!.uid) {
            FirebaseFirestore.instance
                .collection(element)
                .doc('chatfield')
                .collection('chats')
                .doc(widget.friendId)
                .collection('chat')
                .doc(refrence.id)
                .set(
              {
                'text': msg,
                'createdAt': Timestamp.now(),
                'userId': FirebaseAuth.instance.currentUser!.uid,
                'hide': false,
                'senderName': userName,
              },
            );
            FirebaseFirestore.instance
                .collection(element)
                .doc('chatfield')
                .collection('chats')
                .doc(widget.friendId)
                .update(
              {
                // 'messagelength': "0",
                // 'seen': "0",
                'senderName': userName,
                'lastmessage': msg,
                'lastmessagedate': Timestamp.now(),
              },
            );
          }
        }
      });
    });
  }

  _sendMessage(String msg) async {
    final user = FirebaseAuth.instance.currentUser;
    FocusScope.of(context).unfocus();
    if (_isFromProduct ?? false) {
      _isFromProduct = false;
      await FirebaseFirestore.instance
          .collection(widget.friendId)
          .doc('chatfield')
          .collection('chats')
          .get()
          .then((friendDocument) async {
        if (!friendDocument.docs.any((contact) => contact.id == user!.uid)) {
          await addContact(msg);
        }
      });
    }
    FirebaseFirestore.instance
        .collection(user!.uid)
        .doc('chatfield')
        .collection('chats')
        .doc(widget.friendId)
        .collection('chat')
        .add(
      {
        'text': msg,
        'createdAt': Timestamp.now(),
        'userId': user.uid,
        'hide': false,
      },
    ).then((refrence) {
      FirebaseFirestore.instance
          .collection(widget.friendId)
          .doc('chatfield')
          .collection('chats')
          .doc(user.uid)
          .collection('chat')
          .doc(refrence.id)
          .set(
        {
          'text': msg,
          'createdAt': Timestamp.now(),
          'userId': user.uid,
          'hide': false,
        },
      );
      if (_isFromProduct == false) {
        FirebaseFirestore.instance
            .collection(user.uid)
            .doc('chatfield')
            .collection('chats')
            .doc(widget.friendId)
            .update(
          {
            'lastmessage': msg,
            'lastmessagedate': Timestamp.now(),
          },
        );
        FirebaseFirestore.instance
            .collection(widget.friendId)
            .doc('chatfield')
            .collection('chats')
            .doc(user.uid)
            .update(
          {
            'lastmessage': msg,
            'lastmessagedate': Timestamp.now(),
          },
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30), color: Colors.white),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                hintText: 'Type a message',
                hintStyle: TextStyle(color: Colors.grey[400], fontSize: 15),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 0),
              ),
              style: const TextStyle(height: 1.2),
              autocorrect: true,
              enableSuggestions: true,
              textCapitalization: TextCapitalization.sentences,
              controller: _controller,
              onChanged: (val) {
                setState(() {
                  _enteredMessage = val;
                });
              },
            ),
          ),
          IconButton(
            color: Colors.lightGreen,
            disabledColor: Colors.grey,
            icon: const Icon(
              Icons.send,
            ),
            onPressed: _enteredMessage == ""
                ? null
                : () {
                    if (widget.isGroup) {
                      // fromGroup(_enteredMessage);
                      _sendGroupMessage(_enteredMessage);
                    } else {
                      _sendMessage(_enteredMessage);
                    }

                    setState(() {
                      _enteredMessage = "";
                      _controller.clear();
                    });
                  },
          ),
        ],
      ),
    );
  }
}
