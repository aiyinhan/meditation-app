import 'package:flutter/material.dart';

class musicIcon extends StatelessWidget {
  const musicIcon({Key? key,required this.onPressed,required this.operationName, required this.titleController, required this.artistController, required this.buttonText, required this.icon}) : super(key: key);

  final String operationName;
  final  titleController;
  final  artistController;
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
                  TextField(
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Alegreya',
                    ),
                    controller: artistController,
                    decoration: InputDecoration(
                      labelText: 'Artist',
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
