// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:early_ed/main.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;

class AppHelper {
  static Future<bool> pushNotification({
    required String? userToken,
    required String title,
    required String body,
    required String imageURL,
  }) async {
    if (userToken == null) {
      print('Unable to send FCM message, no token exists.');
      return false;
    }
    const String appId = 'early-ed';
    const String authorizationKey = '';

    try {
      return await http
          .post(
        Uri.parse(
            'https://fcm.googleapis.com/v1/projects/$appId/messages:send'),
        headers: <String, String>{
          'Host': 'fcm.googleapis.com',
          'Authorization': 'Bearer $authorizationKey',
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body:

            // },
            jsonEncode({
          "message": {
            "token": userToken,
            "notification": {"title": title, 'body': body, 'image': imageURL}
          }
        }),
      )
          .then(
        (response) {
          if (response.statusCode == 200) {
            print('FCM request for device sent!');
            return true;
          } else {
            print('FCM request has failed!');
            return false;
          }
        },
      );
    } catch (err) {
      print("Error happens $err");
      return false;
    }
  }

  static Future<void> setupFlutterNotifications() async {
    if (isFlutterLocalNotificationsInitialized) {
      return;
    }
    channel = const AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      playSound: true,

      description:
          'This channel is used for important notifications.', // description
      importance: Importance.high,
    );

    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    /// Create an Android Notification Channel.
    ///
    /// We use this channel in the `AndroidManifest.xml` file to override the
    /// default FCM channel to enable heads up notifications.
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    /// Update the iOS foreground notification presentation options to allow
    /// heads up notifications.
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    isFlutterLocalNotificationsInitialized = true;
  }

  static void showFlutterNotification(RemoteMessage message) {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;
    if (notification != null && android != null && !kIsWeb) {
      flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            channelDescription: channel.description,
            // TODO add a proper drawable resource to android, for now using
            //      one that already exists in example app.
            icon: 'launch_background',
          ),
        ),
      );
    }
  }
}
