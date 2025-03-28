import 'dart:io';

import 'package:dayoneasia/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:googleapis_auth/auth_io.dart';

@pragma('vm:entry-point')
Future<void> _firebaseBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: Platform.isAndroid ? DefaultFirebaseOptions.android : DefaultFirebaseOptions.ios);
}

void setUserInCrashlytics({required String userId, required String userName, required String userEmail, required String phone}) {
  // FirebaseCrashlytics.instance.setUserIdentifier(userId);
  // FirebaseCrashlytics.instance.setCustomKey('userName', userName);
  // FirebaseCrashlytics.instance.setCustomKey('userEmail', userEmail);
  // FirebaseCrashlytics.instance.setCustomKey('phone', phone);
}

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

Future<void> initFirebase() async {
  await Firebase.initializeApp(options: Platform.isAndroid ? DefaultFirebaseOptions.android : DefaultFirebaseOptions.ios);
  FirebaseMessaging.onBackgroundMessage(_firebaseBackgroundHandler);
  print('getFcmToken(): ${await getFcmToken()}');
}

Future<String> getFcmToken() async {
  final firebaseMessaging = FirebaseMessaging.instance;
  String firebaseToken = '';
  try {
    firebaseToken = await firebaseMessaging.getToken() ?? '';
    print('firebaseTokenUser: $firebaseToken');

    final key = await getServiceKeyTokens();
    print('firebaseTokenKeyAuth $key');
    final _firebaseMessaging = FirebaseMessaging.instance;

    if (Platform.isIOS) {
      String? apnsToken = await _firebaseMessaging.getAPNSToken();
      print('APNS Token: $apnsToken');
      await Future.delayed(Duration(seconds: 2));
    }
    return firebaseToken;
  } catch (e) {
    if (kDebugMode) {
      print(e);
    }
    return '';
  }
}

Future<String> getServiceKeyTokens() async {
  final scopes = [
    'https://www.googleapis.com/auth/userinfo.email',
    'https://www.googleapis.com/auth/firebase.database',
    'https://www.googleapis.com/auth/firebase.messaging',
  ];

  final client = await clientViaServiceAccount(
      ServiceAccountCredentials.fromJson({
        "type": "service_account",
        "project_id": "sunnydayspiano",
        "private_key_id": "75987f08a6c7e2a89737388e68c3d444d4c13aa7",
        "private_key":
            "-----BEGIN PRIVATE KEY-----\nMIIEvAIBADANBgkqhkiG9w0BAQEFAASCBKYwggSiAgEAAoIBAQDKq+VbAmPLU18Q\neCrAkEhorFQU5JjdWp9+vMyErCEazl26QqGkAeP9aKOxVSxFicv3kbeV/ZafFEy7\n8Ve24RaNWGXXy9DMjzR72oLdsltffBVUsC+f6SEsVggZFIhIz/NAnklNbj16uG/2\n4l+quVO3ws5E4HL9DcSld6Gz2t2597cli7ymzoU5ackqBxyt4+wqqiSLLWlTHiNr\nSeXpaJ/7T/NS2WUnB/gWh/Xo/oiMC8JD9Yih5ijki83Vh3NwCmmbgtd0dte/PF0Y\nes7fHCKRz9NSIdCiq3tHSe8UrCPTCkv6XVL+gmHrqLA2KtO0EUTb01q1B3OeHuAN\nJf1Cr6e5AgMBAAECggEADsQbt5ftexINx46RwtTgSawLNjh6K1/KZg/4W07f3JWe\nKOS+OnZJd5wzl5x2ghx/h//jCc0KN83hUgIhRg7mjJFyXhjDPjF4J/FBfp3biryT\ndfJI41Q3bq+tSF0sGW35MZiMC6r//1xyX+DvX79qlOVfD4/wy3TA194Rocp3mXBh\nwUrEpUqIWBMvsfWQSzZbllMtt0cBMebxgq1umB5ex1WbSmdd2Vykp+NxIhpiKyKp\nmpqYz7naC0gT88Ah8TBX+1f+e2ttCsXBbNE2IR7M2BNDkcuRatKGdgYPhQlQsEmK\n19A7TzHTjtT2xu4hwASZBTqgS+LZGn9xZ1tGGmVrlwKBgQD1fsleet8XN3YPshY3\nWcLVEDqc2DTgvQLrpdUYkcaV3pZKA9TCU0dfcUtl4MnQD9tnqQpS7otYaGSL1N0K\n1bTaNYJr/aWVyhsN8D8TNGVmfLSywqaHtvJmL1+QeW+8jA7hTnbv9NDObUprkbjv\nn4y92vMOtQEnNsB8Sr+tKXNXGwKBgQDTWAHgo6D+VPjtsKtIIllcQ9j17sil/WxA\nd97NGSyO0uLtyF2vXFXkxrj0tWgPTcJHk1t5WD8CgAZhMEeYhp/g5Cqo0Acf1Isb\nUSkfbzkyyp7r7QEs7lXV9/7yPMtGGjFWPkEhtCUA4F/O5JKYUuf/ebTQb5/OWwal\nYFaY2mqFuwKBgGYkrpxE+3WpedHmAyBclJgZ/Ikt3DJ18jUh9pwWa04IIvgAyBFi\nnRu1A+4LrWyIbH2g8861ufy60rrrglzzth/ki7NrAe5k/QS7pULUVixiTrziCHAH\nSqwBof12yWrly3srLomAjzCUgJZpN01cUS7dXqwL28L5IPWWFFJ0IK1pAoGAfh5l\nuG1NFJkWl5k3DWvaEbI3VcOyH0QVBn/CCHi+W1jDrQxFw/EBHO3tz7I1r/RCPL5V\n9xrPNym5JORPxViJLgZa4rSJm9gVTy7msGiKJKI/piCf8/UiafZ9QIdA8suMp5+s\n9HTxJA3BftBuHtJSueUiHsSOA/HUDHpqEvs8WCMCgYAiF8E/P06llkZEgSt2qDQ9\nGSvw8MHxU454UYeyV21INzIoiXBbALPwk8SxadZyj1X7Rz7jc6fZeLXNBAdNh2w0\n/Ucn2OtiSqAE5XcMIuLs6CZsMUu0cCJZ6FYuX5EQ8jSm2aceG+v+OHOxq6VfwRdg\n0yz5QfxH1qQ3KJIggy5l6g==\n-----END PRIVATE KEY-----\n",
        "client_email": "firebase-adminsdk-odl95@sunnydayspiano.iam.gserviceaccount.com",
        "client_id": "112036480127460583204",
        "auth_uri": "https://accounts.google.com/o/oauth2/auth",
        "token_uri": "https://oauth2.googleapis.com/token",
        "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
        "client_x509_cert_url":
            "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-odl95%40sunnydayspiano.iam.gserviceaccount.com",
        "universe_domain": "googleapis.com"
      }),
      scopes);

  final accessServerKey = client.credentials.accessToken.data;
  return accessServerKey;
}
