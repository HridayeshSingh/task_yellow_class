import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hive/hive.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:task_yellow_class/constants.dart';
import 'package:task_yellow_class/models/movies_model.dart';
import 'package:task_yellow_class/screens/home_screen.dart';
import 'package:task_yellow_class/screens/signup_screen.dart';
import 'package:task_yellow_class/widgets/custom_button.dart';
import 'package:task_yellow_class/widgets/custom_text_field.dart';
import 'package:task_yellow_class/models/user_model.dart' as UserModel;

class LoginScreen extends StatefulWidget {
  LoginScreen({@required this.loggedOut});

  final bool loggedOut;

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  bool showSpinner = false;

  @override
  void dispose() {
    super.dispose();

    if (widget.loggedOut) {
      Hive.box<UserModel.User>(kHiveUsersBoxName).close();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      progressIndicator: SpinKitDoubleBounce(
        color: Colors.white,
        size: 50.0,
      ),
      child: Scaffold(
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              physics: MediaQuery.of(context).viewInsets.bottom == 0
                  ? NeverScrollableScrollPhysics()
                  : BouncingScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.all(MediaQuery.of(context).size.width * .1),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'To continue, log in to the YC Task',
                      style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 17.0,
                          fontWeight: FontWeight.w600),
                    ),
                    SizedBox(height: 15.0),
                    ElevatedButton(
                      onPressed: () => _googleLogin(),
                      style: ElevatedButton.styleFrom(
                          primary: Colors.white,
                          shape: StadiumBorder(),
                          padding: EdgeInsets.all(10)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/google_logo.png',
                            height: 25.0,
                            width: 25.0,
                          ),
                          SizedBox(width: 20.0),
                          Text(
                            'Continue with Google',
                            style: TextStyle(
                                fontSize: 16.0,
                                color: Colors.black,
                                fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20.0),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 20.0),
                            child: Divider(
                              color: kHintColor,
                            ),
                          ),
                        ),
                        Text(
                          'or',
                          style: TextStyle(fontSize: 20.0, color: kHintColor),
                        ),
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 20.0),
                            child: Divider(
                              color: kHintColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20.0),
                    Form(
                      key: _loginFormKey,
                      child: Column(
                        children: [
                          TextFieldWidget(
                            hintText: 'Email address',
                            iconData: Icons.alternate_email,
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.emailAddress,
                            controller: _emailController,
                            validator: (input) =>
                                (input == null || input.isEmpty)
                                    ? 'This field is required'
                                    : (!(input.contains('@') &&
                                            input.contains('.')))
                                        ? 'Invalid email'
                                        : null,
                          ),
                          TextFieldWidget(
                            hintText: 'Password',
                            iconData: Icons.lock_outline_rounded,
                            keyboardType: TextInputType.visiblePassword,
                            controller: _passwordController,
                            validator: (input) =>
                                (input == null || input.isEmpty)
                                    ? 'This field is required'
                                    : (input.length < 6)
                                        ? 'Should contain at least 6 characters'
                                        : null,
                            textInputAction: TextInputAction.done,
                            obscureText: true,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 15),
                    ButtonWidget(
                      child: Text(
                        'Log In',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      onPressed: () => _loginButtonPressed(),
                      shapeBorder: StadiumBorder(),
                      padding:
                          EdgeInsets.symmetric(horizontal: 45, vertical: 15),
                    ),
                    SizedBox(height: 25),
                    RichText(
                      text: TextSpan(
                        text: 'New to YC Task? ',
                        style: TextStyle(fontSize: 13, fontFamily: 'Poppins'),
                        children: [
                          TextSpan(
                            text: 'Create account',
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                decoration: TextDecoration.underline),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () => Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SignupScreen(
                                            loggedOut: widget.loggedOut,
                                          ))),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showSnackBarMessage(context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      duration: Duration(seconds: 2),
    ));
  }

  void _loginButtonPressed() async {
    if (_loginFormKey.currentState.validate()) {
      _loginFormKey.currentState.save();

      setState(() {
        showSpinner = true;
      });

      UserCredential userCredential;

      try {
        userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: _emailController.text, password: _passwordController.text);
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          _showSnackBarMessage(context, 'No user found for that email.');
        } else if (e.code == 'wrong-password') {
          _showSnackBarMessage(
              context, 'Wrong password provided for that user.');
        }
      }

      setState(() {
        showSpinner = false;
      });

      if (userCredential != null) {
        await Hive.openBox<Movies>(FirebaseAuth.instance.currentUser.uid);

        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => HomeScreen()));
      }
    }
  }

  void _googleLogin() async {
    setState(() {
      showSpinner = true;
    });

    UserCredential userCredential;
    String idToken;

    try {
      GoogleSignInAccount googleUser = await _googleSignIn.signIn();

      GoogleSignInAuthentication googleSignInAuthentication =
          await googleUser.authentication;

      idToken = googleSignInAuthentication.idToken;

      AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: idToken,
      );

      userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      print(e.message);
    } catch (e) {
      print(e.toString());
    }

    Map<String, dynamic> idMap = _parseJwt(idToken);

    final String name = '${idMap["given_name"]} ${idMap["family_name"]}';

    setState(() {
      showSpinner = false;
    });

    if (userCredential != null) {
      await Hive.openBox<Movies>(FirebaseAuth.instance.currentUser.uid);

      Hive.box<UserModel.User>(kHiveUsersBoxName).put(
        FirebaseAuth.instance.currentUser.uid,
        UserModel.User(
          email: FirebaseAuth.instance.currentUser.email,
          name: name,
        ),
      );

      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => HomeScreen()));
    }
  }

  static Map<String, dynamic> _parseJwt(String token) {
    // validate token
    if (token == null) return null;
    final List<String> parts = token.split('.');
    if (parts.length != 3) {
      return null;
    }
    // retrieve token payload
    final String payload = parts[1];
    final String normalized = base64Url.normalize(payload);
    final String resp = utf8.decode(base64Url.decode(normalized));
    // convert to Map
    final payloadMap = json.decode(resp);
    if (payloadMap is! Map<String, dynamic>) {
      return null;
    }
    return payloadMap;
  }
}
