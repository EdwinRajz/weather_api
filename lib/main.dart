import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'services/image_operator.dart';
import 'services/location.dart';
import 'services/networking.dart';

void main() {
  runApp(WeatherApi());
}

class WeatherApi extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Location location = Location();
  ImageOperator imageOperator = ImageOperator();
  String forecastDay1;
  String forecastDay2;
  String forecastDay3;
  String forecastDay4;
  String cityName;
  String weatherDescription;
  String weatherBackground;
  String weatherIcon;
  int temp;
  bool isLoading = true;
  String forecastIcon1;
  String forecastIcon2;
  String forecastIcon3;
  String forecastIcon4;

  @override
  void initState() {
    super.initState();
    getWeatherData();
    getForecastData();
  }

  Future<void> getWeatherData() async {
    await location.getCurrentLocation();

    final NetworkHelper networkHelper = NetworkHelper(
        'https://api.openweathermap.org/data/2.5/weather?lat=${location.latitude}&lon=${location.longitude}&APPID=1c4f0c8abb7874d8624b2f5947df2516&units=metric');

    final Map<String, dynamic> weatherData = await networkHelper.getData();
    final int weatherId = weatherData['weather'][0]['id'];

    setState(() {
      cityName = weatherData['name'];
      final double accurateTemp = weatherData['main']['temp'];
      temp = accurateTemp.toInt();
      weatherDescription = weatherData['weather'][0]['description'];
      weatherBackground = imageOperator.imageAssigner(weatherId);
      weatherIcon = weatherData['weather'][0]['icon'];
      isLoading = false;
    });
  }

  Future<void> getForecastData() async {
    await location.getCurrentLocation();
    final NetworkHelper networkHelperForecast = NetworkHelper(
        'http://api.openweathermap.org/data/2.5/forecast?lat=${location.latitude}&lon=${location.longitude}&&appid=1c4f0c8abb7874d8624b2f5947df2516&units=metric');
    final Map<String, dynamic> forecastData = await networkHelperForecast.getData();
    final int unixDate1 = forecastData['list'][5]['dt'];
    final int unixDate2 = forecastData['list'][15]['dt'];
    final int unixDate3 = forecastData['list'][25]['dt'];
    final int unixDate4 = forecastData['list'][35]['dt'];

    final DateTime timeFormatter1 =
        DateTime.fromMicrosecondsSinceEpoch(unixDate1 * 1000000);
    final DateTime timeFormatter2 =
        DateTime.fromMicrosecondsSinceEpoch(unixDate2 * 1000000);
   final DateTime timeFormatter3 =
        DateTime.fromMicrosecondsSinceEpoch(unixDate3 * 1000000);
    final DateTime timeFormatter4 =
        DateTime.fromMicrosecondsSinceEpoch(unixDate4 * 1000000);

    setState(() {
      forecastDay1 = timeFormatter1.toIso8601String().substring(0, 10);
      forecastDay2 = timeFormatter2.toIso8601String().substring(0, 10);
      forecastDay3 = timeFormatter3.toIso8601String().substring(0, 10);
      forecastDay4 = timeFormatter4.toIso8601String().substring(0, 10);
      forecastIcon1 = forecastData['list'][5]['weather'][0]['icon'];
      forecastIcon2 = forecastData['list'][15]['weather'][0]['icon'];
      forecastIcon3 = forecastData['list'][25]['weather'][0]['icon'];
      forecastIcon4 = forecastData['list'][35]['weather'][0]['icon'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: isLoading
            ? const LinearProgressIndicator()
            : Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(weatherBackground),
                    fit: BoxFit.fill,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const SizedBox(height: 75.0),
                    Container(
                      padding: const EdgeInsets.all(32.0),
                      child: Text(
                        '$cityName',
                        style: TextStyle(
                          fontSize: 30.0,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    const SizedBox(height: 200.0),
                    Row(
                      textBaseline: TextBaseline.ideographic,
                      children: <Widget>[
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 32.0, vertical: 8.0),
                          child: Image.network(
                              'http://openweathermap.org/img/wn/$weatherIcon.png'),
                        ),
                        Container(
                          child: Text(
                            '$temp ° ',
                            style: TextStyle(
                              fontSize: 30.0,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 32.0, vertical: 8.0),
                      child: Text(
                        '$weatherDescription',
                        style: TextStyle(
                          fontSize: 30.0,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    const SizedBox(
                      height: 50.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            Text(forecastDay1),
                            Image.network(
                                'http://openweathermap.org/img/wn/$forecastIcon1.png'),
                          ],
                        ),
                        Column(
                          children: <Widget>[
                            Text(forecastDay2),
                            Image.network(
                                'http://openweathermap.org/img/wn/$forecastIcon2.png'),
                          ],
                        ),
                        Column(
                          children: <Widget>[
                            Text(forecastDay3),
                            Image.network(
                                'http://openweathermap.org/img/wn/$forecastIcon3.png'),
                          ],
                        ),
                        Column(
                          children: <Widget>[
                            Text(forecastDay4),
                            Image.network(
                                'http://openweathermap.org/img/wn/$forecastIcon4.png'),
                          ],
                        ),
                      ],
                    )
                  ],
                ),
              ),
      ),
    );
  }
}
