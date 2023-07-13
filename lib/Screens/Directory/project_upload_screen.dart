// ignore_for_file: camel_case_types, use_key_in_widget_constructors

import 'package:project/Import/imports.dart';

class createmajorScreen extends StatefulWidget {
  const createmajorScreen({Key? key});

  @override
  State<createmajorScreen> createState() => _createmajorScreenState();
}

class _createmajorScreenState extends State<createmajorScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _featuresController = TextEditingController();
  final _techStackController = TextEditingController();
  final _urlController = TextEditingController();

  void _submitForm() {
    bool _isValidUrl(String url) {
      const pattern = r'^(http(s)?://)?'
          r'((([a-zA-Z0-9-]+\.){1,2}[a-zA-Z]{2,}|'
          r'((\d{1,3}\.){3}\d{1,3}))|'
          r'localhost)(:\d{1,5})?(/[-a-zA-Z0-9+&@#/%?=~_|!:,.;]*)?'
          r'([?][-a-zA-Z0-9+&@#/%=~_|])?';
      final regex = RegExp(pattern);
      return regex.hasMatch(url);
    }

    if (_formKey.currentState!.validate()) {
      // Form fields are valid, proceed with data submission

      // Retrieve the field values
      final String title = _titleController.text;
      final String description = _descriptionController.text;
      final String features = _featuresController.text;
      final String techStack = _techStackController.text;
      final String url = _urlController.text;

      if (!_isValidUrl(url)) {
        // Invalid URL entered
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter a valid URL')),
        );
        return;
      }

      // Get the current user
      final User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // User is signed in, retrieve the username from the "users" collection
        FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get()
            .then((docSnapshot) {
          if (docSnapshot.exists) {
            final String username = docSnapshot.get('username');

            // Save the data to Firebase Firestore
            FirebaseFirestore.instance.collection('projects').add({
              'title': title,
              'description': description,
              'features': features,
              'techStack': techStack,
              'url': url,
              'username': username,
            }).then((docRef) {
              final String projectId =
                  docRef.id; // Retrieve the generated project ID

              // Update the project document with the project ID
              docRef.update({'projectId': projectId}).then((_) {
                // Data saved successfully
                print('Project created successfully with ID: $projectId');
                // Reset the form
                _titleController.clear();
                _descriptionController.clear();
                _featuresController.clear();
                _techStackController.clear();
                _urlController.clear();
                // Show a success message to the user
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Project created successfully')),
                );
              }).catchError((error) {
                // Error occurred while updating the project document
                print('Error updating project document: $error');
                // Show an error message to the user
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Error creating project')),
                );
              });
            }).catchError((error) {
              // Error occurred while saving data
              print('Error creating project: $error');
              // Show an error message to the user
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Error creating project')),
              );
            });
          }
        }).catchError((error) {
          // Error occurred while retrieving the username
          print('Error retrieving username: $error');
          // Show an error message to the user
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Error retrieving username')),
          );
        });
      } else {
        // User is not signed in
        print('User is not signed in');
        // Show an error message to the user
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User is not signed in')),
        );
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _featuresController.dispose();
    _techStackController.dispose();
    _urlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF012630),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Create Project',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'Title',
                    labelStyle: TextStyle(color: Colors.white),
                  ),
                  style: const TextStyle(color: Colors.white),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a title';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    labelStyle: TextStyle(color: Colors.white),
                  ),
                  maxLines: null,
                  style: const TextStyle(color: Colors.white),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a description';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _featuresController,
                  decoration: const InputDecoration(
                    labelText: 'Features',
                    labelStyle: TextStyle(color: Colors.white),
                  ),
                  maxLines: null,
                  style: const TextStyle(color: Colors.white),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter features';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _techStackController,
                  decoration: const InputDecoration(
                    labelText: 'Tech Stack',
                    labelStyle: TextStyle(color: Colors.white),
                  ),
                  maxLines: null,
                  style: const TextStyle(color: Colors.white),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the tech stack used';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _urlController,
                  decoration: const InputDecoration(
                    labelText: 'URL',
                    labelStyle: TextStyle(color: Colors.white),
                  ),
                  style: const TextStyle(color: Colors.white),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a URL';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _submitForm,
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.white),
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.black),
                  ),
                  child: const Text('Create Project'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
