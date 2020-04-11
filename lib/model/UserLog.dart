const String USER_LOG = "userLog";
const String LOG_MESSAGE = "userMessage";
const String LOG_EMOTION = "emotion";
const String LOG_TIMESTAMP = "timestamp";

class UserLog {
  List<CapturedEmotion> listOfUserLogs;

  UserLog({this.listOfUserLogs});

  UserLog.fromJson(Map<String, dynamic> json) {
    if (json[USER_LOG] != null) {
      listOfUserLogs = new List<CapturedEmotion>();
      json[USER_LOG].forEach((v) {
        listOfUserLogs.add(new CapturedEmotion.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.listOfUserLogs != null) {
      data[USER_LOG] = this
          .listOfUserLogs
          .map((emotionValue) => emotionValue.toJson())
          .toList();
    }
    return data;
  }
}

class CapturedEmotion {
  int capturedEmotionValue;
  String capturedMessage;
  int timeStamp;
  bool isDeleted = false;

  CapturedEmotion(
      this.capturedEmotionValue, this.capturedMessage, this.timeStamp,
      [this.isDeleted]);

  CapturedEmotion.fromJson(Map<String, dynamic> json) {
    capturedEmotionValue = json[LOG_EMOTION];
    capturedMessage = json[LOG_MESSAGE];
    timeStamp = json[LOG_TIMESTAMP];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data[LOG_EMOTION] = this.capturedEmotionValue;
    data[LOG_MESSAGE] = this.capturedMessage;
    data[LOG_TIMESTAMP] = this.timeStamp;
    return data;
  }
}
