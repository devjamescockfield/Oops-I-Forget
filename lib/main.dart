import 'package:dissertation/services/AuthService.dart';
import 'package:easy_splash_screen/easy_splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dissertation/screens/auth/verify_email_page.dart';
import 'package:dissertation/services/utils.dart';
import 'package:google_fonts/google_fonts.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [SystemUiOverlay.top]);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  runApp(const MyApp());
}

final navKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    Widget streamBuilder = StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Something went wrong!'));
          } else if (snapshot.hasData) {
            return const VerifyEmailPage();
          } else {
            return const AuthService();
          }
        }
    );

    Widget splashScreen = EasySplashScreen(
        logo: const Image(image: AssetImage('assets/img/Logo-Light.png')),
        logoWidth: 150,
        backgroundColor: const Color.fromRGBO(10, 46, 54, 1),
        showLoader: true,
        navigator: streamBuilder,
        durationInSeconds: 5,
        loaderColor: Colors.white
    );

    return MaterialApp(
      scaffoldMessengerKey: Utils.messengerKey,
      navigatorKey: navKey,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          brightness: Brightness.dark,
          primaryColor: const Color.fromRGBO(10, 46, 54, 1),
          fontFamily: GoogleFonts.dmSans().fontFamily,
          textTheme: GoogleFonts.dmSansTextTheme()
      ),
      home: splashScreen,
    );
  }
}