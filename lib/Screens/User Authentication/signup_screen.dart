// // ignore_for_file: unused_field, prefer_final_fields, prefer_const_constructors, use_build_context_synchronously, use_key_in_widget_constructors, library_private_types_in_public_api, avoid_print, sort_child_properties_last, unrelated_type_equality_checks, unused_local_variable, deprecated_member_use

// import 'package:project/Import/imports.dart';

// class SignupScreen extends StatefulWidget {
//   @override
//   _SignupScreenState createState() => _SignupScreenState();
// }

// class _SignupScreenState extends State<SignupScreen> {
//   final _formKey = GlobalKey<FormState>();

//   late final TextEditingController _usernameController;
//   late final TextEditingController _emailController;
//   late final TextEditingController _passwordController;
//   late final TextEditingController _confirmPasswordController;
//   @override
//   void initState() {
//     super.initState();
//     _usernameController = TextEditingController();
//     _emailController = TextEditingController();
//     _passwordController = TextEditingController();
//     _confirmPasswordController = TextEditingController();
//   }

//   FirebaseAuth _auth = FirebaseAuth.instance;
//   FirebaseFirestore _db = FirebaseFirestore.instance;

//   void _submitForm() async {
//     if (_formKey.currentState!.validate()) {
//       _formKey.currentState!.save();

//       bool usernameExists = await checkUsernameExist(_usernameController.text);

//       if (usernameExists) {
//         showDialog(
//           context: context,
//           builder: (context) => AlertDialog(
//             title: Text('Sign up failed'),
//             content: Text('The username you entered is already in use.'),
//             actions: <Widget>[
//               TextButton(
//                 child: Text('OK'),
//                 onPressed: () {
//                   Navigator.of(context).pop();
//                 },
//               ),
//             ],
//           ),
//         );
//         return;
//       }

