// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, library_private_types_in_public_api

import 'package:project/Import/imports.dart';
import 'package:project/Screens/Blog%20Section/search_article.dart';

class BlogScreen extends StatefulWidget {
  const BlogScreen({Key? key});

  @override
  _BlogScreenState createState() => _BlogScreenState();
}

class _BlogScreenState extends State<BlogScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff012630),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Articles',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton.icon(
                onPressed: () {
                  _navigateToCreateArticleScreen(context);
                },
                icon: const Icon(
                  Icons.article_sharp,
                  color: Colors.white,
                ),
                label: const Text(
                  'Create articles',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream:
                  FirebaseFirestore.instance.collection('articles').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Text('Error loading articles');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final articles = snapshot.data?.docs ?? [];

                if (articles.isEmpty) {
                  return const Center(child: Text('No articles available'));
                }

                return ListView.builder(
                  itemCount: articles.length,
                  itemBuilder: (context, index) {
                    final articleData = articles[index].data();

                    return GestureDetector(
                      onTap: () {
                        _navigateToArticleDetailScreen(context, articleData);
                      },
                      child: Container(
                        margin: const EdgeInsets.all(16),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              articleData['title'] ?? '',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              articleData['description'] ?? '',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
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
            // Handle Home button press
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => HomeScreen()));
          }),
          buildBottomIconButton(Icons.search, () {
            // Handle Search button press
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => ArticleSearchScreen()));
          }),
          buildBottomIconButton(Icons.notifications, () {
            // Handle Notifications button press
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => HomeScreen()));
          }),
          buildBottomIconButton(Icons.person, () {
            // Handle Profile button press
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

  void _navigateToCreateArticleScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) => CreateArticles(),
      ),
    );
  }

  void _navigateToArticleDetailScreen(
      BuildContext context, Map<String, dynamic> articleData) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ArticleDetailScreen(articleData: articleData),
      ),
    );
  }
}
