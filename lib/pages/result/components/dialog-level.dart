import 'package:flutter/material.dart';
import 'package:flutter_app_stulish/helpers/sizes_helpers.dart';

class DialogLevel extends StatefulWidget {
  DialogLevel({
    Key? key,
    required this.textDialog,
  }) : super(key: key);

  final String textDialog;

  @override
  State<DialogLevel> createState() => _DialogLevelState();
}

class _DialogLevelState extends State<DialogLevel> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            height: displayHeight(context) * 0.4,
            margin: EdgeInsets.only(
                bottom: displayHeight(context) * 0.09, left: 12, right: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(40),
            ),
            child: SizedBox(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  child: TextButton(
                    child: Container(
                        padding: EdgeInsets.only(
                            left: displayWidth(context) * 0.08,
                            right: displayWidth(context) * 0.08,
                            top: displayHeight(context) * 0.1),
                        child: Text(widget.textDialog,
                            style:
                                TextStyle(color: Colors.black, fontSize: 25))),
                    onPressed: () {},
                  ),
                ),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  TextButton(
                    child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: displayWidth(context) * 0.1,
                            vertical: displayHeight(context) * 0.02),
                        decoration: BoxDecoration(
                          color: Color(0xFFF5A71F),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child:
                            Text("Oke", style: TextStyle(color: Colors.white))),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  )
                ])
              ],
            )),
          ),
        ),
        Center(
          child: Image(
            width: displayWidth(context) * 0.5,
            image: AssetImage("assets/images/kindem-logo.png"),
          ),
        ),
      ],
    );
  }
}
