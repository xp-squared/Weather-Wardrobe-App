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
Things to add:  

- ADD CONSTRAINTS TO CURRENT LOCATION AS IT WILL GO OFF SCREEN FOR LONG LOCATIONS
- Finish read me page on github
- Link back to weatherapi since I used the free version
- Sourcing the images used for the weathers
- if phone is rotated the whole interface bugs out, research how to fix that or 
make it where app is only ever vertical
- error handling when issues arrive 
- some places do not have location name preferences like the U.S., so for 
Cairo, Egpyt it will say Cairo, Cairo. 
- There are still a lot of weather conditions not accounted for from WeatherAPI
- Next to time maybe put AM or PM


*************************************************************************************************************
*/ 
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'dart:async';
import 'package:weatherapi/weatherapi.dart';


void main() => runApp(MaterialApp( 
  home: MyHomePage(),
  )); // root of the widget tree: MyApp, this begins the whole process of running

class MyHomePage extends StatefulWidget {  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _dateTime = ' ';
  String _currentCity = 'Unknown';
  String _currentWeather = 'Unknown';
  String _currentTemperature = 'Unknown';
  String _bgImage = 'Background3.png'; // always will be 3 if error occurs
  WeatherRequest wr = WeatherRequest('2b3bb4cc90be49ecaab174621243105');
  List<String> _recommendedClothing = [];
  String _weatherIconPath = 'assets/weather-icons/sunny.png';

