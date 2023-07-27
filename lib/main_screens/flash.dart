// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api

import 'dart:async';


import 'package:flutter/material.dart';

import 'onboarding_screen.dart';

class FlashScreen extends StatefulWidget {
  const FlashScreen({Key? key}) : super(key: key);

  @override
  State<FlashScreen> createState() => _FlashScreenState();
}

class _FlashScreenState extends State<FlashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    Timer(
        const Duration(seconds: 3),
        () => Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const Onboardingscreen())));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
        color:
            // const Color.fromRGBO(221,178,0,0),
            Colors.amber,
        child:
            // FlutterLogo(size:MediaQuery.of(context).size.height)
            const Image(
                image: AssetImage(
          'images/logo/cbs.png',
        )));
  }
}
