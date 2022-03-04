import 'package:flutter/widgets.dart';
import 'package:flutter_app_stulish/helpers/sizes_helpers.dart';
import 'package:skeletons/skeletons.dart';

class SkeletonChapter extends StatelessWidget {
  const SkeletonChapter({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(
              top: displayHeight(context) * 0.06,
              bottom: 8.0,
              left: 8.0,
              right: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding:
                        EdgeInsets.only(bottom: displayHeight(context) * 0.01),
                    child: SkeletonAvatar(
                        style: SkeletonAvatarStyle(
                            width: displayWidth(context) * 0.2, height: 20)),
                  ),
                  SkeletonAvatar(
                      style: SkeletonAvatarStyle(
                          width: displayWidth(context) * 0.4, height: 20)),
                ],
              ),
              SkeletonAvatar(
                  style: SkeletonAvatarStyle(
                      width: displayWidth(context) * 0.1,
                      height: displayHeight(context) * 0.05)),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding:
                        EdgeInsets.only(bottom: displayHeight(context) * 0.01),
                    child: SkeletonAvatar(
                        style: SkeletonAvatarStyle(
                            width: displayWidth(context) * 0.2, height: 20)),
                  ),
                  SkeletonAvatar(
                      style: SkeletonAvatarStyle(
                          width: displayWidth(context) * 0.4, height: 20)),
                ],
              ),
              SkeletonAvatar(
                  style: SkeletonAvatarStyle(
                      width: displayWidth(context) * 0.1,
                      height: displayHeight(context) * 0.05)),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding:
                        EdgeInsets.only(bottom: displayHeight(context) * 0.01),
                    child: SkeletonAvatar(
                        style: SkeletonAvatarStyle(
                            width: displayWidth(context) * 0.2, height: 20)),
                  ),
                  SkeletonAvatar(
                      style: SkeletonAvatarStyle(
                          width: displayWidth(context) * 0.4, height: 20)),
                ],
              ),
              SkeletonAvatar(
                  style: SkeletonAvatarStyle(
                      width: displayWidth(context) * 0.1,
                      height: displayHeight(context) * 0.05)),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding:
                        EdgeInsets.only(bottom: displayHeight(context) * 0.01),
                    child: SkeletonAvatar(
                        style: SkeletonAvatarStyle(
                            width: displayWidth(context) * 0.2, height: 20)),
                  ),
                  SkeletonAvatar(
                      style: SkeletonAvatarStyle(
                          width: displayWidth(context) * 0.4, height: 20)),
                ],
              ),
              SkeletonAvatar(
                  style: SkeletonAvatarStyle(
                      width: displayWidth(context) * 0.1,
                      height: displayHeight(context) * 0.05)),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding:
                        EdgeInsets.only(bottom: displayHeight(context) * 0.01),
                    child: SkeletonAvatar(
                        style: SkeletonAvatarStyle(
                            width: displayWidth(context) * 0.2, height: 20)),
                  ),
                  SkeletonAvatar(
                      style: SkeletonAvatarStyle(
                          width: displayWidth(context) * 0.4, height: 20)),
                ],
              ),
              SkeletonAvatar(
                  style: SkeletonAvatarStyle(
                      width: displayWidth(context) * 0.1,
                      height: displayHeight(context) * 0.05)),
            ],
          ),
        ),
      ],
    );
  }
}