  static final Map<String, Map<String, List<String>>> _clothingRecommendations = {
    'Sunny': {
      'freezing': ['Heavy coat', 'Warm pants', 'Boots'],
      'chilly': ['Jacket', 'Long pants', 'Closed shoes'],
      'cool': ['Light jacket', 'Jeans', 'Sneakers'],
      'warm': ['T-shirt', 'Shorts', 'Sandals'],
      'hot': ['Tank top', 'Shorts', 'Flip-flops'],
    },
    'Partly cloudy': {
      'freezing': ['Heavy coat', 'Warm pants', 'Boots'],
      'chilly': ['Jacket', 'Long pants', 'Closed shoes'],
      'cool': ['Light jacket', 'Jeans', 'Sneakers'],
      'warm': ['Short Sleeve T-shirt', 'Shorts', 'Sandals'],
      'hot': ['Tank top', 'Shorts', 'Flip-flops'],
    },
    'Rain': {
      'freezing': ['Raincoat', 'Waterproof pants', 'Boots'],
      'chilly': ['Raincoat', 'Waterproof shoes', 'Umbrella'],
      'cool': ['Light rain jacket', 'Waterproof shoes', 'Umbrella'],
      'warm': ['Light rain jacket', 'Shorts', 'Waterproof sandals'],
      'hot': ['Raincoat', 'Shorts', 'Waterproof sandals'],
    },
    'Overcast': {
      'freezing': ['Heavy coat', 'Warm pants', 'Boots'],
      'chilly': ['Jacket', 'Long pants', 'Closed shoes'],
      'cool': ['Light jacket', 'Jeans', 'Sneakers'],
      'warm': ['T-shirt', 'Jeans', 'Closed shoes'],
      'hot': ['Short sleeve shirt', 'Shorts', 'Closed shoes'],
    },
    'Cloudy': {
      'freezing': ['Heavy coat', 'Warm pants', 'Boots'],
      'chilly': ['Jacket', 'Long pants', 'Closed shoes'],
      'cool': ['Light jacket', 'Jeans', 'Sneakers'],
      'warm': ['T-shirt', 'Jeans', 'Closed shoes'],
      'hot': ['Short sleeve shirt', 'Shorts', 'Closed shoes'],
    },
    'Fog': {
      'freezing': ['Heavy coat', 'Warm pants', 'Boots'],
      'chilly': ['Jacket', 'Long pants', 'Closed shoes'],
      'cool': ['Light jacket', 'Jeans', 'Sneakers'],
      'warm': ['Short sleeve shirt', 'Jeans', 'Closed shoes'],
      'hot': ['Short sleeve shirt', 'Shorts', 'Closed shoes'],
    },
    'Mist': {
      'freezing': ['Heavy coat', 'Warm pants', 'Boots'],
      'chilly': ['Jacket', 'Long pants', 'Closed shoes'],
      'cool': ['Light jacket', 'Jeans', 'Sneakers'],
      'warm': ['Short sleeve shirt', 'Jeans', 'Closed shoes'],
      'hot': ['Tanktop', 'Shorts', 'Closed shoes'],
    },
    'Snow': {
      'freezing': ['Heavy coat', 'Warm pants', 'Snow boots'],
      'chilly': ['Warm coat', 'Thermal pants', 'Boots'],
      'cool': ['Jacket', 'Jeans', 'Boots'],
      'warm': ['Light jacket', 'Jeans', 'Closed shoes'],
      'hot': ['Light jacket', 'Jeans', 'Closed shoes'],
    },
    'Light snow': {
      'freezing': ['Heavy coat', 'Warm pants', 'Snow boots'],
      'chilly': ['Warm coat', 'Thermal pants', 'Boots'],
      'cool': ['Jacket', 'Jeans', 'Boots'],
      'warm': ['Light jacket', 'Jeans', 'Closed shoes'],
      'hot': ['Light jacket', 'Jeans', 'Closed shoes'],
    },
    'Heavy snow': {
      'freezing': ['Heavy coat', 'Warm pants', 'Snow boots'],
      'chilly': ['Warm coat', 'Thermal pants', 'Boots'],
      'cool': ['Jacket', 'Jeans', 'Boots'],
      'warm': ['Light jacket', 'Jeans', 'Closed shoes'],
      'hot': ['Light jacket', 'Jeans', 'Closed shoes'],
    },
    'Blizzard': {
      'freezing': ['Heavy coat', 'Warm pants', 'Snow boots'],
      'chilly': ['Warm coat', 'Thermal pants', 'Boots'],
      'cool': ['Jacket', 'Jeans', 'Boots'],
      'warm': ['Light jacket', 'Jeans', 'Closed shoes'],
      'hot': ['Light jacket', 'Jeans', 'Closed shoes'],
    },
    'Sleet': {
      'freezing': ['Raincoat', 'Waterproof pants', 'Boots'],
      'chilly': ['Raincoat', 'Waterproof shoes', 'Umbrella'],
      'cool': ['Light rain jacket', 'Waterproof shoes', 'Umbrella'],
      'warm': ['Light rain jacket', 'Shorts', 'Waterproof sandals'],
      'hot': ['Raincoat', 'Shorts', 'Waterproof sandals'],
    },
    'Light sleet': {
      'freezing': ['Raincoat', 'Waterproof pants', 'Boots'],
      'chilly': ['Raincoat', 'Waterproof shoes', 'Umbrella'],
      'cool': ['Light rain jacket', 'Waterproof shoes', 'Umbrella'],
      'warm': ['Light rain jacket', 'Shorts', 'Waterproof sandals'],
      'hot': ['Raincoat', 'Shorts', 'Waterproof sandals'],
    },
    'Heavy sleet': {
      'freezing': ['Raincoat', 'Waterproof pants', 'Boots'],
      'chilly': ['Raincoat', 'Waterproof shoes', 'Umbrella'],
      'cool': ['Light rain jacket', 'Waterproof shoes', 'Umbrella'],
      'warm': ['Light rain jacket', 'Shorts', 'Waterproof sandals'],
      'hot': ['Raincoat', 'Shorts', 'Waterproof sandals'],
    },
    'Drizzle': {
      'freezing': ['Raincoat', 'Waterproof pants', 'Boots'],
      'chilly': ['Raincoat', 'Waterproof shoes', 'Umbrella'],
      'cool': ['Light rain jacket', 'Waterproof shoes', 'Umbrella'],
      'warm': ['Light rain jacket', 'Shorts', 'Waterproof sandals'],
      'hot': ['Raincoat', 'Shorts', 'Waterproof sandals'],
    },
    'Freezing drizzle': {
      'freezing': ['Raincoat', 'Waterproof pants', 'Boots'],
      'chilly': ['Raincoat', 'Waterproof shoes', 'Umbrella'],
      'cool': ['Light rain jacket', 'Waterproof shoes', 'Umbrella'],
      'warm': ['Light rain jacket', 'Shorts', 'Waterproof sandals'],
      'hot': ['Raincoat', 'Shorts', 'Waterproof sandals'],
    },
    'Thunderstorms': {
      'freezing': ['Raincoat', 'Warm pants', 'Boots'],
      'chilly': ['Raincoat', 'Long pants', 'Waterproof shoes'],
      'cool': ['Rain jacket', 'Jeans', 'Waterproof shoes'],
      'warm': ['Rain jacket', 'Shorts', 'Waterproof sandals'],
      'hot': ['Raincoat', 'Shorts', 'Waterproof sandals'],
    },
    'Light rain': {
      'freezing': ['Raincoat', 'Warm pants', 'Boots'],
      'chilly': ['Raincoat', 'Long pants', 'Waterproof shoes'],
      'cool': ['Rain jacket', 'Jeans', 'Waterproof shoes'],
      'warm': ['Rain jacket', 'Shorts', 'Waterproof sandals'],
      'hot': ['Raincoat', 'Shorts', 'Waterproof sandals'],
    },
    'Heavy rain': {
      'freezing': ['Heavycoat', 'Warm pants', 'Boots'],
      'chilly': ['Raincoat', 'Long pants', 'Waterproof shoes'],
      'cool': ['Rain jacket', 'Jeans', 'Waterproof shoes'],
      'warm': ['Rain jacket', 'Shorts', 'Waterproof sandals'],
      'hot': ['Raincoat', 'Shorts', 'Waterproof sandals'],
    },
    'Ice pellets': {
      'freezing': ['Heavy coat', 'Warm pants', 'Boots'],
      'chilly': ['Warm coat', 'Long pants', 'Boots'],
      'cool': ['Jacket', 'Jeans', 'Boots'],
      'warm': ['Light jacket', 'Jeans', 'Closed shoes'],
      'hot': ['Light jacket', 'Jeans', 'Closed shoes'],
    },
    'Clear': {
      'freezing': ['Heavy coat', 'Warm pants', 'Boots'],
      'chilly': ['Jacket', 'Long pants', 'Closed shoes'],
      'cool': ['Light jacket', 'Jeans', 'Sneakers'],
      'warm': ['T-shirt', 'Shorts', 'Sandals'],
      'hot': ['Tank top', 'Shorts', 'Flip-flops'],
    },
  };


