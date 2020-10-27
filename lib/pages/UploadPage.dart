import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UploadPage extends StatefulWidget {
  @override
  _UploadPageState createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  File file;
  displayUploadScreen() {
    return Container(
      color: Theme.of(context).accentColor.withOpacity(0.5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.add_photo_alternate,
            color: Colors.green,
            size: 200,
          ),
          Padding(
            padding: EdgeInsets.only(top: 20),
            child: RaisedButton(
              onPressed: () => takeImage(context),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(9),
              ),
              child: Text(
                "Upload Image ",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              color: Colors.green,
            ),
          )
        ],
      ),
    );
  }

  captureImage(ImageSource source) async {
    final imagefile = await ImagePicker()
        .getImage(source: source, maxHeight: 680, maxWidth: 970);

    // Navigator.pop(context);
    // File imagefile = await ImagePicker.pickImage(
    //     source: source, maxHeight: 680, maxWidth: 970);
    setState(() {
      file = File(imagefile.path);
    });

    Navigator.pop(context);
  }

  takeImage(mcontext) {
    return showDialog(
      context: mcontext,
      builder: (context) {
        return SimpleDialog(
          backgroundColor: Colors.white54,
          title: Text(
            "New Post",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          children: [
            SimpleDialogOption(
              onPressed: () => captureImage(ImageSource.camera),
              child: Text(
                "CaptureImage with Camera",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            SimpleDialogOption(
              onPressed: () => captureImage(ImageSource.gallery),
              child: Text(
                "Select Image  From Gallery",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            SimpleDialogOption(
              onPressed: () => Navigator.pop(context),
              child: Text(
                "Cancel",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return displayUploadScreen();
  }
}
