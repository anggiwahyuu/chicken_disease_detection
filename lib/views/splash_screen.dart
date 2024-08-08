// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});
  static const routeName = "/splash_screen";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                child: Image.asset(
                  "assets/images/ayamku.png",
                ),
              ),
              Card(
                color: const Color.fromARGB(255, 255, 255, 255),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                elevation: 5,
                child: SizedBox(
                  width: 190,
                  height: 40,
                  child: InkWell(
                    onTap: () {
                      Navigator.pushReplacementNamed(context, "/home_page");
                    },
                    child: const Center(
                      child: Text(
                        "Mulai Sekarang ...",
                        style: TextStyle(
                            fontSize: 16,
                            color: Color.fromRGBO(0, 0, 0, 1),
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