  // icons came from https://www.iconfinder.com
  final Map<String, String> weatherIcons = {
    'Sunny': 'assets/weather-icons/sunny.png', 
    'Partly cloudy': 'assets/weather-icons/partly_cloudy.png', 
    'Rain': 'assets/weather-icons/rainy.png', 
    'Overcast': 'assets/weather-icons/cloudy.png',
    'Cloudy': 'assets/weather-icons/cloudy.png', 
    'Fog': 'assets/weather-icons/fog.png', 
    'Mist': 'assets/weather-icons/mist.png',
    'Snow': 'assets/weather-icons/snow.png', 
    'Light snow': 'assets/weather-icons/snow.png', 
    'Heavy snow': 'assets/weather-icons/snow.png', 
    'Blizzard': 'assets/weather-icons/snow.png', 
    'Sleet': 'assets/weather-icons/sleet.png', 
    'Light sleet': 'assets/weather-icons/sleet.png',
    'Heavy sleet': 'assets/weather-icons/sleet.png',
    'Drizzle': 'assets/weather-icons/rainy.png',
    'Freezing drizzle': 'assets/weather-icons/sleet.png',
    'Thunderstorms': 'assets/weather-icons/thunderstorms.png',
    'Light rain': 'assets/weather-icons/rainy.png',
    'Heavy rain': 'assets/weather-icons/rainy.png',
    'Ice pellets': 'assets/weather-icons/snow.png',
    'Clear': 'assets/weather-icons/clear.png',
  };

  String _getTemperatureRange(String temp) {
    double tempF = double.parse(temp.replaceAll('°', ''));
    if (tempF < 32) {
      return 'freezing';
    } 
    else if (tempF < 50) {
      return 'chilly';
    } 
    else if (tempF < 65) {
      return 'cool';
    } 
    else if (tempF < 90) {
      return 'warm';
    }
     else {
      return 'hot';
    }
  }

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

  Future<Position> _getUserPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
     if (!serviceEnabled) {
       throw Exception('Location services are disabled.');
     }

