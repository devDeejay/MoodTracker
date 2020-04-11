import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moodtracker/model/UserLog.dart';
import 'package:moodtracker/ui/quiz/QuizScreen.dart';
import 'package:moodtracker/ui/quiz/QuizScreenBloc.dart';
import 'package:moodtracker/utils/Utils.dart';
import 'package:moodtracker/utils/constants.dart';

class DisplayUserLogScreen extends StatefulWidget {
  CapturedEmotion capturedEmotion;

  DisplayUserLogScreen(this.capturedEmotion);

  @override
  _DisplayUserLogScreenState createState() => _DisplayUserLogScreenState();
}

class _DisplayUserLogScreenState extends State<DisplayUserLogScreen> {
  @override
  Widget build(BuildContext buildContext) {
    return Scaffold(
      backgroundColor: kPrimaryColor,
      body: buildBody(buildContext),
    );
  }

  Container buildBody(BuildContext buildContext) {
    return Container(
      child: ListView(
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(40, 16, 16, 16),
                child: buildImage("assets/images/previous_icon.png", 40, () {
                  Navigator.pop(buildContext, widget.capturedEmotion);
                }),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(40, 16, 16, 16),
                child: Text(
                  "Viewing Log",
                  style: TextStyle(
                      fontSize: 32,
                      color: kPrimaryColorDark,
                      fontWeight: FontWeight.w700),
                ),
              ),
              buildViewLogRow(),
              SizedBox(
                height: 16,
              ),
              Container(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          widget.capturedEmotion.isDeleted = true;
                          Navigator.pop(context, widget.capturedEmotion);
                        },
                        child: Icon(
                          Icons.delete,
                          color: Colors.white,
                          size: 48,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          openQuizScreen(context);
                        },
                        child: Icon(
                          Icons.edit,
                          color: Colors.white,
                          size: 48,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Clipboard.setData(ClipboardData(
                              text:
                                  "Hey, here is the log I wanted to share with you, I was feeling ${getEmotionName(widget.capturedEmotion)}${getEmotionMessage(widget.capturedEmotion)} ${getTimeAgo(widget.capturedEmotion)} ago!"));

                          Scaffold.of(buildContext).showSnackBar(SnackBar(
                            content: Text(
                              "Copied to Clipboard, share with some app",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 16.0, fontWeight: FontWeight.bold),
                            ),
                            duration: Duration(seconds: 2),
                            backgroundColor: Colors.red,
                          ));
                        },
                        child: Icon(
                          Icons.share,
                          color: Colors.white,
                          size: 48,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 16,
              ),
              buildStatisticsWidget(),
            ],
          )
        ],
      ),
    );
  }

  openQuizScreen(BuildContext context) async {
    CapturedEmotion newCapturedEmotion =
        await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return buildQuizScreen();
    }));

    if (newCapturedEmotion != null) {
      setState(() {
        this.widget.capturedEmotion = newCapturedEmotion;
      });
    }
  }

  BlocProvider<QuizScreenBloc> buildQuizScreen() {
    return BlocProvider<QuizScreenBloc>(
      create: (context) => QuizScreenBloc(),
      child: QuizScreen(this.widget.capturedEmotion),
    );
  }

  Widget buildViewLogRow() {
    return Row(
      children: <Widget>[
        Expanded(
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(56),
                  bottomRight: Radius.circular(56),
                ),
                color: kPrimaryBackgroundColor),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 32, 56, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 8,
                  ),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        buildMoodEmoticon(widget.capturedEmotion, 80),
                        SizedBox(
                          width: 16,
                        ),
                        buildTimeAgo(widget.capturedEmotion, 52),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                    (widget.capturedEmotion.capturedMessage == null ||
                            widget.capturedEmotion.capturedMessage.isEmpty)
                        ? "You did't shared much..."
                        : widget.capturedEmotion.capturedMessage,
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w700),
                  )
                ],
              ),
            ),
          ),
        ),
        SizedBox(
          width: 80,
        )
      ],
    );
  }

  Widget buildStatisticsWidget() {
    return Row(
      children: <Widget>[
        SizedBox(
          width: 80,
        ),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(56),
                  bottomLeft: Radius.circular(56),
                ),
                color: kPrimaryBackgroundColor),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(56, 32, 32, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Date",
                    style: kBoldLabelStyle,
                  ),
                  Text(
                    getDate(widget.capturedEmotion.timeStamp),
                    style: kDisplayTextStyle,
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                    "Time",
                    style: kBoldLabelStyle,
                  ),
                  Text(
                    getTime(widget.capturedEmotion.timeStamp),
                    style: kDisplayTextStyle,
                  ),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }

  String getEmotionName(CapturedEmotion capturedEmotion) {
    switch (capturedEmotion.capturedEmotionValue) {
      case 1:
        return "Sad";
        break;
      case 2:
        return "Annoyed";
        break;
      case 3:
        return "Just okay";
        break;
      case 4:
        return "Good";
        break;
      case 5:
        return "Happy";
        break;
    }
    return "";
  }

  String getEmotionMessage(CapturedEmotion capturedEmotion) {
    if (capturedEmotion.capturedMessage != null ||
        capturedEmotion.capturedMessage.isNotEmpty) {
      return "";
    } else {
      return " because ${capturedEmotion.capturedMessage} ";
    }
  }
}
