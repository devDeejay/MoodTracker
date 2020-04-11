import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moodtracker/di/DependencyInjector.dart';
import 'package:moodtracker/model/UserLog.dart';
import 'package:moodtracker/ui/all_logs/UserLogsScreen.dart';
import 'package:moodtracker/ui/display_user_log/DisplayUserLogScreen.dart';
import 'package:moodtracker/ui/home/HomeRepository.dart';
import 'package:moodtracker/ui/home/HomeScreenViewModel.dart';
import 'package:moodtracker/ui/quiz/QuizScreen.dart';
import 'package:moodtracker/ui/quiz/QuizScreenBloc.dart';
import 'package:moodtracker/utils/Utils.dart';
import 'package:moodtracker/utils/constants.dart';
import 'package:provider_architecture/provider_architecture.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  HomeScreenViewModel homeScreenViewModel;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: kPrimaryColor,
      child: SafeArea(
        child: ViewModelProvider<HomeScreenViewModel>.withConsumer(
          viewModel: HomeScreenViewModel(
              dependencyInjector.get<HomeScreenRepository>()),
          builder: (context, viewModel, child) {
            homeScreenViewModel = viewModel;
            return Scaffold(
              backgroundColor: kPrimaryColor,
              body: buildBody(),
              bottomNavigationBar: buildBottomNavigationBar(),
            );
          },
        ),
      ),
    );
  }

  Widget buildBody() {
    return ListView(children: <Widget>[
      Container(
        color: kPrimaryColor,
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 8,
              ),
              buildGreetUserWidget(),
              SizedBox(
                height: 8,
              ),
              buildStatisticsRow(),
              SizedBox(
                height: 32,
              ),
              buildLogsRow(),
              SizedBox(
                height: 8,
              )
            ]),
      ),
    ]);
  }

  static BlocProvider<QuizScreenBloc> buildQuizScreen() {
    return BlocProvider<QuizScreenBloc>(
      create: (context) => QuizScreenBloc(),
      child: QuizScreen(),
    );
  }

  BottomNavigationBar buildBottomNavigationBar() {
    return BottomNavigationBar(
      backgroundColor: kPrimaryColor,
      elevation: 0,
      onTap: (newIndex) => {
        setState(() => _currentIndex = newIndex),
        if (newIndex == 1) {openQuizScreen()}
      },
      currentIndex: _currentIndex,
      items: [
        BottomNavigationBarItem(
          icon: Icon(
            Icons.home,
            color: Colors.white,
            size: 40,
          ),
          title: buildSelectedText(0),
        ),
        BottomNavigationBarItem(
            icon: Icon(
              Icons.add_circle,
              color: Colors.white,
              size: 40,
            ),
            title: buildSelectedText(1)),
        BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
              color: Colors.white,
              size: 40,
            ),
            title: buildSelectedText(2)),
      ],
    );
  }

  Text buildSelectedText(int index) {
    return Text(
      "●",
      style: TextStyle(
          color: _currentIndex == index ? kPrimaryColorDark : kPrimaryColor,
          fontWeight: FontWeight.w800,
          fontSize: 24,
          height: 0.6),
    );
  }

  Widget buildStatisticsRow() {
    return Row(
      children: <Widget>[buildStatisticsLabel(), buildStatisticsWidget()],
    );
  }

  Expanded buildStatisticsWidget() {
    return Expanded(
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
                "You have made",
                style: kBoldLabelStyle,
              ),
              Text(
                "${homeScreenViewModel.listOfCapturedEmotions.length} logs",
                style: kDisplayTextStyle,
              ),
              SizedBox(
                height: 8,
              ),
              Text(
                "In the past",
                style: kBoldLabelStyle,
              ),
              Text(
                "24 hours",
                style: kDisplayTextStyle,
              ),
              SizedBox(
                height: 8,
              ),
              FlatButton(
                shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(16.0),
                ),
                color: kButtonLightWhiteColor,
                onPressed: () {
                  openUserLogsScreen();
                },
                child: Container(
                    child: Padding(
                  padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
                  child: Text(
                    "See all logs",
                    style: TextStyle(
                        fontSize: 20,
                        color: Color(0xFF1B708E),
                        fontWeight: FontWeight.w800),
                  ),
                )),
              )
            ],
          ),
        ),
      ),
    );
  }

  RotatedBox buildStatisticsLabel() {
    return RotatedBox(
      quarterTurns: 3,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 40, 0, 24),
        child: Text(
          "Statistics",
          style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: kPrimaryColorDark),
        ),
      ),
    );
  }

  Container buildLogsRow() {
    return Container(
      child: Row(
        children: <Widget>[
          buildLogsWidget(),
          RotatedBox(
            quarterTurns: 1,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 24, 0, 24),
              child: Text(
                "Logs",
                style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: kPrimaryColorDark),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Expanded buildLogsWidget() {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(56),
              bottomRight: Radius.circular(56),
            ),
            color: kPrimaryBackgroundColor),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 32, 56, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Text(
                "Your latest log",
                style: kBoldLabelStyle,
                textAlign: TextAlign.end,
              ),
              SizedBox(
                height: 8,
              ),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Container(
                        width: 140,
                        child: Text(
                          getMessageToPopulate(),
                          style: TextStyle(
                              fontSize: 24,
                              color: Colors.white,
                              fontWeight: FontWeight.w800),
                          textAlign: TextAlign.end,
                        )),
                    SizedBox(
                      width: 8,
                    ),
                    Column(
                      children: <Widget>[
                        buildLatestMoodEmoticon(),
                        buildHoursAgo()
                      ],
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 8,
              ),
              FlatButton(
                shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(16.0),
                ),
                color: kButtonLightWhiteColor,
                onPressed: () async {
                  await openDisplayLatestLogScreen();
                },
                child: Container(
                    child: Padding(
                  padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
                  child: Text(
                    "View more",
                    style: TextStyle(
                        fontSize: 20,
                        color: Color(0xFF1B708E),
                        fontWeight: FontWeight.w800),
                  ),
                )),
              )
            ],
          ),
        ),
      ),
    );
  }

  Text buildHoursAgo() {
    return Text(
      getTimeAgo(homeScreenViewModel.getLatestCapturedEmotion()),
      style: TextStyle(
          fontSize: 28, color: kLightWhiteColor, fontWeight: FontWeight.w800),
    );
  }

  Container buildLatestMoodEmoticon() {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(getEmoticonToPopulate(
              homeScreenViewModel.getLatestCapturedEmotion())),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Column buildGreetUserWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
          child: Text(
            'Hi',
            style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w700,
                color: Colors.white.withOpacity(0.6)),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
          child: Text(
            'There!',
            style: TextStyle(
                fontSize: 40, fontWeight: FontWeight.w800, color: Colors.white),
          ),
        ),
      ],
    );
  }

  openQuizScreen() async {
    CapturedEmotion capturedEmotion =
        await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return buildQuizScreen();
    }));

    if (capturedEmotion != null) {
      homeScreenViewModel.addEmotion(capturedEmotion);
      print(
          "${homeScreenViewModel.getLatestCapturedEmotion().capturedEmotionValue}");
      homeScreenViewModel.saveDataOffline();
      homeScreenViewModel.readDataFromOffline();
    }
  }

  openUserLogsScreen() async {
    List<CapturedEmotion> listOfUpdatedList =
        await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return UserLogsScreen(homeScreenViewModel.listOfCapturedEmotions);
    }));

    if (listOfUpdatedList != null) {
      homeScreenViewModel.updateList(listOfUpdatedList);
      homeScreenViewModel.saveDataOffline();
      homeScreenViewModel.readDataFromOffline();
    }
  }

  openDisplayLatestLogScreen() async {
    CapturedEmotion newCapturedEmotion = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => DisplayUserLogScreen(
                homeScreenViewModel.getLatestCapturedEmotion())));

    if (newCapturedEmotion != null) {
      if (newCapturedEmotion.isDeleted) {
        homeScreenViewModel.deleteLatestLog();
      } else
        homeScreenViewModel.updateLatestLog(newCapturedEmotion);
    }
  }

  String getMessageToPopulate() {
    String message =
        homeScreenViewModel.getLatestCapturedEmotion().capturedMessage;
    if (message != null && message.length < 35) {
      return message;
    } else if (message == null || message.isEmpty) {
      return "You didn't shared much...";
    } else {
      return message.substring(0, 35) + "..";
    }
  }
}
