import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:presensi_app/constants/color_constant.dart';
import 'package:presensi_app/screens/enter_class.dart';
import 'package:presensi_app/screens/home_guru_screen.dart';
import 'package:presensi_app/screens/home_screen.dart';
import 'package:presensi_app/screens/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:page_transition/page_transition.dart';

void main() async {
  runApp(MyApp());
  // WidgetsFlutterBinding.ensureInitialized();
  // SharedPreferences pref = await SharedPreferences.getInstance();
  // var userName = pref.getString('userName');
  // var level = pref.getInt('userLevel');
  // runApp(MaterialApp(
  //     debugShowCheckedModeBanner: false,
  //     home:
  //         userName == null ? App() : (level == 1 ? HomeApp() : HomeGuruApp())));
}

class MyApp extends StatefulWidget {
  //  MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int level;

  userData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      level = pref.getInt('userLevel');
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userData();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // home: level == 2 ? HomeGuruScreen() : HomeScreen(),
      home: SplashScreen(),
      routes: <String, WidgetBuilder>{
        '/login': (BuildContext context) => LoginScreen(),
        '/enter-class': (BuildContext context) => EnterClassScreen(),
        '/dashboard': (BuildContext context) =>
            level == 1 ? HomeScreen() : HomeGuruScreen()
      },
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String userName;
  int level;
  int id_kelas;

  userData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      userName = pref.getString('userName');
      level = pref.getInt('userLevel');
      id_kelas = pref.getInt('idKelasSiswa');
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userData();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LottieBuilder.asset(
              'assets/lottie/splash_screen.json',
              fit: BoxFit.contain,
            ),
            Text(
              'tunggu sebentar ..',
              style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: kBlackColor),
            )
          ],
        ),
      ),
      backgroundColor: Colors.white,
      splashIconSize: 400,
      duration: 3000,
      splashTransition: SplashTransition.scaleTransition,
      nextScreen: userName == null
          ? LoginScreen()
          : (id_kelas == null
              ? EnterClassScreen()
              : (level == 1 ? HomeScreen() : HomeGuruScreen())),
      pageTransitionType: PageTransitionType.topToBottom,
    );
  }
}
