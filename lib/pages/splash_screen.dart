import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:banking_app/pages/root.dart';

class SplashScreenAnimation extends StatefulWidget {
  const SplashScreenAnimation({super.key});

  @override
  AnimatedBuilderDemoState createState() => AnimatedBuilderDemoState();
}

class AnimatedBuilderDemoState extends State<SplashScreenAnimation>
    with SingleTickerProviderStateMixin {

  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller =  AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    );

    _controller.forward().then((value) {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) {
        return const RootPage();
      }));
    });

  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
      Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            opacity: 0.3,
            image: AssetImage('images/digital-bank.jpeg')
          )
        ),
        child: Center(
            child:
            Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedBuilder(
                    animation: _controller,
                    child: const SizedBox(
                      width: 120.0,
                      height: 120.0,
                      child: Icon(
                        Icons.currency_exchange,
                        color: Color(0xFF00214E),
                        size: 100,
                      )
                    ),
                    builder: (BuildContext context, Widget? child) {
                      return Transform.rotate(
                        angle: _controller.value * 2.0 * math.pi,
                        child: child,
                      );
                    },
                  ),
                  Container(height: 15),
                  ShaderMask(
                    shaderCallback: (Rect bounds) {
                      return const LinearGradient(
                        // colors: [Color(0xFF00214E), Color(0xFF282460)],
                        colors: [Color(0xFF00214E), Color(0xFF0066BD)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ).createShader(bounds);
                    },
                    child: const Text(
                      "BankIO",
                      style: TextStyle(
                          fontSize: 60,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic,
                          shadows: [
                            Shadow(
                              color: Color(0xFF282460),      // Choose the color of the shadow
                              blurRadius: 3.0,          // Adjust the blur radius for the shadow effect
                              offset: Offset(3.0, 3.0), // Set the horizontal and vertical offset for the shadow
                            ),
                          ]
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ])
        ),
      ),
    );
  }
}