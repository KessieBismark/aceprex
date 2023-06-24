import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/color.dart';
import '../constants/constant.dart';

class Utils {
  static bool isLogged = false;
  static String userName = '';
  static var uid = ''.obs;
  static var themeDark = true.obs;
  String uidd = '';
  static String userRole = '';
  static String cid = '';
  static String userEmail = '';
  static String userID = '';
  static var userAvatar = ''.obs;
  static var messageCount = 0.obs;
  static var unReadChat = 0.obs;
  static bool isIntroShow = false;
  static List<String> notifyMeg = [];
  static var imageSet=false.obs; 

  static getInto() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool result = false;
    if (prefs.containsKey("intro")) {
      result = prefs.getBool("intro")!;
    }
    return result;
  }

  // static sendNotification(
  //     {required String title,
  //     required channelKey,
  //     required String body,
  //     Map<String, String?>? payload,
  //     String? groupKey}) {
  //   AwesomeNotifications().createNotification(
  //       content: NotificationContent(
  //           id: createUniqueId(),
  //           channelKey: channelKey,
  //           title: title,
  //           groupKey: groupKey,
  //           body: body,
  //           payload: payload,
            
  //           ));

  //   // AwesomeNotifications().setListeners(onActionReceivedMethod: onActionReceivedMethod)  .listen((event) {});
  // }

  static bool isUrl(String string) {
    Uri? uri = Uri.tryParse(string);
    return (uri != null && uri.hasScheme && uri.hasAuthority);
  }

  static String formatTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);
    if (difference.inSeconds < 60) {
      return '${difference.inSeconds} sec ago';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} min ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hours ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return dateTime.dateTimeFormatShortString();
    }
  }

  static String chatFormatTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);
    if (difference.inSeconds < 60) {
      return '${difference.inSeconds} sec ago';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} min ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hours ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return dateTime.dateOnlyFormatShortString();
    }
  }

  static String removeHtmlTags(String htmlString) {
    RegExp htmlTags = RegExp(r'<[^>]*>');
    return htmlString.replaceAll(htmlTags, ' ');
  }

  static Future<bool> checkInternet() async {
    return await InternetConnectionChecker().hasConnection;
  }

  static getLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool result = false;
    if (prefs.containsKey("userID")) {
      userID = prefs.getString("userID")!;
      userEmail = prefs.getString("userEmail")!;
      userName = prefs.getString("userName")!;
      userRole = prefs.getString("userRole")!;
      notifyMeg = prefs.getString("chatMeg")!.split(',');
      userAvatar.value = prefs.getString("userAvatar")!;
      result = true;
    }
    return result;
  }

  static setLogin(
      {required String userID,
      required String userName,
      required String userEmail,
      required String userRole,
      String? userAvatar}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("userID", userID);
    prefs.setString("userEmail", userEmail);
    prefs.setString("userName", userName);
    prefs.setString("userRole", userRole);
    prefs.setString("userAvatar", userAvatar!);
    prefs.setString("chatMeg", notifyMeg.join(','));
  }

  static logOut() async {
    uid.value = '';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // await prefs.clear();
    await prefs.remove('userID');
    await prefs.remove('userEmail');
    await prefs.remove('userName');
    await prefs.remove('userRole');
    await prefs.remove('userAvatar');
    Get.offAllNamed('/start-up');
  }

  static setInto() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("intro", true);
  }

  static final isLightTheme = false.obs;

  static int daysDifference(DateTime from, DateTime to) {
    int days = to.difference(from.subtract(const Duration(days: 1))).inDays;
    int sunday = getSundays(from, to);

    days = days - sunday;
    return days;
  }

  static String getInitials(String str) {
    List<String> words = str.split(' ');
    String initials = '';
    for (String word in words) {
      initials += word[0].toUpperCase();
    }
    var rand = Random();
    int randomNum = rand.nextInt(100);
    return initials + randomNum.toString();
  }

  static int hoursDifference(
      DateTime from, DateTime to, int weekH, int weekendH) {
    int sunday = getSundays(from, to);
    int saturday = getSaturday(from, to);
    int d = 0;
    to = to.subtract(Duration(days: sunday));
    to = to.subtract(Duration(days: saturday));
    d = to.difference(from.subtract(const Duration(days: 1))).inDays;
    int weekhour = d * weekH;
    int wknHours = saturday * weekendH;
    int hours = weekhour + wknHours;
    return hours;
  }

  static timeDifference(var starTime, var endTime) {
    var format = DateFormat("HH:mm");
    var one = format.parse(starTime);
    var two = format.parse(endTime);
    return two.difference(one); // prints 7:40
  }

  static stringToList(String value) {
    final regExp = RegExp(r'(?:\[)?(\[[^\]]*?\](?:,?))(?:\])?');
    final input = value;
    final result = regExp
        .allMatches(input)
        .map((m) => m.group(1))
        .map((String? item) => item!.replaceAll(RegExp(r'[\[\],]'), ''))
        .map((m) => [m])
        .toList();
    return result;
  }

  static dateFormat(dynamic date) {
    var format = DateFormat("'yyyy-MM-dd HH:mm");
    var newDate = format.parse(date);
    return newDate;
  }

  static dateOnly(dynamic date) {
    DateTime dateToday = date;
    String newdate = dateToday.toString().substring(0, 10);
    return newdate;
  }

  static String formatNumber(var number) {
    var formatter = NumberFormat('#,##,000');
    return formatter.format(number);
  }

  static int getSundays(DateTime from, DateTime to) {
    int sunday = 0;
    if (from.weekday == DateTime.monday) {
      sunday = 0;
    } else {
      int days = to.difference(from.subtract(const Duration(days: 1))).inDays;
      from = from.subtract(const Duration(days: 1));
      for (int i = 0; i <= days; i++) {
        if (from.add(Duration(days: i)).weekday == DateTime.sunday) {
          sunday += 1;
        }
      }
    }
    return sunday;
  }

  static convertTime(int seconds) {
    format(Duration d) => d.toString().split('.').first.padLeft(8, "0");
    return format(Duration(seconds: seconds));
  }

  static int getSaturday(DateTime from, DateTime to) {
    int days = to.difference(from.subtract(const Duration(days: 1))).inDays;
    from = from.subtract(const Duration(days: 1));
    int saturday = 0;
    for (int i = 0; i <= days; i++) {
      if (from.add(Duration(days: i)).weekday == DateTime.saturday) {
        saturday += 1;
      }
    }
    return saturday;
  }

  static String myMonth(int value) {
    String m = '';
    if (value == 1) {
      m = 'January';
    } else if (value == 2) {
      m = 'February';
    } else if (value == 3) {
      m = 'March';
    } else if (value == 4) {
      m = 'April';
    } else if (value == 5) {
      m = 'May';
    } else if (value == 6) {
      m = 'June';
    } else if (value == 7) {
      m = 'July';
    } else if (value == 8) {
      m = 'August';
    } else if (value == 9) {
      m = 'September';
    } else if (value == 10) {
      m = 'October';
    } else if (value == 11) {
      m = 'November';
    } else {
      m = 'December';
    }
    return m;
  }

  static int myMonthNumber(String value) {
    int m = 0;
    if (value == 'January') {
      m = 1;
    } else if (value == 'February') {
      m = 2;
    } else if (value == 'March') {
      m = 3;
    } else if (value == 'April') {
      m = 4;
    } else if (value == 'May') {
      m = 5;
    } else if (value == 'June') {
      m = 6;
    } else if (value == 'July') {
      m = 7;
    } else if (value == 'August') {
      m = 8;
    } else if (value == 'September') {
      m = 9;
    } else if (value == 'October') {
      m = 10;
    } else if (value == 'November') {
      m = 11;
    } else {
      m = 12;
    }
    return m;
  }

  static userNameinitials(String val) {
    List<String> spliter = val.trim().split(" ");

    return spliter[0].capitalizeFirst;
  }

  static spaceLink(String val, int num) {
    List<String> spliter = val.trimLeft().split("_");
    String label = '';
    for (int i = 0; i < spliter.length; i++) {
      label = label + spliter[i].trim()[0].toUpperCase();
    }
    label = label + num.toString();
    return label;
  }

  static initials(String val, int num) {
    List<String> spliter = val.trim().split(" ");
    String label = '';
    for (int i = 0; i < spliter.length; i++) {
      label = label + spliter[i].trim()[0].toUpperCase();
    }
    label = label + num.toString();
    return label;
  }

  static bool isNumeric(String s) {
    if (s.isEmpty) {
      return false;
    }
    return double.tryParse(s) != null;
  }

  static getRandomNumbers() {
    var rng = Random();
    var code = rng.nextInt(900000) + 100000;
    return code.toString();
  }

  static getTodaysDate() {
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final String formatted = formatter.format(now);
    return formatted;
  }

  showError(String error) {
    Get.snackbar(
      appName,
      error,
      snackPosition: SnackPosition.BOTTOM,
      isDismissible: true,
      icon: Icon(Icons.error, color: errorColor),
      duration: const Duration(seconds: 5),
    );
  }

  static printInfo(var data) {
    print.call(data);
  }

  showInfo(String info) {
    Get.snackbar(
      appName,
      info,
      snackPosition: SnackPosition.BOTTOM,
      icon: Icon(Icons.info, color: greenfade),
      duration: const Duration(seconds: 3),
      forwardAnimationCurve: Curves.easeInOut,
      isDismissible: true,
    );
  }

  static String? validator(String? value) {
    if (value!.isEmpty) {
      return 'Please this field is required';
    }
    return null;
  }

  String formatDateTime(String dateTimeString) {
    DateTime dateTime = DateTime.parse(dateTimeString);
    DateFormat formatter = DateFormat('MMM dd, yyyy hh:mm a');
    String formattedDateTime = formatter.format(dateTime);
    return formattedDateTime;
  }

//set sunday value to 0
  static int getAdjustedWeekday(DateTime dateTime) => dateTime.weekday % 7;

  static formatDate(DateTime date) => DateFormat.yMd().format(date);
  static niceDateString(String date) =>
      DateFormat('EEE, dd-MMM-yy').format(DateTime.parse(date));

  static mergeName(String surname, String firstname, String? middlename) {
    return "${surname.trim().toUpperCase()}, ${middlename!.trim().capitalize} ${firstname.trim().capitalize}";
  }
}

extension Capitalized on String {
  String capitalized() =>
      substring(0, 1).toUpperCase() + substring(1).toLowerCase();
}

extension DateTimeX on DateTime {
  DateTime get currentDateOnly => DateTime(year, month, day);
  String dateFormatString() => DateFormat('EEE, dd-MMM-yy').format(this);

  //format 29-sep-2022 - 3:31 PM
  String dateTimeFormatString() =>
      DateFormat('dd-MMM-yyyy  hh:mm aaa').format(this);

  //format 29-sep-22 - 3:31 PM
  String dateTimeFormatShortString() =>
      DateFormat('dd-MMM-yy - hh:mm aaa').format(this);

  String dateOnlyFormatShortString() => DateFormat('dd/MMM/yyyy').format(this);
}
