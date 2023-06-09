import 'package:project/Import/imports.dart';

class QuestionSearchScreen extends StatefulWidget {
  const QuestionSearchScreen({Key? key}) : super(key: key);

  @override
  _QuestionSearchScreenState createState() => _QuestionSearchScreenState();
}

class _QuestionSearchScreenState extends State<QuestionSearchScreen> {
  List<Map<String, dynamic>> searchResult = [];

  void searchFromFirebase(String query) async {
    final List<String> words = query.toLowerCase().split(' ');

    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('answers').get();

    final List<Map<String, dynamic>> allDocs =
        snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();

    setState(() {
      searchResult = allDocs
          .where((doc) => words.every((word) =>
              doc['question'].toString().toLowerCase().contains(word)))
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
                hintText: "Search Question Here",
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
                final question = searchResult[index]['question'] as String?;
                final answer = searchResult[index]['answer'] as String?;

                return ListTile(
                  title: Text(question ?? 'No Question'),
                  subtitle: Text(answer ?? 'No Answer'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