     permission = await Geolocator.checkPermission();
     if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
       if (permission == LocationPermission.denied) {
         throw Exception('Location permissions are denied.');
        }
      }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permissions are permanently denied, we cannot request permissions.');
    }

    // Get the current position
    return await Geolocator.getCurrentPosition();
  }


  Future<String> _getTemperature() async {
  try {
    Position position = await _getUserPosition();

    // Fetch weather data using the WeatherAPI
    RealtimeWeather rw = await wr.getRealtimeWeatherByLocation(position.latitude, position.longitude);
    final temperature = rw.current.tempF;

    // Return temperature
    return '$temperature°';
  } catch (e) {
    return 'Error: ${e.toString()}';
  }
  }

  Future<String> _getLocationWeather() async {
    Position position = await _getUserPosition();
    // Use the Geocoding package to get the city and state name from coordinates
    RealtimeWeather rw = await wr.getRealtimeWeatherByLocation(position.latitude, position.longitude);
    final weather = rw.current.condition.text;

    // Return weather condition
    return '$weather';
  }


  Future<String> _getCurrentCityAndState() async {
    Position position = await _getUserPosition();
    // Use the Geocoding package to get the city and state name from coordinates
    List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark place = placemarks[0];
    // Combine city and state
    String city = place.locality ?? 'Unknown';
    String state = place.administrativeArea ?? 'Unknown';
     // condition ? ExprIfTrue : ExprIfFalse
     
    return '$city, $state';
  }


  Widget build(BuildContext context) { // this build function builds up the widget tree
    
    // changing the background based on the time of the day
    final int hour = DateTime.now().hour;
    
    if (0 <= hour && hour < 6) {
      _bgImage = 'Background5.jpeg';
    }
    else if (6 <= hour && hour < 9) {
      _bgImage = 'Background2.jpeg';
    }
    else if (9 <= hour && hour < 12) {
      _bgImage = 'Background1.jpg';
    }
    else if (12 <= hour && hour < 17) {
      _bgImage = 'Background3.png';
    }
    else if (17 <= hour && hour < 21) {
      _bgImage = 'Background4.jpeg';
    }
    else if (21 <= hour && hour < 24) {
      _bgImage = 'Background5.jpeg';
    }
    
    return Material ( 
      type: MaterialType.transparency,
      child: Stack( // stack allows for overlapping of widgets, useful when using background image and placing things over it
        children: <Widget>[

          // background image
          Container(
          decoration:  BoxDecoration(
            image:  DecorationImage(
              image:  AssetImage('assets/$_bgImage'),
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
                    Image.asset(
                      _weatherIconPath,
                      width: 140.0,
                      height: 140.0,
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
                            //'76°',
                            _currentTemperature,
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
                              //'76°',
                               _currentTemperature,
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
                            _currentWeather,
                            //'Current Weather',
                            style: TextStyle(
                            fontFamily: 'Gloock',
                            fontSize: 40, //40
                            foreground: Paint()
                              ..style = PaintingStyle.stroke
                              ..strokeWidth = 6
                              ..color = Colors.black,
                              )
                            ),
                            Text(
                              _currentWeather,
                              //'Current Weather',
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
                            fontSize: 40,
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
                              fontSize: 40,
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
                        crossAxisAlignment: CrossAxisAlignment.center, 
                        children: <Widget> [
                        for (int i = 0; i < _recommendedClothing.length; i++) ...[
                          Stack(
                          children: <Widget> [
                            Text(
                            textAlign: TextAlign.left,
                            _recommendedClothing[i],
                            style: TextStyle(
                            fontFamily: 'Gloock',
                            fontSize: 28,
                            foreground: Paint()
                              ..style = PaintingStyle.stroke
                              ..strokeWidth = 6
                              ..color = Colors.black,
                              )
                            ),
                            Text(
                              textAlign: TextAlign.left,
                              _recommendedClothing[i],
                              style: TextStyle(
                              fontFamily: 'Gloock',
                              fontSize: 28,
                              color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 20),
                          
                          ]
                        ),
                        ]
                      ]
                      ),
                       
                  ]
                ),
                const SizedBox(height: 10),
                const  Divider(
                  color: Colors.black,
                  thickness: 3,
                  indent: 35,
                  endIndent: 35,
                ),
                const SizedBox(height: 15),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    side: BorderSide(width: 3.0, color: Colors.white),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    backgroundColor: Colors.transparent,
                  ),
                  onPressed: () async {
                    try {
                      String cityAndState = await _getCurrentCityAndState();
                      String locationsWeather = await _getLocationWeather();
                      String temperature = await _getTemperature();
                      String tempRange = _getTemperatureRange(temperature);
                      setState(() {
                        _currentCity = cityAndState;
                        _currentWeather = locationsWeather;
                        _currentTemperature = temperature;
                        _weatherIconPath = weatherIcons[_currentWeather] ?? 'assets/weather-icons/sunny.png';
                        _recommendedClothing = _clothingRecommendations[_currentWeather]?[tempRange] ?? [];
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