import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:early_ed/helpers/id_generator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CreateGroupScreen extends StatefulWidget {
  const CreateGroupScreen({super.key});

  @override
  State<CreateGroupScreen> createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends State<CreateGroupScreen> {
  bool isLoading = true;
  String groupName = '';
  var groupList = [];
  List<QueryDocumentSnapshot<Map<String, dynamic>>> users = [];
  @override
  void initState() {
    FirebaseFirestore.instance.collection("userslist").get().then((value) {
      setState(() {
        users = value.docs
            .where((element) =>
                element.id != FirebaseAuth.instance.currentUser!.uid)
            .toList();
        isLoading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Select Users"),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: users.length,
              itemBuilder: (ctxx, index) {
                return ListTile(
                  trailing: Icon(
                      groupList.contains(users[index].data()['userId'])
                          ? Icons.check_box
                          : Icons.check_box_outline_blank_rounded),
                  title: Text(users[index].data()['userName'] ?? ""),
                  leading: ElevatedButton(
                    style: ButtonStyle(
                        shape: MaterialStateProperty.all(const CircleBorder()),
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
                                      users[index]['userImageUrl']),
                                ),
                              ));
                    },
                    child: CircleAvatar(
                      radius: 26,
                      backgroundImage:
                          NetworkImage(users[index]['userImageUrl']),
                    ),
                  ),
                  onTap: () {
                    setState(() {
                      if (groupList.contains(users[index].data()['userId'])) {
                        groupList.remove(users[index].data()['userId']);
                      } else {
                        groupList.add(users[index].data()['userId']);
                      }
                    });
                    //   Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (ctx) => FriendScreen(
                    //       userName: users[index]['userName'],
                    //       imageUrl: users[index]['userImageUrl'],
                    //       userId: users[index]['userId'],
                    //       seen: 0,
                    //       isFromProduct: true,
                    //     ),
                    //   ),
                    // );
                  },
                );
              },
            ),
      floatingActionButton: ElevatedButton(
          onPressed: groupList.isEmpty
              ? null
              : () {
                  showDialog(
                    context: context,
                    builder: (ctx) {
                      return AlertDialog(
                        title: const Text("Group name"),
                        content: TextFormField(
                          onChanged: (value) {
                            setState(() {
                              groupName = value;
                            });
                          },
                        ),
                        actions: [
                          TextButton(
                            onPressed: () async {
                              groupList.insert(
                                  0, FirebaseAuth.instance.currentUser!.uid);
                              var groupId = RandomGenerator.generateGroupID();
                              List<QueryDocumentSnapshot<Map<String, dynamic>>>
                                  addedGroupList = users
                                      .where((user) => groupList.any(
                                          (element) =>
                                              user.data()['userId'] == element))
                                      .toList();
                              await FirebaseFirestore.instance
                                  .collection(
                                      FirebaseAuth.instance.currentUser!.uid)
                                  .doc('chatfield')
                                  .collection('chats')
                                  .doc(groupId)
                                  .set(
                                {
                                  'userid': groupId,
                                  'isGroup': true,
                                  'group_members': groupList,
                                  'username': groupName,
                                  'image_url':
                                      'https://cdn.iconscout.com/icon/free/png-256/free-group-1543496-1305988.png',
                                  'messagelength': "0",
                                  'seen': "0",
                                  'lastmessage': 'you create the group',
                                  'lastmessagedate': Timestamp.now(),
                                },
                              );
                              for (var element in addedGroupList) {
                                FirebaseFirestore.instance
                                    .collection(element.data()['userId'])
                                    .doc('chatfield')
                                    .collection('chats')
                                    .doc(groupId)
                                    .set(
                                  {
                                    'isGroup': true,
                                    'userid': groupId,
                                    'group_members': groupList,
                                    'username': groupName,
                                    'image_url':
                                        'https://cdn.iconscout.com/icon/free/png-256/free-group-1543496-1305988.png',
                                    'messagelength': "0",
                                    'seen': "0",
                                    'lastmessage': 'admin added you',
                                    'lastmessagedate': Timestamp.now(),
                                  },
                                );
                              }
                              Navigator.of(ctx).pop();
                              Navigator.of(context).pop();
                            },
                            child: const Text("Create"),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(ctx).pop();
                            },
                            child: const Text("Cancel"),
                          ),
                        ],
                      );
                    },
                  );
                },
          child: const Text("Create")),
    );
  }
}
