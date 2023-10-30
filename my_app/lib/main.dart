// ignore_for_file: unused_import

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:my_app/providers/user_provider.dart';
import 'package:my_app/responsive_layout_screen/mobile_screen_layout.dart';
import 'package:my_app/responsive_layout_screen/responsive_layout_screen.dart';
import 'package:my_app/responsive_layout_screen/web_screen_layout.dart';
import 'package:my_app/screens/login_screen.dart';
import 'package:my_app/screens/signup_screen.dart';
import 'package:my_app/utils/colors.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:ui' show lerpDouble;

import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: 'AIzaSyAzmHwX4vFlXE5kXh9gwTL - Ghsfoxotnt0',
          appId: '1:788187766571:web:37a2bd93b7fbfce1c5ef6e',
          messagingSenderId: '788187766571',
          projectId: 'instagram-clone-8ba1a',
          storageBucket: "instagram-clone-8ba1a.appspot.com"),
    );
  } else {
    await Firebase.initializeApp();
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Instagram Clone',
        theme: ThemeData.dark()
            .copyWith(scaffoldBackgroundColor: mobileBackgroundColor),
        //home: const ResponsiveLayout(
        // webScreenLayout: WebScreenLayout(),
        // mobileScreenLayout: MobileScreenLayout())
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              if (snapshot.hasData) {
                return const ResponsiveLayout(
                  webScreenLayout: WebScreenLayout(),
                  mobileScreenLayout: MobileScreenLayout(),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('${snapshot.error}'),
                );
              }
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                  child: CircularProgressIndicator(
                color: primaryColor,
              ));
            }

            return const LoginScreen();
          },
        ),
      ),
    );
  }
}
