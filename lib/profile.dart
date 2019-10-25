import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

class Profile extends StatelessWidget {
  final String email;
  final String uid;
  final String displayName;
  final String photoUrl;

  const Profile({this.email, this.uid, this.displayName, this.photoUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[900],
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('Profile'),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Stack(
            alignment: Alignment.topCenter,
            children: <Widget>[
              // Details Card
              Container(
                width: double.infinity,
                child: Card(
                  color: Colors.blueGrey[200],
                  margin: EdgeInsets.only(top: 60.0, bottom: 28.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(28.0, 90.0, 28.0, 16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        // Display Name
                        Text(
                          displayName,
                          style: TextStyle(
                            fontSize: 25.0,
                          ),
                        ),

                        // Level
                        CircularPercentIndicator(
                          radius: 120.0,
                          lineWidth: 13.0,
                          animation: true,
                          animationDuration: 600,
                          percent: 0.7,
                          circularStrokeCap: CircularStrokeCap.round,
                          progressColor: Colors.indigo[400],
                          center: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                "Level",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.0,
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                "40",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 26.0,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Srteak
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              'Streak: ',
                              style: TextStyle(fontSize: 20.0),
                            ),
                            Text(
                              '30',
                              style: TextStyle(fontSize: 20.0),
                            ),
                          ],
                        ),

                        // Bottom Options
                        Divider(
                          color: Colors.blueGrey[500],
                          indent: 24.0,
                          endIndent: 24.0,
                          thickness: 1.0,
                        ),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[],
                        )
                      ],
                    ),
                  ),
                ),
              ),

              // Avatar
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(70.0),
                    border: Border.all(
                      color: Colors.blueGrey[100],
                      width: 6.0,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 2.0,
                      ),
                    ]),
                child: Hero(
                  tag: 'profile',
                  child: CircleAvatar(
                    radius: 60,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(60),
                      child: photoUrl == null
                          ? Image.asset(
                              'assets/images/profile-image.png',
                              fit: BoxFit.fill,
                            )
                          : NetworkImage(photoUrl),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

      // Floating Action Button
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(
          Icons.mode_edit,
          color: Colors.blueGrey[900],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
