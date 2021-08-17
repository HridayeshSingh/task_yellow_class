import 'package:flutter/material.dart';
import 'package:task_yellow_class/screens/add_edit_screen.dart';
import 'package:task_yellow_class/screens/home_screen.dart';
import 'package:task_yellow_class/screens/loading_screen.dart';
import 'package:task_yellow_class/screens/login_screen.dart';
import 'package:task_yellow_class/screens/signup_screen.dart';

class RouteNames {
  static const String LOADING = '/';
  static const String LOGIN = '/login';
  static const String SIGNUP = '/signup';
  static const String HOME = '/home';
  static const String ADD_EDIT = '/add_edit';
}

Map<String, Widget> routes = {
  RouteNames.LOADING: LoadingScreen(),
  RouteNames.LOGIN: LoginScreen(),
  RouteNames.SIGNUP: SignupScreen(),
  RouteNames.HOME: HomeScreen(),
  RouteNames.ADD_EDIT: AddEditScreen(),
};

class SlideRoute extends PageRouteBuilder {
  SlideRoute({String routeName})
      : super(
          settings: RouteSettings(name: routeName), // set name here
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) =>
              routes[routeName],
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) {
            var begin = Offset(1.0, 0.0);
            var end = Offset.zero;
            var curve = Curves.ease;
            var tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            var offsetAnimation = animation.drive(tween);
            return SlideTransition(position: offsetAnimation, child: child);
          },
          transitionDuration: Duration(milliseconds: 700),
        );
}
