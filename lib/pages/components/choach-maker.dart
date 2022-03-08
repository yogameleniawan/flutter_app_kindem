import 'package:coachmaker/coachmaker.dart';
import 'package:flutter/material.dart';

CoachMaker coachMaker(BuildContext context, List<CoachModel> list) {
  return CoachMaker(context,
      initialList: list,
      nextStep: CoachMakerControl.next,
      buttonOptions: CoachButtonOptions(
          buttonTitle: 'Lanjut',
          buttonStyle: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Color(0xFFF5A71F)),
              elevation: MaterialStateProperty.all(0))));
}
