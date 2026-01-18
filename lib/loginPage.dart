import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:voice_to_care/homePage.dart';
import 'package:voice_to_care/signUpPage.dart';

class Loginpage extends StatefulWidget {
  const Loginpage({super.key});

  @override
  State<Loginpage> createState() => _LoginpageState();
}

class _LoginpageState extends State<Loginpage> {

  TextEditingController email= TextEditingController();
  TextEditingController password= TextEditingController();
  bool see=true;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<User?> loginUser() async {

    try {
      final UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email.text,
        password: password.text,
      );


      final User? user = userCredential.user;
      if (user != null) {
        Navigator.push(context, MaterialPageRoute(builder: (context)=>Homepage()));
      }

      final DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection("users")
          .doc(user!.uid)
          .get();

      final userData = userSnapshot.data() as Map<String, dynamic>?;
      print("Login successful: ${user?.email}");
      return user;
    } catch (e, stacktrace) {
      print("Login Error: $e");
      print("StackTrace: $stacktrace");
      return null;

    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 100),
              child: Center(
                child: Image(
                  image: AssetImage('assets/login.png'),
                  height: 250,
                  width: 250,
                ),
              ),
            ),
            SizedBox(height: 30,),
            Text(
              "Voice to Care",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "Understand your feeling better",
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            SizedBox(height: 50,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.email),
                SizedBox(width: 10,),
                SizedBox(
                  width: 300,
                  child: TextFormField(

                    controller: email,
                    decoration: InputDecoration(
                        hintText: "Email",
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                                color: Colors.black
                            )
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                                color: Colors.grey
                            )
                        )
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.lock),
                SizedBox(width: 10,),
                SizedBox(
                  width: 300,
                  child: TextFormField(
                    obscureText: see,
                    controller: password,
                    decoration: InputDecoration(
                        hintText: "password",
                        suffixIcon: IconButton(
                            onPressed: (){
                              setState(() {
                                see=!see;
                              });
                            },
                            icon: Icon(see?Icons.visibility:Icons.visibility_off)),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                                color: Colors.black,
                            )
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                                color: Colors.grey
                            )
                        )
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 50,),
            Padding(
              padding: const EdgeInsets.only(left: 42,right: 38),
              child: GestureDetector(
                onTap: (){
                  loginUser();
                },
                child: Container(
                  height: 70,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                    child: Text(
                        "Login",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),//login button
            SizedBox(height: 20,),
            Padding(
              padding: const EdgeInsets.only(left: 30,right: 30),
              child: Divider(),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("New user??"),
                GestureDetector(
                  onTap: (){
                   Navigator.push(context, MaterialPageRoute(builder: (context)=>Signuppage()));
                  },
                  child: Text(
                    "Sign up",
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
