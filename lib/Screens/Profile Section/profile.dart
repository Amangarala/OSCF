// ignore_for_file: prefer_final_fields, unnecessary_string_interpolations, library_private_types_in_public_api, deprecated_member_use, avoid_print

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:project/Firebase/Profilemodel.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String username = '';
  String email = '';
  String profileImageUrl = '';

  TextEditingController _usernameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    String? userId = FirebaseAuth.instance.currentUser?.uid;
    DocumentSnapshot userSnapshot =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();

    if (userSnapshot.exists) {
      Map<String, dynamic>? userData =
          userSnapshot.data() as Map<String, dynamic>?;

      if (userData != null) {
        setState(() {
          username = userData['username'] ?? '';
          email = userData['email'] ?? '';
          _usernameController.text = username;
          profileImageUrl = userData['profileImageUrl'] ?? '';
        });
      }
    }
  }

  void updateUsername(String newUsername) {
    setState(() {
      username = newUsername;
    });
  }

  Future<void> _uploadImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.getImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      File imageFile = File(pickedImage.path);

      try {
        String? userId = FirebaseAuth.instance.currentUser?.uid;
        String imageName = '$userId.jpg';
        Reference storageReference = FirebaseStorage.instance
            .ref()
            .child('users/$userId/profile_images/$imageName');

        UploadTask uploadTask = storageReference.putFile(imageFile);
        TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});
        String imageUrl = await taskSnapshot.ref.getDownloadURL();

        // Update profile image URL in Firestore
        DocumentReference userRef =
            FirebaseFirestore.instance.collection('users').doc(userId);

        await FirebaseFirestore.instance.runTransaction((transaction) async {
          DocumentSnapshot snapshot = await transaction.get(userRef);

          if (snapshot.exists) {
            ProfileModel profile =
                ProfileModel.fromMap(snapshot.data() as Map<String, dynamic>);

            profile.profileImageUrl = imageUrl;

            transaction.update(userRef, profile.toMap());
          }
        });
      } catch (error) {
        // Handle any errors that occur during image upload
        print('Error uploading image: $error');
      }
    }
  }

  Future<void> _updateUsername() async {
    String? newUsername = _usernameController.text.trim().toLowerCase();

    if (newUsername.isNotEmpty) {
      try {
        String? userId = FirebaseAuth.instance.currentUser?.uid;
        DocumentReference userRef =
            FirebaseFirestore.instance.collection('users').doc(userId);

        // Check if the new username already exists in Firestore
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('users')
            .where('username', isEqualTo: newUsername)
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          // Username already exists
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Username already exists')),
          );
        } else {
          await userRef.update({'username': newUsername});

          // Update the username in the state
          setState(() {
            username = newUsername;
          });

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
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).size.height * 0.07,
            left: 20,
            right: 20,
          ),
          child: Column(
            children: [
              const SizedBox(height: 20),
              GestureDetector(
                onTap: _uploadImage,
                child: Center(
                  child: CircleAvatar(
                    radius: 80,
                    backgroundImage: profileImageUrl.isNotEmpty
                        ? NetworkImage(profileImageUrl) as ImageProvider<Object>
                        : const AssetImage('assets/images/OSCF logo.png'),
                  ),
                ),
              ),
              const SizedBox(height: 25),
              // Text(
              //   'Username: $username',
              //   style: const TextStyle(
              //     color: Colors.white,
              //     fontSize: 18,
              //   ),
              // ),
              // const SizedBox(height: 10),

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
                        builder: (BuildContext context) {
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
              const SizedBox(
                height: 20,
              ),
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
          ),
        ),
      ),
    );
  }
}
