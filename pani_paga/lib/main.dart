import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

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
  var time = DateTime.now();
  var time2 = '';
  var date = '';
  var weekday = '';
  var main1 = '';
  late String so;
  String getIcon() {
    if (so == 'Clouds') {
      return 'assets/icons/cloudy.png';
    } else if (so == 'Haze') {
      return 'assets/icons/hazy.png';
    } else if (so == 'Clear') {
      return 'assets/icons/sunny.png';
    } else if (so == 'Mist') {
      return 'assets/icons/misty.png';
    } else if (so == 'Rain') {
      return 'assets/icons/rainy.png';
    } else {
      return 'assets/icons/humidity.png';
    }
  }

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
                          var timeobj = GetTime(lat, lon);
                          var timeMap = await timeobj.gettingTime();
                          time2 = timeMap['time'];
                          date = timeMap['date'];
                          weekday = timeMap['dayofweek'];
                          var sendLatLon =
                              await GetLatLanGiveWeatherData(lat, lon);
                          var data = await sendLatLon.FetchData();
                          lattt = data['lat'].toString();
                          lonnn = data['lon'].toString();

                          so = data['main'];
                          desc = data['desc'];
                          temp = (data['temp'] - 273.15).toString();
                          temp2 = double.parse(temp);
                          temp3 = temp2.toStringAsFixed(1);
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
                    width: 169,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            children: [
                              Text(
                                '$temp3 c',
                                style: TextStyle(
                                    fontSize: 50,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white),
                              ),
                              Text(
                                ' $desc',
                                style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w300,
                                    color: Colors.white),
                              ),
                            ],
                          ),
                          // Text(
                          //   '${DateFormat('jm').format(time)}',
                          //   style: TextStyle(fontSize: 25, color: Colors.white),
                          // )
                          Text(
                            time2,
                            style: const TextStyle(
                                fontSize: 25, color: Colors.white),
                          )
                        ]),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        width: 128,
                        height: 128,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage(getIcon()),
                                fit: BoxFit.cover)),
                        //color: Colors.amber,
                      ),
                      // Text(
                      //   '${DateFormat('yMMMMEEEEd').format(time)}',
                      //   style: TextStyle(fontSize: 17, color: Colors.white),
                      // )
                      Text(
                        '$weekday, $date',
                        style:
                            const TextStyle(fontSize: 17, color: Colors.white),
                      )
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(
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
                                color: Colors.white, fontSize: 15),
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
                                // Image.asset('assets/icons/wind.png'),
                                Container(
                                  width: 30,
                                  height: 30,
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: AssetImage(
                                              'assets/icons/pressure.png'),
                                          fit: BoxFit.cover)),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text('Pressure',
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 20)),
                              ]),
                              Text('$pressure mb',
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
                              Container(
                                width: 30,
                                height: 30,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: AssetImage(
                                            'assets/icons/humidity.png'),
                                        fit: BoxFit.cover)),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text('Humidity',
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 20))
                            ],
                          ),
                          Text('$humidity%',
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
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(8, 0, 12, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 30,
                                height: 30,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: AssetImage(
                                            'assets/icons/wind.png'))),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text('Wind speed',
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 20))
                            ],
                          ),
                          Text('$wind_speed3 km/h',
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
                            'sunrise',
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          ),
                          Text(
                            sunrise,
                            textScaleFactor: 2,
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.white),
                          )
                        ],
                      )),
                  Container(
                      width: 100,
                      height: 80,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.white54),
                          gradient: LinearGradient(colors: [
                            Colors.white.withOpacity(0.30),
                            Colors.white.withOpacity(0.20),
                            Colors.white.withOpacity(0.30)
                          ])),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Timezone',
                              style:
                                  TextStyle(fontSize: 20, color: Colors.white)),
                          Text(
                            timezone,
                            textScaleFactor: 1.3,
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.white),
                          )
                        ],
                      )),
                  Container(
                      width: 100,
                      height: 100,
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
                          const Text('sunset',
                              style:
                                  TextStyle(fontSize: 20, color: Colors.white)),
                          Text(
                            sunset,
                            textScaleFactor: 2,
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.white),
                          )
                        ],
                      ))
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
      'main': data['weather'][0]['main'],
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

class GetTime {
  var lat;
  var lon;
  GetTime(this.lat, this.lon);
  Future<Map> gettingTime() async {
    Response response = await get(Uri.parse(
        'https://www.timeapi.io/api/Time/current/coordinate?latitude=$lat&longitude=$lon'));
    Map details = jsonDecode(response.body);
    Map timeDetails = {
      'time': details['time'],
      'dayofweek': details['dayOfWeek'],
      'date': details['date'],
    };
    return timeDetails;
  }
}
