// ignore_for_file: library_private_types_in_public_api

import 'package:project/Import/imports.dart';

class CommonSearchScreen extends StatefulWidget {
  const CommonSearchScreen({Key? key}) : super(key: key);

  @override
  _CommonSearchScreenState createState() => _CommonSearchScreenState();
}

class _CommonSearchScreenState extends State<CommonSearchScreen> {
  List<Map<String, dynamic>> searchResult = [];

  void searchFromFirebase(String query) async {
    final List<String> words = query.toLowerCase().split(' ');

    final List<String> collectionNames = ['posts', 'articles', 'answers'];

    List<QuerySnapshot> snapshots = await Future.wait(
      collectionNames.map((collectionName) =>
          FirebaseFirestore.instance.collection(collectionName).get()),
    );

    final List<Map<String, dynamic>> allDocs = [];

    for (var snapshot in snapshots) {
      final List<Map<String, dynamic>> docs = snapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
      allDocs.addAll(docs);
    }

    setState(() {
      searchResult = allDocs.where((doc) {
        final String? text = doc['text'] as String?;
        final String? title = doc['title'] as String?;
        final String? question = doc['question'] as String?;

        return [text, title, question].where((field) => field != null).any(
            (field) =>
                words.every((word) => field!.toLowerCase().contains(word)));
      }).toList();
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
          "Search ",
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
                hintText: "Search Here",
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
                final Map<String, dynamic> doc = searchResult[index];
                final String? text = doc['text'] as String?;
                final String? title = doc['title'] as String?;
                final String? description = doc['description'] as String?;
                final String? question = doc['question'] as String?;
                final String? answer = doc['answer'] as String?;

                Widget subtitleWidget;

                if (title != null &&
                    description != null &&
                    text == null &&
                    question == null &&
                    answer == null) {
                  subtitleWidget = Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        description,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
                  );
                } else if (text != null) {
                  subtitleWidget = Text(
                    text,
                    style: const TextStyle(color: Colors.white),
                  );
                } else if (question != null && answer != null) {
                  subtitleWidget = Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        question,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        answer,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
                  );
                } else {
                  subtitleWidget = const Text(
                    'No content',
                    style: TextStyle(color: Colors.white),
                  );
                }

                return ListTile(
                  subtitle: subtitleWidget,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
