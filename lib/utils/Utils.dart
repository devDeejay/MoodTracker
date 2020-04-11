import 'package:flutter/cupertino.dart';
import 'package:moodtracker/model/UserLog.dart';
import 'package:intl/intl.dart';

import 'constants.dart';

String getEmoticonToPopulate(CapturedEmotion capturedEmotion) {
  int emotionValue = capturedEmotion.capturedEmotionValue;

  if (emotionValue == 1) {
    return "assets/images/very_sad.png";
  } else if (emotionValue == 2) {
    return "assets/images/sad.png";
  } else if (emotionValue == 3) {
    return "assets/images/meh.png";
  } else if (emotionValue == 4) {
    return "assets/images/smile.png";
  } else if (emotionValue == 5) {
    return "assets/images/happy.png";
  } else {
    return "";
  }
}

String getTimeAgo(CapturedEmotion capturedEmotion) {
  int timeStamp = capturedEmotion.timeStamp;
  DateTime previousDateTime = DateTime.fromMillisecondsSinceEpoch(timeStamp);
  Duration diff = DateTime.now().difference(previousDateTime);
  if (diff.inDays > 365)
    return "${(diff.inDays / 365).floor()} ${(diff.inDays / 365).floor() == 1 ? "Y" : "Y"}";
  if (diff.inDays > 30)
    return "${(diff.inDays / 30).floor()} ${(diff.inDays / 30).floor() == 1 ? "M" : "M"}";
  if (diff.inDays > 7)
    return "${(diff.inDays / 7).floor()} ${(diff.inDays / 7).floor() == 1 ? "w" : "w"}";
  if (diff.inDays > 0) return "${diff.inDays} ${diff.inDays == 1 ? "d" : "d"}";
  if (diff.inHours > 0)
    return "${diff.inHours} ${diff.inHours == 1 ? "h" : "h"}";
  if (diff.inMinutes > 0)
    return "${diff.inMinutes}${diff.inMinutes == 1 ? "m" : "m"}";
  return "0m";
}

buildImage(String path, double size, [Function onPressed]) {
  return GestureDetector(
    onTap: onPressed,
    child: Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(path),
          fit: BoxFit.cover,
        ),
      ),
    ),
  );
}

Container buildMoodEmoticon(CapturedEmotion capturedEmotion, double size) {
  return Container(
    width: size,
    height: size,
    decoration: BoxDecoration(
      image: DecorationImage(
        image: AssetImage(getEmoticonToPopulate(capturedEmotion)),
        fit: BoxFit.cover,
      ),
    ),
  );
}

Widget buildTimeAgo(CapturedEmotion capturedEmotion, double textSize) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      Text(
        getTimeAgo(capturedEmotion),
        textAlign: TextAlign.start,
        style: TextStyle(
            fontSize: textSize,
            color: kLightWhiteColor,
            fontWeight: FontWeight.w700),
      ),
      Text(
        "ago",
        textAlign: TextAlign.start,
        style: TextStyle(
            height: 0.5,
            color: kLightWhiteColor,
            fontWeight: FontWeight.bold,
            fontSize: 32),
      )
    ],
  );
}

String getDate(int timeStamp) {
  DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timeStamp);
  var formatter = new DateFormat('dd MMM yyyy');
  String formatted = formatter.format(dateTime);
  return formatted;
}

String getTime(int timeStamp) {
  DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timeStamp);

  String hour = dateTime.hour < 10
      ? "0" + dateTime.hour.toString()
      : dateTime.hour.toString();
  String minute = dateTime.minute < 10
      ? "0" + dateTime.minute.toString()
      : dateTime.minute.toString();
  String period = dateTime.hour < 12 ? "am" : "pm";

  return hour + ":" + minute + " " + period;
}
