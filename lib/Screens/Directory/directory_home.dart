// ignore_for_file: camel_case_types, use_build_context_synchronously, unused_local_variable

import 'package:project/Import/imports.dart';

class directorysscreen extends StatefulWidget {
  const directorysscreen({super.key});

  @override
  State<directorysscreen> createState() => _directorysscreenState();
}

class _directorysscreenState extends State<directorysscreen> {
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

  void _navigateToHomeScreen(BuildContext context) {
    Navigator.pop(
      context,
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) => HomeScreen(),
      ),
    );
  }

  void _navigateToCreateScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) => const createmajorScreen(),
      ),
    );
  }

  void _navigateToProjectDetailScreen(
      BuildContext context, Map<String, dynamic> projectData) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            MajorProjectDetailScreen(projectData: projectData),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF012630),
      appBar: AppBar(
        backgroundColor: const Color(0xFF012630),
        title: const Text(
          'Major Projects',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => _navigateToHomeScreen(context),
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: Column(
        children: [
          if (isAdmin)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton.icon(
                  onPressed: () => _navigateToCreateScreen(context),
                  icon: const Icon(
                    Icons.create,
                    color: Colors.white,
                  ),
                  label: const Text(
                    'Create Project',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          Expanded(
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: FirebaseFirestore.instance
                  .collection('majorprojects')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Text('Error loading projects');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final projects = snapshot.data?.docs ?? [];

                if (projects.isEmpty) {
                  return const Center(child: Text('No projects available'));
                }

                return ListView.builder(
                  itemCount: projects.length,
                  itemBuilder: (context, index) {
                    final projectData = projects[index].data();
                    final String username = projectData['username'];
                    final String title = projectData['title'];

                    return GestureDetector(
                      onTap: () {
                        _navigateToProjectDetailScreen(context, projectData);
                      },
                      child: Container(
                        margin: const EdgeInsets.fromLTRB(0, 0, 0, 12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2F4F4F),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ListTile(
                          contentPadding:
                              const EdgeInsets.fromLTRB(16, 8, 16, 16),
                          title: Text(
                            title,
                            style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          subtitle: const Padding(
                            padding: EdgeInsets.only(top: 8),
                            child: Text(
                              ' ',
                              style:
                                  TextStyle(fontSize: 16, color: Colors.white),
                            ),
                          ),
                          trailing: isAdmin
                              ? IconButton(
                                  icon: const Icon(Icons.delete),
                                  color: Colors.white,
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: const Text('Confirm Delete'),
                                          content: const Text(
                                              'Are you sure you want to delete this project?'),
                                          actions: [
                                            TextButton(
                                              onPressed: () async {
                                                final projectId =
                                                    projectData['projectId'];
                                                await FirebaseFirestore.instance
                                                    .collection('majorprojects')
                                                    .doc(projectId)
                                                    .delete();

                                                Navigator.pop(context);
                                              },
                                              child: const Text('Delete'),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: const Text('Cancel'),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                )
                              : null,
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
    );
  }
}
