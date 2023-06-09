// ignore_for_file: use_key_in_widget_constructors, avoid_print

import 'package:project/Import/imports.dart';

class ArticleDetailScreen extends StatefulWidget {
  final Map<String, dynamic> articleData;

  const ArticleDetailScreen({required this.articleData});

  @override
  State<ArticleDetailScreen> createState() => _ArticleDetailScreenState();
}

class _ArticleDetailScreenState extends State<ArticleDetailScreen> {
  String imageUrl = '';

  @override
  void initState() {
    super.initState();
    fetchImage();
  }

  Future<void> fetchImage() async {
    final String imageId = widget.articleData['image'] ?? '';
    if (imageId.isNotEmpty) {
      try {
        final Reference ref = FirebaseStorage.instance.ref().child(imageId);
        final String downloadUrl = await ref.getDownloadURL();
        setState(() {
          imageUrl = downloadUrl;
        });
      } catch (e) {
        print('Error fetching image: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final String title = widget.articleData['title'] ?? '';
    final String description = widget.articleData['description'] ?? '';

    Widget imageWidget;
    if (imageUrl.isNotEmpty) {
      imageWidget = Image.network(
        imageUrl,
        height: 200,
        width: double.infinity,
        fit: BoxFit.cover,
      );
    } else {
      imageWidget = Container(); // Empty container if no image is available
    }

    return Scaffold(
      backgroundColor: const Color(0xff012630),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              GestureDetector(
                onTap: () {
                  // Handle image tap if needed
                },
                child: imageWidget,
              ),
              const SizedBox(height: 16),
              Text(
                description,
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
