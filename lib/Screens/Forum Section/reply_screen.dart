// ignore_for_file: prefer_const_constructors, avoid_print, unnecessary_this, deprecated_member_use

import 'package:project/Import/imports.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class ReplyScreen extends StatefulWidget {
  final String question;

  const ReplyScreen({Key? key, required this.question}) : super(key: key);

  @override
  State<ReplyScreen> createState() => _ReplyScreenState();
}

class _ReplyScreenState extends State<ReplyScreen> {
  String answer = '';
  File? image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF012630),
      appBar: AppBar(
        backgroundColor: const Color(0xFF012630),
        actions: [
          TextButton(
            onPressed: () {
              _storeQuestionAndAnswer();
            },
            child: const Text(
              'Post',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.question,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              onChanged: (value) {
                setState(() {
                  answer = value;
                });
              },
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Type your answer...',
                hintStyle: const TextStyle(color: Colors.white54),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.white),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.white),
                ),
              ),
              maxLines: null,
            ),
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    _selectImage();
                  },
                  icon: const Icon(
                    Icons.photo,
                    color: Colors.white,
                  ),
                ),
                if (image != null)
                  SizedBox(
                    width: 64,
                    height: 64,
                    child: Image.file(image!),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        image = File(pickedFile.path);
      });
    }
  }

  void _storeQuestionAndAnswer() async {
    String question = widget.question;
    String answer = this.answer;

    final storageRef = firebase_storage.FirebaseStorage.instance.ref();

    String imageName = DateTime.now().microsecondsSinceEpoch.toString();
    String imagePath = 'answers/$imageName.jpg';

    if (image != null) {
      try {
        await storageRef.child(imagePath).putFile(image!);
      } catch (error) {
        print('Error uploading image: $error');
      }
    }

    String imageUrl = '';
    if (image != null) {
      try {
        imageUrl = await storageRef.child(imagePath).getDownloadURL();
      } catch (error) {
        print('Error getting image URL: $error');
      }
    }

    Map<String, dynamic> data = {
      'question': question,
      'answer': answer,
      'createdAt': DateTime.now().toUtc(),
      'answerId':
          Uuid().v4(), // Generate a unique answer ID using the Uuid package
    };

    if (imageUrl.isNotEmpty) {
      data['imageUrl'] = imageUrl;
    }

    FirebaseFirestore.instance.collection('answers').add(data).then((_) {
      Navigator.pop(context);
    }).catchError((error) {
      print('Error storing question and answer: $error');
    });
  }
}
