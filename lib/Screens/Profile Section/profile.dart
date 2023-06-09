// ignore_for_file: prefer_final_fields, unnecessary_string_interpolations, library_private_types_in_public_api, deprecated_member_use, avoid_print, use_build_context_synchronously

// import 'package:project/Import/imports.dart';

// class ProfileScreen extends StatefulWidget {
//   const ProfileScreen({Key? key}) : super(key: key);

//   @override
//   _ProfileScreenState createState() => _ProfileScreenState();
// }

// class _ProfileScreenState extends State<ProfileScreen> {
//   String username = '';
//   String email = '';
//   String profileImageUrl = '';

//   TextEditingController _usernameController = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//     fetchUserData();
//   }

//   Future<void> fetchUserData() async {
//     String? userId = FirebaseAuth.instance.currentUser?.uid;

//     // First, try fetching the data from the cache
//     DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
//         .collection('users')
//         .doc(userId)
//         .get(const GetOptions(source: Source.cache));

//     if (userSnapshot.exists) {
//       Map<String, dynamic>? userData =
//           userSnapshot.data() as Map<String, dynamic>?;

//       if (userData != null) {
//         setState(() {
//           username = userData['username'] ?? '';
//           email = userData['email'] ?? '';
//           _usernameController.text = username;
//           profileImageUrl = userData['profileImageUrl'] ?? '';
//         });
//       }
//     }
//   }

//   Future<void> _logout() async {
//     try {
//       await FirebaseAuth.instance.signOut();

//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       await prefs.setBool('isLoggedIn', false);

//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (context) => LoginScreen()),
//       );
//     } catch (error) {
//       print('Error logging out: $error');
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Failed to log out')),
//       );
//     }
//   }

//   // Future<void> _uploadImage() async {
//   //   final picker = ImagePicker();
//   //   final pickedImage = await picker.getImage(source: ImageSource.gallery);

//   //   if (pickedImage != null) {
//   //     File imageFile = File(pickedImage.path);

//   //     try {
//   //       String? userId = FirebaseAuth.instance.currentUser?.uid;
//   //       String imageName = '$userId.jpg';
//   //       Reference storageReference = FirebaseStorage.instance
//   //           .ref()
//   //           .child('users/$userId/profile_images/$imageName');

//   //       UploadTask uploadTask = storageReference.putFile(imageFile);
//   //       TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});
//   //       String imageUrl = await taskSnapshot.ref.getDownloadURL();

//   //       // Update profile image URL in Firestore
//   //       DocumentReference userRef =
//   //           FirebaseFirestore.instance.collection('users').doc(userId);

//   //       await FirebaseFirestore.instance.runTransaction((transaction) async {
//   //         DocumentSnapshot snapshot = await transaction.get(userRef);

//   //         if (snapshot.exists) {
//   //           ProfileModel profile =
//   //               ProfileModel.fromMap(snapshot.data() as Map<String, dynamic>);

//   //           profile.profileImageUrl = imageUrl;

//   //           transaction.update(userRef, profile.toMap());

//   //           setState(() {
//   //             profileImageUrl = imageUrl;
//   //           });
//   //         }
//   //       });
//   //     } catch (error) {
//   //       // Handle any errors that occur during image upload
//   //       print('Error uploading image: $error');
//   //     }
//   //   }
//   // }

//   Future<void> _uploadImage() async {
//     final picker = ImagePicker();
//     final pickedImage = await picker.getImage(source: ImageSource.gallery);

//     if (pickedImage != null) {
//       File imageFile = File(pickedImage.path);

//       try {
//         String? userId = FirebaseAuth.instance.currentUser?.uid;
//         String imageName = '$userId.jpg';
//         Reference storageReference = FirebaseStorage.instance
//             .ref()
//             .child('users/$userId/profile_images/$imageName');

//         UploadTask uploadTask = storageReference.putFile(imageFile);
//         TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});
//         String imageUrl = await taskSnapshot.ref.getDownloadURL();

//         // Update profile image URL in Firestore
//         DocumentReference userRef =
//             FirebaseFirestore.instance.collection('users').doc(userId);

//         await FirebaseFirestore.instance.runTransaction((transaction) async {
//           DocumentSnapshot snapshot = await transaction.get(userRef);

//           if (snapshot.exists) {
//             ProfileModel profile =
//                 ProfileModel.fromMap(snapshot.data() as Map<String, dynamic>);

//             profile.profileImageUrl = imageUrl;

//             transaction.update(userRef, profile.toMap());

//             setState(() {
//               profileImageUrl = imageUrl;
//             });
//           }
//         });
//       } catch (error) {
//         // Handle any errors that occur during image upload
//         print('Error uploading image: $error');
//       }
//     }
//   }

//   Future<void> _updateUsername() async {
//     String? newUsername = _usernameController.text.trim().toLowerCase();

