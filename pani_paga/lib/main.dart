import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'sonu',
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var placeName = TextEditingController();
  var lattt = '';
  var lonnn = '';
  var desc = '';
  var temp = '';
  late double temp2;
  var temp3 = '';
  var pressure = '';
  var humidity = '';
  var wind_speed = '';
  late double wind_speed2;
  var wind_speed3 = '';
  var sunrise = '';
  var sunset = '';
  var Ccountry = '';
  var Fcountry = '';
  var countryCapital = '';
  var continents = '';
  var subregion = '';
  var timezone = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      // appBar: AppBar(
      //   backgroundColor: Colors.transparent,
      // ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/pathtosun.jpeg'),
                fit: BoxFit.cover)),
        child: SingleChildScrollView(
            child: Column(
          children: [
            Container(
              margin: const EdgeInsets.fromLTRB(0, 60, 0, 0),
              width: 350,
              height: 50,
              decoration: const BoxDecoration(
                color: Colors.transparent,
              ),
              child: Center(
                child: TextField(
                  controller: placeName,
                  cursorColor: Colors.white,
                  style: const TextStyle(fontSize: 25, color: Colors.white),
                  decoration: InputDecoration(
                      hintText: 'Enter Location',
                      hintStyle: const TextStyle(
                        fontSize: 20,
                        color: Colors.white70,
                      ),
                      border: InputBorder.none,
                      prefixIcon: const Icon(
                        Icons.location_on_rounded,
                        size: 30,
                      ),
                      prefixIconColor: Colors.white,
                      suffixIcon: InkWell(
                        onTap: () async {
                          var sendCity = GetCityGiveLatLon(placeName.text);
                          var lattLonn = await sendCity.GetLatLon();
                          var lat = lattLonn['lat'];
                          var lon = lattLonn['lon'];
                          var sendLatLon =
                              await GetLatLanGiveWeatherData(lat, lon);
                          var data = await sendLatLon.FetchData();
                          lattt = data['lat'].toString();
                          lonnn = data['lon'].toString();
                          desc = data['desc'];
                          temp = (data['temp'] - 273.15).toString();
                          temp2 = double.parse(temp);
                          temp3 = temp2.toStringAsFixed(2);
                          pressure = data['pressure'].toString();
                          humidity = data['humidity'].toString();
                          wind_speed = (data['wind_speed'] * 3.6).toString();
                          wind_speed2 = double.parse(wind_speed);
                          wind_speed3 = wind_speed2.toStringAsFixed(1);
                          //country = data['country'];
                          //time convert
                          int rise = data['sunrise'];
                          DateTime dateTime1 =
                              DateTime.fromMillisecondsSinceEpoch(rise * 1000);

                          String formatDate(DateTime dateTime1) {
                            String period = 'AM';
                            int hour = dateTime1.hour;
                            if (hour >= 12) {
                              period = 'PM';
                              if (hour > 12) {
                                hour -= 12;
                              }
                            }
                            String minutes =
                                dateTime1.minute.toString().padLeft(2, '0');
                            String formattedTime = '$hour:$minutes $period';
                            return formattedTime;
                          }

                          sunrise = formatDate(dateTime1);

                          int set = data['sunset'];
                          DateTime dateTime2 =
                              DateTime.fromMillisecondsSinceEpoch(set * 1000);
                          String formatDate2(DateTime dateTime2) {
                            String period = 'AM';
                            int hour = dateTime2.hour;
                            if (hour >= 12) {
                              period = 'PM';
                              if (hour > 12) {
                                hour -= 12;
                              }
                            }
                            String minutes =
                                dateTime2.minute.toString().padLeft(2, '0');
                            String formattedTime = '$hour:$minutes $period';
                            return formattedTime;
                          }

                          sunset = formatDate2(dateTime2);

                          //timezone = data['timezone'].toString();
                          int timezoneOffsetSeconds = data['timezone'];
                          String getUTCOffset(int timezoneOffsetSeconds) {
                            Duration offset =
                                Duration(seconds: timezoneOffsetSeconds.abs());
                            String sign =
                                (timezoneOffsetSeconds >= 0) ? '+' : '-';

                            int hours = offset.inHours;
                            int minutes = offset.inMinutes.remainder(60);

                            String offsetString =
                                '$sign${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}';
                            return 'UTC$offsetString';
                          }

                          timezone = getUTCOffset(timezoneOffsetSeconds);
                          var sendingCode = await CountryName(data['country']);
                          var counObj = await sendingCode.getFullName();
                          Ccountry = counObj['Cname'];
                          Fcountry = counObj['Oname'];
                          countryCapital = counObj['capital'];
                          continents = counObj['continent'];
                          subregion = counObj['subregion'];
                          setState(() {});
                        },
                        child: const Icon(
                          Icons.search_rounded,
                          size: 30,
                        ),
                      ),
                      suffixIconColor: Colors.white),
                  textAlignVertical: TextAlignVertical.center,
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Container(
              width: 350,
              height: 170,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(color: Colors.white54),
                  gradient: LinearGradient(colors: [
                    Colors.white.withOpacity(0.30),
                    Colors.white.withOpacity(0.20),
                    Colors.white.withOpacity(0.30)
                  ], begin: Alignment.topRight, end: Alignment.bottomLeft)),
              child: Row(
                children: [
                  Container(
                    width: 149,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '$temp3',
                            style: TextStyle(
                                fontSize: 50,
                                fontWeight: FontWeight.w500,
                                color: Colors.white),
                          ),
                          Text(
                            ' $desc',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w300,
                                color: Colors.white),
                          )
                        ]),
                  ),
                  Container(
                    width: 199,
                    //color: Colors.amber,
                  )
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              width: 380,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                      width: 110,
                      height: 50,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.white54),
                          gradient: LinearGradient(colors: [
                            Colors.white.withOpacity(0.30),
                            Colors.white.withOpacity(0.20),
                            Colors.white.withOpacity(0.30)
                          ])),
                      child: Column(
                        children: [
                          const Text(
                            'latitude',
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                          Text(lattt,
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 20))
                        ],
                      )),
                  Container(
                      width: 120,
                      height: 50,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.white54),
                          gradient: LinearGradient(colors: [
                            Colors.white.withOpacity(0.30),
                            Colors.white.withOpacity(0.20),
                            Colors.white.withOpacity(0.30)
                          ])),
                      child: Column(
                        children: [
                          const Text('longitude',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20)),
                          Text(lonnn,
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 20))
                        ],
                      )),
                  Container(
                      width: 110,
                      height: 50,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.white54),
                          gradient: LinearGradient(colors: [
                            Colors.white.withOpacity(0.30),
                            Colors.white.withOpacity(0.20),
                            Colors.white.withOpacity(0.30)
                          ])),
                      child: Column(
                        children: [
                          const Text('country',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20)),
                          Text(
                            Ccountry,
                            style: const TextStyle(
                                color: Colors.white, fontSize: 20),
                          )
                        ],
                      ))
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              height: 290,
              width: 350,
              child: Column(
                children: [
                  Container(
                      margin: const EdgeInsets.only(
                          bottom: 10.0, left: 0, right: 0, top: 0),
                      width: double.infinity,
                      height: 90,
                      decoration: BoxDecoration(
                          gradient: LinearGradient(colors: [
                            Colors.white.withOpacity(0.30),
                            Colors.white.withOpacity(0.20),
                            Colors.white.withOpacity(0.30)
                          ]),
                          borderRadius: BorderRadius.circular(35)),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(8.0, 0, 12, 0),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(children: [
                                Icon(Icons.forest_rounded),
                                Text('Pressure',
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 20)),
                              ]),
                              Text(pressure,
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 20))
                            ]),
                      )),
                  Container(
                    margin: EdgeInsets.only(
                        bottom: 10.0, left: 0, right: 0, top: 0),
                    width: double.infinity,
                    height: 90,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [
                          Colors.white.withOpacity(0.30),
                          Colors.white.withOpacity(0.20),
                          Colors.white.withOpacity(0.30)
                        ]),
                        borderRadius: BorderRadius.circular(35)),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(8.0, 0, 12, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.abc_outlined),
                              Text('Humidity',
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 20))
                            ],
                          ),
                          Text(humidity,
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20))
                        ],
                      ),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    height: 90,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [
                          Colors.white.withOpacity(0.30),
                          Colors.white.withOpacity(0.20),
                          Colors.white.withOpacity(0.30)
                        ]),
                        borderRadius: BorderRadius.circular(35)),
                    //child: Text('wind speed $wind_speed3')
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(8, 0, 12, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.add_box_rounded),
                              Text('Wind speed',
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 20))
                            ],
                          ),
                          Text(wind_speed3,
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 20))
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              width: 350,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                      width: 100,
                      height: 100,
                      color: Colors.amber,
                      child: Text('sunrise $sunrise')),
                  Container(
                      width: 100,
                      height: 100,
                      color: Colors.pink,
                      child: Text('sunset $sunset')),
                  Container(
                      width: 100,
                      height: 100,
                      color: Colors.cyanAccent,
                      child: Text('timezone $timezone'))
                ],
              ),
            )
          ],
        )),
      ),
    );
  }
}

