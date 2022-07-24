import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/animation.dart';

//import 'dart:developer' as developer;

class TextCopy {
  final String text;
  final String id_linha;
  bool select;
  final DateTime time;
  AnimationController? controller;
  Animation<double>? animation;

  TextCopy(
      {required this.text,
      required this.time,
      required this.id_linha,
      //required this.controller,
      //required this.animation,
      this.select = false});

  factory TextCopy.fromJson(Map<String, dynamic> json) => TextCopy(
        text: json['text'] as String,
        id_linha: json['id_linha'] as String,
        time: (json['time'] as Timestamp).toDate(),
      );

  Map<String, dynamic> toJson() => {
        'text': text,
        'time': time,
        'id_linha': id_linha,
      };

  @override
  String toString() {
    return 'TextCopy{text: $text, time: ${setStringTimeId()}';
  }

  /*TextCopy? fromDocFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    //TextCopy? fromDocFirestore(DocumentSnapshot<dynamic> doc) {
    var data = doc.data();
    developer.log(data.toString(), name: 'DOC-FIRE');
    if (data != null) {
      return TextCopy(
        text: data['text'] as String,
        time: (data['time'] as Timestamp).toDate(),
      );
    } else {
      return null;
    }
  }

  factory TextCopy.fromDocFirestore(Map<String, dynamic> data) {
    final texFire = data['text'] as String;
    final timeFire = (data['time'] as Timestamp).toDate();
    final textCopy = TextCopy(
      text: texFire,
      //text: data.text as String,
      time: timeFire,
      //time: (data.time as Timestamp).toDate(),
    );

    //developer.log(textCopy.toString(), name: 'DOC-MODEL-FIRE');
    return textCopy;
  }*/

  String setStringTimeId() {
    return DateTime(
      time.year,
      time.month,
      time.day,
      time.hour,
      time.minute,
      time.second,
    ).toUtc().toIso8601String();
  }

  static String getStringDateHoraTime(String date, int hora, int min) {
    final dateTime = DateTime.parse(date);

    return DateTime(dateTime.year, dateTime.month, dateTime.day, hora, min)
        .toUtc()
        .toIso8601String();
  }

/* Map<String, dynamic> toJson() =>
      {'exame': version, 'timeStamp': timeStamp.toString()};*/

}
