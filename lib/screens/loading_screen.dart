import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:task_yellow_class/models/movies_model.dart';
import 'package:task_yellow_class/models/user_model.dart' as UserModel;
import 'package:task_yellow_class/screens/home_screen.dart';
import 'package:task_yellow_class/screens/login_screen.dart';

import '../constants.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({Key key}) : super(key: key);

  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  FirebaseAuth _auth;
  User _user;

  @override
  void initState() {
    super.initState();

    _initializeApplication();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20.0),
            Container(
              child: Container(
                width: MediaQuery.of(context).size.width * .7,
                height: MediaQuery.of(context).size.height * .1,
                alignment: AlignmentDirectional.center,
                child: RichText(
                  text: TextSpan(
                    text: 'YC ',
                    style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 30.0,
                        fontWeight: FontWeight.w800),
                    children: [
                      TextSpan(
                        text: 'Task',
                        style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 20.0,
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
                decoration: BoxDecoration(
                  color: Color(0XFF10101A),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(15.0),
                    bottomRight: Radius.circular(15.0),
                  ),
                ),
              ),
              alignment: AlignmentDirectional.topCenter,
              height: MediaQuery.of(context).size.height * .7,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/icon.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * .15),
            RichText(
              text: TextSpan(
                text: 'Made with 💛 by ',
                children: [
                  TextSpan(
                      text: 'Hridayesh Singh',
                      style: TextStyle(
                          fontSize: 15.0, fontWeight: FontWeight.w900))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _initializeApplication() async {
    await Firebase.initializeApp();

    final appDocumentDirectory = await getApplicationDocumentsDirectory();
    Hive.init(appDocumentDirectory.path);
    Hive.registerAdapter<UserModel.User>(UserModel.UserAdapter());
    Hive.registerAdapter<Movies>(MoviesAdapter());
    await Hive.openBox<UserModel.User>(kHiveUsersBoxName);

    setState(() {
      _auth = FirebaseAuth.instance;
      _user = _auth.currentUser;
    });

    Timer(Duration(seconds: 2), () {
      Navigator.pushReplacement(
          context,
          (_user != null)
              ? MaterialPageRoute(builder: (context) => HomeScreen())
              : MaterialPageRoute(builder: (context) => LoginScreen()));
    });
  }
}
