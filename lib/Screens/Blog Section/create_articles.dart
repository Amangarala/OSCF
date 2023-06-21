// ignore_for_file: unnecessary_null_comparison, avoid_print, use_build_context_synchronously, deprecated_member_use, library_private_types_in_public_api

import 'package:project/Import/imports.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class CreateArticles extends StatefulWidget {
  const CreateArticles({Key? key}) : super(key: key);

  @override
  _CreateArticlesState createState() => _CreateArticlesState();
}

class _CreateArticlesState extends State<CreateArticles> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  File? _image;

  Future<void> _getImage() async {
    final pickedFile =
        await ImagePicker().getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _createArticle() async {
    final user = FirebaseAuth.instance.currentUser;
    final userId = user?.uid;
    String? username;

    if (userId != null) {
      final userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (userSnapshot.exists) {
        username = userSnapshot.data()?['username'];
      }
    }

    if (_titleController.text.isEmpty || _image == null) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Missing Information'),
            content: const Text('Please provide a title and upload an image.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Close the dialog
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
      return;
    }

    final articleData = {
      'title': _titleController.text,
      'description': _descriptionController.text,
      'username': username ?? '',
      'createdAt': FieldValue.serverTimestamp(),
    };

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Center(child: CircularProgressIndicator());
      },
    );

    try {
      final firebaseStorageRef = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('article_images')
          .child(DateTime.now().millisecondsSinceEpoch.toString());

      final uploadTask = firebaseStorageRef.putFile(_image!);
      final snapshot = await uploadTask.whenComplete(() {});

      final downloadURL = await snapshot.ref.getDownloadURL();

      articleData['image'] = downloadURL;

      final docRef = await FirebaseFirestore.instance
          .collection('articles')
          .add(articleData);

      await docRef.update({'id': docRef.id});

      Navigator.pop(context);
      Navigator.pop(context);
    } catch (error) {
      print('Error creating article: $error');
      Navigator.pop(context);

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content:
                const Text('An error occurred while creating the article.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF012630),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: _createArticle,
            child: const Text('Publish', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: _titleController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Title',
                  labelStyle: TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: _descriptionController,
                style: const TextStyle(color: Colors.white),
                maxLines: null,
                decoration: const InputDecoration(
                  hintText: 'Description',
                  hintStyle: TextStyle(color: Colors.white70),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white70),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              Row(
                children: [
                  _image != null
                      ? SizedBox(
                          width: 100,
                          height: 100,
                          child: Image.file(_image!),
                        )
                      : IconButton(
                          icon: const Icon(Icons.image, color: Colors.white),
                          onPressed: _getImage,
                        ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
