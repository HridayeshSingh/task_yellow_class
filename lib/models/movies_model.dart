import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'movies_model.g.dart';

@HiveType(typeId: 1)
class Movies {
  Movies(
      {@required this.movieName,
      @required this.directorName,
      @required this.coverPhotoPath});

  @HiveField(0)
  final String movieName;

  @HiveField(1)
  final String directorName;

  @HiveField(2)
  final String coverPhotoPath;
}
