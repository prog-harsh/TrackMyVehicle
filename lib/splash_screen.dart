import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:trackmyvehicle/gmap_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final Tween<double> _scaleTween = Tween<double>(begin: 0.2, end: 1.2);
  late DatabaseReference _databaseReference;

  void getTimer() {
    Timer(const Duration(seconds: 5), finished);
  }

  Future<String> getLatitude(DatabaseReference ref) async {
    DataSnapshot snap = await ref.child('GPS_LAT').get();
    snap = await ref.child('GPS_LAT').get();
    return snap.value.toString();
  }

  Future<String> getLongitute(DatabaseReference ref) async {
    DataSnapshot snap = await ref.child('GPS_LON').get();
    return snap.value.toString();
  }

  @override
  void initState() {
    super.initState();
    _databaseReference = FirebaseDatabase.instance.ref();
    // print(getLatitude(_databaseReference));
    getTimer();
  }

  void finished() async {
    String lat = await getLatitude(_databaseReference);
    String lon = await getLongitute(_databaseReference);
    // ignore: use_build_context_synchronously
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) =>  GmapScreen(lat,lon),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
        elevation: 0,
        backgroundColor: Colors.transparent,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
        ),
      ),
      backgroundColor: Colors.white,
      body: TweenAnimationBuilder(
        curve: Curves.bounceIn,
        tween: _scaleTween,
        duration: const Duration(milliseconds: 3000),
        builder: (ctx, double scale, child) {
          return Transform.scale(
            scale: scale,
            child: child,
          );
        },
        child: Container(
          alignment: Alignment.center,
          child: Image(
            image:const AssetImage('images/car.jpg'),
            width: MediaQuery.of(context).size.width * 0.8,
          ),
        ),
      ),
    );
  }
}
