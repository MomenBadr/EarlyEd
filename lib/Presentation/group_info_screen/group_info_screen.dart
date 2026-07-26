import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:early_ed/Presentation/group_info_screen/add_new_users_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class GroupInfoScreen extends StatefulWidget {
  final String groupId;
  final String groupName;

  const GroupInfoScreen(
      {super.key, required this.groupId, required this.groupName});

  @override
  State<GroupInfoScreen> createState() => _GroupInfoScreenState();
}

class _GroupInfoScreenState extends State<GroupInfoScreen> {
  bool isLoading = true;
  List<Map<String, dynamic>> usersList = [];
  @override
  void initState() {
    getUsersList();
    super.initState();
  }

  void getUsersList() async {
    if (!isLoading) {
      isLoading = true;
    }
    var data = await FirebaseFirestore.instance.collection('userslist').get();

    setState(() {
      usersList = data.docs.map((user) => user.data()).toList();
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(""),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection(FirebaseAuth.instance.currentUser!.uid)
                  .doc('chatfield')
                  .collection('chats')
                  .doc(widget.groupId)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  List<String> groupMembers =
                      List.from(snapshot.data?.data()?['group_members'] ?? []);

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // const SizedBox(
                      //   height: 40,
                      // ),
                      Text(
                        widget.groupName,
                        style: const TextStyle(fontSize: 20),
                      ),
                      const SizedBox(
                        height: 39,
                      ),
                      Transform.scale(
                        scale: 1.5,
                        child: const CircleAvatar(
                          radius: 26,
                          backgroundImage: NetworkImage(
                            'https://cdn.iconscout.com/icon/free/png-256/free-group-1543496-1305988.png',
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text("Group Members"),
                                IconButton(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                AddNewUsersScreen(
                                                    groupId: widget.groupId,
                                                    groupName: widget.groupName,
                                                    currentUsers: groupMembers),
                                          ));
                                    },
                                    icon: const Icon(
                                      Icons.group_add_outlined,
                                      color: Colors.green,
                                    ))
                              ],
                            )),
                      ),
                      const Divider(
                        endIndent: 10,
                        indent: 20,
                      ),
                      SizedBox(
                        width: double.infinity,
                        height: 300,
                        child: ListView.builder(
                            itemCount: groupMembers.length,
                            itemBuilder: (ctxx, index) {
                              return ListTile(
                                title: Text(usersList.firstWhere((element) =>
                                        element['userId'] ==
                                        groupMembers[index])['userName'] ??
                                    ""),
                                leading: ElevatedButton(
                                  style: ButtonStyle(
                                      shape: MaterialStateProperty.all(
                                          const CircleBorder()),
                                      padding: MaterialStateProperty.all(
                                          EdgeInsets.zero)),
                                  onPressed: () {
                                    showDialog(
                                        context: context,
                                        builder: (ctx) => AlertDialog(
                                              contentPadding: EdgeInsets.zero,
                                              shape:
                                                  const RoundedRectangleBorder(),
                                              content: SizedBox(
                                                height: 300,
                                                width: 300,
                                                child: Image.network(usersList
                                                        .firstWhere((element) =>
                                                            element['userId'] ==
                                                            groupMembers[
                                                                index])[
                                                    'userImageUrl']),
                                              ),
                                            ));
                                  },
                                  child: CircleAvatar(
                                    radius: 26,
                                    backgroundImage: NetworkImage(
                                        usersList.firstWhere((element) =>
                                                element['userId'] ==
                                                groupMembers[index])[
                                            'userImageUrl']),
                                  ),
                                ),
                                trailing: groupMembers[index] ==
                                        'bQFcj7UM1CaaJtlEN3Zz41lZe6T2'
                                    ? const Text(
                                        "Admin",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold),
                                      )
                                    : IconButton(
                                        icon: const Icon(
                                            Icons.group_remove_outlined),
                                        color: Colors.red,
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder: (context) => AlertDialog(
                                              title:
                                                  const Text("Are you sure?"),
                                              content: Text(
                                                  "Do you really want to remove [${usersList.firstWhere((element) => element['userId'] == groupMembers[index])['userName'] ?? ""}] from the group"),
                                              actions: [
                                                TextButton(
                                                  onPressed: () {
                                                    var deletedMember =
                                                        groupMembers[index];
                                                    groupMembers
                                                        .removeAt(index);
                                                    FirebaseFirestore.instance
                                                        .collection(FirebaseAuth
                                                            .instance
                                                            .currentUser!
                                                            .uid)
                                                        .doc('chatfield')
                                                        .collection('chats')
                                                        .doc(widget.groupId)
                                                        .update({
                                                      'group_members':
                                                          groupMembers
                                                    });
                                                    FirebaseFirestore.instance
                                                        .collection(
                                                            deletedMember)
                                                        .doc('chatfield')
                                                        .collection('chats')
                                                        .doc(widget.groupId)
                                                        .delete();
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: const Text(
                                                    "Remove",
                                                    style: TextStyle(
                                                        color: Colors.red),
                                                  ),
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: const Text(
                                                    "Cancel",
                                                    style: TextStyle(
                                                        color: Colors.red),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                onTap: () {},
                              );
                            }),
                      ),
                    ],
                  );
                  // return Column(
                  //   crossAxisAlignment: CrossAxisAlignment.center,
                  //   children: [
                  //     const CircleAvatar(
                  //       child: Icon(Icons.group),
                  //     ),
                  //     const SizedBox(
                  //       height: 100,
                  //     ),
                  //     const Text("Group Members"),
                  //     ListView.builder(
                  //         itemCount: groupMembers.length,
                  //         itemBuilder: (ctxx, index) {
                  //           return ListTile(
                  //             title: Text(usersList.firstWhere((element) =>
                  //                         element[groupMembers[index]])[
                  //                     'userName'] ??
                  //                 ""),
                  //             leading: ElevatedButton(
                  //               style: ButtonStyle(
                  //                   shape: MaterialStateProperty.all(
                  //                       const CircleBorder()),
                  //                   padding: MaterialStateProperty.all(
                  //                       EdgeInsets.zero)),
                  //               onPressed: () {
                  //                 showDialog(
                  //                     context: context,
                  //                     builder: (ctx) => AlertDialog(
                  //                           contentPadding: EdgeInsets.zero,
                  //                           shape:
                  //                               const RoundedRectangleBorder(),
                  //                           content: SizedBox(
                  //                             height: 300,
                  //                             width: 300,
                  //                             child: Image.network(usersList
                  //                                     .firstWhere((element) =>
                  //                                         element[groupMembers[
                  //                                             index]])[
                  //                                 'userImageUrl']),
                  //                           ),
                  //                         ));
                  //               },
                  //               child: CircleAvatar(
                  //                 radius: 26,
                  //                 backgroundImage: NetworkImage(
                  //                     usersList.firstWhere((element) =>
                  //                             element[groupMembers[index]])[
                  //                         'userImageUrl']),
                  //               ),
                  //             ),
                  //             onTap: () {},
                  //           );
                  //         }),
                  //   ],
                  // );
                }
              },
            ),
    );
  }
}