//     if (newUsername.isNotEmpty) {
//       try {
//         String? userId = FirebaseAuth.instance.currentUser?.uid;
//         DocumentReference userRef =
//             FirebaseFirestore.instance.collection('users').doc(userId);

//         // Check if the new username already exists in Firestore
//         QuerySnapshot querySnapshot = await FirebaseFirestore.instance
//             .collection('users')
//             .where('username', isEqualTo: newUsername)
//             .get();

//         if (querySnapshot.docs.isNotEmpty) {
//           // Username already exists
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(content: Text('Username already exists')),
//           );
//         } else {
//           await userRef.update({'username': newUsername});

//           // Update the username in the state
//           setState(() {
//             username = newUsername;
//           });

//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(content: Text('Username updated successfully')),
//           );
//         }
//       } catch (error) {
//         print('Error updating username: $error');
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Failed to update username')),
//         );
//       }
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Please enter a valid username')),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFF012630),
//       appBar: AppBar(
//         backgroundColor: const Color(0xFF012630),
//         centerTitle: true,
//         title: const Text(
//           'Profile',
//           style: TextStyle(
//             color: const Color(0xFFD9D9D9),
//             fontSize: 20,
//           ),
//         ),
//         actions: [
//           IconButton(
//             onPressed: _logout,
//             icon: const Icon(Icons.logout),
//           ),
//         ],
//       ),
//       body: SingleChildScrollView(
//         child: Container(
//           padding: EdgeInsets.only(
//             top: MediaQuery.of(context).size.height * 0.07,
//             left: 20,
//             right: 20,
//           ),
//           child: Column(
//             children: [
//               const SizedBox(height: 20),
//               GestureDetector(
//                 onTap: _uploadImage,
//                 child: Center(
//                   child: CircleAvatar(
//                     radius: 80,
//                     backgroundImage: profileImageUrl.isNotEmpty
//                         ? NetworkImage(profileImageUrl) as ImageProvider<Object>
//                         : const AssetImage('assets/images/OSCF logo.png'),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 25),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     'Username: $username',
//                     style: const TextStyle(
//                       color: Colors.white,
//                       fontSize: 18,
//                     ),
//                   ),
//                   const SizedBox(height: 10),
//                   IconButton(
//                     onPressed: () {
//                       showDialog(
//                         context: context,
//                         builder: (BuildContext context) {
//                           return AlertDialog(
//                             title: const Text('Update Username'),
//                             content: TextField(
//                               controller: _usernameController,
//                               style: const TextStyle(color: Colors.black),
//                               decoration: const InputDecoration(
//                                 hintText: 'Enter new username',
//                               ),
//                             ),
//                             actions: [
//                               TextButton(
//                                 onPressed: () {
//                                   Navigator.pop(context);
//                                 },
//                                 child: const Text('Cancel'),
//                               ),
//                               TextButton(
//                                 onPressed: _updateUsername,
//                                 child: const Text('Update'),
//                               ),
//                             ],
//                           );
//                         },
//                       );
//                     },
//                     icon: const Icon(Icons.edit, color: Colors.white),
//                   ),
//                 ],
//               ),
//               const SizedBox(
//                 height: 20,
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 children: [
//                   Text(
//                     'Email: $email',
//                     style: const TextStyle(
//                       color: Colors.white,
//                       fontSize: 18,
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 20),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
// Future<void> fetchUserData() async {
//   String? userId = FirebaseAuth.instance.currentUser?.uid;
//   DocumentSnapshot userSnapshot =
//       await FirebaseFirestore.instance.collection('users').doc(userId).get();

//   if (userSnapshot.exists) {
//     Map<String, dynamic>? userData =
//         userSnapshot.data() as Map<String, dynamic>?;

//     if (userData != null) {
//       setState(() {
//         username = userData['username'] ?? '';
//         email = userData['email'] ?? '';
//         _usernameController.text = username;
//         profileImageUrl = userData['profileImageUrl'] ?? '';
//       });
//     }
//   }
// }

// void updateUsername(String newUsername) {
//   setState(() {
//     username = newUsername;
//   });
// }

// Text(
//   'Username: $username',
//   style: const TextStyle(
//     color: Colors.white,
//     fontSize: 18,
//   ),
// ),
// const SizedBox(height: 10),
// if (!userSnapshot.exists) {
//   // If the data is not available in the cache, fetch it from the server
//   userSnapshot = await FirebaseFirestore.instance
//       .collection('users')
//       .doc(userId)
//       .get(const GetOptions(source: Source.server));
// }

// Future<void> _uploadImage() async {
//   final picker = ImagePicker();
//   final pickedImage = await picker.getImage(source: ImageSource.gallery);

//   if (pickedImage != null) {
//     File imageFile = File(pickedImage.path);

//     try {
//       String? userId = FirebaseAuth.instance.currentUser?.uid;
//       String imageName = '$userId.jpg';
//       Reference storageReference = FirebaseStorage.instance
//           .ref()
//           .child('users/$userId/profile_images/$imageName');

