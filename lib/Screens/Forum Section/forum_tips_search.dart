// ignore_for_file: library_private_types_in_public_api

import 'package:project/Import/imports.dart';

class PostSearchScreen extends StatefulWidget {
  const PostSearchScreen({Key? key}) : super(key: key);

  @override
  _PostSearchScreenState createState() => _PostSearchScreenState();
}

class _PostSearchScreenState extends State<PostSearchScreen> {
  List<Map<String, dynamic>> searchResult = [];

  void searchFromFirebase(String query) async {
    final List<String> words = query.toLowerCase().split(' ');

    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('posts').get();

    final List<Map<String, dynamic>> allDocs =
        snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();

    setState(() {
      searchResult = allDocs
          .where((doc) => words.every(
              (word) => doc['text'].toString().toLowerCase().contains(word)))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Firebase Search"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: TextField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Search Posts Here",
              ),
              onChanged: (query) {
                searchFromFirebase(query);
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: searchResult.length,
              itemBuilder: (context, index) {
                final username = searchResult[index]['username'] as String?;
                final text = searchResult[index]['text'] as String?;

                return ListTile(
                  title: Text(username ?? 'No username'),
                  subtitle: Text(text ?? 'No posts'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
