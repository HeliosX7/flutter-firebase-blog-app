import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:intl/intl.dart';
import 'package:blogger/feed.dart';
import 'dialogbox.dart';

class NewPost extends StatefulWidget {
  final File image;
  NewPost({Key key, @required this.image}) : super(key: key);

  @override
  _NewPostState createState() => _NewPostState(image);
}

class _NewPostState extends State<NewPost> {
  File image;
  String _desc;
  String _url;
  DialogBox dialogBox;
  final formKey = GlobalKey<FormState>();

  _NewPostState(this.image);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Create Post",
          style: TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5),
        ),
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      body: Center(
        child: Container(
            padding: EdgeInsets.all(25),
            child: Form(
                key: formKey,
                child: Column(children: <Widget>[
                  Image.file(image, height: 175, width: 350),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Caption'),
                    validator: (value) {
                      return value.isEmpty ? 'Description is required' : null;
                    },
                    onSaved: (value) {
                      return _desc = value;
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  InkWell(
                    onTap: uploadImage,
                    child: Container(
                      width: 100,
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                              colors: [Colors.cyan, Colors.blue]),
                          borderRadius: BorderRadius.circular(6.0),
                          boxShadow: [
                            BoxShadow(
                                color: Color(0xFF6078ea).withOpacity(.3),
                                offset: Offset(0.0, 8.0),
                                blurRadius: 8.0)
                          ]),
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: Text(
                            "DONE",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.5),
                          ),
                        ),
                      ),
                    ),
                  ),
                ]))),
      ),
    );
  }

  bool formValidateAndSave() {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }

  void uploadImage() async {
    if (formValidateAndSave()) {
      final StorageReference postImageRef =
          FirebaseStorage.instance.ref().child("post images");
      var timeKey = DateTime.now();
      final StorageUploadTask uploadTask =
          postImageRef.child(timeKey.toString() + ".jpg").putFile(image);
      var imageUrl = await (await uploadTask.onComplete).ref.getDownloadURL();
      _url = imageUrl.toString();
      await saveToDatabase(_url);
      goToFeed();
    }
  }

  Future saveToDatabase(url) async {
    var timeKey = DateTime.now();
    var formatDate = DateFormat('MMM d, yyyy');
    var formatTime = DateFormat('EEEE, hh:mm aaa');

    String date = formatDate.format(timeKey);
    String time = formatTime.format(timeKey);

    DatabaseReference ref = FirebaseDatabase.instance.reference();
    var data = {"image": _url, "desc": _desc, "date": date, "time": time};

    ref.child("posts").push().set(data);
  }

  void goToFeed() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => Feed()));
  }
}
