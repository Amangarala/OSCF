// ignore_for_file: library_private_types_in_public_api

import 'package:project/Import/imports.dart';

class ArticleSearchScreen extends StatefulWidget {
  const ArticleSearchScreen({Key? key}) : super(key: key);

  @override
  _ArticleSearchScreenState createState() => _ArticleSearchScreenState();
}

class _ArticleSearchScreenState extends State<ArticleSearchScreen> {
  List<Map<String, dynamic>> searchResult = [];

  void searchFromFirebase(String query) async {
    final List<String> words = query.toLowerCase().split(' ');

    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('articles').get();

    final List<Map<String, dynamic>> allDocs =
        snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();

    setState(() {
      searchResult = allDocs
          .where((doc) => words.every(
              (word) => doc['title'].toString().toLowerCase().contains(word)))
          .toList();
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
          "Article Search",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: TextField(
              decoration: const InputDecoration(
                filled: true,
                fillColor: Color(0xFFD9D9D9),
                border: OutlineInputBorder(),
                hintText: "Search Articles Here",
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
                final title = searchResult[index]['title'] as String?;
                final description =
                    searchResult[index]['description'] as String?;

                return ListTile(
                  title: Text(
                    title ?? 'No title',
                    style: const TextStyle(color: Colors.white),
                  ),
                  subtitle: Text(
                    description ?? 'No description',
                    style: const TextStyle(color: Colors.white),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
