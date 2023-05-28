// // ignore_for_file: unused_field, library_private_types_in_public_api, use_build_context_synchronously, avoid_print, deprecated_member_use

// import 'dart:io';

// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:project/Firebase/Profilemodel.dart';

// class EditProfileScreen extends StatefulWidget {
//   final String username;
//   final String email;
//   final Function(String) updateUsername;
//   final String profileImageUrl;

//   EditProfileScreen({
//     required this.username,
//     required this.email,
//     required this.updateUsername,
//     required this.profileImageUrl,
//   });

//   @override
//   _EditProfileScreenState createState() => _EditProfileScreenState();
// }

// class _EditProfileScreenState extends State<EditProfileScreen> {
//   String? _newUsername;
//   File? _imageFile;
//   String? profileImageUrl;
//   final ImagePicker _imagePicker = ImagePicker();
//   final TextEditingController _usernameController = TextEditingController();
//   bool _usernameExists = false;

//   @override
//   void initState() {
//     super.initState();
//     _usernameController.text = widget.username;
//   }

//   Future<void> _pickImage(ImageSource source) async {
//     final pickedImage = await _imagePicker.pickImage(source: source);
//     if (pickedImage != null) {
//       setState(() {
//         _imageFile = File(pickedImage.path);
//       });
//     }
//   }

//   Future<void> _uploadImage() async {
//     final picker = ImagePicker();
//     final pickedImage = await picker.getImage(source: ImageSource.gallery);

//     if (pickedImage != null) {
//       setState(() {
//         _imageFile = File(pickedImage.path);
//       });

//       try {
//         String? userId = FirebaseAuth.instance.currentUser?.uid;
//         String imageName = '$userId.jpg';
//         Reference storageReference = FirebaseStorage.instance
//             .ref()
//             .child('users/$userId/profile_images/$imageName');

//         UploadTask uploadTask = storageReference.putFile(_imageFile!);
//         TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});
//         String imageUrl = await taskSnapshot.ref.getDownloadURL();

//         // Update profile image URL in Firestore
//         DocumentReference userRef =
//             FirebaseFirestore.instance.collection('users').doc(userId);

//         await FirebaseFirestore.instance.runTransaction((transaction) async {
//           DocumentSnapshot snapshot = await transaction.get(userRef);

//           if (snapshot.exists) {
//             ProfileModel profile = ProfileModel();

//             // Update the profileImageUrl only
//             profile.profileImageUrl = imageUrl;

//             transaction.update(userRef, profile.toMap());

//             // setState(() {
//             //   profileImageUrl = imageUrl;
//             // });
//           }
//         });
//       } catch (error) {
//         // Handle any errors that occur during image upload
//         print('Error uploading image: $error');
//       }
//     }
//   }

//   Future<bool> _checkUsernameExists(String username) async {
//     final snapshot = await FirebaseFirestore.instance
//         .collection('users')
//         .where('username', isEqualTo: username)
//         .limit(1)
//         .get();
//     return snapshot.docs.isNotEmpty;
//   }

//   Future<void> _updateUsername() async {
//     final newUsername = _usernameController.text.trim();

//     final usernameExists = await _checkUsernameExists(newUsername);

//     setState(() {
//       _usernameExists = usernameExists;
//     });

//     if (usernameExists) {
//       return;
//     }

//     try {
//       await FirebaseFirestore.instance
//           .collection('users')
//           .doc(FirebaseAuth.instance.currentUser?.uid)
//           .update({'username': newUsername});
//       setState(() {
//         _newUsername = newUsername;
//       });
//       widget.updateUsername(_newUsername!);
//       Navigator.pop(context);
//     } catch (e) {
//       print('Error updating username: $e');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Edit Profile'),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Center(
//               child: GestureDetector(
//                 onTap: () => _pickImage(ImageSource.gallery),
//                 child: CircleAvatar(
//                   radius: 80,
//                   backgroundImage: _imageFile != null
//                       ? FileImage(_imageFile!)
//                       : const NetworkImage(
//                           'imageUrl',
//                         ) as ImageProvider<Object>,
//                 ),
//               ),
//             ),
//             const SizedBox(height: 16),
//             TextField(
//               controller: _usernameController,
//               decoration: InputDecoration(
//                 labelText: 'Username',
//                 errorText: _usernameExists ? 'Username already exists' : null,
//               ),
//             ),
//             const SizedBox(height: 16),
//             ElevatedButton(
//               onPressed: () {
//                 _uploadImage();
//                 _updateUsername();
//               },
//               child: const Text('Save'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
