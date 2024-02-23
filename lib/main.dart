import 'package:MeetUp/Screens/auth/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter/services.dart';


late Size mq;
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp,DeviceOrientation.portraitDown]).then((value) {
    _initializeFirebase();
    runApp(const MyApp());
  } );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MEETUP',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        //background colour
        scaffoldBackgroundColor: Colors.white,

        //appbar
        appBarTheme:const AppBarTheme(centerTitle: true,
          elevation: 200,
          titleTextStyle: TextStyle(
            fontSize: 35,
            color: Colors.white,
            fontWeight: FontWeight.normal,
          ),

          backgroundColor:Colors.black  ,
        )),
        home: const Loginscreen(),
    );
  }
}

_initializeFirebase() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}
