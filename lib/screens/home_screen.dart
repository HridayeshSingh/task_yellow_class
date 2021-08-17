import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:task_yellow_class/constants.dart';
import 'package:task_yellow_class/models/movies_model.dart';
import 'package:task_yellow_class/models/user_model.dart' as UserModel;
import 'package:task_yellow_class/screens/add_edit_screen.dart';
import 'package:task_yellow_class/screens/login_screen.dart';
import 'package:task_yellow_class/widgets/custom_movie_card.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final GoogleSignIn _googleSignIn = GoogleSignIn();

  var isDialOpen = ValueNotifier<bool>(false);
  UserModel.User user;

  @override
  void initState() {
    super.initState();

    _initializePage();
  }

  @override
  void dispose() {
    super.dispose();

    Hive.box<UserModel.User>(kHiveUsersBoxName).close();
    Hive.box<Movies>(_auth.currentUser.uid).close();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (isDialOpen.value) {
          isDialOpen.value = false;
          return false;
        }
        return true;
      },
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(MediaQuery.of(context).size.width * .1),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                RichText(
                  text: TextSpan(
                    text: 'Hello ',
                    style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 20.0,
                        fontWeight: FontWeight.w600),
                    children: [
                      TextSpan(
                        text: '${user.name.split(" ")[0]}!',
                        style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 20.0,
                            fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                ),
                Text(
                  'Here\'s your watched movies list',
                  style: TextStyle(
                      fontFamily: 'Poppins', fontSize: 13, color: kHintColor),
                ),
                SizedBox(height: 30),
                ValueListenableBuilder(
                  valueListenable:
                      Hive.box<Movies>(_auth.currentUser.uid).listenable(),
                  builder: (context, moviesBox, _) {
                    return Flexible(
                      child: ListView.builder(
                        physics: BouncingScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: moviesBox.length,
                        itemBuilder: (context, index) {
                          final Movies movie = moviesBox.getAt(index);
                          return MoviesCardWidget(
                            index: index,
                            movieName: movie.movieName,
                            directorName: movie.directorName,
                            imagePath: movie.coverPhotoPath,
                          );
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: SpeedDial(
          icon: Icons.settings_outlined,
          activeIcon: Icons.close,
          backgroundColor: kButtonColor,
          activeBackgroundColor: kButtonColor,
          foregroundColor: Colors.white60,
          activeForegroundColor: Colors.white60,
          spacing: 3,
          openCloseDial: isDialOpen,
          spaceBetweenChildren: 4,
          elevation: 8.0,
          isOpenOnStart: false,
          closeManually: false,
          renderOverlay: true,
          animationSpeed: 150,
          children: [
            SpeedDialChild(
              child: Icon(Icons.add),
              backgroundColor: kButtonColor,
              foregroundColor: Colors.white60,
              label: 'Add Movie',
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AddEditScreen())),
            ),
            SpeedDialChild(
              child: Icon(Icons.logout),
              backgroundColor: kButtonColor,
              foregroundColor: Colors.white60,
              label: 'Log Out',
              onTap: () async {
                User user = _auth.currentUser;

                if (user.providerData[0].providerId == 'google.com')
                  await _googleSignIn.disconnect();

                await _auth.signOut();

                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => LoginScreen()));
              },
            ),
          ],
        ),
      ),
    );
  }

  void _initializePage() {
    //await Hive.openBox<Movies>(_auth.currentUser.uid);
    user =
        Hive.box<UserModel.User>(kHiveUsersBoxName).get(_auth.currentUser.uid);
  }
}