//       UploadTask uploadTask = storageReference.putFile(imageFile);
//       TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});
//       String imageUrl = await taskSnapshot.ref.getDownloadURL();

//       // Update profile image URL in Firestore
//       DocumentReference userRef =
//           FirebaseFirestore.instance.collection('users').doc(userId);

//       await FirebaseFirestore.instance.runTransaction((transaction) async {
//         DocumentSnapshot snapshot = await transaction.get(userRef);

//         if (snapshot.exists) {
//           ProfileModel profile =
//               ProfileModel.fromMap(snapshot.data() as Map<String, dynamic>);

//           profile.profileImageUrl = imageUrl;

//           transaction.update(userRef, profile.toMap());
//         }
//       });
//     } catch (error) {
//       // Handle any errors that occur during image upload
//       print('Error uploading image: $error');
//     }
//   }
// }

// import 'package:project/Import/imports.dart';

// class ProfileScreen extends StatefulWidget {
//   const ProfileScreen({Key? key}) : super(key: key);

//   @override
//   _ProfileScreenState createState() => _ProfileScreenState();
// }

// class _ProfileScreenState extends State<ProfileScreen> {
//   String username = '';
//   String email = '';
//   String profileImageUrl = '';

//   TextEditingController _usernameController = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//     fetchUserData();
//   }

//   Future<void> fetchUserData() async {
//     String? userId = FirebaseAuth.instance.currentUser?.uid;

//     // First, try fetching the data from the cache
//     DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
//         .collection('users')
//         .doc(userId)
//         .get(GetOptions(source: Source.cache));

//     if (userSnapshot.exists) {
//       Map<String, dynamic>? userData =
//           userSnapshot.data() as Map<String, dynamic>?;

//       if (userData != null) {
//         setState(() {
//           username = userData['username'] ?? '';
//           email = userData['email'] ?? '';
//           _usernameController.text = username;
//           profileImageUrl = userData['profileImageUrl'] ?? '';
//         });
//       }
//     }
//   }

//   Future<void> _logout() async {
//     try {
//       await FirebaseAuth.instance.signOut();

//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       await prefs.setBool('isLoggedIn', false);

//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (context) => LoginScreen()),
//       );
//     } catch (error) {
//       print('Error logging out: $error');
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Failed to log out')),
//       );
//     }
//   }

//   Future<void> _uploadImage() async {
//     final picker = ImagePicker();
//     final pickedImage = await picker.getImage(source: ImageSource.gallery);

//     if (pickedImage != null) {
//       File imageFile = File(pickedImage.path);

//       try {
//         String? userId = FirebaseAuth.instance.currentUser?.uid;
//         String imageName = '$userId.jpg';
//         Reference storageReference = FirebaseStorage.instance
//             .ref()
//             .child('users')
//             .child(userId!)
//             .child('profile_images')
//             .child(imageName);

//         UploadTask uploadTask = storageReference.putFile(imageFile);

//         uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
//           if (snapshot.state == TaskState.success) {
//             snapshot.ref.getDownloadURL().then((imageUrl) async {

//               DocumentReference userRef =
//                   FirebaseFirestore.instance.collection('users').doc(userId);

//               await userRef.update({'profileImageUrl': imageUrl});

//               setState(() {
//                 profileImageUrl = imageUrl;
//               });
//             });
//           }
//         });
//       } catch (error) {
//         // Handle any errors that occur during image upload
//         print('Error uploading image: $error');
//       }
//     }
//   }

//   Future<void> _updateUsername() async {
//     String newUsername = _usernameController.text.trim().toLowerCase();

//     if (newUsername.isNotEmpty) {
//       try {
//         String? userId = FirebaseAuth.instance.currentUser?.uid;
//         DocumentReference userRef =
//             FirebaseFirestore.instance.collection('users').doc(userId);

//         // Check if the new username already exists in Firestore
//         QuerySnapshot querySnapshot = await FirebaseFirestore.instance
//             .collection('users')
//             .where('username', isEqualTo: newUsername)
//             .get();

//         if (querySnapshot.docs.isNotEmpty) {
//           // Username already exists
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(content: Text('Username already exists')),
//           );
//         } else {
//           await userRef.update({'username': newUsername});

//           // Update the username in the state
//           setState(() {
//             username = newUsername;
//           });

