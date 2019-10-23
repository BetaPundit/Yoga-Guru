import 'package:flutter/material.dart';

class YogaCard extends StatelessWidget {
  final String asana;
  final Color color;

  const YogaCard({this.asana, this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      padding: EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10.0,
            offset: Offset(0.0, 10.0),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(
              "assets/poses/" + asana + ".png",
              fit: BoxFit.contain,
            ),
          ),
          Text(
            asana,
            style: TextStyle(fontSize: 24),
          )
        ],
      ),
    );
  }
}
