/* ************************************************************************************************************
Dart/Flutter Notes  
https://api.flutter.dev/flutter/material/MaterialApp-class.html
***************************************************************************************************************
Vocab: 

stateless widget: immutable, properties cant change over time

stateful widget: the state of the widget can change over time

extends (inheritance) : used to create a class that inherits properties and behaviors from another class,
reffered to as superclass. When a class textends another class, it gains access to all the variable, methods,
constructors defined in the super class


**************************************************************************************************************
Notations: 

=> fat arrow notation with example : A fat arrow is used to define a single expression in a function. 
This is a cleaner way to write functions with a single statement.

regular example:
void main() {
  perimeterOfRectangle(47, 57);
}
void perimeterOfRectangle(int length, int breadth) {
  var perimeter = 2 * (length + breadth);
  print('The perimeter of rectangle is $perimeter');
}

=> notation example:
void main() {
  perimeterOfRectangle(47, 57);
 }
void perimeterOfRectangle(int length, int breadth) =>
  print('The perimeter of rectangele is ${2 * (length + breadth)}');

Key? key notation https://stackoverflow.com/questions/64560461/the-parameter-cant-have-a-value-of-null-because-of-its-type-in-dart
(If you want to have a nullable parameter)

stless (new stateless widget class)

@override, for build function it will override the one defined in the classes ancestor, the thing we extend from, statelesswidget,
so we just use our own build in general.

example code for images I had 
body: Center(
        child: Image(
          image: AssetImage('assets/weather-icons-set/CLOUDS/png clouds/001lighticons-01.png'),
        ),
      ),

************************************************************************************************************ */ 

import 'package:flutter/material.dart';

void main() => runApp(MaterialApp( 
  home: MyHomePage(),
  )); // root of the widget tree: MyApp, this begins the whole process of running



class MyHomePage extends StatelessWidget { // extending staeless widget class in flutter
  @override
  Widget build(BuildContext context) { // this build function builds up the widget tree
     // beginning to build the scaffold (top level container), wrapper to layer widgets like buttons and body text
    return Scaffold ( 

      appBar: AppBar (
        title: const Text(
          "Current Location",
          style: TextStyle(
            color: Colors.black,
            fontSize: 30, 
            fontWeight: FontWeight.w500, // boldness
            fontFamily: 'Gloock'
          ),
        ),
        backgroundColor: Color.fromARGB(209, 139, 139, 139),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(30.0),
        child: Container(
          height: 3.0, // thickness of black line
          color: Colors.black.withOpacity(.5), // opacity of the thin black line
          ),
          ),
        ),
      body: Container(
        padding: EdgeInsets.fromLTRB(5, 5, 5, 5), // left top right bottom
        margin: EdgeInsets.all(50),
        color: Colors.red[400],
        child: Image(
          image: AssetImage('assets/weather-icons-set/CLOUDS/png clouds/001lighticons-01.png'),
        ),
      )
    );
    // end of return statement always put semicolon!
  }
}