//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(content: Text('Username updated successfully')),
//           );
//         }
//       } catch (error) {
//         print('Error updating username: $error');
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Failed to update username')),
//         );
//       }
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Please enter a valid username')),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFF012630),
//       appBar: AppBar(
//         backgroundColor: const Color(0xFF012630),
//         centerTitle: true,
//         title: const Text(
//           'Profile',
//           style: TextStyle(
//             color: const Color(0xFFD9D9D9),
//             fontSize: 20,
//           ),
//         ),
//         actions: [
//           IconButton(
//             onPressed: _logout,
//             icon: const Icon(Icons.logout),
//           ),
//         ],
//       ),
//       body: SingleChildScrollView(
//         child: Container(
//           padding: EdgeInsets.only(
//             top: MediaQuery.of(context).size.height * 0.07,
//             left: 20,
//             right: 20,
//           ),
//           child: Column(
//             children: [
//               const SizedBox(height: 20),
//               GestureDetector(
//                 onTap: _uploadImage,
//                 child: Center(
//                   child: CircleAvatar(
//                     radius: 80,
//                     backgroundImage: profileImageUrl.isNotEmpty
//                         ? NetworkImage(profileImageUrl) as ImageProvider<Object>
//                         : const AssetImage('assets/images/OSCF logo.png'),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 25),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     'Username: $username',
//                     style: const TextStyle(
//                       color: Colors.white,
//                       fontSize: 18,
//                     ),
//                   ),
//                   const SizedBox(height: 10),
//                   IconButton(
//                     onPressed: () {
//                       showDialog(
//                         context: context,
//                         builder: (BuildContext context) {
//                           return AlertDialog(
//                             title: const Text('Update Username'),
//                             content: TextField(
//                               controller: _usernameController,
//                               style: const TextStyle(color: Colors.black),
//                               decoration: const InputDecoration(
//                                 hintText: 'Enter new username',
//                               ),
//                             ),
//                             actions: [
//                               TextButton(
//                                 onPressed: () {
//                                   Navigator.pop(context);
//                                 },
//                                 child: const Text('Cancel'),
//                               ),
//                               TextButton(
//                                 onPressed: _updateUsername,
//                                 child: const Text('Update'),
//                               ),
//                             ],
//                           );
//                         },
//                       );
//                     },
//                     icon: const Icon(Icons.edit, color: Colors.white),
//                   ),
//                 ],
//               ),
//               const SizedBox(
//                 height: 20,
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 children: [
//                   Text(
//                     'Email: $email',
//                     style: const TextStyle(
//                       color: Colors.white,
//                       fontSize: 18,
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 20),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
// Future<void> _uploadImage() async {
//   final picker = ImagePicker();
//   final pickedImage = await picker.getImage(source: ImageSource.gallery);

//   if (pickedImage != null) {
//     File imageFile = File(pickedImage.path);

//     try {
//       String? userId = FirebaseAuth.instance.currentUser?.uid;
//       String imageName = '$userId.jpg';
//       Reference storageReference = FirebaseStorage.instance
//           .ref()
//           .child('users/$userId/profile_images/$imageName');

//       UploadTask uploadTask = storageReference.putFile(imageFile);
//       TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});
//       String imageUrl = await taskSnapshot.ref.getDownloadURL();

//       // Update profile image URL in Firestore
//       DocumentReference userRef =
//           FirebaseFirestore.instance.collection('users').doc(userId);

//       await FirebaseFirestore.instance.runTransaction((transaction) async {
//         DocumentSnapshot snapshot = await transaction.get(userRef);

//         if (snapshot.exists) {
//           ProfileModel profile =
//               ProfileModel.fromMap(snapshot.data() as Map<String, dynamic>);

//           profile.profileImageUrl = imageUrl;

//           transaction.update(userRef, profile.toMap());
//         }
//       });
//     } catch (error) {
//       // Handle any errors that occur during image upload
//       print('Error uploading image: $error');
//     }
//   }
// }

// import 'package:project/Import/imports.dart';

// class ProfileScreen extends StatefulWidget {
//   const ProfileScreen({Key? key}) : super(key: key);

//   @override
//   _ProfileScreenState createState() => _ProfileScreenState();
// }

// class _ProfileScreenState extends State<ProfileScreen> {
//   late Stream<DocumentSnapshot> userDataStream;
//   String username = '';
//   String email = '';
//   String profileImageUrl = '';

//   TextEditingController _usernameController = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//     fetchUserData();
//   }

//   Future<void> fetchUserData() async {
//     String? userId = FirebaseAuth.instance.currentUser?.uid;

//     DocumentReference userRef =
//         FirebaseFirestore.instance.collection('users').doc(userId);

//     // Subscribe to real-time updates for the user's data
//     userDataStream = userRef.snapshots();

//     // Fetch initial data
//     DocumentSnapshot userSnapshot = await userRef.get();

//     if (userSnapshot.exists) {
//       Map<String, dynamic>? userData =
//           userSnapshot.data() as Map<String, dynamic>?;

//       if (userData != null) {
//         setState(() {
//           username = userData['username'] ?? '';
//           email = userData['email'] ?? '';
//           _usernameController.text = username;
//           profileImageUrl = userData['profileImageUrl'] ?? '';
//         });
//       }
//     }
//   }

//   Future<void> _logout() async {
//     try {
//       await FirebaseAuth.instance.signOut();

//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       await prefs.setBool('isLoggedIn', false);

//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (context) => LoginScreen()),
//       );
//     } catch (error) {
//       print('Error logging out: $error');
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Failed to log out')),
//       );
//     }
//   }

