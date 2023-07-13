// ignore_for_file: use_key_in_widget_constructors, unnecessary_null_comparison, deprecated_member_use

import 'package:project/Import/imports.dart';

class AskScreen extends StatefulWidget {
  @override
  State<AskScreen> createState() => _AskScreenState();
}

class _AskScreenState extends State<AskScreen> {
  final TextEditingController _questionController = TextEditingController();
  bool isQuestionSelected = true;

  @override
  void initState() {
    super.initState();
    _loadProfileData(); // Load profile data
  }

  void _loadProfileData() {
    String uid = FirebaseAuth.instance.currentUser?.uid ?? '';
    DocumentReference userRef =
        FirebaseFirestore.instance.collection('users').doc(uid);

    userRef.get().then((snapshot) {
      if (snapshot.exists) {
        setState(() {});
      }
    });
  }

  void updateProfileQuestion(String question) async {
    String uid = FirebaseAuth.instance.currentUser?.uid ?? '';
    DocumentReference userRef =
        FirebaseFirestore.instance.collection('users').doc(uid);

    DocumentSnapshot snapshot = await userRef.get();
    Map<String, dynamic>? userData = snapshot.data() as Map<String, dynamic>?;

    List<String> existingQuestions = [];
    if (userData != null && userData.containsKey('questions')) {
      dynamic questionsData = userData['questions'];
      if (questionsData is List<dynamic>) {
        existingQuestions = List<String>.from(questionsData);
      }
    }

    existingQuestions.add(question);

    await userRef.update({'questions': existingQuestions});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF012630),
      appBar: AppBar(
        backgroundColor: const Color(0xFF012630),
        leading: IconButton(
          icon: const Icon(
            Icons.close,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const ForumScreen()),
            );
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (_questionController.text.isEmpty) {
                return;
              }

              String newQuestion = _questionController.text;
              updateProfileQuestion(newQuestion);

              _questionController.clear();
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
                color: Colors.white,
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
                      Navigator.pushReplacement(
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
                      Navigator.pushReplacement(
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
            const SizedBox(height: 15),
            TextField(
              controller: _questionController,
              maxLines: null,
              decoration: const InputDecoration(
                hintText: 'Ask a question...',
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
          ],
        ),
      ),
    );
  }
}
