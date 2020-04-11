import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:moodtracker/model/UserLog.dart';

/// Events

class QuizScreenEvents extends Equatable {
  @override
  List<Object> get props => null;
}

class OpenFirstQuizPage extends QuizScreenEvents {}

class OpenSecondQuizPage extends QuizScreenEvents {}

class SaveUserQuiz extends QuizScreenEvents {}

/// States

class QuizScreenState extends Equatable {
  @override
  List<Object> get props => [];
}

class ShowFirstQuizPage extends QuizScreenState {}

class ShowSecondQuizPage extends QuizScreenState {}

class SavedUserQuiz extends QuizScreenState {
  final CapturedEmotion capturedEmotion;
  SavedUserQuiz(this.capturedEmotion);
}

/// BLoC

class QuizScreenBloc extends Bloc<QuizScreenEvents, QuizScreenState> {
  CapturedEmotion capturedEmotion = CapturedEmotion(null, "", null);

  @override
  QuizScreenState get initialState => ShowFirstQuizPage();

  @override
  Stream<QuizScreenState> mapEventToState(QuizScreenEvents event) async* {
    if (event is OpenSecondQuizPage) {
      yield ShowSecondQuizPage();
    } else if (event is SaveUserQuiz) {
      capturedEmotion.timeStamp = DateTime.now().millisecondsSinceEpoch;
      yield SavedUserQuiz(capturedEmotion);
    } else if (event is OpenFirstQuizPage) {
      yield ShowFirstQuizPage();
    } else if (event is OpenSecondQuizPage) {
      yield ShowSecondQuizPage();
    }
  }
}
