import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:moodtracker/di/DependencyInjector.dart';
import 'package:moodtracker/model/UserLog.dart';
import 'package:moodtracker/ui/display_user_log/DisplayUserLogScreen.dart';
import 'package:moodtracker/ui/all_logs/UserLogsRepository.dart';
import 'package:moodtracker/ui/all_logs//UserLogsViewModel.dart';
import 'package:moodtracker/utils/Utils.dart';
import 'package:moodtracker/utils/constants.dart';
import 'package:provider_architecture/viewmodel_provider.dart';

class UserLogsScreen extends StatelessWidget {
  final List<CapturedEmotion> listOfCapturedEmotions;
  UserLogsScreenViewModel userLogsViewModel;
  int activeEmotionTag;

  UserLogsScreen(this.listOfCapturedEmotions);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor,
      body: SafeArea(child: buildBody()),
    );
  }

  Widget buildBody() {
    return ViewModelProvider<UserLogsScreenViewModel>.withConsumer(
        viewModel: UserLogsScreenViewModel(
            listOfCapturedEmotions.reversed.toList(),
            dependencyInjector.get<UserLogsRepository>()),
        builder: (context, viewModel, child) {
          userLogsViewModel = viewModel;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: 100,
                child: Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(40, 8, 0, 16),
                      child: buildImage("assets/images/close_icon.png", 32, () {
                        Navigator.pop(context,
                            viewModel.listOfUserLogs.reversed.toList());
                      }),
                    )
                  ],
                ),
              ),
              Expanded(child: HorizontalPageView(viewModel)),
            ],
          );
        });
  }
}

class HorizontalPageView extends StatefulWidget {
  final UserLogsScreenViewModel viewModel;

  HorizontalPageView(this.viewModel);

  @override
  _HorizontalPageViewState createState() => _HorizontalPageViewState();
}

class _HorizontalPageViewState extends State<HorizontalPageView> {
  final PageController pageController = PageController(viewportFraction: 0.8);
  int activeCurrentEmotionTag;
  int currentPage = 0;

  @override
  void initState() {
    pageController.addListener(() {
      int next = pageController.page.round();
      if (currentPage != next) {
        setState(() {
          currentPage = next;
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: PageView.builder(
          itemCount: widget.viewModel.listOfUserLogs.length + 1,
          controller: pageController,
          itemBuilder: (context, int currentIndex) {
            if (currentIndex == 0) {
              return _buildInitialPage();
            } else if (widget.viewModel.listOfUserLogs.length >= currentIndex) {
              bool active = currentIndex == currentPage;
              return _buildStoryPage(
                  widget.viewModel.listOfUserLogs[currentIndex - 1], active,
                  () {
                openDisplayUserLogScreen(currentIndex - 1);
              });
            } else {
              return null;
            }
          }),
    );
  }

  Widget _buildInitialPage() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        buildImage("assets/images/happy.png", 120),
        SizedBox(
          height: 24,
        ),
        Text(
          "Your logs",
          style: TextStyle(
              fontSize: 56, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(32, 8, 32, 8),
          child: Text(
            "Here is what all you have logged so far. \n\nSwipe left to see more >",
            style: TextStyle(
                color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        )
      ],
    );
  }

  Widget _buildStoryPage(
      CapturedEmotion capturedEmotion, bool active, Function onTap) {
    final double blur = active ? 32 : 0;
    final double offset = active ? 8 : 0;
    final double top = active ? 56 : 100;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        height: MediaQuery.of(context).size.height,
        duration: Duration(microseconds: 2000),
        curve: Curves.easeIn,
        margin: EdgeInsets.only(top: top, bottom: 50, right: 30),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: kPrimaryColor,
            boxShadow: [
              BoxShadow(
                  color: Colors.black26.withOpacity(0.2),
                  blurRadius: blur,
                  offset: Offset(offset, offset)),
              BoxShadow(
                  color: Colors.white.withOpacity(0.4),
                  blurRadius: blur,
                  offset: Offset(-offset, -offset))
            ]),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  buildMoodEmoticon(capturedEmotion, 104),
                  SizedBox(
                    width: 16,
                  ),
                  buildTimeAgo(capturedEmotion, 56)
                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(32, 16, 32, 16),
                child: Text(
                  capturedEmotion.capturedMessage.isEmpty
                      ? "You didn't shared much"
                      : capturedEmotion.capturedMessage,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w700),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  openDisplayUserLogScreen(int index) async {
    CapturedEmotion capturedEmotionToDisplay =
        widget.viewModel.listOfUserLogs[index];

    CapturedEmotion updatedEmotion = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                DisplayUserLogScreen(capturedEmotionToDisplay)));

    if (updatedEmotion != null) {
      if (updatedEmotion.isDeleted) {
        widget.viewModel.deleteWidget(index);
      } else
        widget.viewModel.listOfUserLogs[index] = updatedEmotion;
    }
  }
}
