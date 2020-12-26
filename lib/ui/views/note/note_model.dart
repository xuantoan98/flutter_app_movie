import 'package:flutter/material.dart';

class Note {
  String id =
      UniqueKey().hashCode.toUnsigned(20).toRadixString(16).padLeft(5, '0');

  String title;
  String desc;
  bool isDeleted = false;

  Note(this.title, this.desc);

  static String get tableName => 'Notes';

  static String get createTable =>
      'CREATE TABLE $tableName(`id` TEXT PRIMARY KEY,'
      ' `title` TEXT,'
      ' `desc` TEXT,'
      ' `isDeleted` INTEGER DEFAULT 0)';

  static List<Note> fromList(List<Map<String, dynamic>> query) {
    List<Note> items = List<Note>();
    for (Map map in query) {
      items.add(Note.fromMap(map));
    }
    return items;
  }

  Note.fromMap(Map data)
      : id = data['id'],
        title = data['title'],
        desc = data['desc'],
        isDeleted = data['isDeleted'] == 1 ? true : false;
  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'desc': desc,
        'isDeleted': isDeleted ? 1 : 0,
      };
}
