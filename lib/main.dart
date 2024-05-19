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

'new' keyword is obsolete in dart 2, no longer needed to be used when making new classes
************************************************************************************************************ */ 

import 'package:flutter/material.dart';

void main() => runApp(MaterialApp( 
  home: MyHomePage(),
  )); // root of the widget tree: MyApp, this begins the whole process of running



class MyHomePage extends StatefulWidget {  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
 // extending staeless widget class in flutter
  @override
  Widget build(BuildContext context) { // this build function builds up the widget tree
     // beginning to build the scaffold (top level container), wrapper to layer widgets like buttons and body text
    return Material ( 
      type: MaterialType.transparency,
      child: Stack( // stack allows for overlapping of widgets, useful when using background image and placing things over it
        children: <Widget>[
           Container(
          decoration:  BoxDecoration(
            image:  DecorationImage(
              image:  AssetImage('assets/Background1.jpg'),
              fit: BoxFit.fill,
            ),
            ),
          ),

          Container(
            child: Column(
              children: <Widget> [
                SizedBox(height: 90),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget> [
                    // using stack to layer things once more, layering text on top of each other to get a border effect
                    Stack(
                      children: <Widget> [
                    // this text is the border
                     Text(
                      'Current Location',
                      style: TextStyle(
                        fontFamily: 'Gloock',
                        fontSize: 40,
                        foreground: Paint()
                          ..style = PaintingStyle.stroke
                          ..strokeWidth = 6
                          ..color = Colors.black,
                      )
                    ),
                    // this is the inside text
                    Text(
                      'Current Location',
                      style: TextStyle(
                        fontFamily: 'Gloock',
                        fontSize: 40,
                        color: Colors.grey[300],
                          ),
                        ),
                      ]
                    )
                  ]
                )
              ]
            )
          )
        ]
      )
    );   // end of return statement always put semicolon!
  }
}