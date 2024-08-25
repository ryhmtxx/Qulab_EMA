import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter_emoji/flutter_emoji.dart';
// import 'package:http/http.dart' as http;
import 'dart:convert';
import 'api.dart';
import 'RegisterInfo.dart';
import 'Forgetpass.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();


final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

//注册功能
// Future<void> createUser(String email, String password) async {
//   try {
//     final response = await Api.register(email, password);
//     if (response.statusCode == 201) {
//       if (navigatorKey.currentState != null && navigatorKey.currentState!.overlay != null) {
//         showDialog(
//           context: navigatorKey.currentState!.overlay!.context,
//           builder: (context) => AlertDialog(
//             title: Text("Registration Successful"),
//             content: Text("Your account has been created successfully."),
//             actions: <Widget>[
//               TextButton(
//                 onPressed: () {
//                   Navigator.of(context).pop();
//                 },
//                 child: Text('OK'),
//               ),
//             ],
//           ),
//         );
//       }
//     }
//   } catch (e) {
//     print("Error in user registration: $e");
//   }
// }

//登录功能
Future<void> signInUser(String email, String password, BuildContext context) async {
  try {
    final response = await Api.login(email, password);
    final responseData = jsonDecode(response.body);

    if (response.statusCode == 200) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => WelcomePage()),
        (route) => false,
      );
    } else {
      _showDialog(context, 'Error', responseData['message']);
    }
  } catch (e) {
    print("Error in user sign-in: $e");
    _showDialog(context, 'Error', 'An unexpected error occurred');
  }
}

void _showDialog(BuildContext context, String title, String message) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('OK'),
        ),
      ],
    ),
  );
}


//获取现在用户
Future<Map<String, dynamic>?> getCurrentUser() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? userId = prefs.getString('user_id');
  String? email = prefs.getString('email');
  if (userId != null && email != null) {
    return {
      'user_id': userId,
      'email': email,
    };
  }
  return null;
}

// 登出功能
Future<void> signOutUser() async {
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_id');
    await prefs.remove('email');
    print("User signed out successfully.");
  } catch (e) {
    print("Error signing out: $e");
  }
}

Future onDidReceiveNotificationResponse(NotificationResponse notificationResponse) async {
  if (notificationResponse.payload != null) {
    debugPrint('notification payload: ${notificationResponse.payload}');
    final user = await Api.getCurrentUser();
    navigatorKey.currentState?.pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (_) => user != null ? WelcomePage() : AuthPage(),
      ),
      (Route<dynamic> route) => false,
    );
  }
}

Future onSelectNotification(String? payload) async {
  if (payload != null) {
    debugPrint('notification payload: $payload');
    final user = await Api.getCurrentUser();
    navigatorKey.currentState?.pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (_) => user != null ? WelcomePage() : AuthPage(),
      ),
      (Route<dynamic> route) => false,
    );
  }
}

Future<void> createNotificationChannel() async {
  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'daily_notification_channel_id',
    'Daily Notifications',
    description: 'This channel is used for daily reminders',
    importance: Importance.max,
  );

  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  print("Notification Channel Created");
}



//设置问题
List<SurveyQuestion> _questions = [
  SurveyQuestion(
    question: 'How healthy do you feel now?',
    options: ['Not at all', 'A little', 'Somewhat', 'Quite a bit','A lot'],
  ),
  SurveyQuestion(
    question: 'How content do you feel right now? ',
    options: ['Not at all', 'A little', 'Somewhat', 'Quite a bit','A lot'],
  ),
  SurveyQuestion(
    question: 'How tired do you feel right now? ',
    options: ['Not at all', 'A little', 'Somewhat', 'Quite a bit','A lot'],
  ),
  SurveyQuestion(
    question: 'How overwhelmed do you feel right now? ',
    options: ['Not at all', 'A little', 'Somewhat', 'Quite a bit','A lot'],
  ),
  SurveyQuestion(
    question: 'How cheerful do you feel right now? ',
    options: ['Not at all', 'A little', 'Somewhat', 'Quite a bit','A lot'],
  ),
  SurveyQuestion(
    question: 'How lonely do you feel right now? ',
    options: ['Not at all', 'A little', 'Somewhat', 'Quite a bit','A lot'],
  ),
  SurveyQuestion(
    question: 'How sad do you feel right now? ',
    options: ['Not at all', 'A little', 'Somewhat', 'Quite a bit','A lot'],
  ),
  SurveyQuestion(
    question: 'How angry do you feel right now? ',
    options: ['Not at all', 'A little', 'Somewhat', 'Quite a bit','A lot'],
  ),
  SurveyQuestion(
    question: 'How excited do you feel right now? ',
    options: ['Not at all', 'A little', 'Somewhat', 'Quite a bit','A lot'],
  ),
  SurveyQuestion(
    question: 'How worried do you feel right now? ',
    options: ['Not at all', 'A little', 'Somewhat', 'Quite a bit','A lot'],
  ),
  SurveyQuestion(
    question: 'How stressed do you feel right now? ',
    options: ['Not at all', 'A little', 'Somewhat', 'Quite a bit','A lot'],
  ),
  SurveyQuestion(
    question: 'How safe do you feel right now? ',
    options: ['Not at all', 'A little', 'Somewhat', 'Quite a bit','A lot'],
  ),
//   SurveyQuestion(
//     question: 'Which state management solutions do you use?',
//     options: ['Provider', 'Bloc', 'Redux', 'Riverpod'],
//     isMultipleChoice: true,
//   ),
//   SurveyQuestion(
//   question: 'Any additional comments or suggestions?',
//   isOpenEnded: true, // 设置为简答题
// ),
//   Add more questions if needed
];


