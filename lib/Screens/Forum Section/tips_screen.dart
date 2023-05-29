import 'package:project/Import/imports.dart';

class TipsScreen extends StatefulWidget {
  const TipsScreen({Key? key}) : super(key: key);

  @override
  _TipsScreenState createState() => _TipsScreenState();
}

class _TipsScreenState extends State<TipsScreen> {
  Future<List<Map<String, dynamic>>> _fetchPosts() async {
    final snapshot = await FirebaseFirestore.instance.collection('users').get();
    final userDataList = snapshot.docs.map((doc) => doc.data()).toList();

    final posts = <Map<String, dynamic>>[];

    for (final userData in userDataList) {
      final profile = ProfileModel.fromMap(userData);

      if (profile.posts != null && profile.posts!.isNotEmpty) {
        final postList = List<String>.from(profile.posts!);

        for (final post in postList) {
          final postParts = post.split('|');
          if (postParts.length == 2) {
            final text = postParts[0];
            final imageUrl = postParts[1];
            final postMap = {
              'type': 'post',
              'text': text,
              'imageUrl': imageUrl,
              'username': profile.username,
              'profileImage': profile.profileImageUrl,
            };
            posts.add(postMap);
          }
        }
      }
    }

    return posts;
  }

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
              //final imageUrl = post['imageUrl'];
              final username = post['username'];
              // final profileImage = post['profileImage'];

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
                        // CircleAvatar(
                        //   backgroundImage: NetworkImage(profileImage),
                        //   // You can customize the size of the profile image using radius or child constraints
                        //   radius: 20,
                        // ),
                        // const SizedBox(width: 8.0),
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
                    // if (imageUrl != null && imageUrl.isNotEmpty)
                    //   Padding(
                    //     padding: const EdgeInsets.only(top: 8.0),
                    //     child: SizedBox(
                    //       height: 100,
                    //       child: Image.network(imageUrl),
                    //     ),
                    // ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
