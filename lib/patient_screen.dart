import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:health_connect/authentication.dart';
import 'package:health_connect/cardiac_arrest.dart';
import 'package:health_connect/const.dart';
import 'package:health_connect/login.dart';
import 'package:health_connect/main.dart';
import 'package:health_connect/symptoms.dart';
import 'package:health_connect/history.dart';
import 'package:health_connect/profile_page.dart';
import 'package:health_connect/widgets/card_main.dart';
import 'package:health_connect/widgets/card_section.dart';
import 'package:health_connect/widgets/custom_clipper.dart';
import 'package:health_connect/heartrate.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:health_connect/oxygenreading.dart';
import 'package:health_connect/communication.dart';
import 'package:health_connect/parameterreader.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    Key? key,
    required this.camera,
  }) : super(key: key);

  final CameraDescription camera;

  @override
  State<StatefulWidget> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  Communication communication = Communication();
  String result = "";

  @override
  Widget build(BuildContext context) {
    double statusBarHeight = MediaQuery.of(context).padding.top;

    return Scaffold(
      appBar: AppBar(
          backgroundColor: Constants.darkAccent, foregroundColor: Colors.white),
      drawer: Drawer(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
          children: [
            const DrawerHeader(
                padding: EdgeInsets.only(bottom: 40),
                child: Image(
                  image: AssetImage('assets/icons/logo.png'),
                  fit: BoxFit.contain,
                )),
            const SizedBox(
              height: 40,
            ),
            ListTile(
              minVerticalPadding: 20,
              title: const Text(
                'Profile',
                style: TextStyle(
                  color: Constants.darkAccent,
                  fontSize: 22,
                  fontWeight: FontWeight.w200,
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ProfileScreen(),
                  ),
                );
              },
            ),
            ListTile(
              minVerticalPadding: 20,
              title: const Text(
                'History',
                style: TextStyle(
                  color: Constants.darkAccent,
                  fontSize: 22,
                  fontWeight: FontWeight.w200,
                ),
              ),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HistoryScreen(),
                  ),
                );
              },
            ),
            ListTile(
              minVerticalPadding: 20,
              title: const Text(
                'Check Severity',
                style: TextStyle(
                  color: Constants.darkAccent,
                  fontSize: 22,
                  fontWeight: FontWeight.w200,
                ),
              ),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CardiacScreen(),
                  ),
                );
              },
            ),
            ListTile(
              minVerticalPadding: 20,
              title: const Text(
                'Log Out',
                style: TextStyle(
                  color: Constants.darkAccent,
                  fontSize: 22,
                  fontWeight: FontWeight.w200,
                ),
              ),
              onTap: () {
                Auth.signOut();
                Navigator.of(context).pop();
                Navigator.of(context).pushAndRemoveUntil(
                    PageRouteBuilder(pageBuilder: (context, _, __) {
                  return LoginPage(camera: widget.camera);
                }), (route) => false);
              },
            )
          ],
        ),
      ),
      backgroundColor: Constants.backgroundColor,
      body: Stack(
        children: <Widget>[
          ClipPath(
            clipper: MyCustomClipper(clipType: ClipType.bottom),
            child: Container(
              color: Constants.lightAccent,
              height: Constants.headerHeight + statusBarHeight,
            ),
          ),
          Positioned(
            right: -45,
            top: -30,
            child: ClipOval(
              child: Container(
                color: Colors.black.withOpacity(0.05),
                height: 220,
                width: 220,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(Constants.paddingSide),
            child: ListView(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    const Expanded(
                      child: Text(
                        "Hi,\nPatient",
                        style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w900,
                            color: Colors.white),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ProfileScreen(),
                          ),
                        );
                      },
                      child: const CircleAvatar(
                        radius: 26.0,
                        backgroundImage:
                            AssetImage('assets/icons/default_picture.png'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 80),
                SizedBox(
                  height: 200,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: <Widget>[
                      CardMain(
                        image: const AssetImage('assets/icons/heartbeat.png'),
                        title: "Oxygen",
                        value: result,
                        unit: "%",
                        color: Constants.lightGreen,
                        func: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return BackdropFilter(
                                filter: ImageFilter.blur(
                                  sigmaX: 10.0,
                                  sigmaY: 10.0,
                                ),
                                child: Dialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                      20,
                                    ),
                                  ),
                                  elevation: 5,
                                  backgroundColor: Colors.indigo[50],
                                  child: SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.30,
                                    width:
                                        MediaQuery.of(context).size.width - 10,
                                    child: Center(
                                      child: Column(
                                        children: [
                                          const Text(
                                            'Do you have Health Connect Device?',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) {
                                                      return ParameterReader(
                                                        communication:
                                                            communication,
                                                        bluetoothMessage:
                                                            "Oxygen",
                                                        title: "Oxygen Reading",
                                                        sensorWaitingTime: 75,
                                                      );
                                                    }),
                                                  ).then((value) {
                                                    setState(() {
                                                      result = value;
                                                    });
                                                    Navigator.pop(context);
                                                  });
                                                },
                                                child: const Text('Yes'),
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          OxygenReading(
                                                        camera: widget.camera,
                                                      ),
                                                    ),
                                                  ).then((value) {
                                                    setState(() {
                                                      result = value;
                                                    });
                                                    Navigator.pop(context);
                                                  });
                                                },
                                                child: const Text("No"),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                      // CardMain(
                      //     image: AssetImage('assets/icons/blooddrop.png'),
                      //     title: "Blood Pressure",
                      //     value: "66/123",
                      //     unit: "mmHg",
                      //     color: Constants.lightYellow, func:),
                      // CardMain(
                      //     image: AssetImage('assets/icons/blooddrop.png'),
                      //     title: "Blood Pressure",
                      //     value: "66/123",
                      //     unit: "mmHg",
                      //     color: Constants.lightBlue, func:)
                    ],
                  ),
                ),
                const SizedBox(height: 50),
                const Text(
                  "YOUR DOCTORS",
                  style: TextStyle(
                    color: Constants.textPrimary,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  height: 150,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: const <Widget>[
                      CardSection(
                          title: "Dr. ABC",
                          picture:
                              AssetImage('assets/icons/profile_picture.png')),
                      CardSection(
                          title: "Dr. Devansh",
                          picture:
                              AssetImage('assets/icons/profile_picture.png'))
                    ],
                  ),
                ),
                const SizedBox(height: 50),
                const Text(
                  "YOUR SYMPTOMS",
                  style: TextStyle(
                      color: Constants.textPrimary,
                      fontSize: 13,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                Container(
                  margin: const EdgeInsets.only(right: 15.0),
                  width: 240,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    shape: BoxShape.rectangle,
                    color: Colors.white,
                  ),
                  child: Stack(
                    clipBehavior: Clip.hardEdge,
                    children: <Widget>[
                      Positioned(
                        child: ClipPath(
                          clipper:
                              MyCustomClipper(clipType: ClipType.semiCircle),
                          child: Container(
                            decoration: const BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                              color: Color.fromRGBO(255, 171, 171, 0.1),
                            ),
                            height: 120,
                            width: 120,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: const <Widget>[
                                Image(
                                  image: AssetImage('assets/icons/capsule.png'),
                                  width: 40,
                                  height: 40,
                                  color: Color(0xffffabab),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Expanded(
                                    child: InkWell(
                                  onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const SymptomsScreen(),
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: const <Widget>[
                                      Text(
                                        "Symptoms",
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Constants.textPrimary),
                                      ),
                                      SizedBox(height: 5),
                                    ],
                                  ),
                                )),
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
