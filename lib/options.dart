import 'books.dart';
import 'package:flutter/material.dart';
import 'videos.dart';
import 'package:e_learner/services/authentication.dart';
import 'admin.dart';
import 'package:firebase_database/firebase_database.dart';

final dbRef = FirebaseDatabase.instance.reference();

class OptionScreen extends StatefulWidget {
    OptionScreen({Key key, this.auth, this.userId, this.logoutCallback})
      : super(key: key);

  final BaseAuth auth;
  final VoidCallback logoutCallback;
  final String userId;

  @override
  OptionScreenState createState() {
    return new OptionScreenState();
  }
}

class OptionScreenState extends State<OptionScreen> {

  bool _isButtonDisabled = true;
  Map <dynamic, dynamic> values;

  @override
  void initState() {
    checkAdmin();
    super.initState();
  }

  void checkAdmin(){
    var data = dbRef.child("Admins");
    data.once().then((DataSnapshot snapshot) {
      values = snapshot.value;

      setState(() {
        for(var k in values.keys)
          if(k.toString() == widget.auth.toString() || k.toString() == widget.userId)
            _isButtonDisabled = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            bottom: TabBar(
              tabs: [
                Tab(icon: Icon(Icons.ondemand_video)),
                Tab(icon: Icon(Icons.book)),
              ],
            ),
            title: Text('E_Learner IITG'),
            actions: <Widget>[
              new FlatButton(
                onPressed:
                  _isButtonDisabled ? null : () {
                  Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (context) => new AdminScreen()),
                  );
                },
                child: new Text('Admin'),
              ),
              new FlatButton(
                child: new Text('Logout',
                style: new TextStyle(fontSize: 17.0, color: Colors.white)),
                onPressed: signOut)
            ],
          ),
          body: TabBarView(
            children: [
              videoSearch(),
              bookSearch(),
            ],
          ),
        ),
      ),
    );
  }

    signOut() async {
    try {
      await widget.auth.signOut();
      widget.logoutCallback();
    } catch (e) {
      print(e);
    }
  }

}