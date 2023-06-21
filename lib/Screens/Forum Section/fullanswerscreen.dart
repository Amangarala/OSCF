// ignore_for_file: unnecessary_null_comparison, use_key_in_widget_constructors

import 'package:project/Import/imports.dart';

class QuestionAnswerScreen extends StatefulWidget {
  final String question;
  final String answer;
  final String imageUrl;

  const QuestionAnswerScreen({
    required this.question,
    required this.answer,
    required this.imageUrl,
  });

  @override
  State<QuestionAnswerScreen> createState() => _QuestionAnswerScreenState();
}

class _QuestionAnswerScreenState extends State<QuestionAnswerScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF012630),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Question & Answer',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Q: ${widget.question}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'A: ${widget.answer}',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
            if (widget.imageUrl.isNotEmpty)
              SizedBox(
                height: 300,
                child: Image.network(
                  widget.imageUrl,
                  loadingBuilder: (BuildContext context, Widget child,
                      ImageChunkEvent? loadingProgress) {
                    if (loadingProgress == null) {
                      return child;
                    }
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                  errorBuilder: (BuildContext context, Object exception,
                      StackTrace? stackTrace) {
                    return const Icon(Icons.error);
                  },
                  fit: BoxFit.contain,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
