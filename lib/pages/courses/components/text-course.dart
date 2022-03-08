import 'package:flutter/material.dart';
import 'package:flutter_app_stulish/pages/courses/components/skeleton-course-text.dart';
import 'package:skeletons/skeletons.dart';

class TextCourse extends StatelessWidget {
  const TextCourse({
    Key? key,
    required this.courses,
    required this.indexCourses,
  }) : super(key: key);

  final List courses;
  final int indexCourses;

  @override
  Widget build(BuildContext context) {
    return Skeleton(
      skeleton: SkeletonTextCourse(),
      isLoading: courses.length < 1,
      child: Column(
        children: [
          Text(courses.length > 0 ? courses[indexCourses].english_text : "-",
              style: TextStyle(
                fontSize: 30,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              )),
          Text(courses.length > 0 ? courses[indexCourses].indonesia_text : "-",
              style: TextStyle(color: Colors.black, fontSize: 20)),
        ],
      ),
    );
  }
}
