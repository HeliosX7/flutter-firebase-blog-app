import 'package:flutter/material.dart';

class DialogBox {
  information(BuildContext context, String title, String desc) {
    return showDialog(
      context:context,
      barrierDismissible: true,

      builder: (BuildContext context){
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(desc),
              ],
            ),
          ),

          actions: <Widget>[
            FlatButton(onPressed: (){
              return Navigator.pop(context);
            }, child: Text("OK"))
          ],
        );
      }
    );
  }
}
