import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:deevloopers_task/screen/emailsignup.dart';
import 'package:deevloopers_task/main.dart';

import '../auth.dart';

class LogedInuser extends StatefulWidget {
  const LogedInuser({Key? key}) : super(key: key);

  @override
  _LogedInuserState createState() => _LogedInuserState();
}

class _LogedInuserState extends State<LogedInuser> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.only(left: 40,right: 40),
          child: FlatButton(
            onPressed: (){
              AuthClass().signOut();
              Navigator.pushReplacement(context, MaterialPageRoute(builder:(context)=> MyHomePage()));
            },
            child: Container(
              height: 40,
              decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(20)
              ),
                color: Colors.black,

              ),
              child: Center(child: Text('signup')),
            ),
          ),

          ),
        ),
      );

  }
}
