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

The container widget comes to the rescue and provides you with various common painting, 
positioning, and sizing widgets. These are widgets that can contain multiple child widgets.
 The row is the widget that can display various child widgets in a horizontal manner. 
 The column displays child widgets in a vertical manner
************************************************************************************************************ 
Implementation Notes: 

- Button to update location: easier to implement and more efficient for battery life
- When different location time changes possibly?

- Add error handling
- Loading Indicators as location is getting grabbed?

- Weather Icon changing on the weather
- Clothing recommendations changing on weather

- ADD CONSTRAINTS TO CURRENT LOCATION

*************************************************************************************************************
*/ 



import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'dart:async';


void main() => runApp(MaterialApp( 
  home: MyHomePage(),
  )); // root of the widget tree: MyApp, this begins the whole process of running



class MyHomePage extends StatefulWidget {  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _dateTime = ' ';
  String _currentCity = 'Unknown';


 // extending stateless widget class in flutter
  @override

  void initState() {
    super.initState();
    _dateTime = getCurrentDateTime(); // Set initial date and time
    Timer.periodic(Duration(seconds: 1), (Timer t) => _updateDateTime()); // Update every second
  }

  void _updateDateTime() {
    setState(() {
      _dateTime = getCurrentDateTime();
    });
  }

  // Method to get the current date and time
  String getCurrentDateTime() {
    final now = DateTime.now();
    return DateFormat('MM-dd-yyyy    KK:mm:ss').format(now);
  }

