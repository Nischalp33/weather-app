


import 'package:flutter/material.dart';

class WeatherCard extends StatelessWidget {
final String time, temperature;
final IconData icon;
  const WeatherCard({Key? key, required this.time, required this.temperature, required this.icon,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 6,
      child: Container(
        width: 100,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Text(time, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              ),
              SizedBox(
                height: 8,
              ),
              Icon(icon, size: 32,),
              SizedBox(
                height: 8,
              ),
              Text(temperature),

            ],
          ),
        ),
      ),
    );
  }
}
