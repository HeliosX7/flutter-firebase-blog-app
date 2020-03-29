import 'dart:io';
import 'package:blogger/post.dart';
import 'package:flutter/material.dart';
import 'package:blogger/upload.dart';
import 'package:firebase_database/firebase_database.dart';
import 'auth.dart';
import 'package:image_picker/image_picker.dart';

class Feed extends StatefulWidget {
  final AuthImplementation auth;
  final VoidCallback onSignedOut;
  Feed({
    this.auth,
    this.onSignedOut,
  });
  @override
  _FeedState createState() => _FeedState();
}

class _FeedState extends State<Feed> {
  List<Post> postList = [];
  File _image;

  @override
  void initState() {
    super.initState();
    DatabaseReference postRef =
        FirebaseDatabase.instance.reference().child("posts");
    postRef.once().then((DataSnapshot snap) {
      var postKeys = snap.value.keys;
      var postData = snap.value;

      postList.clear();

      for (var postKey in postKeys) {
        Post posts = Post(
          postData[postKey]['image'],
          postData[postKey]['desc'],
          postData[postKey]['date'],
          postData[postKey]['time'],
        );

        postList.add(posts);

        setState(() {
          print('Length : $postList.length');
        });
      }
    });
  }

  void logOutUser() async {
    try {
      await widget.auth.signOut();
      widget.onSignedOut();
    } catch (e) {
      print("error :" + e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Feed",
          style: TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5),
        ),
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      body: Container(
        child: postList.length == 0
            ? Center(
                child: Text("No blogs yet"),
              )
            : ListView.builder(
                itemCount: postList.length,
                itemBuilder: (_, index) {
                  return postCard(
                    postList[index].image,
                    postList[index].desc,
                    postList[index].date,
                    postList[index].time,
                  );
                },
              ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          decoration: BoxDecoration(
            gradient:
                LinearGradient(colors: [Colors.cyan, Colors.blue]),
          ),
          child: Padding(
            padding: EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                IconButton(
                    tooltip: 'Refresh',
                    icon: Icon(Icons.refresh),
                    onPressed: () {
                      setState(() {});
                    }),
                IconButton(
                    tooltip: 'Add post',
                    icon: Icon(Icons.add_circle),
                    onPressed: () async {
                      await getImage();
                      if(_image != null){
                        Navigator.push(context,
                          MaterialPageRoute(builder: (context) => NewPost(image: _image,)));
                      }
                    }),
                IconButton(
                    tooltip: 'Profile',
                    icon: Icon(Icons.person),
                    onPressed: (){}),
                IconButton(
                    tooltip: 'Logout',
                    icon: Icon(Icons.call_missed_outgoing),
                    onPressed: logOutUser),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future getImage() async{
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image=image;
    }); 
  }

  Widget postCard(String image, String desc, String date, String time) {
    return Card(
      elevation: 10,
      margin: EdgeInsets.all(15),
      child: Container(
        padding: EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  date,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.subtitle,
                ),
                Text(
                  time,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.subtitle,
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Image.network(
              image,
              fit: BoxFit.contain,
              height: 300,
              width: 600,
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              desc,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.subhead,
            ),
          ],
        ),
      ),
    );
  }
}
