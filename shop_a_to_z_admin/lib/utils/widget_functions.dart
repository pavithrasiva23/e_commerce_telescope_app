import 'package:flutter/material.dart';

class Utils{
 static showSingleTextInputDialog({
    required BuildContext context,
    required String title,
    String posBtnText = 'OK',
    String negBtnText = 'CLOSE',
    required Function(String) onSubmit
  }){
    final textCtrller = TextEditingController();
    showDialog(context: context, builder: (innerCtx){
      return AlertDialog(
        title: Text(title),
        content: Padding(
          padding: const EdgeInsets.all(12),
          child: TextField(
            controller: textCtrller,
            autofocus: true, //whenever dialog box opened then textfield is shown as focussed/selected
            decoration: InputDecoration(
                labelText: title
            ),
          ),
        ),
        actions: [
          TextButton(onPressed: ()
          {
            if(textCtrller.text.isEmpty) return;
            onSubmit(textCtrller.text);
            Navigator.pop(innerCtx);
          },
              child: Text(posBtnText)),
          TextButton(onPressed: ()=> Navigator.pop(innerCtx), child: Text(negBtnText))
        ],
      );
    });
  } 
  
  static showMsg(BuildContext context, String msg)=> ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
}