//       try {
//         UserCredential userCredential = await signUpUser();
//         await saveUserDataToDatabase(userCredential);
//         SharedPreferences prefs = await SharedPreferences.getInstance();
//         await prefs.setBool('isLoggedIn', true);
//         // Navigate to home screen
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (context) => HomeScreen()),
//         );
//       } on FirebaseAuthException catch (e) {
//         if (e.code == 'email-already-in-use') {
//           // Email address is already in use
//           showDialog(
//             context: context,
//             builder: (context) => AlertDialog(
//               title: Text('Sign up failed'),
//               content: Text('The email address you entered is already in use.'),
//               actions: <Widget>[
//                 TextButton(
//                   child: Text('OK'),
//                   onPressed: () {
//                     Navigator.of(context).pop();
//                   },
//                 ),
//               ],
//             ),
//           );
//         } else {
//           print('Error creating user: ${e.message}');
//         }
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder(
//       future: SharedPreferences.getInstance(),
//       builder:
//           (BuildContext context, AsyncSnapshot<SharedPreferences> snapshot) {
//         if (snapshot.hasData) {
//           bool isLoggedIn = snapshot.data!.getBool('isLoggedIn') ?? false;
//           if (isLoggedIn) {
//             return HomeScreen();
//           } else {
//             bool hasSignedUp = snapshot.data!.getBool('hasSignedUp') ?? false;
//             if (hasSignedUp) {
//               return LoginScreen();
//             } else {
//               return Container(
//                 decoration: const BoxDecoration(
//                     image: DecorationImage(
//                   image: AssetImage('assets/images/oscflogin.jpg'),
//                   fit: BoxFit.cover,
//                 )),
//                 child: Scaffold(
//                   backgroundColor: Colors.transparent,
//                   body: SingleChildScrollView(
//                     child: Container(
//                       padding: EdgeInsets.only(
//                         top: MediaQuery.of(context).size.height * 0.24,
//                         right: 35,
//                         left: 20,
//                       ),
//                       child: Form(
//                         key: _formKey,
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.stretch,
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Center(
//                               child: buildTitle(),
//                             ),
//                             SizedBox(
//                               height: 5,
//                             ),
//                             Center(
//                               child: const Text(
//                                 'Create your account',
//                                 style: TextStyle(
//                                     color: Colors.black,
//                                     fontWeight: FontWeight.w400,
//                                     fontSize: 14),
//                               ),
//                             ),
//                             SizedBox(
//                               height: 50,
//                             ),

//                             buildTextFormField(
//                               controller: _usernameController,
//                               hintText: 'Username',
//                               prefixIcon: Icons.supervised_user_circle,
//                               validator: (value) {
//                                 if (value == null || value.isEmpty) {
//                                   return 'Please enter your username';
//                                 }
//                                 return null;
//                               },
//                               textInputAction: TextInputAction.next,
//                             ),

//                             sizedBox(),

//                             buildTextFormField(
//                               controller: _emailController,
//                               hintText: 'Email',
//                               prefixIcon: Icons.email_rounded,
//                               keyboardType: TextInputType.emailAddress,
//                               validator: (value) {
//                                 if (value == null || value.isEmpty) {
//                                   return 'Please enter your email';
//                                 }
//                                 if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
//                                     .hasMatch(value)) {
//                                   return 'Please enter a valid email address';
//                                 }
//                                 return null;
//                               },
//                               textInputAction: TextInputAction.next,
//                             ),

//                             sizedBox(),

//                             buildTextFormField(
//                               controller: _passwordController,
//                               hintText: 'Password',
//                               prefixIcon: Icons.password_rounded,
//                               keyboardType: TextInputType.emailAddress,
//                               obscureText: true,
//                               validator: (value) {
//                                 if (value == null || value.isEmpty) {
//                                   return 'Please enter a password';
//                                 }
//                                 if (value.length < 6) {
//                                   return 'Password must be at least 6 characters long';
//                                 }
//                                 if (!RegExp(
//                                         r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{6,}$')
//                                     .hasMatch(value)) {
//                                   return 'Password must contain at least one uppercase letter, one lowercase letter, one digit, and one special character';
//                                 }
//                                 return null;
//                               },
//                               textInputAction: TextInputAction.next,
//                             ),

//                             sizedBox(),

//                             buildTextFormField(
//                               controller: _confirmPasswordController,
//                               hintText: 'Confirm Password',
//                               prefixIcon: Icons.password_rounded,
//                               keyboardType: TextInputType.emailAddress,
//                               obscureText: true,
//                               validator: (value) {
//                                 if (value == null || value.isEmpty) {
//                                   return 'Please confirm your password';
//                                 }
//                                 if (value != _passwordController.text) {
//                                   return 'Passwords do not match';
//                                 }
//                                 return null;
//                               },
//                               textInputAction: TextInputAction.done,
//                             ),

//                             sizedBox(),
//                             TextButton(
//                               child: Text(
//                                 'Create Account',
//                                 style: TextStyle(
//                                     fontSize: 16,
//                                     color: Colors.black,
//                                     fontWeight: FontWeight.bold),
//                               ),
//                               onPressed: _submitForm,
//                               style: ButtonStyle(
//                                   shape: MaterialStateProperty.all<
//                                       RoundedRectangleBorder>(
//                                     RoundedRectangleBorder(
//                                       borderRadius: BorderRadius.circular(
//                                           40.0), // Border radius
//                                     ),
//                                   ),
//                                   backgroundColor:
//                                       MaterialStateProperty.all<Color>(
//                                     const Color(0xFF389EA3),
//                                   ),
//                                   foregroundColor:
//                                       MaterialStateProperty.all<Color>(
//                                           Colors.black),
//                                   minimumSize:
//                                       MaterialStateProperty.all(Size(30, 50))),
//                             ),
//                             SizedBox(
//                                 height:
//                                     15.0), // Add some spacing between the buttons

//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 Text(
//                                   'Already have an account?',
//                                   style: TextStyle(color: Colors.black),
//                                 ),
//                                 TextButton(
//                                   child: Text(
//                                     'Sign In',
//                                     style: TextStyle(
//                                         color: Colors.black,
//                                         fontWeight: FontWeight.bold),
//                                   ),
//                                   onPressed: _navigateToLoginScreen,
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               );
//             }
//           }
//         } else {
//           return SplashScreen(); // show a loading screen while loading shared preferences
//         }
//       },
//     );
//   }

//   Widget buildTitle() {
//     return const Text(
//       'REGISTER',
//       style: TextStyle(
//           letterSpacing: 3,
//           color: Colors.black,
//           fontWeight: FontWeight.bold,
//           fontSize: 32),
//     );
//   }

//   Widget sizedBox() {
//     return SizedBox(
//       height: 20,
//     );
//   }

//   Widget buildTextFormField({
//     required TextEditingController controller,
//     required String hintText,
//     required IconData prefixIcon,
//     TextInputType keyboardType = TextInputType.text,
//     required String? Function(String?) validator,
//     TextInputAction textInputAction = TextInputAction.done,
//     bool obscureText = false,
//   }) {
//     return TextFormField(
//       controller: controller,
//       decoration: InputDecoration(
//         filled: true,
//         fillColor: const Color(0xFF93c1c4),
//         focusedBorder: OutlineInputBorder(
//           borderSide: BorderSide(color: Colors.transparent),
//           borderRadius: BorderRadius.circular(20.0),
//         ),
//         enabledBorder: OutlineInputBorder(
//           borderSide: BorderSide(color: Colors.transparent),
//           borderRadius: BorderRadius.circular(20.0),
//         ),
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(20),
//         ),
//         hintText: hintText,
//         hintStyle: TextStyle(color: Colors.black87),
//         prefixIcon: Icon(
//           prefixIcon,
//           color: Colors.black,
//         ),
//       ),
//       keyboardType: keyboardType,
//       obscureText: obscureText,
//       validator: validator,
//       textInputAction: textInputAction,
//     );
//   }

//   void _navigateToLoginScreen() {
//     Navigator.pushReplacement(
//       context,
//       MaterialPageRoute(builder: (context) => LoginScreen()),
//     );
//   }

//   Future<bool> checkUsernameExist(String username) async {
//     final result = await FirebaseFirestore.instance
//         .collection('users')
//         .where('username', isEqualTo: username.toLowerCase())
//         .get();
//     return result.docs.isNotEmpty;
//   }

//   Future<UserCredential> signUpUser() async {
//     UserCredential userCredential =
//         await FirebaseAuth.instance.createUserWithEmailAndPassword(
//       email: _emailController.text,
//       password: _passwordController.text,
//     );
//     return userCredential;
//   }

//   Future<void> saveUserDataToDatabase(UserCredential userCredential) async {
//     String userId = userCredential.user!.uid;
//     ProfileModel profileModel = ProfileModel();
//     profileModel.email = _emailController.text;
//     profileModel.uid = userId;
//     profileModel.username = _usernameController.text.toLowerCase();

//     CollectionReference usersCollection =
//         FirebaseFirestore.instance.collection('users');

//     await usersCollection.doc(userId).set(profileModel.toMap());
//   }
// }

// ignore_for_file: unused_field, prefer_final_fields, prefer_const_constructors, use_build_context_synchronously, use_key_in_widget_constructors, library_private_types_in_public_api, avoid_print, sort_child_properties_last, unrelated_type_equality_checks, unused_local_variable, deprecated_member_use

import 'package:project/Import/imports.dart';

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _usernameController;
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final TextEditingController _confirmPasswordController;
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
  }

  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _db = FirebaseFirestore.instance;

  void _submitForm() async {
    if (_formKey.currentState!.validate() && !isLoading) {
      setState(() {
        isLoading = true;
      });
      _formKey.currentState!.save();

      bool usernameExists = await checkUsernameExist(_usernameController.text);

      if (usernameExists) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Sign up failed'),
            content: Text('The username you entered is already in use.'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
        return;
      }

      try {
        UserCredential userCredential = await signUpUser();
        await saveUserDataToDatabase(userCredential);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);
        // Navigate to home screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      } on FirebaseAuthException catch (e) {
        if (e.code == 'email-already-in-use') {
          // Email address is already in use
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Sign up failed'),
              content: Text('The email address you entered is already in use.'),
              actions: <Widget>[
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        } else {
          print('Error creating user: ${e.message}');
        }
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: SharedPreferences.getInstance(),
      builder:
          (BuildContext context, AsyncSnapshot<SharedPreferences> snapshot) {
        if (snapshot.hasData) {
          bool isLoggedIn = snapshot.data!.getBool('isLoggedIn') ?? false;
          if (isLoggedIn) {
            return HomeScreen();
          } else {
            bool hasSignedUp = snapshot.data!.getBool('hasSignedUp') ?? false;
            if (hasSignedUp) {
              return LoginScreen();
            } else {
              return Scaffold(
                backgroundColor: Color(0xFF012630),
                body: SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.18,
                      right: 35,
                      left: 20,
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Center(
                            child: buildTitle(),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Center(
                            child: const Text(
                              'Create your account',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14),
                            ),
                          ),
                          SizedBox(
                            height: 50,
                          ),

                          buildTextFormField(
                            controller: _usernameController,
                            hintText: 'Username',
                            prefixIcon: Icons.supervised_user_circle,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your username';
                              }
                              return null;
                            },
                            textInputAction: TextInputAction.next,
                          ),

                          sizedBox(),

                          buildTextFormField(
                            controller: _emailController,
                            hintText: 'Email',
                            prefixIcon: Icons.email_rounded,
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your email';
                              }
                              if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                                  .hasMatch(value)) {
                                return 'Please enter a valid email address';
                              }
                              return null;
                            },
                            textInputAction: TextInputAction.next,
                          ),

                          sizedBox(),

                          buildTextFormField(
                            controller: _passwordController,
                            hintText: 'Password',
                            prefixIcon: Icons.password_rounded,
                            keyboardType: TextInputType.emailAddress,
                            obscureText: true,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a password';
                              }
                              if (value.length < 6) {
                                return 'Password must be at least 6 characters long';
                              }
                              if (!RegExp(
                                      r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{6,}$')
                                  .hasMatch(value)) {
                                return 'Password must contain at least one uppercase letter, one lowercase letter, one digit, and one special character';
                              }
                              return null;
                            },
                            textInputAction: TextInputAction.next,
                          ),

                          sizedBox(),

                          buildTextFormField(
                            controller: _confirmPasswordController,
                            hintText: 'Confirm Password',
                            prefixIcon: Icons.password_rounded,
                            keyboardType: TextInputType.emailAddress,
                            obscureText: true,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please confirm your password';
                              }
                              if (value != _passwordController.text) {
                                return 'Passwords do not match';
                              }
                              return null;
                            },
                            textInputAction: TextInputAction.done,
                          ),

                          sizedBox(),
                          TextButton(
                            child: isLoading
                                ? CircularProgressIndicator() // Show loading indicator
                                : Text(
                                    'Create Account',
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: Color(0xFF012630),
                                        fontWeight: FontWeight.bold),
                                  ),
                            onPressed: _submitForm,
                            style: ButtonStyle(
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        40.0), // Border radius
                                  ),
                                ),
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                  const Color(0xFFD9D9D9),
                                ),
                                foregroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.black),
                                minimumSize:
                                    MaterialStateProperty.all(Size(30, 50))),
                          ),
                          SizedBox(
                              height:
                                  15.0), // Add some spacing between the buttons

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Already have an account?',
                                style: TextStyle(color: Colors.white),
                              ),
                              TextButton(
                                child: Text(
                                  'Sign In',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                                onPressed: _navigateToLoginScreen,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }
          }
        } else {
          return SplashScreen(); // show a loading screen while loading shared preferences
        }
      },
    );
  }

  Widget buildTitle() {
    return const Text(
      'New User',
      style: TextStyle(
          letterSpacing: 2,
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 28),
    );
  }

  Widget sizedBox() {
    return SizedBox(
      height: 20,
    );
  }

  Widget buildTextFormField({
    required TextEditingController controller,
    required String hintText,
    required IconData prefixIcon,
    TextInputType keyboardType = TextInputType.text,
    required String? Function(String?) validator,
    TextInputAction textInputAction = TextInputAction.done,
    bool obscureText = false,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0xFFD9D9D9),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
          borderRadius: BorderRadius.circular(20.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
          borderRadius: BorderRadius.circular(20.0),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.black87),
        prefixIcon: Icon(
          prefixIcon,
          color: Colors.black,
        ),
      ),
      keyboardType: keyboardType,
      obscureText: obscureText,
      validator: validator,
      textInputAction: textInputAction,
    );
  }

  void _navigateToLoginScreen() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

  Future<bool> checkUsernameExist(String username) async {
    final result = await FirebaseFirestore.instance
        .collection('users')
        .where('username', isEqualTo: username.toLowerCase())
        .get();
    return result.docs.isNotEmpty;
  }

  Future<UserCredential> signUpUser() async {
    UserCredential userCredential =
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: _emailController.text,
      password: _passwordController.text,
    );
    return userCredential;
  }

  Future<void> saveUserDataToDatabase(UserCredential userCredential) async {
    String userId = userCredential.user!.uid;
    ProfileModel profileModel = ProfileModel();
    profileModel.email = _emailController.text;
    profileModel.uid = userId;
    profileModel.username = _usernameController.text.toLowerCase();

    CollectionReference usersCollection =
        FirebaseFirestore.instance.collection('users');

    await usersCollection.doc(userId).set(profileModel.toMap());
  }
}