class GetCityGiveLatLon {
  var cityName;
  GetCityGiveLatLon(this.cityName);
  Future<Map> GetLatLon() async {
    Response response1 = await get(Uri.parse(
        'http://api.openweathermap.org/geo/1.0/direct?q=$cityName&limit=4&appid=6b07be6ec4cee14629447c5f51e1f14d'));

    List<dynamic> cityData1 = jsonDecode(response1.body);
    if (cityData1.isNotEmpty) {
      var lat = cityData1[0]['lat'];
      var lon = cityData1[0]['lon'];
      return {'lat': lat, 'lon': lon};
    } else {
      return {'lat': null, 'lon': null};
    }
  }
}

class GetLatLanGiveWeatherData {
  var latitude;
  var longitude;
  GetLatLanGiveWeatherData(this.latitude, this.longitude);
  Future<Map> FetchData() async {
    Response responseMain = await get(Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?lat=$latitude&lon=$longitude&appid=6b07be6ec4cee14629447c5f51e1f14d'));
    Map data = jsonDecode(responseMain.body);
    //creating map
    Map impData = {
      'lat': data['coord']['lat'],
      'lon': data['coord']['lon'],
      'desc': data['weather'][0]['description'],
      'temp': data['main']['temp'],
      'pressure': data['main']['pressure'],
      'humidity': data['main']['humidity'],
      'wind_speed': data['wind']['speed'],
      'sunrise': data['sys']['sunrise'],
      'sunset': data['sys']['sunset'],
      'country': data['sys']['country'],
      'timezone': data['timezone']
    };
    return (impData);
  }
}

class CountryName {
  var code;
  CountryName(this.code);
  Future<Map> getFullName() async {
    Response responseCoun =
        await get(Uri.parse('https://restcountries.com/v3.1/alpha/$code'));
    List countryDetails = jsonDecode(responseCoun.body);
    Map details = {
      'Cname': countryDetails[0]['name']['common'],
      'Oname': countryDetails[0]['name']['official'],
      'capital': countryDetails[0]['capital'][0],
      'continent': countryDetails[0]['region'],
      'subregion': countryDetails[0]['subregion']
    };
    return details;
  }
}
