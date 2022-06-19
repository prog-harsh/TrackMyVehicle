// import 'package:dr_fit/screens/mainpage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'gmap_screen.dart';
import 'auhentication_service.dart';

// ignore: must_be_immutable
class LoginScreen extends StatefulWidget {
  String lat;
  String lon;
  LoginScreen(this.lat, this.lon, {Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _loading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
        elevation: 0,
        backgroundColor: Colors.white,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
        ),
      ),
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // const Spacer(),
          Center(
            child: Image.asset(
              'images/sp.jpg',
              fit: BoxFit.cover,
              width: MediaQuery.of(context).size.width * 0.9,
              height: MediaQuery.of(context).size.height * 0.45,
            ),
          ),
          const Spacer(),
          Container(
            margin: const EdgeInsets.only(left: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Hello there,',
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.w500),
                ),
                Text(
                  'Welcome back',
                  style: TextStyle(
                    fontSize: 29,
                  ),
                ),
                Text(
                  'Please Sign In using Google',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
          const Spacer(
            flex: 2,
          ),
          Center(
            child: ClipRRect(
              borderRadius: const BorderRadius.horizontal(
                  left: Radius.circular(80), right: Radius.circular(80)),
              child: _loading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              const Color.fromARGB(255, 32, 38, 104))),
                      onPressed: () async {
                        setState(() {
                          _loading = true;
                        });
                        try {
                          await AuthenticationService.signInWithGoogle(
                              context: context);
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(e.toString()),
                            backgroundColor: Colors.red,
                            duration: const Duration(seconds: 6),
                          ));
                        }

                        setState(() {
                          _loading = false;
                        });
                        if (FirebaseAuth.instance.currentUser != null) {
                          // ignore: use_build_context_synchronously
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (ctx) =>
                                      GmapScreen(widget.lat, widget.lon)));
                        }
                      },
                      child: Container(
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width * 0.8,
                        height: MediaQuery.of(context).size.height * 0.11,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            FaIcon(
                              FontAwesomeIcons.googlePlusG,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              'Sign In with Google',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 24),
                            ),
                          ],
                        ),
                      ),
                    ),
            ),
          ),
          const Spacer(
            flex: 3,
          )
        ],
      ),
    );
  }
}
