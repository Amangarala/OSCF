// ignore_for_file: library_private_types_in_public_api, use_key_in_widget_constructors

import 'package:project/Import/imports.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey =
      "pk_test_51NEGTlSA6nOYUQ7R2IzIojJeqPyL2Y13MmhXOYYkJtArZvZqILfjotSQwUXRtmVeKthbaaQCpDbqm79eFfU3aEy800jkwkJa3x";
  await Stripe.instance.applySettings();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }

  void checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    setState(() {
      _isLoggedIn = isLoggedIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => SplashScreen(),
        '/login': (context) => _isLoggedIn ? HomeScreen() : LoginScreen(),
        '/signup': (context) => _isLoggedIn ? HomeScreen() : SignupScreen(),
        '/home': (context) => HomeScreen(),
      },
    );
  }
}
