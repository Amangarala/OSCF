// ignore_for_file: use_key_in_widget_constructors, unnecessary_null_comparison, deprecated_member_use, unused_field

import 'package:project/Import/imports.dart';

class AskScreen extends StatefulWidget {
  @override
  State<AskScreen> createState() => _AskScreenState();
}

class _AskScreenState extends State<AskScreen> {
  final TextEditingController _questionController = TextEditingController();
  bool isQuestionSelected = true;
  StreamSubscription<DocumentSnapshot>? _profileSubscription;

  @override
  void initState() {
    super.initState();
    _loadProfileData(); // Load profile data
  }

  void _loadProfileData() {
    String uid = FirebaseAuth.instance.currentUser?.uid ?? '';
    DocumentReference userRef =
        FirebaseFirestore.instance.collection('users').doc(uid);

    _profileSubscription = userRef.snapshots().listen((snapshot) {
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

    // Check if user data exists and retrieve the existing questions
    List<String> existingQuestions =
        (userData != null && userData.containsKey('questions'))
            ? List<String>.from(userData['questions'])
            : [];

    // Append the new question
    existingQuestions.add(question);

    // Update only the 'questions' field
    await userRef.update({'questions': existingQuestions});
  }

  @override
  void dispose() {
    _profileSubscription
        ?.cancel(); // Cancel the subscription to avoid memory leaks
    super.dispose();
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
                // Perform the desired action on add button press
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
                  color: Colors.black,
                ),
              ),
            ),
          ]),
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
                              color: Colors.white, // Set the color of the line
                              width: 2.0, // Set the width of the line
                            ),
                          ),
                        )
                      : null, // No decoration when not selected
                  child: ElevatedButton(
                    onPressed: () {
                      // Perform the desired action on "Add Question" button press
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AskScreen()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      primary: const Color(0xFF012630),
                      elevation: 0, // Set the button's background color
                    ),
                    child: const Text('Add Question'),
                  ),
                ),
                Ink(
                  decoration: !isQuestionSelected
                      ? const ShapeDecoration(
                          shape: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.white, // Set the color of the line
                              width: 2.0, // Set the width of the line
                            ),
                          ),
                        )
                      : null, // No decoration when not selected
                  child: ElevatedButton(
                    onPressed: () {
                      // Perform the desired action on "Create Post" button press
                      // Add your logic here
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const PostScreen()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      primary: const Color(0xFF012630),
                      elevation: 0, // Set the button's background color
                    ),
                    child: const Text('Create Post'),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 15,
            ),
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
