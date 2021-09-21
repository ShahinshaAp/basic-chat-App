import 'dart:io';

import 'package:chat_app/widgets/Auth/auth_form.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Authscreen extends StatefulWidget {
  @override
  _AuthscreenState createState() => _AuthscreenState();
}

class _AuthscreenState extends State<Authscreen> {
  var _isLoading = false;
  final _auth = FirebaseAuth.instance;
  void _submitAuthForm(String useremail, String userName, String userPassword,
      File userImage, bool isLogin, BuildContext context) async {
    AuthResult authResult;
    try {
      setState(() {
        _isLoading = true;
      });
      if (isLogin) {
        authResult = await _auth.signInWithEmailAndPassword(
            email: useremail, password: userPassword);
      } else {
        authResult = await _auth.createUserWithEmailAndPassword(
            email: useremail, password: userPassword);

        final ref = FirebaseStorage.instance
            .ref()
            .child('user_image')
            .child(authResult.user.uid + '.jpg');
        await ref.putFile(userImage).onComplete;
        final url = await ref.getDownloadURL();

        await Firestore.instance
            .collection('users')
            .document(authResult.user.uid)
            .setData({
          'userName': userName,
          'userEmail': useremail,
          'userImage': url,
        });
      }
    } on PlatformException catch (error) {
      var message = ' an error occurred, please check your credential';
      if (error.message != null) {
        message = error.message;
      }
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).errorColor,
      ));
      setState(() {
        _isLoading = false;
      });
    } catch (error) {
      print(error);
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 60,
              ),
              Center(
                child: Container(
                    child: Text(
                  'Flip Chat',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 50,
                      fontWeight: FontWeight.w900),
                )),
              ),
              SizedBox(
                height: 40,
              ),
              AuthForm(_submitAuthForm, _isLoading),
            ],
          ),
        ));
  }
}
