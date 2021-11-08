import 'package:flutter/material.dart';
import 'package:deevloopers_task/component/textfield.dart';
import 'package:deevloopers_task/auth.dart';
import 'package:deevloopers_task/screen/logedin user.dart';

class EmailLogin extends StatefulWidget {
  const EmailLogin({Key? key}) : super(key: key);

  @override
  _EmailLoginState createState() => _EmailLoginState();
}

class _EmailLoginState extends State<EmailLogin> {
  @override
  TextEditingController _emailText = TextEditingController();
  TextEditingController _passwordText = TextEditingController();


  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.only(left: 20,right: 20),
        children: [
          SizedBox(height: 50),
          Text('Email'),
          SizedBox(
            height: 10,
          ),
          TextFieldWithController(onPress:(value){}, controller: _emailText, textObsecure: false),
          SizedBox(height: 20),
          Text('Username'),
          SizedBox(
            height: 10,
          ),
          TextFieldWithController(onPress:(value){}, controller: _passwordText, textObsecure: false),
          SizedBox(height: 40),
          Padding(padding: EdgeInsets.all(40),
            child: FlatButton(
              onPressed: (){
                AuthClass()
                    .signIN(
                    email: _emailText.text.trim(),
                    password: _passwordText.text.trim())
                    .then((value) {
                  if (value == "Welcome") {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder:(context)=> LogedInuser()));
                  } else {

                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text(value)));
                  }
                });
              },
              child: Container(
                height: 40,
                decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(20)
                ),
                  color: Colors.black,

                ),
                child: Center(child: Text('login')),
              ),
            ),
          )
        ],

      ),
    );
  }
}
