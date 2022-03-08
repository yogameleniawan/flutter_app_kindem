import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app_stulish/helpers/sizes_helpers.dart';
import 'package:skeletons/skeletons.dart';

class ImageCourse extends StatelessWidget {
  const ImageCourse({
    Key? key,
    required this.courses,
    required this.indexCourses,
  }) : super(key: key);

  final List courses;
  final int indexCourses;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: displayWidth(context) * 0.1,
        vertical: displayWidth(context) * 0.3,
      ),
      child: Skeleton(
        skeleton: SkeletonAvatar(
          style: SkeletonAvatarStyle(
            width: displayWidth(context) * 1,
            minHeight: displayHeight(context) * 0.1,
            maxHeight: displayHeight(context) * 0.3,
          ),
        ),
        isLoading: courses.length < 1,
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(20)),
          child: CachedNetworkImage(
            height: displayHeight(context) * 0.3,
            width: displayWidth(context) * 0.8,
            imageUrl: courses.length > 0 ? courses[indexCourses].image : "",
            progressIndicatorBuilder: (context, url, downloadProgress) =>
                SkeletonAvatar(
              style: SkeletonAvatarStyle(
                width: displayWidth(context) * 1,
                minHeight: displayHeight(context) * 0.1,
                maxHeight: displayHeight(context) * 0.3,
              ),
            ),
            errorWidget: (context, url, error) => Icon(Icons.error),
          ),
        ),
      ),
    );
  }
}
