import 'package:flutter/material.dart';
import 'package:kindem_app/helpers/sizes_helpers.dart';

class DialogMessage extends StatefulWidget {
  DialogMessage({
    Key? key,
    required this.textDialog,
  }) : super(key: key);

  final String textDialog;

  @override
  State<DialogMessage> createState() => _DialogMessageState();
}

class _DialogMessageState extends State<DialogMessage> {
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
                            horizontal: displayWidth(context) * 0.08,
                            vertical: displayHeight(context) * 0.02),
                        decoration: BoxDecoration(
                          color: Color(0xFFF5A71F),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text("Tidak",
                            style: TextStyle(color: Colors.white))),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
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
                            Text("Ya", style: TextStyle(color: Colors.white))),
                    onPressed: () {
                      int count = 2;
                      Navigator.of(context).popUntil((_) => count-- <= 0);
                      // Navigator.of(context).pop();
                      // Navigator.of(context).pop();
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
