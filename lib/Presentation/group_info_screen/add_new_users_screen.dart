import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddNewUsersScreen extends StatefulWidget {
  final List<String> currentUsers;
  final String groupName;
  final String groupId;
  const AddNewUsersScreen(
      {super.key,
      required this.currentUsers,
      required this.groupId,
      required this.groupName});

  @override
  State<AddNewUsersScreen> createState() => _AddNewUsersScreenState();
}

class _AddNewUsersScreenState extends State<AddNewUsersScreen> {
  bool isLoading = true;
  var groupList = [];
  List<QueryDocumentSnapshot<Map<String, dynamic>>> users = [];
  @override
  void initState() {
    FirebaseFirestore.instance.collection("userslist").get().then((value) {
      setState(() {
        users = value.docs
            .where((element) => !widget.currentUsers
                .any((currentUser) => currentUser == element.id))
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
        title: const Text("Add Users"),
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
                  },
                );
              },
            ),
      floatingActionButton: ElevatedButton(
          onPressed: groupList.isEmpty
              ? null
              : () {
                  List<QueryDocumentSnapshot<Map<String, dynamic>>> newUsers =
                      users
                          .where((user) => groupList.any(
                              (element) => user.data()['userId'] == element))
                          .toList();
                  groupList.addAll(widget.currentUsers);
                  groupList.removeWhere(
                      (element) => element == 'bQFcj7UM1CaaJtlEN3Zz41lZe6T2');
                  groupList.insert(0, 'bQFcj7UM1CaaJtlEN3Zz41lZe6T2');
                  for (var userId in widget.currentUsers) {
                    FirebaseFirestore.instance
                        .collection(userId)
                        .doc('chatfield')
                        .collection('chats')
                        .doc(widget.groupId)
                        .update(
                      {
                        'group_members': groupList,
                      },
                    );
                  }
                  for (var element in newUsers) {
                    FirebaseFirestore.instance
                        .collection(element.data()['userId'])
                        .doc('chatfield')
                        .collection('chats')
                        .doc(widget.groupId)
                        .set(
                      {
                        'isGroup': true,
                        'userid': widget.groupId,
                        'group_members': groupList,
                        'username': widget.groupName,
                        'image_url':
                            'https://cdn.iconscout.com/icon/free/png-256/free-group-1543496-1305988.png',
                        'messagelength': "0",
                        'seen': "0",
                        'lastmessage': 'admin added you',
                        'lastmessagedate': Timestamp.now(),
                      },
                    );
                  }

                  Navigator.of(context).pop();
                },
          child: const Text("Add")),
    );
  }
}
