import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:task_yellow_class/constants.dart';
import 'package:task_yellow_class/models/movies_model.dart';
import 'package:task_yellow_class/screens/add_edit_screen.dart';

class MoviesCardWidget extends StatelessWidget {
  const MoviesCardWidget({
    Key key,
    @required this.index,
    @required this.movieName,
    @required this.directorName,
    @required this.imagePath,
  }) : super(key: key);

  final int index;
  final String movieName;
  final String directorName;
  final String imagePath;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15),
      margin: EdgeInsets.only(top: 20, bottom: 10),
      height: 200.0,
      decoration: BoxDecoration(
        color: Color(0xFF12121C),
        borderRadius: BorderRadius.circular(20.0),
        border: Border.all(
          color: Color(0xFF2A2D39),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: FileImage(File(imagePath)),
                fit: BoxFit.cover,
              ),
            ),
            width: MediaQuery.of(context).size.width * .3,
            // child: Image.asset('assets/images/icon1.jpg'),
          ),
          SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  movieName,
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                  ),
                  softWrap: true,
                ),
                Text(
                  directorName,
                  style: TextStyle(fontSize: 10, fontFamily: 'Poppins'),
                  softWrap: true,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddEditScreen(
                            index: index,
                            movieName: movieName,
                            directorName: directorName,
                            coverPhotoPath: imagePath,
                          ),
                        ),
                      ),
                      icon: Icon(
                        Icons.edit_rounded,
                        color: kButtonColor,
                      ),
                    ),
                    IconButton(
                        onPressed: () => Hive.box<Movies>(
                                FirebaseAuth.instance.currentUser.uid)
                            .deleteAt(index),
                        icon: Icon(
                          Icons.delete_rounded,
                          color: kButtonColor,
                        )),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
