import 'package:firebase_messaging/firebase_messaging.dart';

import 'dart:io';
import 'dart:async';

class PushNotification {
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  final _mensajesStreamController = StreamController<String>.broadcast();
  Stream<String> get mensajes => _mensajesStreamController.stream;

  initNotifications() {

    _firebaseMessaging.requestNotificationPermissions();

    _firebaseMessaging.getToken().then((token) {
      print('===== FCM Token =====');
      print(token);
      // f-opgFP51dQ:APA91bEkrlR8dN7Dgf2wYq_3M_CSyrL4-TmuqDScvaGOkHs9DcoJgQEViahhniO5yLmFqZvYUpJYMt8Et_JrIY03SjThqdO3FLV9ANTFyRUO9QlFDT9k57_c2ADxgRGzNZvUeVpK0ffz
    });

    _firebaseMessaging.configure(onMessage: (info) {
      print('======= On Message ========');
      print(info);

      String argumento = 'no-data';
      if (Platform.isAndroid) {
        argumento = info['notofication']['body'] ?? 'no-data';
      } else {
        argumento = info['body'] ?? 'no-data-ios';
      }

      _mensajesStreamController.sink.add(argumento);
    }, onLaunch: (info) {
      print('======= On Launch ========');
      print(info);

    }, onResume: (info) {
      print('======= On Resume ========');
      print(info);
      print(info.length);

      String argumento = 'no-data';

      if (Platform.isAndroid) {
        argumento = info['data']['info'] ?? 'no-data';
      } else {
        argumento = info['info'] ?? 'no-data-ios';
      }

      _mensajesStreamController.sink.add(argumento);
    });
  }

  Future <String> getToken() async{
    String tokens = "";//No relevante
    _firebaseMessaging.requestNotificationPermissions();

    await _firebaseMessaging.getToken().then((token) {
      print('===== FCM Token =====');
      print(token);
      tokens = token;
      // f-opgFP51dQ:APA91bEkrlR8dN7Dgf2wYq_3M_CSyrL4-TmuqDScvaGOkHs9DcoJgQEViahhniO5yLmFqZvYUpJYMt8Et_JrIY03SjThqdO3FLV9ANTFyRUO9QlFDT9k57_c2ADxgRGzNZvUeVpK0ffz
    });
    return tokens;
  }
  

  dispose() {
    _mensajesStreamController?.close();
  }
}
