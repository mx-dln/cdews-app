import 'dart:convert';

import 'package:flutter/material.dart';
import 'ui/onboarding_screen.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

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
    // final response = await http.get(
    //     Uri.parse('http://10.0.2.2:8000/api/notification/23108/municipal'));
    final response = await http.get(Uri.parse(
        'https://c-dews.synqbox.com/api/oltrapsdata/23108/municipal/2023-01-27'));
    var jsonResponse = jsonDecode(response.body);
    print(jsonResponse);

    if (jsonResponse['status'] == 'success') {
      // Show notification
      AwesomeNotifications().createNotification(
          content: NotificationContent(
        id: createUniqueId(),
        channelKey: 'basic_channel',
        title: 'Community-Dengue Early Warning System',
        body: 'New Dengue Egg Detected',
        // bigPicture: 'asset://assets/images/agency-birdc.png',
        // notificationLayout: NotificationLayout.BigPicture
      ));
    }
    // if (jsonResponse['status'] == 'notify') {
    //   // Show notification
    //   AwesomeNotifications().createNotification(
    //       content: NotificationContent(
    //     id: createUniqueId(),
    //     channelKey: 'basic_channel',
    //     title: 'Community-Dengue Early Warning System',
    //     body: 'New Dengue Egg Detected',
    //     // bigPicture: 'asset://assets/images/agency-birdc.png',
    //     // notificationLayout: NotificationLayout.BigPicture
    //   ));
    // }
  });
}

int createUniqueId() {
  return DateTime.now().microsecondsSinceEpoch.remainder(100000);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Onboarding Screen',
      home: OnboardingScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
