// ignore_for_file: camel_case_types, use_build_context_synchronously, avoid_unnecessary_containers

import 'package:project/Import/imports.dart';

class projectsscreen extends StatefulWidget {
  const projectsscreen({super.key});

  @override
  State<projectsscreen> createState() => _projectsscreenState();
}

class _projectsscreenState extends State<projectsscreen> {
  bool isAdmin = false;
  @override
  void initState() {
    super.initState();
    checkAdminRole(); // Check user's role when the widget initializes
  }

  void checkAdminRole() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final String uid = user.uid;

      final userDoc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();

      final String? userRole = userDoc.data()?['role'];

      setState(() {
        isAdmin = userRole == 'admin'; // Set isAdmin based on the user's role
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
        builder: (context) => const createScreen(),
      ),
    );
  }

  void _navigateToProjectDetailScreen(
      BuildContext context, Map<String, dynamic> projectData) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProjectDetailScreen(projectData: projectData),
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
          'Projects',
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
              stream:
                  FirebaseFirestore.instance.collection('projects').snapshots(),
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
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              'Project by: $username',
                              style: const TextStyle(
                                  fontSize: 16, color: Colors.white),
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
                                                // Delete the project from Firestore
                                                final projectId =
                                                    projectData['projectId'];
                                                await FirebaseFirestore.instance
                                                    .collection('projects')
                                                    .doc(projectId)
                                                    .delete();

                                                Navigator.pop(
                                                    context); // Close the dialog
                                              },
                                              child: const Text('Delete'),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(
                                                    context); // Close the dialog
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
