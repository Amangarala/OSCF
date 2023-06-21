// ignore_for_file: unnecessary_null_comparison, avoid_print

import 'package:project/Import/imports.dart';
import 'package:http/http.dart' as http;

class ForumScreen extends StatefulWidget {
  const ForumScreen({Key? key}) : super(key: key);

  @override
  State<ForumScreen> createState() => _ForumScreenState();
}

class _ForumScreenState extends State<ForumScreen> {
  late User? currentUser;
  late StreamSubscription<QuerySnapshot> _subscription;
  List<Map<String, dynamic>> questionAnswerList = [];
  bool isLoading = true;
  bool isAdmin = false;

  @override
  void initState() {
    super.initState();
    currentUser = FirebaseAuth.instance.currentUser;
    _subscribeToAnswers();
    checkAdminRole();
  }

  @override
  void dispose() {
    _unsubscribeFromAnswers();
    super.dispose();
  }

  void checkAdminRole() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final String uid = user.uid;

      final userDoc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();

      final String? userRole = userDoc.data()?['role'];

      setState(() {
        isAdmin = userRole == 'admin';
      });
    }
  }

  void _subscribeToAnswers() {
    _subscription = FirebaseFirestore.instance
        .collection('answers')
        .snapshots()
        .listen((snapshot) {
      _fetchQuestionAndAnswers(snapshot);
    });
  }

  void _unsubscribeFromAnswers() {
    _subscription.cancel();
  }

  void _navigateToAskScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) => AskScreen(),
      ),
    );
  }

  void _navigateToPostScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) => const PostScreen(),
      ),
    );
  }

  void _navigateToTipsScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) => const TipsScreen(),
      ),
    );
  }

  void _navigateToHomeScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) => HomeScreen(),
      ),
    );
  }

  void _navigateToQuestionAnswerScreen(BuildContext context, String question) {
    final questionAnswer = questionAnswerList.firstWhere(
        (qa) => qa['question'] == question,
        orElse: () => Map<String, dynamic>());

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => QuestionAnswerScreen(
          question: question,
          answer: questionAnswer['answer'] ?? '',
          imageUrl: questionAnswer['imageUrl'] ?? '',
        ),
      ),
    );
  }

  void _deleteQuestionAnswer(String documentId) {
    FirebaseFirestore.instance
        .collection('answers')
        .doc(documentId)
        .delete()
        .then((_) {
      // Remove the deleted question from the list
      setState(() {
        questionAnswerList.removeWhere((qa) => qa['documentId'] == documentId);
      });
    }).catchError((error) {
      print('Error deleting question and answer: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF012630),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Forum',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => _navigateToHomeScreen(context),
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton.icon(
                onPressed: () => _navigateToAskScreen(context),
                icon: const Icon(
                  Icons.help_outline,
                  color: Colors.white,
                ),
                label: const Text(
                  'Ask',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
              TextButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AnswerScreen(),
                    ),
                  );
                },
                icon: const Icon(
                  Icons.edit,
                  color: Colors.white,
                ),
                label: const Text(
                  'Answer',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
              TextButton.icon(
                onPressed: () => _navigateToPostScreen(context),
                icon: const Icon(
                  Icons.post_add,
                  color: Colors.white,
                ),
                label: const Text(
                  'Post',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
              TextButton.icon(
                onPressed: () => _navigateToTipsScreen(context),
                icon: const Icon(
                  Icons.lightbulb,
                  color: Colors.white,
                ),
                label: const Text(
                  'Tips',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : ListView.builder(
                    itemCount: questionAnswerList.length,
                    itemBuilder: (BuildContext context, int index) {
                      final question =
                          questionAnswerList[index]['question'] as String;
                      final answer =
                          questionAnswerList[index]['answer'] as String;
                      final documentId =
                          questionAnswerList[index]['documentId'] as String;

                      return GestureDetector(
                        onTap: () {
                          _navigateToQuestionAnswerScreen(context, question);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          margin: const EdgeInsets.only(
                            bottom: 16,
                            // left: 16,
                            // right: 16,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF2F4F4F),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Q: $question',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'A: ${answer.split('\n').take(2).join('\n')}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  IconButton(
                                    onPressed: () => _updateLikes(
                                        index,
                                        questionAnswerList[index]['documentId'],
                                        questionAnswerList[index]['isLiked']),
                                    icon: Icon(
                                      questionAnswerList[index]['isLiked']
                                          ? Icons.thumb_up_alt
                                          : Icons.thumb_up,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    'Likes: ${questionAnswerList[index]['likes']}',
                                    style: const TextStyle(
                                        fontSize: 16, color: Colors.white),
                                  ),
                                  IconButton(
                                    onPressed: () => _shareQuestionAnswer(
                                      question,
                                      answer,
                                      questionAnswerList[index]['imageUrl'],
                                    ),
                                    icon: const Icon(
                                      Icons.share,
                                      color: Colors.white,
                                    ),
                                  ),
                                  isAdmin
                                      ? IconButton(
                                          onPressed: () =>
                                              _deleteQuestionAnswer(documentId),
                                          icon: const Icon(
                                            Icons.delete,
                                            color: Colors.white,
                                          ),
                                        )
                                      : const SizedBox(
                                          width: 0,
                                        ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      bottomNavigationBar: buildBottomNavigationBar(context),
    );
  }

  Widget buildBottomNavigationBar(BuildContext context) {
    return BottomAppBar(
      color: const Color(0xFFD9D9D9),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          buildBottomIconButton(Icons.home, () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => HomeScreen()));
          }),
          buildBottomIconButton(Icons.search, () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const QuestionSearchScreen()));
          }),
          buildBottomIconButton(Icons.notifications, () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => HomeScreen()));
          }),
          buildBottomIconButton(Icons.person, () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const ProfileScreen()));
          }),
        ],
      ),
    );
  }

  Widget buildBottomIconButton(IconData icon, VoidCallback onPressed) {
    return IconButton(
      icon: Icon(icon),
      iconSize: 30,
      onPressed: onPressed,
    );
  }

  void _fetchQuestionAndAnswers(
      QuerySnapshot<Map<String, dynamic>> snapshot) async {
    final updatedQuestionAnswerList =
        await Future.wait(snapshot.docs.map((doc) async {
      final question = doc.data()['question'] ?? '';
      final answer = doc.data()['answer'] ?? '';
      final imageUrl = doc.data()['imageUrl'] ?? '';
      final likes = doc.data()['likes'] ?? 0;
      final likedBy = doc.data()['likedBy'] ?? [];

      if (imageUrl.isNotEmpty) {
        try {
          final response = await http.get(Uri.parse(imageUrl));
          if (response.statusCode == 200) {}
        } catch (error) {
          print('Error fetching image: $error');
        }
      }

      final currentUser = FirebaseAuth.instance.currentUser;
      final isLiked = likedBy.contains(currentUser?.uid);

      return {
        'question': question,
        'answer': answer,
        'imageUrl': imageUrl,
        'likes': likes,
        'documentId': doc.id,
        'isLiked': isLiked,
      };
    }));

    if (mounted) {
      setState(() {
        questionAnswerList = updatedQuestionAnswerList;
        isLoading = false;
      });
    }
  }

  void _updateLikes(int index, String documentId, bool isLiked) {
    final currentUser = FirebaseAuth.instance.currentUser;
    final currentLikes = questionAnswerList[index]['likes'] ?? 0;

    if (isLiked) {
      FirebaseFirestore.instance.collection('answers').doc(documentId).update({
        'likes': currentLikes - 1,
        'likedBy': FieldValue.arrayRemove([currentUser?.uid])
      }).then((_) {
        setState(() {
          questionAnswerList[index]['likes'] = currentLikes - 1;
          questionAnswerList[index]['isLiked'] = false;
        });
      }).catchError((error) {
        print('Error updating likes: $error');
      });
    } else {
      FirebaseFirestore.instance.collection('answers').doc(documentId).update({
        'likes': currentLikes + 1,
        'likedBy': FieldValue.arrayUnion([currentUser?.uid])
      }).then((_) {
        setState(() {
          questionAnswerList[index]['likes'] = currentLikes + 1;
          questionAnswerList[index]['isLiked'] = true;
        });
      }).catchError((error) {
        print('Error updating likes: $error');
      });
    }
  }

  void _shareQuestionAnswer(
    String question,
    String answer,
    String imageUrl,
  ) async {
    final shareText = 'Question: $question\n\nAnswer: $answer';
    const appLink = 'https://your-app-store-link.com';

    final textWithLink = '$shareText\n\nGet the app: $appLink';

    if (imageUrl != null && imageUrl.isNotEmpty) {
      try {
        final response = await http.get(Uri.parse(imageUrl));
        if (response.statusCode == 200) {
          final directory = await getTemporaryDirectory();
          final imagePath = '${directory.path}/image.jpg';

          File(imagePath).writeAsBytesSync(response.bodyBytes);

          Share.shareFiles([imagePath], text: shareText);
        } else {
          Share.share(textWithLink);
        }
      } catch (e) {
        print('Error sharing image: $e');
        Share.share(textWithLink);
      }
    } else {
      Share.share(textWithLink);
    }
  }
}
