import 'dart:async';
import 'dart:convert';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:cdewsv2/constants.dart';

class ScanPage extends StatefulWidget {
  const ScanPage({super.key});

  @override
  State<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  Timer? scanPageTimer;
  String? lastLatestDatetime;

  @override
  void initState() {
    super.initState();

    AwesomeNotifications().initialize(
        'resource://drawable/res_birdc_icon',
        [
          NotificationChannel(
            channelKey: 'basic_channel',
            channelName: 'Basic Notifications',
            channelDescription: 'Notification for C-Dews App',
            defaultColor: Colors.teal,
            importance: NotificationImportance.High,
            channelShowBadge: true,
          )
        ]);

    // Start periodic check
    scanPageTimer = Timer.periodic(const Duration(minutes: 1), (timer) {
      checkAndNotify();
    });

    // Initial fetch
    checkAndNotify();
  }

  @override
  void dispose() {
    scanPageTimer?.cancel();
    super.dispose();
  }

  Future<List<dynamic>> fetchEggData() async {
    // Generate current date
    DateTime now = DateTime.now();
    String formattedDate = "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";

    final response = await http.get(Uri.parse(
        'https://c-dews.synqbox.com/api/oltrapsdata/23108/municipal/$formattedDate'));
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      if (jsonResponse['status'] == 'success') {
        return jsonResponse['data'] as List<dynamic>;
      }
    }
    return [];
  }

  Future<void> checkAndNotify() async {
    List<dynamic> newData = await fetchEggData();
    if (newData.isNotEmpty) {
      newData.sort((a, b) => b['datetime'].compareTo(a['datetime']));
      String latestDatetime = newData.first['datetime'];

      if (lastLatestDatetime == null || latestDatetime != lastLatestDatetime) {
        AwesomeNotifications().createNotification(
          content: NotificationContent(
            id: createUniqueId(),
            channelKey: 'basic_channel',
            title: 'Community-Dengue Early Warning System',
            body: 'New Dengue Egg data detected at ${newData.first['station_name']}!',
          ),
        );

        lastLatestDatetime = latestDatetime;
      }
    }
  }

  int createUniqueId() {
    return DateTime.now().microsecondsSinceEpoch.remainder(100000);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          Positioned(
              top: 50,
              left: 20,
              right: 20,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        color: Constants.primaryColor.withOpacity(.15),
                      ),
                      child: Icon(
                        Icons.close,
                        color: Constants.primaryColor,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      checkAndNotify();
                    },
                    child: Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        color: Constants.primaryColor.withOpacity(.15),
                      ),
                      child: Icon(
                        Icons.notifications,
                        color: Constants.primaryColor,
                      ),
                    ),
                  ),
                ],
              )),
          Positioned(
            top: 100,
            right: 20,
            left: 20,
            child: Container(
              width: size.width * .8,
              height: size.height * .8,
              padding: const EdgeInsets.all(20),
              child: const Center(
                child: Text(
                  'Notifications will be triggered if new data is detected.',
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