//   Future<void> _uploadImage() async {
//     final picker = ImagePicker();
//     final pickedImage = await picker.getImage(source: ImageSource.gallery);

//     if (pickedImage != null) {
//       File imageFile = File(pickedImage.path);

//       try {
//         String? userId = FirebaseAuth.instance.currentUser?.uid;
//         String imageName = '$userId.jpg';
//         Reference storageReference = FirebaseStorage.instance
//             .ref()
//             .child('users')
//             .child(userId!)
//             .child('profile_images')
//             .child(imageName);

//         UploadTask uploadTask = storageReference.putFile(imageFile);

//         uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
//           if (snapshot.state == TaskState.success) {
//             snapshot.ref.getDownloadURL().then((imageUrl) async {
//               DocumentReference userRef =
//                   FirebaseFirestore.instance.collection('users').doc(userId);

//               await userRef.update({'profileImageUrl': imageUrl});

//               setState(() {
//                 profileImageUrl = imageUrl;
//               });
//             });
//           }
//         });
//       } catch (error) {
//         // Handle any errors that occur during image upload
//         print('Error uploading image: $error');
//       }
//     }
//   }

//   Future<void> _updateUsername() async {
//     String newUsername = _usernameController.text.trim().toLowerCase();

//     if (newUsername.isNotEmpty) {
//       try {
//         String? userId = FirebaseAuth.instance.currentUser?.uid;
//         DocumentReference userRef =
//             FirebaseFirestore.instance.collection('users').doc(userId);

//         // Check if the new username already exists in Firestore
//         QuerySnapshot querySnapshot = await FirebaseFirestore.instance
//             .collection('users')
//             .where('username', isEqualTo: newUsername)
//             .get();

//         if (querySnapshot.docs.isNotEmpty) {
//           // Username already exists
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(content: Text('Username already exists')),
//           );
//         } else {
//           await userRef.update({'username': newUsername});

//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(content: Text('Username updated successfully')),
//           );
//         }
//       } catch (error) {
//         print('Error updating username: $error');
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Failed to update username')),
//         );
//       }
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Please enter a valid username')),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFF012630),
//       appBar: AppBar(
//         backgroundColor: const Color(0xFF012630),
//         centerTitle: true,
//         title: const Text(
//           'Profile',
//           style: TextStyle(
//             color: const Color(0xFFD9D9D9),
//             fontSize: 20,
//           ),
//         ),
//         actions: [
//           IconButton(
//             onPressed: _logout,
//             icon: const Icon(Icons.logout),
//           ),
//         ],
//       ),
//       body: SingleChildScrollView(
//         child: Container(
//           padding: EdgeInsets.only(
//             top: MediaQuery.of(context).size.height * 0.07,
//             left: 20,
//             right: 20,
//           ),
//           child: StreamBuilder<DocumentSnapshot>(
//             stream: userDataStream,
//             builder: (BuildContext context,
//                 AsyncSnapshot<DocumentSnapshot> snapshot) {
//               if (snapshot.hasData) {
//                 Map<String, dynamic>? userData =
//                     snapshot.data?.data() as Map<String, dynamic>?;

//                 if (userData != null) {
//                   username = userData['username'] ?? '';
//                   email = userData['email'] ?? '';
//                   profileImageUrl = userData['profileImageUrl'] ?? '';
//                 }
//               }

//               return Column(
//                 children: [
//                   const SizedBox(height: 20),
//                   GestureDetector(
//                     onTap: _uploadImage,
//                     child: Center(
//                       child: CircleAvatar(
//                         radius: 80,
//                         backgroundImage: profileImageUrl.isNotEmpty
//                             ? NetworkImage(profileImageUrl)
//                                 as ImageProvider<Object>
//                             : const AssetImage('assets/images/OSCF logo.png'),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 25),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(
//                         'Username: $username',
//                         style: const TextStyle(
//                           color: Colors.white,
//                           fontSize: 18,
//                         ),
//                       ),
//                       const SizedBox(height: 10),
//                       IconButton(
//                         onPressed: () {
//                           showDialog(
//                             context: context,
//                             builder: (BuildContext context) {
//                               return AlertDialog(
//                                 title: const Text('Update Username'),
//                                 content: TextField(
//                                   controller: _usernameController,
//                                   style: const TextStyle(color: Colors.black),
//                                   decoration: const InputDecoration(
//                                     hintText: 'Enter new username',
//                                   ),
//                                 ),
//                                 actions: [
//                                   TextButton(
//                                     onPressed: () {
//                                       Navigator.pop(context);
//                                     },
//                                     child: const Text('Cancel'),
//                                   ),
//                                   TextButton(
//                                     onPressed: _updateUsername,
//                                     child: const Text('Update'),
//                                   ),
//                                 ],
//                               );
//                             },
//                           );
//                         },
//                         icon: const Icon(Icons.edit, color: Colors.white),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(
//                     height: 20,
//                   ),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     children: [
//                       Text(
//                         'Email: $email',
//                         style: const TextStyle(
//                           color: Colors.white,
//                           fontSize: 18,
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 20),
//                 ],
//               );
//             },
//           ),
//         ),
//       ),
//     );
//   }
// }
// import 'package:project/Import/imports.dart';

