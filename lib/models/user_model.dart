import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'user_model.g.dart';

@HiveType(typeId: 0)
class User {
  User({@required this.name, @required this.email});

  @HiveField(1)
  final String email;

  @HiveField(2)
  final String name;
}