//定义对应规则
Map<String, int> ascendingRule = {
  'Not at all': 1,
  'A little': 2,
  'Somewhat':3,
  'Quite a bit': 4,
  'A lot': 5,
  //if you feel good, you get a higher number
};

Map<String, int> descendingRule = {
  'Not at all': 5,
  'A little': 4,
  'Somewhat': 3,
  'Quite a bit': 2,
  'A lot': 1,
  //if you feel good, you get a higher number
};

// 定义问题规则映射
Map<String, String> questionRules = {
  'How healthy do you feel now?': 'ascending',
  'How content do you feel right now? ': 'ascending',
  'How tired do you feel right now? ': 'descending',
  'How overwhelmed do you feel right now? ': 'descending',
  'How cheerful do you feel right now? ':'ascending',
  'How lonely do you feel right now? ':'descending',
  'How sad do you feel right now? ':'descending',
  'How angry do you feel right now? ':'descending',
  'How excited do you feel right now? ':'ascending',
  'How worried do you feel right now? ':'descending',
  'How stressed do you feel right now? ':'descending',
  'How safe do you feel right now? ':'ascending',
  // Add other questions and their corresponding rules here
};

int answerToNumeric(String question, String answer) {
  if (questionRules[question] == 'ascending') {
    return ascendingRule[answer] ?? 0;
  } else if (questionRules[question] == 'descending') {
    return descendingRule[answer] ?? 0;
  }
  return 0; // 默认返回值
}


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();

  // 获取设备的 IANA 时区名称
  final String localTimeZone = await FlutterTimezone.getLocalTimezone();

  // 设置 tz.local 为设备的时区
  tz.setLocalLocation(tz.getLocation(localTimeZone));

  await createNotificationChannel();
  var initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
  var initializationSettingsIOS = DarwinInitializationSettings(
    requestAlertPermission: true,
    requestBadgePermission: true,
    requestSoundPermission: true,
    onDidReceiveLocalNotification: (id, title, body, payload) async {
      // 处理IOS前台通知
    },
  );
  var initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsIOS,
  );

  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
  );

  print("FlutterLocalNotificationsPlugin initialized");

  runApp(SurveyApp());
}