// class ProfileScreen extends StatefulWidget {
//   const ProfileScreen({Key? key}) : super(key: key);

//   @override
//   _ProfileScreenState createState() => _ProfileScreenState();
// }

// class _ProfileScreenState extends State<ProfileScreen> {
//   late Stream<DocumentSnapshot> userDataStream;
//   String username = '';
//   String email = '';
//   String profileImageUrl = '';

//   TextEditingController _usernameController = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//     fetchUserData();
//   }

//   Future<void> fetchUserData() async {
//     final userId = FirebaseAuth.instance.currentUser?.uid;

//     final userRef = FirebaseFirestore.instance.collection('users').doc(userId);

//     userDataStream = userRef.snapshots();

//     final userSnapshot = await userRef.get();

//     if (userSnapshot.exists) {
//       final userData = userSnapshot.data() as Map<String, dynamic>?;

//       if (userData != null) {
//         setState(() {
//           username = userData['username'] ?? '';
//           email = userData['email'] ?? '';
//           _usernameController.text = username;
//           profileImageUrl = userData['profileImageUrl'] ?? '';
//         });
//       }
//     }
//   }

//   Future<void> _logout() async {
//     try {
//       await FirebaseAuth.instance.signOut();

//       final prefs = await SharedPreferences.getInstance();
//       await prefs.setBool('isLoggedIn', false);

//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (context) => LoginScreen()),
//       );
//     } catch (error) {
//       print('Error logging out: $error');
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Failed to log out')),
//       );
//     }
//   }

//   Future<void> _uploadImage() async {
//     final picker = ImagePicker();
//     final pickedImage = await picker.getImage(source: ImageSource.gallery);

//     if (pickedImage != null) {
//       final imageFile = File(pickedImage.path);

//       try {
//         final userId = FirebaseAuth.instance.currentUser?.uid;
//         final imageName = '$userId.jpg';
//         final storageReference = FirebaseStorage.instance
//             .ref()
//             .child('users')
//             .child(userId!)
//             .child('profile_images')
//             .child(imageName);

//         final uploadTask = storageReference.putFile(imageFile);

//         uploadTask.snapshotEvents.listen((snapshot) async {
//           if (snapshot.state == TaskState.success) {
//             final imageUrl = await snapshot.ref.getDownloadURL();
//             final userRef =
//                 FirebaseFirestore.instance.collection('users').doc(userId);

//             await userRef.update({'profileImageUrl': imageUrl});

//             setState(() {
//               profileImageUrl = imageUrl;
//             });
//           }
//         });
//       } catch (error) {
//         print('Error uploading image: $error');
//       }
//     }
//   }

//   Future<void> _updateUsername() async {
//     final newUsername = _usernameController.text.trim().toLowerCase();

//     if (newUsername.isNotEmpty) {
//       try {
//         final userId = FirebaseAuth.instance.currentUser?.uid;
//         final userRef =
//             FirebaseFirestore.instance.collection('users').doc(userId);

//         final querySnapshot = await FirebaseFirestore.instance
//             .collection('users')
//             .where('username', isEqualTo: newUsername)
//             .get();

//         if (querySnapshot.docs.isNotEmpty) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(content: Text('Username already exists')),
//           );
//         } else {
//           await userRef.update({'username': newUsername});

//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(content: Text('Username updated successfully')),
//           );
//         }
//       } catch (error) {
//         print('Error updating username: $error');
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Failed to update username')),
//         );
//       }
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Please enter a valid username')),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFF012630),
//       appBar: AppBar(
//         backgroundColor: const Color(0xFF012630),
//         centerTitle: true,
//         title: const Text(
//           'Profile',
//           style: TextStyle(
//             color: const Color(0xFFD9D9D9),
//             fontSize: 20,
//           ),
//         ),
//         actions: [
//           IconButton(
//             onPressed: _logout,
//             icon: const Icon(Icons.logout),
//           ),
//         ],
//       ),
//       body: SingleChildScrollView(
//         padding: EdgeInsets.only(
//           top: MediaQuery.of(context).size.height * 0.07,
//           left: 20,
//           right: 20,
//         ),
//         child: StreamBuilder<DocumentSnapshot>(
//           stream: userDataStream,
//           builder: (context, snapshot) {
//             if (snapshot.hasData) {
//               final userData = snapshot.data?.data() as Map<String, dynamic>?;

//               if (userData != null) {
//                 username = userData['username'] ?? '';
//                 email = userData['email'] ?? '';
//                 profileImageUrl = userData['profileImageUrl'] ?? '';
//               }
//             }