  Future<String> _getCurrentCityAndState() async {
  bool serviceEnabled;
  LocationPermission permission;

  // Check if location services are enabled
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return Future.error('Location permissions are denied.');
    }
  }
  
  if (permission == LocationPermission.deniedForever) {
    return Future.error('Location permissions are permanently denied, we cannot request permissions.');
  }

  // Get the current position
  Position position = await Geolocator.getCurrentPosition();
  // Use the Geocoding package to get the city and state name from coordinates
  List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
  Placemark place = placemarks[0];

  // Combine city and state
  String city = place.locality ?? 'Unknown';
  String state = place.administrativeArea ?? 'Unknown';
  return '$city, $state';
}


  Widget build(BuildContext context) { // this build function builds up the widget tree
    return Material ( 
      type: MaterialType.transparency,
      child: Stack( // stack allows for overlapping of widgets, useful when using background image and placing things over it
        children: <Widget>[

          // background image
          Container(
          decoration:  BoxDecoration(
            image:  DecorationImage(
              image:  AssetImage('assets/Background3.png'),
              fit: BoxFit.fill,
            ),
            ),
          ),

           // all text and information of the app is in this section
           Column(
              children: <Widget> [
                SizedBox(height: 70),
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
                        _currentCity,
                        style: TextStyle(
                          fontFamily: 'Gloock',
                          fontSize: 45,
                          foreground: Paint()
                            ..style = PaintingStyle.stroke
                            ..strokeWidth = 6
                            ..color = Colors.black,
                            )
                          ),
                      // this is the inside text
                        Text(
                        _currentCity,
                        style: TextStyle(
                          fontFamily: 'Gloock',
                          fontSize: 45,
                          color: Colors.white,
                                ),
                              ),
                          ]
                        ),
                  ]
                ),
                const SizedBox(height: 0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget> [
                    Stack(
                      children: <Widget> [
                    // this text is the border
                     Text(
                      //'Date and Time', 
                      _dateTime,
                      style: TextStyle(
                        fontFamily: 'Gloock',
                        fontSize: 30,
                        foreground: Paint()
                          ..style = PaintingStyle.stroke
                          ..strokeWidth = 6
                          ..color = Colors.black,
                          )
                        ),
                    // this is the inside text
                    Text(
                      //'Date and Time',
                      _dateTime,
                      style: TextStyle(
                        fontFamily: 'Gloock',
                        fontSize: 30,
                        color: Colors.white,
                              ),
                            ),
                          ]
                    )
                  ]
                ),
                const SizedBox(height: 5),
                Divider(
                  color: Colors.black,
                  thickness: 3,
                  indent: 35,
                  endIndent: 35,
                ),
                SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget> [
                    Icon(
                      // https://fonts.google.com/icons?icon.query=weather other weather icons
                      // We want to come back and change this based on the current weather
                      Icons.cloud, 
                      color: Colors.white,
                      size: 120.0,
                    ),
                  ]
                ),
                SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget> [
                  Column(
                      children: <Widget> [
                        Stack(
                          children: <Widget> [
                            Text(
                            '76°',
                            style: TextStyle(
                            fontFamily: 'Gloock',
                            fontSize: 60,
                            foreground: Paint()
                              ..style = PaintingStyle.stroke
                              ..strokeWidth = 6
                              ..color = Colors.black,
                              )
                            ),
                            Text(
                              '76°',
                              style: TextStyle(
                              fontFamily: 'Gloock',
                              fontSize: 60,
                              color: Colors.white,
                              ),
                            )
                          ]
                        )
                      ]
                    )
                ]
               ),
               Row (
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget> [
                    Column(
                      children: <Widget> [
                        Stack(
                          children: <Widget> [
                            Text(
                            'Current Weather',
                            style: TextStyle(
                            fontFamily: 'Gloock',
                            fontSize: 40,
                            foreground: Paint()
                              ..style = PaintingStyle.stroke
                              ..strokeWidth = 6
                              ..color = Colors.black,
                              )
                            ),
                            Text(
                              'Current Weather',
                              style: TextStyle(
                              fontFamily: 'Gloock',
                              fontSize: 40,
                              color: Colors.white,
                              ),
                            )
                          ]
                        )
                      ]
                    )
                    ]
                  ),
                const SizedBox(height: 5),
                const  Divider(
                  color: Colors.black,
                  thickness: 3,
                  indent: 35,
                  endIndent: 35,
                
                ),
                const SizedBox(height: 5),
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget> [
                    Column(
                      children: <Widget> [
                        Stack(
                          children: <Widget> [
                            Container( // needed container for box constraints so no overflow on the screen
                            constraints: BoxConstraints(maxWidth: 300),
                            child: Text(
                            textAlign: TextAlign.center,
                            'Recommended Clothing!',
                            style: TextStyle(
                            fontFamily: 'Gloock',
                            fontSize: 30,
                            foreground: Paint()
                              ..style = PaintingStyle.stroke
                              ..strokeWidth = 6
                              ..color = Colors.black,
                              )
                            )
                            ),
                            Container(
                              constraints: BoxConstraints(maxWidth: 300),
                              child: Text(
                              textAlign: TextAlign.center,
                              'Recommended Clothing!',
                              style: TextStyle(
                              fontFamily: 'Gloock',
                              fontSize: 30,
                              color: Colors.white,
                              ),
                            )
                            )
                          ]
                        )
                      ]
                    ),
                  ]
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget> [
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start, 
                        children: <Widget> [
                        Stack(
                          children: <Widget> [
                            Text(
                            textAlign: TextAlign.left,
                            'Hat: ',
                            style: TextStyle(
                            fontFamily: 'Gloock',
                            fontSize: 25,
                            foreground: Paint()
                              ..style = PaintingStyle.stroke
                              ..strokeWidth = 6
                              ..color = Colors.black,
                              )
                            ),
                            Text(
                              textAlign: TextAlign.left,
                              'Hat: ',
                              style: TextStyle(
                              fontFamily: 'Gloock',
                              fontSize: 25,
                              color: Colors.white,
                              ),
                            ),
                          ]
                        ),
                        SizedBox(height: 10),
                        Stack(
                          children: <Widget> [
                            Text(
                            textAlign: TextAlign.left,
                            'Jacket: ',
                            style: TextStyle(
                            fontFamily: 'Gloock',
                            fontSize: 25,
                            foreground: Paint()
                              ..style = PaintingStyle.stroke
                              ..strokeWidth = 6
                              ..color = Colors.black,
                              )
                            ),
                            Text(
                              textAlign: TextAlign.left,
                              'Jacket: ',
                              style: TextStyle(
                              fontFamily: 'Gloock',
                              fontSize: 25,
                              color: Colors.white,
                              ),
                            ),
                          ]
                        ),
                        SizedBox(height: 10),
                        Stack(
                          children: <Widget> [
                            Text(
                            textAlign: TextAlign.left,
                            'Shirt: ',
                            style: TextStyle(
                            fontFamily: 'Gloock',
                            fontSize: 25,
                            foreground: Paint()
                              ..style = PaintingStyle.stroke
                              ..strokeWidth = 6
                              ..color = Colors.black,
                              )
                            ),
                            Text(
                              textAlign: TextAlign.left,
                              'Shirt: ',
                              style: TextStyle(
                              fontFamily: 'Gloock',
                              fontSize: 25,
                              color: Colors.white,
                              ),
                            ),
                          ]
                        ),
                      ]
                      ),
                      SizedBox(width: 80),
                       Column(
                        crossAxisAlignment: CrossAxisAlignment.start, 
                        children: <Widget> [
                        Stack(
                          children: <Widget> [
                            Text(
                            textAlign: TextAlign.left,
                            'Pants: ',
                            style: TextStyle(
                            fontFamily: 'Gloock',
                            fontSize: 25,
                            foreground: Paint()
                              ..style = PaintingStyle.stroke
                              ..strokeWidth = 6
                              ..color = Colors.black,
                              )
                            ),
                            Text(
                              textAlign: TextAlign.left,
                              'Pants: ',
                              style: TextStyle(
                              fontFamily: 'Gloock',
                              fontSize: 25,
                              color: Colors.white,
                              ),
                            ),
                          ]
                        ),
                        SizedBox(height: 10),
                        Stack(
                          children: <Widget> [
                            Text(
                            textAlign: TextAlign.left,
                            'Shoes: ',
                            style: TextStyle(
                            fontFamily: 'Gloock',
                            fontSize: 25,
                            foreground: Paint()
                              ..style = PaintingStyle.stroke
                              ..strokeWidth = 6
                              ..color = Colors.black,
                              )
                            ),
                            Text(
                              textAlign: TextAlign.left,
                              'Shoes: ',
                              style: TextStyle(
                              fontFamily: 'Gloock',
                              fontSize: 25,
                              color: Colors.white,
                              ),
                            ),
                          ]
                        ),
                        SizedBox(height: 10),
                        Stack(
                          children: <Widget> [
                            Text(
                            textAlign: TextAlign.left,
                            // accessorys like umbrellas etc
                            'Accessory: ',
                            style: TextStyle(
                            fontFamily: 'Gloock',
                            fontSize: 25,
                            foreground: Paint()
                              ..style = PaintingStyle.stroke
                              ..strokeWidth = 6
                              ..color = Colors.black,
                              )
                            ),
                            Text(
                              textAlign: TextAlign.left,
                              'Accessory: ',
                              style: TextStyle(
                              fontFamily: 'Gloock',
                              fontSize: 25,
                              color: Colors.white,
                              ),
                            ),
                          ]
                        ),
                      ]
                      ),
                  ]
                ),
                const SizedBox(height: 20),
                const  Divider(
                  color: Colors.black,
                  thickness: 3,
                  indent: 35,
                  endIndent: 35,
                ),
                const SizedBox(height: 40),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      side: BorderSide(width: 3.0, color: Colors.white),
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      backgroundColor: Colors.transparent,
                    ),
                    onPressed: () async {
                      // Functionality to get location will be added here later
                      try {
                        String cityAndState = await _getCurrentCityAndState();
                        setState(() {
                          _currentCity = cityAndState;
                        });
                      } catch (e) {
                        print(e);
                      }
                    },
                    child: Stack(
                      children: <Widget>[
                        // this text is the border
                        Text(
                          'Get Location',
                          style: TextStyle(
                            fontFamily: 'Gloock',
                            fontSize: 25,
                            foreground: Paint()
                              ..style = PaintingStyle.stroke
                              ..strokeWidth = 4
                              ..color = Colors.black,
                          ),
                        ),
                        // this is the inside text
                        Text(
                          'Get Location',
                          style: TextStyle(
                            fontFamily: 'Gloock',
                            fontSize: 25,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                // this is where we are still inside of our column
              ]
            ),
        ]
      )
    );   // end of return statement always put semicolon!
  }
}