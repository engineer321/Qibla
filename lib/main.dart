import 'dart:developer';
import 'dart:ui';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_qiblah/flutter_qiblah.dart';
import 'package:qibla/screens/device_incompatibility.dart';
import 'package:qibla/screens/qibla_screen.dart';
import 'package:qibla/utils/loading_indicator.dart';

import 'firebase_options.dart';

void main() async {
  // runZonedGuarded<Future<void>>(() async {
  //
  // },
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  FirebaseMessaging.instance.getInitialMessage();
  // FirebaseMessaging.instance.sendMessage();

  // var token = await FirebaseMessaging.instance.getToken();
  // print(" Instance Token ID: ${token!}");
  await FirebaseMessaging.instance.setAutoInitEnabled(true);
  final fcmToken = await FirebaseMessaging.instance.getToken();
  log('FCM Token $fcmToken');

  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };
  // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  runApp(const MyApp());
}

late Size mq;

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _deviceSupport = FlutterQiblah.androidDeviceSensorSupport();

  // bool hasPermission = false;
  // Future getPermission() async {
  //   if (await Permission.location.serviceStatus.isEnabled) {
  //     var status = await Permission.location.status;
  //     if (status.isGranted) {
  //       hasPermission = true;
  //     } else {
  //       Permission.location.request().then((value) {
  //         setState(() {
  //           hasPermission = (value == PermissionStatus.granted);
  //         });
  //       });
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Qibla Guide',
      theme: ThemeData(
        appBarTheme: const AppBarTheme(centerTitle: true),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: FutureBuilder(
        future: _deviceSupport,
        builder: (context, AsyncSnapshot<bool?> snapshot) {
          // print('Data: ${snapshot.data}');
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingIndicator();
          }
          if (snapshot.hasError) {
            return Center(
              child: Text("Error: ${snapshot.error.toString()}"),
            );
          }

          if (snapshot.data!) {
            return const QiblaScreen();
          } else {
            return const DeviceIncompatibility();
          }
        },
      ),
    );
  }
}
// com.example.qibla_guide_new
