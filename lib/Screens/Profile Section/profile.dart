// ignore_for_file: prefer_final_fields, unnecessary_string_interpolations, library_private_types_in_public_api, deprecated_member_use, avoid_print, use_build_context_synchronously

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
  TextEditingController _oldPasswordController = TextEditingController();
  TextEditingController _newPasswordController = TextEditingController();
  TextEditingController _usernameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

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

  Future<void> _resetPassword() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      final oldPassword = _oldPasswordController.text.trim();
      final newPassword = _newPasswordController.text.trim();

      if (oldPassword.isNotEmpty && newPassword.isNotEmpty) {
        try {
          final email = user.email;
          final credential = EmailAuthProvider.credential(
              email: email!, password: oldPassword);
          await user.reauthenticateWithCredential(credential);

          if (oldPassword == newPassword) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text(
                      'New password should be different from old password')),
            );
          } else {
            await user.updatePassword(newPassword);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Password reset successful')),
            );
          }
        } catch (error) {
          print('Error reauthenticating user: $error');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to reset password')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Please enter both old and new passwords')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User not found')),
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

  void _navigateToHomeScreen(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) => HomeScreen(),
      ),
    );
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
            color: Color(0xFFD9D9D9),
            fontSize: 20,
          ),
        ),
        leading: IconButton(
          onPressed: () => _navigateToHomeScreen(context),
          icon: const Icon(Icons.arrow_back),
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
                GestureDetector(
                  onTap: _uploadImage,
                  child: Center(
                    child: CircleAvatar(
                      radius: 80,
                      backgroundImage: profileImageUrl.isNotEmpty
                          ? NetworkImage(profileImageUrl)
                          : const AssetImage('assets/images/OSCF logo.png')
                              as ImageProvider<Object>,
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
                const SizedBox(height: 40),
                TextFormField(
                  controller: _oldPasswordController,
                  obscureText: true,
                  style: const TextStyle(
                      color: Colors.white), // Set label text color
                  decoration: const InputDecoration(
                    labelText: 'old Password',
                    labelStyle:
                        TextStyle(color: Colors.white), // Set label text color
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.white), // Set border color
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.white), // Set border color
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _newPasswordController,
                  obscureText: true,
                  style: const TextStyle(
                      color: Colors.white), // Set label text color
                  decoration: const InputDecoration(
                    labelText: 'New Password',
                    labelStyle:
                        TextStyle(color: Colors.white), // Set label text color
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.white), // Set border color
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.white), // Set border color
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // TextFormField(
                //   controller: _confirmPasswordController,
                //   obscureText: true,
                //   style: const TextStyle(color: Colors.white),
                //   decoration: const InputDecoration(
                //     labelText: 'Confirm Password',
                //     labelStyle: TextStyle(color: Colors.white),
                //     enabledBorder: OutlineInputBorder(
                //       borderSide: BorderSide(color: Colors.white),
                //     ),
                //     focusedBorder: OutlineInputBorder(
                //       borderSide: BorderSide(color: Colors.white),
                //     ),
                //   ),
                // ),
                // const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _resetPassword,
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.white),
                  ),
                  child: const Text(
                    'Reset Password',
                    style: TextStyle(color: Colors.black),
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
