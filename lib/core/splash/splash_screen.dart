import 'package:flutter/material.dart';
import 'package:whatsapp/core/theme/style.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(),
          Image.asset(
            "assets/whats_app_logo.png",
            color: Colors.white,
            width: 100,
            height: 100,
          ),
          Column(
            children: [
              Text(
                "from",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                  color: greyColor.withValues(alpha: .6),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/meta.png",
                    color: Colors.white,
                    width: 35,
                    height: 35,
                  ),
                  const SizedBox(width: 5),
                  const Text(
                    "Meta",
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              const SizedBox(height: 30),
            ],
          ),
        ],
      ),
    );
  }
}
