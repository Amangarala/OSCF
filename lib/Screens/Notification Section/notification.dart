// ignore_for_file: unused_field

import 'package:project/Import/imports.dart';

class NotificationView extends StatefulWidget {
  const NotificationView({Key? key}) : super(key: key);

  @override
  State<NotificationView> createState() => _NotificationViewState();
}

class _NotificationViewState extends State<NotificationView> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff012630),
      appBar: AppBar(
        backgroundColor: const Color(0xFF012630),
        centerTitle: true,
        title: const Text(
          "Notifications",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('articles')
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, articleSnapshot) {
          if (articleSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (!articleSnapshot.hasData || articleSnapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text('No notifications available.'),
            );
          }

          final articleDocs = articleSnapshot.data!.docs;

          return StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('posts')
                .orderBy('createdAt', descending: true)
                .snapshots(),
            builder: (context, postSnapshot) {
              if (postSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (!postSnapshot.hasData || postSnapshot.data!.docs.isEmpty) {
                return const Center(
                  child: Text('No notifications available.'),
                );
              }

              final postDocs = postSnapshot.data!.docs;
              final List<dynamic> mergedData = [];

              mergedData.addAll(articleDocs);
              mergedData.addAll(postDocs);

              mergedData.sort((a, b) {
                final aTimestamp = (a['createdAt'] as Timestamp).toDate();
                final bTimestamp = (b['createdAt'] as Timestamp).toDate();
                return bTimestamp.compareTo(aTimestamp);
              });

              //     return ListView.builder(
              //       itemCount: mergedData.length,
              //       itemBuilder: (context, index) {
              //         final data =
              //             mergedData[index].data() as Map<String, dynamic>?;
              //         if (data == null) {
              //           return const SizedBox();
              //         }

              //         final String type =
              //             data.containsKey('text') ? 'post' : 'article';
              //         final String username = data['username'] as String;
              //         final DateTime timestamp =
              //             (data['createdAt'] as Timestamp).toDate();

              //         return ListTile(
              //           title: Text(
              //             '$username has posted a $type',
              //             style: const TextStyle(color: Colors.white),
              //           ),
              //           trailing: Text(
              //             _formatTimestamp(timestamp),
              //             style: const TextStyle(color: Colors.white),
              //           ),
              //         );
              //       },
              //     );
              //   },
              // );
              return ListView.separated(
                itemCount: mergedData.length,
                separatorBuilder: (context, index) => const Divider(
                  color: Colors.white,
                ),
                itemBuilder: (context, index) {
                  final data =
                      mergedData[index].data() as Map<String, dynamic>?;
                  if (data == null) {
                    return const SizedBox();
                  }

                  final String type =
                      data.containsKey('text') ? 'post' : 'article';
                  final String username = data['username'] as String;
                  final DateTime timestamp =
                      (data['createdAt'] as Timestamp).toDate();

                  return ListTile(
                    title: Text(
                      '$username has posted a $type',
                      style: const TextStyle(color: Colors.white),
                    ),
                    trailing: Text(
                      _formatTimestamp(timestamp),
                      style: const TextStyle(color: Colors.white),
                    ),
                  );
                },
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
      elevation: 2,
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
                    builder: (context) => const CommonSearchScreen()));
          }),
          buildBottomIconButton(Icons.notifications, () {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => const NotificationView()));
          }),
          buildBottomIconButton(Icons.person, () {
            Navigator.pushReplacement(context,
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

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes} mins ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours} hours ago';
    } else {
      return '${timestamp.day}-${timestamp.month}-${timestamp.year}';
    }
  }
}
