import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:early_ed/database/my_database.dart';
import 'package:early_ed/helpers/helper.dart';
import 'package:early_ed/model/news_model.dart';
import 'package:early_ed/Presentation/news/news_screen.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddNews extends StatefulWidget {
  const AddNews({super.key, required this.canEdit});

  final bool canEdit;

  @override
  State<AddNews> createState() => _AddNewsState();
}

class _AddNewsState extends State<AddNews> {
  String? _image;
  TextEditingController controller = TextEditingController();

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
          title: Column(
            children: [
              Image.asset(
                "assets/images/EARLYED.png",
                width: 150,
                height: 100,
                fit: BoxFit.fill,
              ),
            ],
          ),
          centerTitle: true,
          backgroundColor: Colors.lightBlue,
          actions: const [
            Icon(Icons.more_vert_rounded, size: 33, color: Colors.black)
          ],
        ),
        body: Center(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          _image != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(
                      MediaQuery.of(context).size.height * .1),
                  child: Image.file(
                    File(_image!),
                    width: MediaQuery.of(context).size.height * .2,
                    height: MediaQuery.of(context).size.height * .2,
                    fit: BoxFit.cover,
                  ),
                )
              : Container(),
          ElevatedButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return Container(
                      padding: const EdgeInsets.all(10),
                      height: 150,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Choose your Image",
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                          InkWell(
                              onTap: () async {
                                final ImagePicker picker = ImagePicker();
                                final XFile? image = await picker.pickImage(
                                    source: ImageSource.gallery,
                                    imageQuality: 80);
                                if (image != null) {
                                  log('Image path: ${image.path} -- MimeType ${image.mimeType}');
                                  setState(() {
                                    _image = image.path;
                                  });
                                }
                              },
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(10),
                                child: const Row(
                                  children: [
                                    Icon(Icons.photo),
                                    Text(
                                      "From Gallery",
                                      style: TextStyle(fontSize: 20),
                                    )
                                  ],
                                ),
                              )),
                          InkWell(
                              onTap: () async {
                                final ImagePicker picker = ImagePicker();
                                final XFile? image = await picker.pickImage(
                                    source: ImageSource.camera,
                                    imageQuality: 80);
                                if (image != null) {
                                  log('Image path: ${image.path} -- MimeType ${image.mimeType}');
                                  setState(() {
                                    _image = image.path;
                                  });
                                }
                              },
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(10),
                                child: const Row(
                                  children: [
                                    Icon(Icons.camera_alt_outlined),
                                    Text(
                                      "From Camera",
                                      style: TextStyle(fontSize: 20),
                                    )
                                  ],
                                ),
                              )),
                        ],
                      ),
                    );
                  },
                );
              },
              child: const Text("Upload Image")),
          TextFormField(
            controller: controller,
            minLines: 1,
            maxLines: 8,
            decoration: const InputDecoration(
              filled: true,
              fillColor: Colors.white,
              hintText: "type here",
            ),
          ),
          ElevatedButton(
              onPressed: () async {
                NewsModel newModel = NewsModel(
                    details: controller.text.trim(), imageUrl: _image);
                if (_image != null)
                  MyDataBase.addNewsImage(newModel, File(_image!));
                MyDataBase.addNews(newModel);
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            NewsScreen(canEdit: widget.canEdit)));
                var data = await FirebaseFirestore.instance
                    .collection('userslist')
                    .get();
                for (var doc in data.docs) {
                  AppHelper.pushNotification(
                      userToken: doc.data()['noti_token'] ?? "",
                      title: "news",
                      body: controller.text,
                      imageURL: "https://anything.com/abc.jpg");
                }
              },
              child: const Text('submit'))
        ])));
  }
}
