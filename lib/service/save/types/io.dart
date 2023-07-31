// import 'dart:math' as math;
import 'dart:developer';
import 'dart:io';

import 'package:android_path_provider/android_path_provider.dart';
import 'package:flutter/services.dart';

// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import 'base.dart';

class Save extends BaseSave {
  @override
  Future<void> saveFile(Uint8List bytes, String filename) async {
    String path = '';
    try {
      if (await _requestPermission(Permission.storage)) {
        try {
          if (Platform.isAndroid) {
            path = await AndroidPathProvider.documentsPath
                .then((value) => value)
                .catchError((e) async {
              final directory = await getExternalStorageDirectory();
              return directory?.path ?? '';
            });
          } else if (Platform.isIOS) {
            path = (await getApplicationDocumentsDirectory()).absolute.path;
          } else {
            path = (await getApplicationDocumentsDirectory()).path;
          }
          final newFile = File('$path/$filename');
          await newFile.writeAsBytes(bytes);
          if (Platform.isAndroid || Platform.isIOS) {
            // _showNotification(filename, newFile.path);
            // Fluttertoast.showToast(msg: "Saved");
          }
        } on PlatformException {
          path = '';
        }
      } else {
        path = '';
      }
    } catch (e) {
      path = '';
      log('$e');
    }
    if (path.isEmpty) {
      // Fluttertoast.showToast(msg: "Couldn't save");
    }
  }

  Future<bool> _requestPermission(Permission permission) async {
    if (await permission.isGranted) {
      return true;
    } else {
      var result = await permission.request();
      if (result == PermissionStatus.granted) {
        return true;
      }
    }
    return false;
  }

// Future<void> _showNotification(String fileName, String filePath) async {
//   var flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
//   const AndroidNotificationChannel channel = AndroidNotificationChannel(
//     'download', // id
//     'Download', // title
//     description: 'Download files', // description
//     importance: Importance.max,
//   );
//   await flutterLocalNotificationsPlugin
//       .resolvePlatformSpecificImplementation<
//           AndroidFlutterLocalNotificationsPlugin>()
//       ?.createNotificationChannel(channel);
//   var androidNotificationDetails = AndroidNotificationDetails(
//     channel.id,
//     channel.name,
//     channelDescription: channel.description,
//     icon: '@drawable/notification_icon',
//     playSound: true,
//     largeIcon: const DrawableResourceAndroidBitmap("student"),
//     enableVibration: true,
//     importance: Importance.max,
//     priority: Priority.high,
//     channelShowBadge: true,
//     onlyAlertOnce: true,
//   );
//   var notificationDetails =
//       NotificationDetails(android: androidNotificationDetails);
//
//   await flutterLocalNotificationsPlugin.show(
//     math.Random().nextInt(1000),
//     "Saved Document",
//     "$fileName.pdf",
//     notificationDetails,
//     payload: "save==,==$filePath",
//   );
// }
}
