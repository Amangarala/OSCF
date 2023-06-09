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

  @override
  void initState() {
    super.initState();
    _subscribeToProfiles();
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
          return ProfileModel.fromMap(doc.data() as Map<String, dynamic>);
        }).toList();
      });
    });
  }

  void _unsubscribeFromProfiles() {
    _subscription.cancel();
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
          // Display each question in a separate container
          return Column(
            children: profile.questions!.map((question) {
              return Container(
                margin: const EdgeInsets.only(bottom: 8.0),
                child: Column(
                  children: [
                    Container(
                      color: Colors.white,
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage:
                              NetworkImage(profile.profileImageUrl ?? ''),
                          radius: 15, // Adjust the radius as needed
                        ),
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              profile.username ?? '',
                              style: const TextStyle(
                                color: Colors.black,
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
                            color: Colors.black54,
                            fontSize: 18,
                          ),
                        ),
                        trailing: IconButton(
                          onPressed: () {
                            // Handle the button press here
                            // You can navigate to another screen or perform any desired action
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ReplyScreen(
                                  question: question, // Pass the question here
                                ), // Replace with your ReplyScreen widget
                              ),
                            );
                          },
                          icon: const Icon(Icons.edit),
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
