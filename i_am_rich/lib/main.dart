import 'package:flutter/material.dart';

void main() {
  runApp(
      MaterialApp(
        home: Scaffold(
          backgroundColor: Colors.white12,
          appBar: AppBar(
            title: Text('I AM RICH'),
            backgroundColor: Colors.blueGrey,
          ),
          body: Center(
            child: Image(
              image: AssetImage('images/daimond.png'),
            ),
          ),
        ),
      ),
  );
}





