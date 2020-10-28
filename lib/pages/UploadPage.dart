import 'dart:io';
import 'dart:ui';

import 'package:buddiesgram/models/user.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';

class UploadPage extends StatefulWidget {
  final User gCurrentUser;

  const UploadPage({Key key, this.gCurrentUser}) : super(key: key);

  @override
  _UploadPageState createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  File file;
  TextEditingController descrptionTextEditingController =
      TextEditingController();
  TextEditingController locationTextEditingController = TextEditingController();
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
    return file == null ? displayUploadScreen() : displayUploadFormScreen();
  }

  getLocation() async {
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    List<Placemark> placemarks = await Geolocator()
        .placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark mplaceMark = placemarks[0];
    String completeAddressInfo =
        '${mplaceMark.subThoroughfare} ${mplaceMark.thoroughfare},${mplaceMark.subLocality} ${mplaceMark.locality},${mplaceMark.subAdministrativeArea} ${mplaceMark.administrativeArea},${mplaceMark.postalCode} ${mplaceMark.country}';
    String specificAddress = '${mplaceMark.locality},${mplaceMark.country}';
    locationTextEditingController.text = specificAddress;
  }

  displayUploadFormScreen() {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: removeImage,
        ),
        centerTitle: true,
        title: Text(
          "New Post",
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          FlatButton(
            onPressed: () => print('tapped'),
            child: Text(
              "Share",
              style: TextStyle(
                color: Colors.greenAccent,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        children: [
          Container(
            height: 230,
            width: MediaQuery.of(context).size.width * 0.8,
            child: Center(
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          fit: BoxFit.cover, image: FileImage(file))),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 12),
          ),
          ListTile(
            leading: CircleAvatar(
              backgroundImage:
                  CachedNetworkImageProvider(widget.gCurrentUser.url),
            ),
            title: Container(
              width: 250,
              child: TextField(
                controller: descrptionTextEditingController,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                    hintText: "Say something",
                    hintStyle: TextStyle(
                      color: Colors.white,
                    ),
                    border: InputBorder.none),
              ),
            ),
          ),
          Divider(),
          ListTile(
            leading: Icon(
              Icons.person_pin_circle,
              color: Colors.white,
              size: 36,
            ),
            title: Container(
              width: 250,
              child: TextField(
                controller: locationTextEditingController,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                    hintText: "Location...",
                    hintStyle: TextStyle(
                      color: Colors.white,
                    ),
                    border: InputBorder.none),
              ),
            ),
          ),
          Container(
            width: 220,
            height: 110,
            alignment: Alignment.center,
            child: RaisedButton.icon(
              onPressed: getLocation,
              icon: Icon(
                Icons.location_on,
                color: Colors.white,
              ),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(35)),
              label: Text(
                "get Locayion",
                style: TextStyle(color: Colors.white),
              ),
              color: Colors.green,
            ),
          )
        ],
      ),
    );
  }

  removeImage() {
    setState(() {
      file = null;
    });
  }
}
