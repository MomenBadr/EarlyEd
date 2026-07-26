// import 'package:shopping/other/constants.dart';

import 'package:early_ed/Presentation/group_info_screen/group_info_screen.dart';

import 'widgets/new_message.dart';
import 'widgets/message.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FriendScreen extends StatelessWidget {
  final String userName;
  final String imageUrl;
  final String userId;
  final int seen;
  final bool isFromProduct;
  final bool isGroup;

  const FriendScreen({
    required this.userName,
    required this.imageUrl,
    required this.userId,
    required this.seen,
    this.isFromProduct = false,
    this.isGroup = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final myid = FirebaseAuth.instance.currentUser!.uid;
    return Scaffold(
        appBar: AppBar(
          title: ListTile(
            contentPadding: EdgeInsets.zero,
            subtitle: const Text("Online"),
            title: Text(
              userName,
            ),
            leading: CircleAvatar(
              backgroundImage: NetworkImage(imageUrl),
            ),
          ),
          actions: [
            isGroup &&
                    FirebaseAuth.instance.currentUser!.uid ==
                        "bQFcj7UM1CaaJtlEN3Zz41lZe6T2"
                ? IconButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => GroupInfoScreen(
                            groupId: userId, groupName: userName),
                      ));
                    },
                    icon: const Icon(Icons.settings))
                : const SizedBox()
          ],
        ),
        body: Stack(children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            color: Theme.of(context).scaffoldBackgroundColor == Colors.white
                ? const Color(0xFFE4DDD6)
                : Colors.black12,
            child: Opacity(
              opacity: 0.06,
              child: Image.asset(
                'assets/images/chat_background.png',
                repeat: ImageRepeat.repeatX,
              ),
            ),
          ),
          Column(mainAxisSize: MainAxisSize.min, children: [
            Expanded(
                child: Messages(
              myId: myid,
              friendId: userId,
              seen: seen,
              isGroup: isGroup,
            )),
            NewMessages(
              friendId: userId,
              isFromProduct: isFromProduct,
              isGroup: isGroup,
            ),
          ]),
        ]));
  }
}
