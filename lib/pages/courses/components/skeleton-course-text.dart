import 'package:flutter/widgets.dart';
import 'package:kindem_app/helpers/sizes_helpers.dart';
import 'package:skeletons/skeletons.dart';

class SkeletonTextCourse extends StatelessWidget {
  const SkeletonTextCourse({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SkeletonAvatar(
            style: SkeletonAvatarStyle(
                width: displayWidth(context) * 0.2, height: 25)),
        Padding(
          padding: EdgeInsets.only(top: displayHeight(context) * 0.01),
          child: SkeletonAvatar(
              style: SkeletonAvatarStyle(
                  width: displayWidth(context) * 0.4, height: 25)),
        ),
      ],
    );
  }
}
