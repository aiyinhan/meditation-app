import 'package:flutter/material.dart';

class VideoIcon extends StatelessWidget {
  const VideoIcon({Key? key, required this.operationName, this.titleController, required this.buttonText, this.onPressed, this.icon}) : super(key: key);

  final String operationName;
  final  titleController;
  final String buttonText;
  final Function()? onPressed;
  final IconData ?icon;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(
                operationName,
                style: TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Alegreya',
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Alegreya',
                    ),
                    controller: titleController,
                    decoration: InputDecoration(
                      labelText: 'Title',
                      labelStyle: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Alegreya',
                      ),
                    ),
                  ),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Alegreya',
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: Text(
                    buttonText,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Alegreya',
                    ),
                  ),
                  onPressed:onPressed,
                ),
              ],
            );
          },
        );
      },
      icon: Icon(icon, color: Colors.black87,),
    );
  }
}
