import 'package:college_project_doctor/provider/userProvider.dart';
import 'package:college_project_doctor/screens/Login/welcomeScreen.dart';
import 'package:college_project_doctor/screens/bottomNavigation/bottomNavigation.dart';
import 'package:college_project_doctor/helper/helperFunction.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isCheckedIn = false;
  @override
  void initState() {
    getLoggedIn();
    // TODO: implement initState
    super.initState();
    print(isCheckedIn);
  }

  getLoggedIn() async {
    await HelperFunctions.getUserLoggedInSharedPreference().then((value) {
      setState(() {
        isCheckedIn = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => UserProvider())],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primarySwatch: Colors.blue,
        ),
        home: isCheckedIn == null
            ? LoginScreen()
            : isCheckedIn
                ? Bottom_Navigation()
                : LoginScreen(),
      ),
    );
  }
}
