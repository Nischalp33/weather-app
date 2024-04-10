import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/widgets/additional_info_widget.dart';
import 'package:weather_app/widgets/weather_card.dart';
import 'package:http/http.dart' as http;

import '../methods/weather_api.dart';
import '../secrets.dart';

class WeatherScreen extends StatefulWidget {




  const WeatherScreen({Key? key}) : super(key: key);

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}



class _WeatherScreenState extends State<WeatherScreen> {

   late Future<Map<String,dynamic>> weather;


  @override

  Future<Map<String, dynamic>>getWeatherApi()async{


    final String cityName = 'Bhaktapur';
    final String countryName = 'np';

    final response = await http.get(Uri.parse('https://api.openweathermap.org/data/2.5/forecast?q=$cityName,$countryName&APPID=$openWeatherAPIkey'),);



    try{
      if(response.statusCode == 200){
        var data = jsonDecode(response.body);


        // temp = data['list'][0]['main']['temp'];
    return data;
      }else{

        throw Exception('error');
      }

    }
    catch(e){

      throw e.toString();
    }

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    weather = getWeatherApi();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height * 1;
    final width = MediaQuery.sizeOf(context).width * 1;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Weather App',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                weather = getWeatherApi();
              });
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body:
      FutureBuilder(
        future: weather,
        builder: (context, AsyncSnapshot snapshot) {



          if(snapshot.connectionState==ConnectionState.waiting){
            return LinearProgressIndicator();

          }

          final data = snapshot.data;
          final currentTemp = data['list'][0]['main']['temp'];
          final currentSky = data['list'][0]['weather'][0]['main'];



          final humidity = data['list'][0]['main']['humidity'];
          final air = data['list'][0]['wind']['speed'];
          final pressure = data['list'][0]['main']['pressure'];

          return Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              SizedBox(
                width: double.infinity,
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 10,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Text(
                              '$currentTemp° K',
                              style: TextStyle(
                                  fontSize: 32, fontWeight: FontWeight.bold),
                            ),
                            Icon(
                              currentSky == 'Clouds'|| currentSky =='Rain'?
                              Icons.cloud: Icons.sunny,
                              size: 64,
                            ),
                            SizedBox(
                              height: 16,
                            ),
                            Text(
                              currentSky,
                              style: TextStyle(fontSize: 20),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const Align(
                alignment: Alignment.centerLeft,
                child:  Text(
                  'Hourly Forecast',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              // SingleChildScrollView(
              //   scrollDirection: Axis.horizontal,
              //   child: Row(
              //     children: [
              //       WeatherCard(time: '12:00', temperature: '100° k', icon: Icons.cloud),
              //       WeatherCard(time: '12:00', temperature: '100° k', icon: Icons.sunny),
              //       WeatherCard(time: '12:00', temperature: '200° k', icon: Icons.sunny),
              //       WeatherCard(time: '12:00', temperature: '100° k', icon: Icons.cloud),
              //       WeatherCard(time: '12:00', temperature: '100° k', icon: Icons.cloud),
              //
              //     ],
              //   ),
              // ),

              SizedBox(
                height: 130,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                      itemCount: snapshot.data['cnt'] -1,
                    itemBuilder: (BuildContext context, index){

                      final hourlyTemp = data['list'][index+1]['main']['temp'];
                      final hourlyTime = data['list'][index+1]['dt_txt'];
                      final hourlySky = data['list'][index+1]['weather'][0]['main'];


                      
                      //dateTime
                      
                      final time = DateTime.parse(hourlyTime.toString());

                      return WeatherCard(
                        time: DateFormat.j().format(time),
                          temperature: '${hourlyTemp.toString()}° K',
                          icon: hourlySky == 'Clouds'|| hourlySky =='Rain'?
                          Icons.cloud: Icons.sunny,);
                    }),
              ),

              const SizedBox(
                height: 20,
              ),
             const Align(
                alignment: Alignment.centerLeft,
                child:  Text(
                  'Additional Information',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                padding: EdgeInsets.all(8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AdditionalInfoWidget(text: 'Humidity', data: humidity.toString(), icon:Icons.water_drop),
                    AdditionalInfoWidget(text: 'Wind Speed', data: air.toString(), icon: Icons.air),
                    AdditionalInfoWidget(text: 'Pressure', data: pressure.toString(), icon: Icons.beach_access,),


                  ],
                ),
              )
            ],
          ),
        );
        },
      ),
    );
  }

}
