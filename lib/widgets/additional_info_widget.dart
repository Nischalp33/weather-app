import 'package:flutter/material.dart';

class AdditionalInfoWidget extends StatelessWidget {
  final String text;
  final IconData icon;
  final String data;
  const AdditionalInfoWidget({Key? key, required this.text,required this.data,required this.icon}) : super(key: key);



  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          size: 32,
            icon),
        SizedBox(
          height: 8,
        ),
        Text(
          text,
          style: TextStyle(fontSize: 16, color: Colors.white60),
        ),
        SizedBox(
          height: 8,
        ),
        Text(
          data,
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
