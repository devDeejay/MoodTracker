import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moodtracker/model/UserLog.dart';
import 'package:moodtracker/ui/quiz/QuizScreenBloc.dart';
import 'package:moodtracker/utils/Utils.dart';
import 'package:moodtracker/utils/constants.dart';

class QuizScreen extends StatefulWidget {
  CapturedEmotion capturedEmotion;

  @override
  _QuizScreenState createState() => _QuizScreenState();

  QuizScreen([this.capturedEmotion]);
}

class _QuizScreenState extends State<QuizScreen> {
  QuizScreenBloc quizScreenBloc;

  @override
  void dispose() {
    quizScreenBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    quizScreenBloc = BlocProvider.of<QuizScreenBloc>(context);
    if (widget.capturedEmotion != null) {
      quizScreenBloc.capturedEmotion = widget.capturedEmotion;
    }
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      backgroundColor: kPrimaryColor,
      body: SafeArea(
        child: BlocBuilder<QuizScreenBloc, QuizScreenState>(
          builder: (context, state) {
            return AnimatedSwitcher(
                duration: Duration(milliseconds: 250),
                switchOutCurve: Threshold(0),
                child: buildBlocScreen(state, context));
          },
        ),
      ),
    );
  }

  Widget buildBlocScreen(QuizScreenState state, BuildContext context) {
    if (state is ShowFirstQuizPage) {
      return buildFirstQuizPage();
    } else if (state is ShowSecondQuizPage) {
      return buildSecondQuizPage();
    } else if (state is SavedUserQuiz) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        Navigator.pop(context, state.capturedEmotion);
      });
    }
    return Container();
  }

  Widget buildFirstQuizPage() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Expanded(
          flex: 1,
          child: Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(40, 8, 0, 16),
                child: buildImage("assets/images/close_icon.png", 32, () {
                  Navigator.pop(context);
                }),
              )
            ],
          ),
        ),
        Expanded(
          flex: 8,
          child: Container(
            child: Column(
              children: <Widget>[
                Text(
                  "How do you feel?",
                  style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                      color: Colors.white),
                ),
                SizedBox(
                  height: 16,
                ),
                Column(
                  children: <Widget>[
                    _buildEmotionImageContainer("assets/images/happy.png", 5,
                        () {
                      setSelectedEmotion(5);
                    }),
                    _buildEmotionImageContainer("assets/images/smile.png", 4,
                        () {
                      setSelectedEmotion(4);
                    }),
                    _buildEmotionImageContainer("assets/images/meh.png", 3, () {
                      setSelectedEmotion(3);
                    }),
                    _buildEmotionImageContainer("assets/images/sad.png", 2, () {
                      setSelectedEmotion(2);
                    }),
                    _buildEmotionImageContainer("assets/images/very_sad.png", 1,
                        () {
                      setSelectedEmotion(1);
                    }),
                  ],
                )
              ],
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 40, 8),
                child:
                    quizScreenBloc.capturedEmotion.capturedEmotionValue != null
                        ? buildImage("assets/images/next_icon.png", 40, () {
                            quizScreenBloc.add(OpenSecondQuizPage());
                          })
                        : Container(
                            width: 40,
                            height: 40,
                          ),
              )
            ],
          ),
        )
      ],
    );
  }

  Widget buildSecondQuizPage() {
    return Container(
      width: MediaQuery.of(context).size.width,
      color: kPrimaryColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(40, 8, 0, 24),
                child: buildImage("assets/images/previous_icon.png", 40, () {
                  quizScreenBloc.add(OpenFirstQuizPage());
                }),
              )
            ],
          ),
          Expanded(
            child: Container(
              child: Column(
                children: <Widget>[
                  Text(
                    "What's going on?",
                    style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w800,
                        color: Colors.white),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(56, 8, 56, 16),
                        child: Container(
                          height: 400,
                          decoration: BoxDecoration(
                              color: kButtonLightWhiteColor.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(32)),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                            child: Center(
                              child: TextFormField(
                                initialValue: (quizScreenBloc.capturedEmotion
                                                .capturedMessage !=
                                            null &&
                                        quizScreenBloc.capturedEmotion
                                            .capturedMessage.isNotEmpty)
                                    ? quizScreenBloc
                                        .capturedEmotion.capturedMessage
                                    : "",
                                onChanged: (newText) {
                                  quizScreenBloc.capturedEmotion
                                      .capturedMessage = newText;
                                  setState(() {});
                                },
                                minLines: 2,
                                maxLines: 11,
                                maxLength: 120,
                                keyboardType: TextInputType.multiline,
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 32,
                                    color: Colors.white),
                                decoration: InputDecoration.collapsed(
                                    hintText: "Share how do you feel...",
                                    hintStyle: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 24,
                                        color: Colors.white)),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 32, 16),
                child:
                    quizScreenBloc.capturedEmotion.capturedEmotionValue != null
                        ? GestureDetector(
                            onTap: () {
                              quizScreenBloc.add(SaveUserQuiz());
                            },
                            child: Icon(
                              Icons.done,
                              color: Colors.white,
                              size: 40,
                            ),
                          )
                        : Container(
                            width: 40,
                            height: 40,
                          ),
              )
            ],
          )
        ],
      ),
    );
  }

  setSelectedEmotion(int emotionValue) {
    setState(() {
      quizScreenBloc.capturedEmotion.capturedEmotionValue = emotionValue;
    });
  }

  Widget _buildEmotionImageContainer(
      String imagePath, int emotionValue, Function onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: AnimatedContainer(
          duration: Duration(milliseconds: 80),
          width: quizScreenBloc.capturedEmotion.capturedEmotionValue ==
                  emotionValue
              ? 88
              : 72,
          height: quizScreenBloc.capturedEmotion.capturedEmotionValue ==
                  emotionValue
              ? 88
              : 72,
          decoration: BoxDecoration(
            image: DecorationImage(
              colorFilter:
                  quizScreenBloc.capturedEmotion.capturedEmotionValue ==
                          emotionValue
                      ? null
                      : ColorFilter.mode(
                          kPrimaryColor.withOpacity(0.3), BlendMode.dstATop),
              image: AssetImage(imagePath),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
