import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:task_yellow_class/constants.dart';
import 'package:task_yellow_class/models/movies_model.dart';
import 'package:task_yellow_class/widgets/custom_button.dart';
import 'package:task_yellow_class/widgets/custom_text_field.dart';

class AddEditScreen extends StatefulWidget {
  const AddEditScreen({
    Key key,
    this.index,
    this.movieName,
    this.directorName,
    this.coverPhotoPath,
  }) : super(key: key);

  final int index;
  final movieName;
  final directorName;
  final coverPhotoPath;

  @override
  _AddEditScreenState createState() => _AddEditScreenState();
}

class _AddEditScreenState extends State<AddEditScreen> {
  final GlobalKey<FormState> _movieFormKey = GlobalKey<FormState>();
  String mName, dName, coverPic;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.all(MediaQuery.of(context).size.width * .1),
            child: Form(
              key: _movieFormKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    decoration:
                        (coverPic != null || widget.coverPhotoPath != null)
                            ? BoxDecoration(
                                image: DecorationImage(
                                  image: FileImage(
                                      File(coverPic ?? widget.coverPhotoPath)),
                                  fit: BoxFit.contain,
                                ),
                                border: Border.all(
                                  color: Color(0xFF2A2D39),
                                ),
                              )
                            : BoxDecoration(
                                border: Border.all(
                                  color: Color(0xFF2A2D39),
                                ),
                              ),
                    width: MediaQuery.of(context).size.width * .8,
                    height: MediaQuery.of(context).size.width * .6,
                    child: FloatingActionButton(
                      mini: true,
                      onPressed: () => _editButtonClicked(),
                      backgroundColor: kButtonColor,
                      foregroundColor: Colors.white60,
                      child: Icon(
                        Icons.edit_rounded,
                        size: 20,
                      ),
                    ),
                    alignment: AlignmentDirectional.topEnd,
                  ),
                  SizedBox(height: 40),
                  RichText(
                    text: TextSpan(
                      text: 'Movie ',
                      style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 15.0,
                          fontWeight: FontWeight.w600),
                      children: [
                        TextSpan(
                          text: 'Name:',
                          style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 15.0,
                              fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                  ),
                  TextFieldWidget(
                    hintText: 'Avengers: Endgame',
                    keyboardType: TextInputType.name,
                    validator: (input) => (input == null || input.isEmpty)
                        ? 'This field is required'
                        : null,
                    initialValue: widget.movieName,
                    onSaved: (value) {
                      setState(() {
                        mName = value;
                      });
                    },
                    textInputAction: TextInputAction.next,
                  ),
                  SizedBox(height: 20),
                  RichText(
                    text: TextSpan(
                      text: 'Director ',
                      style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 15.0,
                          fontWeight: FontWeight.w600),
                      children: [
                        TextSpan(
                          text: 'Name:',
                          style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 15.0,
                              fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                  ),
                  TextFieldWidget(
                    hintText: 'Anthony and Joe Russo',
                    keyboardType: TextInputType.name,
                    validator: (input) => (input == null || input.isEmpty)
                        ? 'This field is required'
                        : null,
                    initialValue: widget.directorName,
                    onSaved: (value) {
                      setState(() {
                        dName = value;
                      });
                    },
                    textInputAction: TextInputAction.done,
                  ),
                  SizedBox(height: 30),
                  ButtonWidget(
                    child: Text(
                      'Save',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    onPressed: () => _saveButtonPressed(),
                    shapeBorder: StadiumBorder(),
                    padding: EdgeInsets.symmetric(horizontal: 45, vertical: 15),
                  ),
                ],
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

  void _saveButtonPressed() {
    if (_movieFormKey.currentState.validate() &&
        (coverPic != null || widget.coverPhotoPath != null)) {
      _movieFormKey.currentState.save();

      Movies movie = Movies(
          movieName: mName,
          directorName: dName,
          coverPhotoPath: coverPic ?? widget.coverPhotoPath);

      if (widget.index == null)
        Hive.box<Movies>(FirebaseAuth.instance.currentUser.uid).add(movie);
      else
        Hive.box<Movies>(FirebaseAuth.instance.currentUser.uid)
            .putAt(widget.index, movie);
      Navigator.pop(context);
    } else {
      _showSnackBarMessage(context, 'Invalid data in fields/cover photo.');
    }
  }

  void _editButtonClicked() async {
    FilePickerResult result = await FilePicker.platform.pickFiles();
    if (result != null) {
      setState(() {
        coverPic = result.files.single.path;
      });
    }
  }
}
