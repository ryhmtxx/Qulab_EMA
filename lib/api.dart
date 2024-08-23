import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class Api {
  static const String baseUrl = 'http://qu-statlab.ics.uci.edu';

  static Future<http.Response> register(String email, String password, String sex, int dobm, int doby, String major,
      double height, double weight, double bmi, String racialBackground, String firstGen,
      String internationalStudent, String status, String year) {
    return http.post(
      Uri.parse('$baseUrl/registerryh'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'email': email,
        'password': password,
        'sex': sex,
        // 'age': age,
        'dobm' : dobm,
        'doby' : doby,
        'major': major,
        'height': height,
        // 'height_inches': heightInches,
        'weight': weight,
        'BMI': bmi,
        'racial_background': racialBackground,
        'first_gen': firstGen,
        'international_student': internationalStudent,
        'status': status,
        'year': year,
      }),
    );
  }

  static Future<http.Response> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/loginryh'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      // 登录成功后保存用户信息到本地存储
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      await prefs.setString('user_id', responseData['user_id'].toString());
      await prefs.setString('email', email);
    }

    return response;
  }

  static Future<http.Response> submitSurvey(Map<String, dynamic> surveyData) {
    return http.post(
      Uri.parse('$baseUrl/submitryh'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(surveyData),
    );
  }

  static Future<Map<String, dynamic>?> getCurrentUser() async {
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

  static Future<http.Response> getSurveyResults(String userId, String date) {
    return http.get(
      Uri.parse('$baseUrl/todayryh/$userId?date=$date'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
  }

  static Future<Map<String, dynamic>?> fetchSurveyResultsFromApi(String userId, DateTime date) async {
    final dateString = "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
    final response = await getSurveyResults(userId, dateString);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      print("Error fetching survey results: ${response.body}");
      return null;
    }
  }

  // static Future<http.Response> getHistoricalSurveyResults(String userId) {
  //   return http.get(
  //     Uri.parse('$baseUrl/historyryh/$userId'),
  //     headers: <String, String>{
  //       'Content-Type': 'application/json; charset=UTF-8',
  //     },
  //   );
  // }

  static Future<Map<String, dynamic>?> fetchHistoricalSurveyResultsFromApi(String userId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/historyryh/$userId'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      print("Error fetching historical survey results: ${response.body}");
      return null;
    }
  }

  static Future<http.Response> testDbConnection() {
    return http.get(
      Uri.parse('$baseUrl/test_db_connectionryh'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
  }

    static Future<http.Response> sendResetCode(String email) {
    return http.post(
      Uri.parse('$baseUrl/request-password-resetryh'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': email,
      }),
    );
  }

  static Future<http.Response> verifyCodeAndResetPassword(String email, String code, String newPassword) {
    return http.post(
      Uri.parse('$baseUrl/verify-coderyh'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'code': code,
        'new_password': newPassword,
      }),
    );
  }
}
