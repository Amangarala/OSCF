// ignore_for_file: deprecated_member_use

import 'package:project/Import/imports.dart';

class MajorProjectDetailScreen extends StatefulWidget {
  final Map<String, dynamic> projectData;

  const MajorProjectDetailScreen({Key? key, required this.projectData})
      : super(key: key);

  @override
  State<MajorProjectDetailScreen> createState() =>
      _MajorProjectDetailScreenState();
}

class _MajorProjectDetailScreenState extends State<MajorProjectDetailScreen> {
  void _launchURL() async {
    final String projectUrl = widget.projectData['url'];

    if (await canLaunch(projectUrl)) {
      await launch(projectUrl);
    } else {
      throw 'Could not launch $projectUrl';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF012630),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Project Detail'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${widget.projectData['title']}',
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              const SizedBox(height: 15),
              RichText(
                text: TextSpan(
                  style: const TextStyle(fontSize: 16, color: Colors.white),
                  children: [
                    const TextSpan(
                      text: 'Description\n',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text: widget.projectData['description'],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15),
              RichText(
                text: TextSpan(
                  style: const TextStyle(fontSize: 16, color: Colors.white),
                  children: [
                    const TextSpan(
                      text: 'Features\n',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text: widget.projectData['features'],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15),
              RichText(
                text: TextSpan(
                  style: const TextStyle(fontSize: 16, color: Colors.white),
                  children: [
                    const TextSpan(
                      text: 'Tech Stack\n',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text: widget.projectData['techStack'],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15),
              GestureDetector(
                onTap: _launchURL,
                child: RichText(
                  text: TextSpan(
                    text: 'Project URL: ',
                    style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                    children: [
                      TextSpan(
                        text: widget.projectData['url'],
                        style: const TextStyle(
                          decoration: TextDecoration.underline,
                          color: Colors.blue,
                        ),
                      ),
                    ],
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
