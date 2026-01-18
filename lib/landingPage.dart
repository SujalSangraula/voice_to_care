import 'package:flutter/material.dart';
import 'package:voice_to_care/loginPage.dart';

class Landingpage extends StatefulWidget {
  const Landingpage({super.key});

  @override
  State<Landingpage> createState() => _LandingpageState();
}

class _LandingpageState extends State<Landingpage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 140),
              child: Center(child: Image.asset('assets/logo.png')),
            ),
            SizedBox(height: 30,),
            Text(
              "Voice to Care",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10,),
            Text(
              "Understand your feeling better",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black45,
              ),
            ),
            SizedBox(height: 50,),
            GestureDetector(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>Loginpage()));
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(10)
                ),
                height: 75,
                width: 75,
                child: Column(
                  children: [
                    SizedBox(height: 22,),
                    Icon(Icons.arrow_forward_rounded,color: Colors.white,size: 30,)
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