class HistoryPage extends StatefulWidget {
  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  String selectedQuestion = _questions[0].question;
  bool showFullHistory = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('History Results'),
      ),
      body: Column(
        children: [
          DropdownButton<String>(
            value: selectedQuestion,
            items: _questions.map((question) {
              return DropdownMenuItem<String>(
                value: question.question,
                child: Text(question.question),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                selectedQuestion = value!;
              });
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Show full history'),
              Switch(
                value: showFullHistory,
                onChanged: (value) {
                  setState(() {
                    showFullHistory = value;
                  });
                },
              ),
            ],
          ),
          Expanded(
            child: FutureBuilder<List<charts.Series<TimeSeriesData, DateTime>>>(
              future: _fetchHistoricalData(selectedQuestion, showFullHistory),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error fetching data: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No data available'));
                } else {
                  List<charts.Series<TimeSeriesData, DateTime>> seriesList = snapshot.data!;
                  DateTime? minDate;
                  
                  if (seriesList.isNotEmpty && seriesList[0].data.isNotEmpty) {
                    minDate = seriesList[0].data.map((data) => data.time).reduce((a, b) => a.isBefore(b) ? a : b);
                  }
                  // print('minDate: $minDate');
                  // print(DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day));
                  final parser = EmojiParser();

                  return charts.TimeSeriesChart(
                    seriesList,
                    animate: true,
                    primaryMeasureAxis: charts.NumericAxisSpec(
                      tickProviderSpec: charts.StaticNumericTickProviderSpec([
                        charts.TickSpec(0, label: 'No data', style: charts.TextStyleSpec(
                          fontSize: 12,
                          color: charts.MaterialPalette.black,
                        )),
                        charts.TickSpec(1, label: parser.emojify(':weary:'), style: charts.TextStyleSpec(
                          fontSize: 23,
                          color: charts.MaterialPalette.black,
                        )),
                        charts.TickSpec(2, label: parser.emojify(':slightly_frowning_face:'), style: charts.TextStyleSpec(
                          fontSize: 23,
                          color: charts.MaterialPalette.black,
                        )),
                        charts.TickSpec(3, label: parser.emojify(':neutral_face:'), style: charts.TextStyleSpec(
                          fontSize: 23,
                          color: charts.MaterialPalette.black,
                        )),
                        charts.TickSpec(4, label: parser.emojify(':slightly_smiling_face:'), style: charts.TextStyleSpec(
                          fontSize: 23,
                          color: charts.MaterialPalette.black,
                        )),
                        charts.TickSpec(5, label: parser.emojify(':grinning:'), style: charts.TextStyleSpec(
                          fontSize: 23,
                          color: charts.MaterialPalette.black,
                        )),
                      ]),
                      viewport: charts.NumericExtents(0, 5),
                      renderSpec: charts.GridlineRendererSpec(
                        labelStyle: charts.TextStyleSpec(
                          fontSize: 12,
                          color: charts.MaterialPalette.black,
                        ),
                      ),
                    ),
                    domainAxis: charts.DateTimeAxisSpec(
                      tickFormatterSpec: charts.AutoDateTimeTickFormatterSpec(
                        day: charts.TimeFormatterSpec(
                          format: 'MM/dd',
                          transitionFormat: 'MM/dd',
                        ),
                        month: charts.TimeFormatterSpec(
                          format: 'MM/dd',
                          transitionFormat: 'MM/dd',
                        ),
                        year: charts.TimeFormatterSpec(
                          format: 'yyyy',
                          transitionFormat: 'yyyy',
                        ),
                      ),
                      tickProviderSpec: showFullHistory && minDate != null
                          ? (minDate != DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day))
                            ? charts.StaticDateTimeTickProviderSpec([
                              charts.TickSpec(minDate),
                              charts.TickSpec(DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day)),
                            ])
                            :charts.DayTickProviderSpec(increments: [1])
                          : charts.DayTickProviderSpec(increments: [1]),
                    ),
                    layoutConfig: charts.LayoutConfig(
                      leftMarginSpec: charts.MarginSpec.fixedPixel(60),
                      topMarginSpec: charts.MarginSpec.fixedPixel(20),
                      rightMarginSpec: charts.MarginSpec.fixedPixel(30),
                      bottomMarginSpec: charts.MarginSpec.fixedPixel(60),
                    ),
                    defaultRenderer: charts.LineRendererConfig(includePoints: true),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<List<charts.Series<TimeSeriesData, DateTime>>> _fetchHistoricalData(String question, bool showFullHistory) async {
    final user = await Api.getCurrentUser();
    if (user == null) {
      print("No user is currently signed in.");
      return [];
    }

    // 映射问题内容到数字编号
    Map<String, int> questionToId = {
      'How healthy do you feel now?': 1,
      'How content do you feel right now? ': 2,
      'How tired do you feel right now? ': 3,
      'How overwhelmed do you feel right now? ': 4,
      'How cheerful do you feel right now? ': 5,
      'How lonely do you feel right now? ': 6,
      'How sad do you feel right now? ': 7,
      'How angry do you feel right now? ': 8,
      'How excited do you feel right now? ': 9,
      'How worried do you feel right now? ': 10,
      'How stressed do you feel right now? ': 11,
      'How safe do you feel right now? ': 12,
      // 添加其他问题
    };

    int? questionId = questionToId[question];
    if (questionId == null) {
      print("Invalid question: $question");
      return [];
    }

    try {
      final results = await Api.fetchHistoricalSurveyResultsFromApi(user['user_id']);

      // print("API results: $results");

      if (results == null || results.isEmpty) {
        print("No survey answers found.");
        return [];
      }

      Map<DateTime, int?> dateToAnswerMap = {};
      List<TimeSeriesData?> data = [];

      results.forEach((dateStr, answers) {
        try {
          // print("Parsing date: $dateStr");
          DateTime fulldate= DateTime.parse(dateStr);
          DateTime date = DateTime(fulldate.year,fulldate.month,fulldate.day);
          if (answers.containsKey(questionId.toString())) {
            final answerStr = answers[questionId.toString()];
            final answer = answerToNumeric(question, answerStr);
            dateToAnswerMap[date] = answer;  // 直接使用解析的date作为key
            // print(dateToAnswerMap);
          }
        } catch (e) {
          print("Error parsing date: $e");
        }
      });

      if (dateToAnswerMap.isEmpty) {
        print("No data points found for the question: $question");
        return [];
      }

      DateTime startDate;
      // DateTime endDate = DateTime.now();
      DateTime endDate = DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day);

      if (showFullHistory) {
        startDate = dateToAnswerMap.keys.first;
        // print(startDate);
        // print(endDate);
      } else {
        startDate = endDate.subtract(Duration(days: 6));
        // print(startDate);
        // print(endDate);
      }

      for (int i = 0; i <= endDate.difference(startDate).inDays; i++) {
        DateTime date = startDate.add(Duration(days: i));
        if (!showFullHistory && date.isAfter(DateTime.now())) break;
        // if(!showFullHistory) break;
        if (dateToAnswerMap.containsKey(date)) {
          int? answer = dateToAnswerMap[date];
          data.add(TimeSeriesData(date, answer));
        } else {
          data.add(TimeSeriesData(date, null));
        }
      }
      // print("Data points: $data");

      if (data.isEmpty) {
        print("No data points found for the question: $question");
      }

      return [
        charts.Series<TimeSeriesData, DateTime>(
          id: 'SurveyResults',
          colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
          domainFn: (TimeSeriesData? data, _) => data!.time,
          measureFn: (TimeSeriesData? data, _) => data!.value,
          data: data.whereType<TimeSeriesData>().toList(),
        )
      ];
    } catch (e) {
      print("Error fetching historical data: $e");
      return [];
    }
  }
}


class TimeSeriesData {
  final DateTime time;
  final int? value;

  TimeSeriesData(this.time, this.value);
}

//欢迎界面(new)
class WelcomePage extends StatefulWidget {
  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> with WidgetsBindingObserver {
  TimeOfDay? _selectedTime;
  // bool _isAppInForeground = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadSavedTime();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    // _isAppInForeground = state == AppLifecycleState.resumed;
  }

  Future<void> _loadSavedTime() async {
    final prefs = await SharedPreferences.getInstance();
    final int? hour = prefs.getInt('notification_hour');
    final int? minute = prefs.getInt('notification_minute');
    if (hour != null && minute != null) {
      setState(() {
        _selectedTime = TimeOfDay(hour: hour, minute: minute);
      });
    }
  }

  Future<void> _saveSelectedTime(TimeOfDay time) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('notification_hour', time.hour);
    await prefs.setInt('notification_minute', time.minute);
  }

  Future<void> _pickTime(BuildContext context) async {
    final TimeOfDay? timeOfDay = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
    );
    if (timeOfDay != null && timeOfDay != _selectedTime) {
      setState(() {
        _selectedTime = timeOfDay;
      });
      await _saveSelectedTime(timeOfDay);
      await scheduleDailyNotification(timeOfDay);
    }
  }

  Future<void> scheduleDailyNotification(TimeOfDay time) async {
    // final now = DateTime.now();
    // final todayAtTime = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    // final tomorrowAtTime = todayAtTime.add(Duration(days: 1));
    // final dateTimeNow = tz.TZDateTime.now(tz.local);
    // final scheduledDate = tz.TZDateTime(tz.local, tomorrowAtTime.year, tomorrowAtTime.month, tomorrowAtTime.day, time.hour, time.minute);
    final now = tz.TZDateTime.now(tz.local);  // 使用 tz.TZDateTime 代替 DateTime
    final todayAtTime = tz.TZDateTime(tz.local, now.year, now.month, now.day, time.hour, time.minute);
    final tomorrowAtTime = todayAtTime.add(Duration(days: 1));

    // 判断当前时间是否早于今天的目标时间，如果是，则计划今天的通知，否则计划明天的
    final scheduledDate = now.isBefore(todayAtTime) ? todayAtTime : tomorrowAtTime;

    // final testScheduledDate = now.add(Duration(minutes: 1));


    var androidDetails = AndroidNotificationDetails(
      'daily_notification_channel_id',
      'daily_notification_channel_name',
      channelDescription: 'channel_description',
      importance: Importance.max,
      priority: Priority.high,
    );
    var iosDetails = DarwinNotificationDetails();
    var platformDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      'It\'s time to check-in!',
      'How was your day?',
      // dateTimeNow.isBefore(todayAtTime) ? tz.TZDateTime.from(todayAtTime, tz.local) : scheduledDate,
      scheduledDate,
      // testScheduledDate,
      platformDetails,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
      androidScheduleMode: AndroidScheduleMode.alarmClock,
    );
    // print(dateTimeNow.isBefore(todayAtTime));
    // print(tz.TZDateTime.now(tz.local));
    // print(DateTime.now());
    print("$now");
    print("Today at time:$todayAtTime");
    print("Tomorrow at time:$tomorrowAtTime");
    // print("Date time now:$dateTimeNow");
    // print("ScheduledDate:$scheduledDate");
    print("Scheduled Notification at $scheduledDate");
    // print("$testScheduledDate");
    print("\n");
  }

  Future<bool> checkIfSurveyCompletedToday(String userId) async {
    final results = await Api.fetchSurveyResultsFromApi(userId, DateTime.now());
    return results != null && results['status'] == 'success' && results['answers'] != null && results['answers'].isNotEmpty;
  }

    void _showSurveyResults(BuildContext context) async {
      final user = await Api.getCurrentUser();
      if (user == null) {
        _noResultsDialog(context);
        return;
      }

      final results = await Api.fetchSurveyResultsFromApi(user['user_id'], DateTime.now());
      if (results != null && results['status'] == 'success' && results['answers'] != null && results['answers'].isNotEmpty) {
        Map<String, dynamic> answers = results['answers'];

        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("Today's Survey Results"),
            content: Container(
              width: double.maxFinite,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    GridView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        childAspectRatio: 1,
                      ),
                      itemCount: _questions.length,
                      itemBuilder: (context, index) {
                        String questionText = _questions[index].question;
                        String answerText = answers[(index + 1).toString()] ?? 'No answer';
                        String keyword = _getKeywordFromQuestion(questionText);
                        String emoji = _getEmojiForAnswer(questionText, answerText, EmojiParser());

                        return Card(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                keyword,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: keyword == 'overwhelmed' ? 19 : 11, // 单独调整某些关键词的字体大小
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                emoji,
                                style: TextStyle(fontSize: 30),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('Close'),
              ),
            ],
          ),
        );
      } else {
        _noResultsDialog(context);
      }
    }

  void _noResultsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("No Results"),
        content: Text("No survey has been completed today."),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

    final Map<String, String> questionKeywords = {
    'How healthy do you feel now?': 'Healthy',
    'How content do you feel right now? ': 'Content',
    'How tired do you feel right now? ': 'Tired',
    'How overwhelmed do you feel right now? ': 'Overwhelmed',
    'How cheerful do you feel right now? ': 'Cheerful',
    'How lonely do you feel right now? ': 'Lonely',
    'How sad do you feel right now? ': 'Sad',
    'How angry do you feel right now? ': 'Angry',
    'How excited do you feel right now? ': 'Excited',
    'How worried do you feel right now? ': 'Worried',
    'How stressed do you feel right now? ': 'Stressed',
    'How safe do you feel right now? ': 'Safe',
  };

  String _getKeywordFromQuestion(String question) {
    return questionKeywords[question] ?? 'unknown';
  }

  String _getEmojiForAnswer(String question, String answer, EmojiParser parser) {
    int numericValue = answerToNumeric(question, answer);
    switch (numericValue) {
      case 1:
        return parser.emojify(':weary:');
      case 2:
        return parser.emojify(':slightly_frowning_face:');
      case 3:
        return parser.emojify(':neutral_face:');
      case 4:
        return parser.emojify(':slightly_smiling_face:');
      case 5:
        return parser.emojify(':grinning:');
      default:
        return '';
    }
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome to the Survey'),
      ),
      body: Column(
        children: [
          SizedBox(height: 80), // 设置与顶部的间距
          ElevatedButton(
            onPressed: () => _pickTime(context),
            child: Text('Set Daily Survey Time'),
          ),
          Spacer(), // 使用Spacer将中间的三个按钮居中
          ElevatedButton(
            onPressed: () async {
              final user = await Api.getCurrentUser();
              if (user != null) {
                bool alreadyCompleted = await checkIfSurveyCompletedToday(user['user_id']);
                if (alreadyCompleted) {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text("Survey Already Completed"),
                      content: Text("You have already completed the survey today."),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text('OK'),
                        ),
                      ],
                    ),
                  );
                } else {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => SurveyPage()));
                }
              }
            },
            child: Text('To the Survey Page'),
          ),
          SizedBox(height: 50),
          ElevatedButton(
            onPressed: () => _showSurveyResults(context),
            child: Text('View Today\'s Survey Results'),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => HistoryPage())),
            child: Text('View History Results'),
          ),
          Spacer(), // 另一个Spacer用于调整与底部的间距
          Padding(
            padding: const EdgeInsets.only(bottom: 40.0), // 调整与底部的间距
            child: ElevatedButton(
              onPressed: () {
                signOutUser().then((_) {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => AuthPage()),
                    (Route<dynamic> route) => false,
                  );
                }).catchError((error) {
                  print("Failed to sign out: $error");
                });
              },
              child: Text('Log Out'),
            ),
          ),
          Container(
            height: 80.0, // 固定容器的高度
            alignment: Alignment.bottomCenter, // 控制文本的位置
            padding: const EdgeInsets.only(bottom: 35.0), // 调整底部的间距
            child: Text(
              'If you encounter any issues with the app.\nPlease email us at yanqulab@gmail.com',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}

class AuthPage extends StatefulWidget {
  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscureText = true;

  void _testDbConnection() async {
    try {
      final response = await Api.testDbConnection();
      if (response.statusCode == 200) {
        final result = json.decode(response.body);
        _showDialog(context, 'Success', result['message']);
      } else {
        final result = json.decode(response.body);
        _showDialog(context, 'Error', result['message']);
      }
    } catch (e) {
      _showDialog(context, 'Error', e.toString());
    }
  }

  void _showDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Qu_lab_EMA')),
      resizeToAvoidBottomInset: false, // 防止布局在键盘弹出时调整
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegisterPage()),
                );
              },
              child: Text('Register From here'),
            ),
            SizedBox(height: 40),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureText ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: _togglePasswordVisibility,
                ),
              ),
              obscureText: _obscureText,
            ),
            SizedBox(height: 40),
            // ElevatedButton(
            //   onPressed: _testDbConnection,
            //   child: Text('Test DB Connection'),
            // ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ForgotPasswordPage()),
                );
              },
              child: Text('Forgot Password?'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                signInUser(_emailController.text, _passwordController.text, context);
              },
              child: Text('Login'),
            ),
            Spacer(), // 将以下文本推到页面底部
            Padding(
              padding: EdgeInsets.only(bottom: 10.0), // 调整与底部的间隔
              child: Text(
                'If you encounter any issues with the app\nPlease email us at yanqulab@gmail.com',
                style: TextStyle(fontSize: 16), // 可以调整字体大小
                textAlign: TextAlign.center, // 文本内容居中
              ),
            ),
          ],
        ),
      ),
    );
  }
}

              


class SurveyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      home: FutureBuilder<Map<String, dynamic>?>(
        future: Api.getCurrentUser(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.data == null) {
              return AuthPage();
            }
            return WelcomePage();
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

class SurveyQuestion {
  final String question;
  final List<String> options;
  final bool isMultipleChoice;
  final bool isOpenEnded;

  SurveyQuestion({
    required this.question,
    this.options = const [],
    this.isMultipleChoice = false,
    this.isOpenEnded = false,
  });
}

class SurveyPage extends StatefulWidget {
  @override
  _SurveyPageState createState() => _SurveyPageState();
}

class _SurveyPageState extends State<SurveyPage> {
  int _currentQuestionIndex = 0;
  Map<int, dynamic> _answers = {};

  void _printSortedAnswers() {
    var sortedKeys = _answers.keys.toList()..sort();
    var sortedAnswers = {for (var key in sortedKeys) key: _answers[key]};
    print('Sorted Survey answers: $sortedAnswers');
  }

  void _nextQuestion() {
    if (_currentQuestionIndex < _questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
      });
    } else {
      if (_allQuestionsAnswered()) {
        _printSortedAnswers();
        _showCompletionDialog();
      } else {
        _showUnansweredQuestionsAlert();
      }
    }
  }

  void _prevQuestion() {
    if (_currentQuestionIndex > 0) {
      setState(() {
        _currentQuestionIndex--;
      });
    }
  }

  bool _allQuestionsAnswered() {
    for (var i = 0; i < _questions.length; i++) {
      if (_answers[i] == null || (_answers[i] is Set<String> && _answers[i].isEmpty)) {
        return false;
      }
      if (_questions[i].isOpenEnded && _answers[i].trim().isEmpty) {
        return false;
      }
    }
    return true;
  }

  void _showUnansweredQuestionsAlert() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Incomplete Survey'),
        content: Text('Please answer all the questions before submitting.'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Survey Completed'),
        content: Text('Congratulations, you have completed today\'s survey!'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              saveSurveyResultsToApi(_answers);
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentQuestion = _questions[_currentQuestionIndex];
    dynamic currentAnswer = _answers[_currentQuestionIndex];

    TextEditingController? textController;
    if (currentQuestion.isOpenEnded) {
      textController = TextEditingController(text: currentAnswer ?? '');
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Survey Question'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            currentQuestion.question,
            style: TextStyle(fontSize: 18),
            textAlign: TextAlign.center,
          ),
          if (!currentQuestion.isMultipleChoice && !currentQuestion.isOpenEnded) ...[
            for (var option in currentQuestion.options)
              GestureDetector(
                onTap: () {
                  setState(() {
                    _answers[_currentQuestionIndex] = option;
                  });
                },
                child: ListTile(
                  title: Text(option),
                  leading: Radio<String?>(
                    value: option,
                    groupValue: currentAnswer,
                    onChanged: (value) {
                      setState(() {
                        _answers[_currentQuestionIndex] = value;
                      });
                    },
                  ),
                ),
              ),
          ] else if (currentQuestion.isMultipleChoice && !currentQuestion.isOpenEnded) ...[
            for (var option in currentQuestion.options)
              GestureDetector(
                onTap: () {
                  setState(() {
                    var checkedOptions = (_answers[_currentQuestionIndex] as Set<String>?) ?? {};
                    if (checkedOptions.contains(option)) {
                      checkedOptions.remove(option);
                    } else {
                      checkedOptions.add(option);
                    }
                    _answers[_currentQuestionIndex] = checkedOptions;
                  });
                },
                child: CheckboxListTile(
                  value: currentAnswer != null ? currentAnswer.contains(option) : false,
                  title: Text(option),
                  onChanged: (bool? value) {
                    setState(() {
                      var checkedOptions = (_answers[_currentQuestionIndex] as Set<String>?) ?? {};
                      if (value == true) {
                        checkedOptions.add(option);
                      } else {
                        checkedOptions.remove(option);
                      }
                      _answers[_currentQuestionIndex] = checkedOptions;
                    });
                  },
                ),
              ),
          ] else if (currentQuestion.isOpenEnded) ...[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: textController,
                decoration: InputDecoration(
                  labelText: 'Your answer',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.multiline,
                maxLines: null,
                onChanged: (text) {
                  _answers[_currentQuestionIndex] = text;
                },
              ),
            ),
          ],
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              if (_currentQuestionIndex > 0)
                ElevatedButton(
                  onPressed: _prevQuestion,
                  child: Text('Back'),
                ),
              ElevatedButton(
                onPressed: _nextQuestion,
                child: Text(_currentQuestionIndex < _questions.length - 1 ? 'Next' : 'Submit'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

Future<void> saveSurveyResultsToApi(Map<int, dynamic> answers) async {
  final user = await Api.getCurrentUser();
  if (user != null) {
    List<String> formattedAnswers = [];
    for (var i = 0; i < _questions.length; i++) {
      if (answers.containsKey(i)) {
        formattedAnswers.add(answers[i].toString());
      } else {
        formattedAnswers.add(""); // 如果没有答案，添加一个空字符串
      }
    }

    final date = DateTime.now();
    final dateString = "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";

    await Api.submitSurvey({
      'user_id': user['user_id'],
      'answers': formattedAnswers,
      'date': dateString,
    });
  }
}





