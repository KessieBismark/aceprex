import '../../home_page/component/controller.dart';
import '../../pages/chats/chat_notify.dart';
import '../../pages/notification/notifications.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:get/get.dart';

import '../../pages/library/component/file_local.dart';

class NotificationService {
  static Future<void> initializeNotification() async {
    await AwesomeNotifications().initialize(
      'resource://drawable/res_logo',
      [
        NotificationChannel(
            channelKey: 'chat',
            channelName: 'Basic Notification',
            //  defaultColor: trans,
            importance: NotificationImportance.High,
            channelShowBadge: true,
            //  onlyAlertOnce: true,
            channelDescription: 'aceprex'),
        NotificationChannel(
            channelKey: 'notification',
            channelName: 'Basic Notification',
            // defaultColor: trans,
            importance: NotificationImportance.High,
            channelShowBadge: true,
            //    onlyAlertOnce: true,
            channelDescription: 'aceprex'),
        NotificationChannel(
            channelKey: 'library',
            channelName: 'Basic Notification',
            //   defaultColor: trans,
            importance: NotificationImportance.High,
            channelShowBadge: true,
            //  onlyAlertOnce: true,
            channelDescription: 'aceprex'),
        NotificationChannel(
            channelKey: 'library download',
            channelName: 'Basic Notification',
            //   defaultColor: trans,
            importance: NotificationImportance.High,
            channelShowBadge: true,
            //  onlyAlertOnce: true,
            channelDescription: 'aceprex')
      ],
    );
    await AwesomeNotifications().setListeners(
        onActionReceivedMethod: onActionReceivedMethod,
        onNotificationCreatedMethod: onNotificationCreatedMethod,
        onDismissActionReceivedMethod: onDismissActionReceivedMethod,
        onNotificationDisplayedMethod: onNotificationDisplayedMethod);
  }

  static Future<void> onNotificationCreatedMethod(
      ReceivedNotification receivedNotification) async {}

  static Future<void> onActionReceivedMethod(
      ReceivedAction receivedAction) async {
    final payload = receivedAction.payload ?? {};
    if (payload['type'] == "chat") {
      AwesomeNotifications().decrementGlobalBadgeCounter();
      Get.to(() => ChatNotifyUI(
            to: int.parse(payload['to']!),
            name: payload['name']!,
            isOnline: int.parse(payload['isOnline']!),
            avatar: payload['avatar']!,
          ));
    } else if (payload['type'] == "library") {
      AwesomeNotifications().decrementGlobalBadgeCounter();
      HomeController().tabIndex.value = 1;
      Get.to(() => LibNotifyLocal(
            title: payload['title']!,
            author: payload['author']!,
            description: payload['description']!,
            fileLink: payload['fileLink']!,
            imagPath: payload['image']!,
            id: int.parse(payload['id']!),
          ));
    } else if (payload['type'] == "library download") {
      AwesomeNotifications().decrementGlobalBadgeCounter();
    } else if (payload['type'] == "notification") {
      AwesomeNotifications().decrementGlobalBadgeCounter();
      Get.to(() => const Notifications());
    } else {
      AwesomeNotifications().decrementGlobalBadgeCounter();
    }
  }

  static Future<void> onDismissActionReceivedMethod(
      ReceivedAction receivedAction) async {
    AwesomeNotifications().decrementGlobalBadgeCounter();
  }

  static Future<void> onNotificationDisplayedMethod(
      ReceivedNotification receivedNotification) async {}

  static Future<void> showNotification({
    required final int id,
    required final String title,
    required final String body,
    required final String channelKey,
    final String? groupKey,
    final String? summary,
    final Map<String, String>? payload,
    final ActionType actionType = ActionType.Default,
    final NotificationLayout notificationLayout = NotificationLayout.Default,
    final NotificationCategory? category,
    final String? bigPictuire,
    final List<NotificationActionButton>? actionButtons,
    final bool scheduled = false,
    final int? interval,
  }) async {
    assert(!scheduled || (scheduled && interval != null));
    await AwesomeNotifications().createNotification(
        content: NotificationContent(
          groupKey: groupKey,
          id: id,
          channelKey: channelKey,
          title: title,
          body: body,
          actionType: actionType,
          notificationLayout: notificationLayout,
          summary: summary,
          category: category,
          payload: payload,
        ),
        actionButtons: actionButtons,
        schedule: scheduled
            ? NotificationInterval(
                interval: interval,
                timeZone:
                    await AwesomeNotifications().getLocalTimeZoneIdentifier(),
                preciseAlarm: true)
            : null);
  }
}
