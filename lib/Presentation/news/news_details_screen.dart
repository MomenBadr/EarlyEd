import 'dart:developer';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:early_ed/database/my_database.dart';
import 'package:early_ed/model/news_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';


class NewsDetailsScreen extends StatefulWidget {
  const NewsDetailsScreen({super.key, required this.news, required this.canEdit});
  final NewsModel news;
  final bool canEdit;

  @override
  State<NewsDetailsScreen> createState() => _NewsDetailsScreenState();
}

class _NewsDetailsScreenState extends State<NewsDetailsScreen> {
  bool selectImage = false;
  String? _image;
  GlobalKey<FormState> formKey = GlobalKey();
  TextEditingController detailsController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: widget.canEdit? FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (_) => Form(
              key: formKey,
              child: AlertDialog(
                contentPadding: EdgeInsets.only(
                    left: 24.w, right: 24.w, top: 20.h, bottom: 10.h),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                title:Column(
                  children: [
                    ElevatedButton.icon(onPressed: () {
                      setState(() {
                        selectImage = !selectImage;
                      });
                    }, icon: const Icon(Icons.edit), label: const Text('Edit Image')),
                    if(selectImage) Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(icon: const Icon(Icons.image), onPressed: () async {
                          final ImagePicker picker = ImagePicker();
                          final XFile? image = await picker.pickImage(
                              source: ImageSource.gallery, imageQuality: 80);
                          if (image != null) {
                            log('Image path: ${image.path} -- MimeType ${image.mimeType}');
                            setState(() {
                              _image = image.path;
                            });
                          }
                        }),
                        IconButton(icon: const Icon(Icons.camera_alt), onPressed: () async {
                          final ImagePicker picker = ImagePicker();
                          final XFile? image = await picker.pickImage(
                              source: ImageSource.camera, imageQuality: 80);
                          if (image != null) {
                            log('Image path: ${image.path} -- MimeType ${image.mimeType}');
                            setState(() {
                              _image = image.path;
                            });
                          }
                        })
                      ]
                    )
                  ]
                ),
                content: TextFormField(
                  controller: detailsController,
                  validator: (text) {
                    if (text == null || text.trim().isEmpty) {
                      return 'Please enter a value';
                    }
                    return null;
                  },
                  decoration:
                  const InputDecoration(hintText: 'Details'),
                ),
                actions: [
                  MaterialButton(
                    onPressed: () {
                      _image = null;
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'cancel',
                      style: TextStyle(color: Colors.blue, fontSize: 16),
                    ),
                  ),
                  MaterialButton(
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        if(_image != null) MyDataBase.updateNewsPicture(File(_image!), widget.news.id!);
                        MyDataBase.updateNewsDetails(widget.news.id!, detailsController.text.trim());
                        Navigator.pop(context);
                        setState(() {});
                      }
                    },
                    child: Text(
                      'save',
                      style: TextStyle(color: Colors.blue, fontSize: 16.h),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        child: const Icon(Icons.edit),
        // iconSize: 40,
      ): null,
      appBar: AppBar(
        toolbarHeight: 100,
        // leading: IconButton(
        //   icon: const Icon(
        //     Icons.home,
        //     size: 35,
        //   ),
        //   onPressed: () {
        //     Navigator.push(
        //         context,
        //         MaterialPageRoute(
        //           builder: (context) => const HomeScreen(),
        //         ));
        //   },
        // ),
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

      ),
      body: Container(
        decoration: const BoxDecoration(color: Colors.white10),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
              alignment: Alignment.center,
              child: const Text(
                "NEWS",
                style: TextStyle(
                  fontSize: 50,
                  color: Colors.black,
                ),
              ),
            ),
            ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: CachedNetworkImage(
                    fit: BoxFit.contain,
                    height: 250.h,
                    width: 300.w,
                    imageUrl: widget.news.imageUrl ??
                        'https://s.france24.com/media/display/e6279b3c-db08-11ee-b7f5-005056bf30b7/w:1024/p:16x9/news_en_1920x1080.jpg',
                    // errorWidget: (context, url, error) => const CustomImage(imagePath: AppAssets.errorImage),
                    // placeholder: (context, url) => const CustomImage(imagePath: AppAssets.placeholder),
                    progressIndicatorBuilder: (context, url, progress) => SizedBox(
                        width: 228.w,
                        child: const Center(child: CircularProgressIndicator())))),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.black26)
              ),
              height: 200,
              width: 350,
              child:
              Text(
                widget.news.details ?? '',
                style: const TextStyle(fontSize: 20),
              ),
            )
          ],
        ),
      ),
    );
  }
}
