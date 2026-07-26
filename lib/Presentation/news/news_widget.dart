import 'package:cached_network_image/cached_network_image.dart';
import 'package:early_ed/model/news_model.dart';
import 'package:early_ed/Presentation/news/news_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NewsWidget extends StatelessWidget {
  const NewsWidget({super.key, required this.news, required this.canEdit});
  final NewsModel news;
  final bool canEdit;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: CachedNetworkImage(
              fit: BoxFit.contain,
              height: 250.h,
              width: 300.w,
              imageUrl: news.imageUrl ??
                  'https://s.france24.com/media/display/e6279b3c-db08-11ee-b7f5-005056bf30b7/w:1024/p:16x9/news_en_1920x1080.jpg',
              // errorWidget: (context, url, error) => const CustomImage(imagePath: AppAssets.errorImage),
              // placeholder: (context, url) => const CustomImage(imagePath: AppAssets.placeholder),
              progressIndicatorBuilder: (context, url, progress) => SizedBox(
                  width: 228.w,
                  child: const Center(child: CircularProgressIndicator())))),
      Row(mainAxisAlignment: MainAxisAlignment.end, children: [
        SizedBox(
            width: 150.w,
            child: Text(
              news.details ?? '',
              style: TextStyle(fontSize: 20.h),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            )),
        TextButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NewsDetailsScreen(
                      news: news,
                      canEdit: canEdit,
                    ),
                  ));
            },
            child: const Text("Read more.."))
      ])
    ]);
  }
}
