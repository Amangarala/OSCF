// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, library_private_types_in_public_api, avoid_print

import 'package:project/Import/imports.dart';
import 'package:project/Screens/Blog%20Section/search_article.dart';

class BlogScreen extends StatefulWidget {
  const BlogScreen({Key? key});

  @override
  _BlogScreenState createState() => _BlogScreenState();
}

class _BlogScreenState extends State<BlogScreen> {
  bool isAdmin = false;
  @override
  void initState() {
    super.initState();
    checkAdminRole();
  }

  void checkAdminRole() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final String uid = user.uid;

      final userDoc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();

      final String? userRole = userDoc.data()?['role'];

      setState(() {
        isAdmin = userRole == 'admin';
      });
    }
  }

  void _deleteArticle(String articleId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Deletion'),
        content: const Text('Are you sure you want to delete this article?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // Perform the deletion
              FirebaseFirestore.instance
                  .collection('articles')
                  .doc(articleId)
                  .delete()
                  .then((value) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Article deleted successfully')),
                );
              }).catchError((error) {
                print('Error deleting article: $error');
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Error deleting article')),
                );
              });
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _navigateToHomeScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) => HomeScreen(),
      ),
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
        leading: IconButton(
          onPressed: () => _navigateToHomeScreen(context),
          icon: const Icon(Icons.arrow_back),
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
                    final imageUrl = articleData['image'];

                    return GestureDetector(
                      onTap: () {
                        _navigateToArticleDetailScreen(context, articleData);
                      },
                      child: IntrinsicHeight(
                        child: Container(
                          margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 25),
                          decoration: BoxDecoration(
                            color: const Color(0xFF2F4F4F),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Text(
                                  articleData['title'] ?? '',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              if (imageUrl != null && imageUrl.isNotEmpty)
                                SizedBox(
                                  // height: 400,
                                  width: double.infinity,
                                  child: Image.network(
                                    imageUrl,
                                    fit: BoxFit.contain,
                                    errorBuilder: (context, error, stackTrace) {
                                      return const Text('Image not available');
                                    },
                                  ),
                                ),
                              if (imageUrl == null || imageUrl.isEmpty)
                                const Text('No image available'),
                              if (isAdmin)
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    IconButton(
                                      onPressed: () =>
                                          _deleteArticle(articleData['id']),
                                      icon: const Icon(
                                        Icons.delete,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                            ],
                          ),
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
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => HomeScreen()));
          }),
          buildBottomIconButton(Icons.search, () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => ArticleSearchScreen()));
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
}