//             return Column(
//               children: [
//                 const SizedBox(height: 20),
//                 GestureDetector(
//                   onTap: _uploadImage,
//                   child: Center(
//                     child: CircleAvatar(
//                       radius: 80,
//                       backgroundImage: profileImageUrl.isNotEmpty
//                           ? NetworkImage(profileImageUrl)
//                           : const AssetImage('assets/images/OSCF logo.png')
//                               as ImageProvider<Object>,
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 25),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(
//                       'Username: $username',
//                       style: const TextStyle(
//                         color: Colors.white,
//                         fontSize: 18,
//                       ),
//                     ),
//                     const SizedBox(height: 10),
//                     IconButton(
//                       onPressed: () {
//                         showDialog(
//                           context: context,
//                           builder: (context) {
//                             return AlertDialog(
//                               title: const Text('Update Username'),
//                               content: TextField(
//                                 controller: _usernameController,
//                                 style: const TextStyle(color: Colors.black),
//                                 decoration: const InputDecoration(
//                                   hintText: 'Enter new username',
//                                 ),
//                               ),
//                               actions: [
//                                 TextButton(
//                                   onPressed: () {
//                                     Navigator.pop(context);
//                                   },
//                                   child: const Text('Cancel'),
//                                 ),
//                                 TextButton(
//                                   onPressed: _updateUsername,
//                                   child: const Text('Update'),
//                                 ),
//                               ],
//                             );
//                           },
//                         );
//                       },
//                       icon: const Icon(Icons.edit, color: Colors.white),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 20),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   children: [
//                     Text(
//                       'Email: $email',
//                       style: const TextStyle(
//                         color: Colors.white,
//                         fontSize: 18,
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 20),
//               ],
//             );
//           },
//         ),
//       ),
//     );
//   }
// }

