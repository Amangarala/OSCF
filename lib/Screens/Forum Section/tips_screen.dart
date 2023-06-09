// // ignore_for_file: library_private_types_in_public_api, avoid_print

// ignore_for_file: library_private_types_in_public_api, unused_local_variable

import 'package:project/Import/imports.dart';
import 'package:project/Screens/Forum%20Section/forum_tips_search.dart';

class TipsScreen extends StatefulWidget {
  const TipsScreen({Key? key}) : super(key: key);

  @override
  _TipsScreenState createState() => _TipsScreenState();
}

class _TipsScreenState extends State<TipsScreen> {
  final currentUser = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF012630),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Tips',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _fetchPosts(),
        builder: (BuildContext context,
            AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final posts = snapshot.data;

          if (posts == null || posts.isEmpty) {
            return const Center(child: Text('No posts available'));
          }

          return ListView.builder(
            itemCount: posts.length,
            itemBuilder: (BuildContext context, int index) {
              final post = posts[index];
              final text = post['text'];
              final imageUrl = post['imageUrl'];
              final username = post['username'];

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
                    Row(
                      children: [
                        Text(
                          username,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      'Post: $text',
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    if (imageUrl != null && imageUrl.isNotEmpty) ...[
                      const SizedBox(height: 8.0),
                      LayoutBuilder(
                        builder:
                            (BuildContext context, BoxConstraints constraints) {
                          double imageSize = constraints
                              .maxWidth; // Set the height equal to width
                          return SizedBox(
                            width: double
                                .infinity, // Set the width to occupy the full container width
                            height: imageSize,
                            child: Image.network(
                              imageUrl,
                              fit: BoxFit
                                  .cover, // Maintain the aspect ratio and cover the available space
                            ),
                          );
                        },
                      ),
                    ],
                    const SizedBox(height: 8.0),
                  ],
                ),
              );
            },
          );
        },
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
                    builder: (context) => const PostSearchScreen()));
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

  Future<List<Map<String, dynamic>>> _fetchPosts() async {
    QuerySnapshot postSnapshot =
        await FirebaseFirestore.instance.collection('posts').get();

    List<Map<String, dynamic>> posts = [];

    await Future.forEach(postSnapshot.docs, (DocumentSnapshot postDoc) async {
      Map<String, dynamic> postData = postDoc.data() as Map<String, dynamic>;

      String username = postData['username'];

      QuerySnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('username', isEqualTo: username)
          .limit(1)
          .get();

      if (userSnapshot.docs.isNotEmpty) {
        Map<String, dynamic> userData =
            userSnapshot.docs.first.data() as Map<String, dynamic>;

        String fetchedUsername = userData['username'];

        postData['username'] = fetchedUsername;
        posts.add(postData);
      }
    });

    return posts;
  }
}
