// ignore_for_file: use_key_in_widget_constructors, avoid_print

import 'package:project/Import/imports.dart';

class ArticleDetailScreen extends StatefulWidget {
  final Map<String, dynamic> articleData;

  const ArticleDetailScreen({required this.articleData});

  @override
  State<ArticleDetailScreen> createState() => _ArticleDetailScreenState();
}

class _ArticleDetailScreenState extends State<ArticleDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final String title = widget.articleData['title'] ?? '';
    final String description = widget.articleData['description'] ?? '';
    final String imageUrl = widget.articleData['image'] ?? '';

    return Scaffold(
      backgroundColor: const Color(0xff012630),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: IntrinsicHeight(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              if (imageUrl.isNotEmpty)
                GestureDetector(
                  onTap: () {},
                  child: Image.network(
                    imageUrl,
                    // height: 400,
                    width: double.infinity,
                    fit: BoxFit.contain,
                  ),
                ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  description,
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
