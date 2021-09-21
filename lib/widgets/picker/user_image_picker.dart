import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  final void Function(File pickedImagefn) imagePickfn;
  UserImagePicker(this.imagePickfn);

  @override
  _UserImagePickerState createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File _pickedImage;

  void pickImage() async {
    final pickedImage = await ImagePicker.pickImage(
        source: ImageSource.camera, imageQuality: 50, maxWidth: 150);

    setState(() {
      _pickedImage = pickedImage;
    });
    widget.imagePickfn(pickedImage);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundImage:
              _pickedImage != null ? FileImage(_pickedImage) : null,
          backgroundColor: Colors.grey,
        ),
        FlatButton.icon(
            onPressed: pickImage,
            icon: Icon(Icons.image),
            label: Text('Add Image')),
      ],
    );
  }
}
