// ignore_for_file: file_names

import 'package:project/Import/imports.dart';

class AnswerScreen extends StatefulWidget {
  const AnswerScreen({Key? key}) : super(key: key);

  @override
  State<AnswerScreen> createState() => _AnswerScreenState();
}

class _AnswerScreenState extends State<AnswerScreen> {
  late StreamSubscription<QuerySnapshot> _subscription;
  List<ProfileModel> profiles = [];
  bool isAdmin = false;

  @override
  void initState() {
    super.initState();
    _subscribeToProfiles();
    checkAdminRole();
  }

  void checkAdminRole() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final String uid = user.uid;

      final userDoc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();

      final String? userRole = userDoc.data()?['role'];

      setState(() {
        isAdmin = userRole == 'admin'; // Set isAdmin based on the user's role
      });
    }
  }

  @override
  void dispose() {
    _unsubscribeFromProfiles();
    super.dispose();
  }

  void _subscribeToProfiles() {
    _subscription = FirebaseFirestore.instance
        .collection('users')
        .snapshots()
        .listen((snapshot) {
      setState(() {
        profiles = snapshot.docs.map((doc) {
          return ProfileModel.fromMap(doc.data());
        }).toList();
      });
    });
  }

  void _unsubscribeFromProfiles() {
    _subscription.cancel();
  }

  void _navigateToForumScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) => const ForumScreen(),
      ),
    );
  }

  void _deleteQuestion(String question, String userId) {
    FirebaseFirestore.instance.collection('users').doc(userId).update({
      'questions': FieldValue.arrayRemove([question]),
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
          'Answer',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          onPressed: () => _navigateToForumScreen(context),
          icon: const Icon(Icons.arrow_back),
        ),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: profiles.length,
        itemBuilder: (context, index) {
          final profile = profiles[index];
          if (profile.questions == null || profile.questions!.isEmpty) {
            // If no questions asked, don't show the username
            return Container();
          }

          return Column(
            children: profile.questions!.map((question) {
              return Container(
                margin: const EdgeInsets.only(bottom: 8.0),
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF2F4F4F),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ListTile(
                        leading: profile.profileImageUrl != null &&
                                profile.profileImageUrl!.isNotEmpty
                            ? CircleAvatar(
                                backgroundImage:
                                    NetworkImage(profile.profileImageUrl!),
                                radius: 15, // Adjust the radius as needed
                              )
                            : const CircleAvatar(
                                backgroundImage:
                                    AssetImage('assets/images/OSCF logo.png'),
                                radius: 15, // Adjust the radius as needed
                              ),
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              profile.username ?? '',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 15.0), // Add desired spacing
                          ],
                        ),
                        subtitle: Text(
                          question,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (isAdmin)
                              IconButton(
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text('Confirmation'),
                                        content: const Text(
                                            'Are you sure you want to delete this question?'),
                                        actions: <Widget>[
                                          TextButton(
                                            onPressed: () {
                                              _deleteQuestion(
                                                  question, profile.uid!);
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text('Delete'),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text('Cancel'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                icon: const Icon(Icons.delete,
                                    color: Colors.white),
                              ),
                            IconButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ReplyScreen(
                                      question: question,
                                    ),
                                  ),
                                );
                              },
                              icon: const Icon(
                                Icons.edit,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 2.0),
                  ],
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
