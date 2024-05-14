/* ************************************************************************************************************
Dart/Flutter Notes  
https://api.flutter.dev/flutter/material/MaterialApp-class.html
***************************************************************************************************************
Vocab: 

stateless: immutable, properties dont change over time

stateful: updates when data changes

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




************************************************************************************************************ */ 

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp();
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp( 
      home: const MyHomePage(),
    );
  }
}


class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold (  // beginning to build the scaffold (top level container)
      appBar: AppBar (
        title: const Text('Weather Area'),
      ),
    );
  }
}