import 'package:cloud_notes/google_auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
        body: SafeArea(
      child: Center(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(50),
              child: Container(
                height: deviceSize.height * 0.4,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/cloud.png"),
                  ),
                ),
              ),
            ),
            Text(
              "All Your Notes in One Place",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: ElevatedButton(
                  onPressed: () {
                    signInWithGoogle(context);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        "assets/images/google.png",
                        height: 25,
                        width: 25,
                      ),
                      SizedBox(width: 20),
                      Text(
                        "Login with Google",
                        style: TextStyle(color: Colors.black),
                      ),
                    ],
                  ),
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.white),
                      padding: MaterialStateProperty.all(
                        EdgeInsets.symmetric(vertical: 10),
                      ),
                      shape:
                          MaterialStateProperty.all(RoundedRectangleBorder()),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap)),
            ),
          ],
        ),
      ),
    ));
  }
}
