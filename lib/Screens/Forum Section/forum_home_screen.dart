// ignore_for_file: unnecessary_null_comparison

import 'package:project/Import/imports.dart';
import 'package:http/http.dart' as http;
import 'package:project/Screens/Forum%20Section/forum_question_search.dart';

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

  @override
  void initState() {
    super.initState();
    currentUser = FirebaseAuth.instance.currentUser;
    _subscribeToAnswers();
  }

  @override
  void dispose() {
    _unsubscribeFromAnswers();
    super.dispose();
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
                  Icons.lightbulb_outline,
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
          Expanded(
            child: isLoading
                ? Center(child: CircularProgressIndicator())
                : questionAnswerList.isEmpty
                    ? const Center(child: Text('No data available'))
                    : ListView.builder(
                        itemCount: questionAnswerList.length,
                        itemBuilder: (BuildContext context, int index) {
                          final question =
                              questionAnswerList[index]['question'];
                          final answer = questionAnswerList[index]['answer'];
                          final imageUrl =
                              questionAnswerList[index]['imageUrl'];
                          final documentId =
                              questionAnswerList[index]['documentId'];
                          final currentLikes =
                              questionAnswerList[index]['likes'] ?? 0;
                          final isLiked =
                              questionAnswerList[index]['isLiked'] ?? false;

                          return Container(
                            padding: const EdgeInsets.all(16.0),
                            margin: const EdgeInsets.only(bottom: 8.0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 8.0),
                                Text(
                                  'Question: $question',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8.0),
                                Text(
                                  'Answer: $answer',
                                  style: const TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                                if (imageUrl != null &&
                                    imageUrl.isNotEmpty) ...[
                                  const SizedBox(height: 8.0),
                                  LayoutBuilder(
                                    builder: (BuildContext context,
                                        BoxConstraints constraints) {
                                      final imageSize = constraints.maxWidth;
                                      return SizedBox(
                                        width: double.infinity,
                                        height: imageSize,
                                        child: Image.network(
                                          imageUrl,
                                          fit: BoxFit.cover,
                                        ),
                                      );
                                    },
                                  ),
                                ],
                                const SizedBox(height: 8.0),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    IconButton(
                                      onPressed: () => _updateLikes(
                                          index, documentId, isLiked),
                                      icon: Icon(
                                        isLiked
                                            ? Icons.thumb_up_alt
                                            : Icons.thumb_up,
                                      ),
                                    ),
                                    Text(
                                      'Likes: $currentLikes',
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                    IconButton(
                                      onPressed: () => _shareQuestionAnswer(
                                        question,
                                        answer,
                                        imageUrl,
                                      ),
                                      icon: const Icon(
                                        Icons.share,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
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
                    builder: (context) => QuestionSearchScreen()));
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

      dynamic image;
      if (imageUrl.isNotEmpty) {
        try {
          final response = await http.get(Uri.parse(imageUrl));
          if (response.statusCode == 200) {
            final bytes = response.bodyBytes;
            image = base64Encode(bytes);
          }
        } catch (error) {
          print('Error fetching image: $error');
        }
      }

      final currentUser = FirebaseAuth.instance.currentUser;
      final isLiked = likedBy.contains(currentUser?.uid);

      return {
        'question': question,
        'answer': answer,
        'image': image ?? '',
        'imageUrl': imageUrl,
        'likes': likes,
        'documentId': doc.id,
        'isLiked': isLiked,
      };
    }));

    setState(() {
      questionAnswerList = updatedQuestionAnswerList;
      isLoading = false; // Set isLoading to false after data is fetched
    });
  }

  // Rest of the code remains the same...
  void _updateLikes(int index, String documentId, bool isLiked) {
    final currentUser = FirebaseAuth.instance.currentUser;
    final currentLikes = questionAnswerList[index]['likes'] ?? 0;

    if (isLiked) {
      // Decrement like count and remove user from likedBy list
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
      // Increment like count and add user to likedBy list
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

    if (imageUrl != null && imageUrl.isNotEmpty) {
      try {
        final response = await http.get(Uri.parse(imageUrl));
        if (response.statusCode == 200) {
          final directory = await getTemporaryDirectory();
          final imagePath = '${directory.path}/image.jpg';

          File(imagePath).writeAsBytesSync(response.bodyBytes);

          Share.shareFiles([imagePath], text: shareText);
        } else {
          Share.share(shareText);
        }
      } catch (e) {
        print('Error sharing image: $e');
        Share.share(shareText);
      }
    } else {
      Share.share(shareText);
    }
  }
}
