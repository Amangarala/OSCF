// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'package:project/Import/imports.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class PostScreen extends StatefulWidget {
  const PostScreen({Key? key}) : super(key: key);

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  final TextEditingController _postController = TextEditingController();
  bool isQuestionSelected = true;
  File? selectedImage;

  @override
  void initState() {
    super.initState();
    _loadProfileData(); // Load profile data
  }

  @override
  void dispose() {
    _postController.dispose();
    super.dispose();
  }

  void _loadProfileData() {
    String uid = FirebaseAuth.instance.currentUser?.uid ?? '';
    FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .get()
        .then((snapshot) {
      if (snapshot.exists) {
        setState(() {});
      }
    });
  }

  // void updateProfilePost(String question) async {
  //   String uid = FirebaseAuth.instance.currentUser?.uid ?? '';
  //   DocumentReference userRef =
  //       FirebaseFirestore.instance.collection('users').doc(uid);

  //   DocumentSnapshot snapshot = await userRef.get();
  //   Map<String, dynamic>? userData = snapshot.data() as Map<String, dynamic>?;

  //   List<String> existingposts =
  //       (userData != null && userData.containsKey('posts'))
  //           ? List<String>.from(userData['posts'])
  //           : [];

  //   existingposts.add(question);

  //   await userRef.update({'posts': existingposts});
  // }
  void updateProfilePost(String post, String imageUrl) async {
    String uid = FirebaseAuth.instance.currentUser?.uid ?? '';
    DocumentReference userRef =
        FirebaseFirestore.instance.collection('users').doc(uid);

    DocumentSnapshot snapshot = await userRef.get();
    Map<String, dynamic>? userData = snapshot.data() as Map<String, dynamic>?;

    List<String> existingPosts =
        (userData != null && userData.containsKey('posts'))
            ? List<String>.from(userData['posts'])
            : [];

    String newPost = '$post|$imageUrl';
    existingPosts.add(newPost);

    await userRef.update({'posts': existingPosts});
  }

  // Future<void> _selectImage() async {
  //   final ImagePicker _picker = ImagePicker();

  //   try {
  //     final XFile? pickedFile = await _picker.pickImage(
  //       source: ImageSource
  //           .gallery, // You can change this to ImageSource.camera for capturing from the camera
  //     );

  //     if (pickedFile != null) {
  //       setState(() {
  //         selectedImage = File(pickedFile.path);
  //       });
  //     }
  //   } catch (e) {
  //     // Handle image selection error
  //     print('Image selection error: $e');
  //   }
  // }
  Future<void> _selectImage() async {
    final ImagePicker _picker = ImagePicker();

    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      // Upload the image to Firebase Storage
      File file = File(image.path);
      String imageName = DateTime.now().millisecondsSinceEpoch.toString();
      firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('images')
          .child(imageName);
      firebase_storage.UploadTask uploadTask = ref.putFile(file);

      // Get the download URL of the uploaded image
      String imageUrl = await (await uploadTask).ref.getDownloadURL();

      // Save the post and image URL in user's profile in Firestore
      updateProfilePost(_postController.text, imageUrl);
      _postController.clear();
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ForumScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF012630),
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(
            Icons.close,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ForumScreen()),
            );
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (_postController.text.isEmpty) {
                return;
              }
              String newPost = _postController.text;
              String imageUrl = 'selectedImage';
              updateProfilePost(newPost, imageUrl);
              _postController.clear();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ForumScreen()),
              );
            },
            child: const Text(
              'Add',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Ink(
                  decoration: !isQuestionSelected
                      ? const ShapeDecoration(
                          shape: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.white,
                              width: 2.0,
                            ),
                          ),
                        )
                      : null,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AskScreen()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      primary: const Color(0xFF012630),
                      elevation: 0,
                    ),
                    child: const Text('Add Question'),
                  ),
                ),
                Ink(
                  decoration: isQuestionSelected
                      ? const ShapeDecoration(
                          shape: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.white,
                              width: 2.0,
                            ),
                          ),
                        )
                      : null,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const PostScreen()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      primary: const Color(0xFF012630),
                      elevation: 0,
                    ),
                    child: const Text('Create Post'),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _postController,
              maxLines: null,
              decoration: const InputDecoration(
                hintText: 'Share your tips...',
                hintStyle: TextStyle(color: Colors.white),
                border: InputBorder.none,
              ),
              style: const TextStyle(color: Colors.white),
              textInputAction: TextInputAction.done,
              keyboardType: TextInputType.multiline,
            ),
            const Divider(
              color: Colors.white,
              thickness: 1,
            ),
            const SizedBox(
              height: 15,
            ),
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    // Handle image selection here
                    _selectImage();
                  },
                  icon: const Icon(
                    Icons.photo,
                    color: Colors.white,
                  ),
                ),
                if (selectedImage != null)
                  SizedBox(
                    width: 64,
                    height: 64,
                    child: Image.file(selectedImage!),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
