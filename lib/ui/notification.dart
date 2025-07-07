import 'package:awesome_notifications/awesome_notifications.dart';

int createUniqueId() {
  return DateTime.now().microsecondsSinceEpoch.remainder(100000);
}

Future<void> createNotification() async {
  await AwesomeNotifications().createNotification(
      content: NotificationContent(
          id: createUniqueId(),
          channelKey: 'basic_channel',
          title: 'C-Dews Notification',
          body: 'Notification Received',
          bigPicture: 'asset://assets/images/agency-birdc.png',
          notificationLayout: NotificationLayout.BigPicture));
}
