import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'ui/onboarding_screen.dart';
import 'ui/root_page.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:http/http.dart' as http;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  backgroundTask();

  runApp(const MyApp());
}

void backgroundTask() {
  AwesomeNotifications().initialize('resource://drawable/res_birdc_icon', [
    NotificationChannel(
      channelKey: 'basic_channel',
      channelName: 'Basic Notifications',
      channelDescription: 'Notification for C-Dews App',
      defaultColor: Colors.teal,
      importance: NotificationImportance.High,
      channelShowBadge: true,
    )
  ]);

  Timer.periodic(const Duration(minutes: 1), (Timer t) async {
    final response = await http.get(Uri.parse(
        'https://c-dews.synqbox.com/api/oltrapsdata/23108/municipal/2023-01-27'));
    var jsonResponse = jsonDecode(response.body);
    print(jsonResponse);

    if (jsonResponse['status'] == 'success') {
      AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: createUniqueId(),
          channelKey: 'basic_channel',
          title: 'Community-Dengue Early Warning System',
          body: 'New Dengue Egg Detected',
        ),
      );
    }
  });
}

int createUniqueId() {
  return DateTime.now().microsecondsSinceEpoch.remainder(100000);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<bool> checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // Check your saved key from login, e.g. "isLoggedIn"
    // Or you can check if "scopeValue" or "permissionValue" is not null
    String? scope = prefs.getString('scopeValue');
    String? permission = prefs.getString('permissionValue');
    String? name = prefs.getString('name');

    if (scope != null && permission != null && name != null) {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'C-DEWS',
      debugShowCheckedModeBanner: false,
      home: FutureBuilder<bool>(
        future: checkLoginStatus(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else {
            if (snapshot.data == true) {
              // User is already logged in
              return const RootPage();
            } else {
              // Not logged in yet
              return const OnboardingScreen();
            }
          }
        },
      ),
    );
  }
}