import 'package:cached_network_image/cached_network_image.dart';
import 'package:project/Import/imports.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late Stream<DocumentSnapshot> userDataStream;
  String username = '';
  String email = '';
  String profileImageUrl = '';
  bool isUploading = false;

  TextEditingController _usernameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  // Future<void> fetchUserData() async {
  //   final userId = FirebaseAuth.instance.currentUser?.uid;

  //   final userRef = FirebaseFirestore.instance.collection('users').doc(userId);

  //   userDataStream = userRef.snapshots();

  //   // No need to fetch initial data here as it will be handled by StreamBuilder
  // }
  void fetchUserData() {
    final userId = FirebaseAuth.instance.currentUser?.uid;

    final userRef = FirebaseFirestore.instance.collection('users').doc(userId);

    userDataStream = userRef.snapshots().map((snapshot) {
      if (snapshot.exists) {
        final userData = snapshot.data();
        if (userData != null) {
          username = userData['username'] ?? '';
          email = userData['email'] ?? '';
          profileImageUrl = userData['profileImageUrl'] ?? '';
        }
      }
      return snapshot;
    });
  }

  Future<void> _logout() async {
    try {
      await FirebaseAuth.instance.signOut();

      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', false);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    } catch (error) {
      print('Error logging out: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to log out')),
      );
    }
  }

  Future<void> _uploadImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.getImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      final imageFile = File(pickedImage.path);

      try {
        final userId = FirebaseAuth.instance.currentUser?.uid;
        final imageName = '$userId.jpg';
        final storageReference = FirebaseStorage.instance
            .ref()
            .child('users')
            .child(userId!)
            .child('profile_images')
            .child(imageName);

        final uploadTask = storageReference.putFile(imageFile);

        uploadTask.snapshotEvents.listen((snapshot) async {
          if (snapshot.state == TaskState.success) {
            final imageUrl = await snapshot.ref.getDownloadURL();
            final userRef =
                FirebaseFirestore.instance.collection('users').doc(userId);

            await userRef.update({'profileImageUrl': imageUrl});

            setState(() {
              profileImageUrl = imageUrl;
            });
          }
        });
      } catch (error) {
        print('Error uploading image: $error');
      }
    }
  }
  // Future<void> _uploadImage() async {
  //   final picker = ImagePicker();
  //   final pickedImage = await picker.getImage(source: ImageSource.gallery);

  //   if (pickedImage != null) {
  //     final imageFile = File(pickedImage.path);

  //     try {
  //       final userId = FirebaseAuth.instance.currentUser?.uid;
  //       final imageName = '$userId.jpg';
  //       final storageReference = FirebaseStorage.instance
  //           .ref()
  //           .child('users')
  //           .child(userId!)
  //           .child('profile_images')
  //           .child(imageName);

  //       final uploadTask = storageReference.putFile(imageFile);

  //       uploadTask.snapshotEvents.listen((snapshot) async {
  //         if (snapshot.state == TaskState.success) {
  //           final imageUrl = await snapshot.ref.getDownloadURL();
  //           setState(() {
  //             profileImageUrl = imageUrl;
  //           });

  //           final userRef =
  //               FirebaseFirestore.instance.collection('users').doc(userId);
  //           await userRef.update({'profileImageUrl': imageUrl});
  //         }
  //       });
  //     } catch (error) {
  //       print('Error uploading image: $error');
  //     }
  //   }
  // }
  // Future<void> _uploadImage() async {
  //   final picker = ImagePicker();
  //   final pickedImage = await picker.getImage(source: ImageSource.gallery);

  //   if (pickedImage != null) {
  //     setState(() {
  //       isUploading = true;
  //     });

  //     final imageFile = File(pickedImage.path);
  //     final compressedImageFile =
  //         await compressImage(imageFile); // Compress the image

  //     try {
  //       final userId = FirebaseAuth.instance.currentUser?.uid;
  //       final imageName = '$userId.jpg';
  //       final storageReference = FirebaseStorage.instance
  //           .ref()
  //           .child('users')
  //           .child(userId!)
  //           .child('profile_images')
  //           .child(imageName);

  //       final uploadTask = storageReference.putFile(compressedImageFile);

  //       await uploadTask.whenComplete(() => null);

  //       final imageUrl = await storageReference.getDownloadURL();

  //       setState(() {
  //         profileImageUrl = imageUrl;
  //         isUploading = false;
  //       });

  //       final userRef =
  //           FirebaseFirestore.instance.collection('users').doc(userId);
  //       await userRef.update({'profileImageUrl': imageUrl});
  //     } catch (error) {
  //       print('Error uploading image: $error');
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(content: Text('Failed to upload image')),
  //       );
  //       setState(() {
  //         isUploading = false;
  //       });
  //     }
  //   }
  // }

  // Future<File> compressImage(File imageFile) async {
  //   final compressedFile = await FlutterImageCompress.compressAndGetFile(
  //     imageFile.path,
  //     imageFile.path,
  //     quality: 70, // Adjust the quality as needed
  //   );
  //   return compressedFile as File? ?? imageFile;
  // }

  Future<void> _updateUsername() async {
    final newUsername = _usernameController.text.trim().toLowerCase();

    if (newUsername.isNotEmpty) {
      try {
        final userId = FirebaseAuth.instance.currentUser?.uid;
        final userRef =
            FirebaseFirestore.instance.collection('users').doc(userId);

        final querySnapshot = await FirebaseFirestore.instance
            .collection('users')
            .where('username', isEqualTo: newUsername)
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Username already exists')),
          );
        } else {
          await userRef.update({'username': newUsername});

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Username updated successfully')),
          );
        }
      } catch (error) {
        print('Error updating username: $error');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to update username')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid username')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF012630),
      appBar: AppBar(
        backgroundColor: const Color(0xFF012630),
        centerTitle: true,
        title: const Text(
          'Profile',
          style: TextStyle(
            color: const Color(0xFFD9D9D9),
            fontSize: 20,
          ),
        ),
        actions: [
          IconButton(
            onPressed: _logout,
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).size.height * 0.07,
          left: 20,
          right: 20,
        ),
        child: StreamBuilder<DocumentSnapshot>(
          stream: userDataStream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final userData = snapshot.data?.data() as Map<String, dynamic>?;

              if (userData != null) {
                username = userData['username'] ?? '';
                email = userData['email'] ?? '';
                profileImageUrl = userData['profileImageUrl'] ?? '';
              }
            }

            return Column(
              children: [
                const SizedBox(height: 20),
                // GestureDetector(
                //   onTap: _uploadImage,
                //   child: Center(
                //     child: CircleAvatar(
                //       radius: 80,
                //       backgroundImage: profileImageUrl.isNotEmpty
                //           ? NetworkImage(profileImageUrl)
                //           : const AssetImage('assets/images/OSCF logo.png')
                //               as ImageProvider<Object>,
                //     ),
                //   ),
                // ),
                GestureDetector(
                  onTap: _uploadImage,
                  child: Center(
                    child: CachedNetworkImage(
                      imageUrl: profileImageUrl,
                      imageBuilder: (context, imageProvider) => CircleAvatar(
                        radius: 80,
                        backgroundImage: imageProvider,
                      ),
                      placeholder: (context, url) => const CircleAvatar(
                        radius: 80,
                        backgroundImage:
                            AssetImage('assets/images/placeholder.png'),
                      ),
                      errorWidget: (context, url, error) => const CircleAvatar(
                        radius: 80,
                        backgroundImage: AssetImage('assets/images/error.png'),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Username: $username',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 10),
                    IconButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text('Update Username'),
                              content: TextField(
                                controller: _usernameController,
                                style: const TextStyle(color: Colors.black),
                                decoration: const InputDecoration(
                                  hintText: 'Enter new username',
                                ),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: _updateUsername,
                                  child: const Text('Update'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      icon: const Icon(Icons.edit, color: Colors.white),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Email: $email',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            );
          },
        ),
      ),
    );
  }
}
