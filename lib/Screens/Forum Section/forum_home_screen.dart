// // ignore_for_file: unused_local_variable, avoid_print

// import 'package:path_provider/path_provider.dart';
// import 'package:project/Import/imports.dart';
// import 'package:http/http.dart' as http;
// import 'package:share_plus/share_plus.dart';
// // import 'package:share/share.dart';

// class ForumScreen extends StatefulWidget {
//   const ForumScreen({Key? key}) : super(key: key);

//   @override
//   State<ForumScreen> createState() => _ForumScreenState();
// }

// class _ForumScreenState extends State<ForumScreen> {
//   final currentUser = FirebaseAuth.instance.currentUser;
//   bool isLiked = false;
//   void _navigateToAskScreen(BuildContext context) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         fullscreenDialog: true,
//         builder: (context) => AskScreen(),
//       ),
//     );
//   }

//   void _navigateToPostScreen(BuildContext context) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         fullscreenDialog: true,
//         builder: (context) => const PostScreen(),
//       ),
//     );
//   }

//   void _navigateToTipsScreen(BuildContext context) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         fullscreenDialog: true,
//         builder: (context) => const TipsScreen(),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFF012630),
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         title: const Text(
//           'Forum',
//           style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//         ),
//         centerTitle: true,
//       ),
//       body: Column(
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [
//               TextButton.icon(
//                 onPressed: () {
//                   _navigateToAskScreen(context);
//                 },
//                 icon: const Icon(
//                   Icons.help_outline,
//                   color: Colors.white,
//                 ),
//                 label: const Text(
//                   'Ask',
//                   style: TextStyle(
//                     color: Colors.white,
//                   ),
//                 ),
//               ),
//               TextButton.icon(
//                 onPressed: () {
//                   // Handle answer button pressed
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => const AnswerScreen(),
//                     ),
//                   );
//                 },
//                 icon: const Icon(
//                   Icons.edit,
//                   color: Colors.white,
//                 ),
//                 label: const Text(
//                   'Answer',
//                   style: TextStyle(
//                     color: Colors.white,
//                   ),
//                 ),
//               ),
//               TextButton.icon(
//                 onPressed: () {
//                   // Handle post button pressed
//                   _navigateToPostScreen(context);
//                 },
//                 icon: const Icon(
//                   Icons.post_add,
//                   color: Colors.white,
//                 ),
//                 label: const Text(
//                   'Post',
//                   style: TextStyle(
//                     color: Colors.white,
//                   ),
//                 ),
//               ),
//               TextButton.icon(
//                 onPressed: () {
//                   // Handle tips button pressed
//                   _navigateToTipsScreen(context);
//                 },
//                 icon: const Icon(
//                   Icons.lightbulb_outline,
//                   color: Colors.white,
//                 ),
//                 label: const Text(
//                   'Tips',
//                   style: TextStyle(
//                     color: Colors.white,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           Expanded(
//             child: FutureBuilder<List<Map<String, dynamic>>>(
//               future: _fetchQuestionAndAnswers(),
//               builder: (BuildContext context,
//                   AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return const Center(child: CircularProgressIndicator());
//                 }

//                 if (snapshot.hasError) {
//                   return Center(child: Text('Error: ${snapshot.error}'));
//                 }

//                 final questionAnswerList = snapshot.data;

//                 if (questionAnswerList == null || questionAnswerList.isEmpty) {
//                   return const Center(child: Text('No data available'));
//                 }

//                 return ListView.builder(
//                   itemCount: questionAnswerList.length,
//                   itemBuilder: (BuildContext context, int index) {
//                     final question = questionAnswerList[index]['question'];
//                     final answer = questionAnswerList[index]['answer'];
//                     final imageUrl = questionAnswerList[index]['imageUrl'];
//                     final documentId = questionAnswerList[index]['documentId'];

//                     int currentLikes = questionAnswerList[index]['likes'] ?? 0;
//                     return Container(
//                       padding: const EdgeInsets.all(16.0),
//                       margin: const EdgeInsets.only(bottom: 8.0),
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(8.0),
//                       ),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           const SizedBox(height: 8.0),
//                           Text(
//                             'Question: $question',
//                             style: const TextStyle(
//                               fontSize: 18,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                           const SizedBox(height: 8.0),
//                           Text(
//                             'Answer: $answer',
//                             style: const TextStyle(
//                               fontSize: 16,
//                             ),
//                           ),
//                           if (imageUrl != null && imageUrl.isNotEmpty) ...[
//                             const SizedBox(height: 8.0),
//                             LayoutBuilder(
//                               builder: (BuildContext context,
//                                   BoxConstraints constraints) {
//                                 double imageSize = constraints
//                                     .maxWidth; // Set the height equal to width
//                                 return SizedBox(
//                                   width: double
//                                       .infinity, // Set the width to occupy the full container width
//                                   height: imageSize,
//                                   child: Image.network(
//                                     imageUrl,
//                                     fit: BoxFit
//                                         .cover, // Maintain the aspect ratio and cover the available space
//                                   ),
//                                 );
//                               },
//                             ),
//                           ],
//                           const SizedBox(height: 8.0),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               IconButton(
//                                 onPressed: () {
//                                   if (questionAnswerList[index]['isLiked']) {
//                                     // Decrement like count and remove user from likedBy list
//                                     FirebaseFirestore.instance
//                                         .collection('answers')
//                                         .doc(documentId)
//                                         .update({
//                                       'likes': currentLikes - 1,
//                                       'likedBy': FieldValue.arrayRemove(
//                                           [currentUser?.uid])
//                                     }).then((_) {
//                                       setState(() {
//                                         questionAnswerList[index]['likes'] =
//                                             currentLikes - 1;
//                                         questionAnswerList[index]['isLiked'] =
//                                             false;
//                                       });
//                                     }).catchError((error) {
//                                       print('Error updating likes: $error');
//                                     });
//                                   } else {
//                                     // Increment like count and add user to likedBy list
//                                     FirebaseFirestore.instance
//                                         .collection('answers')
//                                         .doc(documentId)
//                                         .update({
//                                       'likes': currentLikes + 1,
//                                       'likedBy': FieldValue.arrayUnion(
//                                           [currentUser?.uid])
//                                     }).then((_) {
//                                       setState(() {
//                                         questionAnswerList[index]['likes'] =
//                                             currentLikes + 1;
//                                         questionAnswerList[index]['isLiked'] =
//                                             true;
//                                       });
//                                     }).catchError((error) {
//                                       print('Error updating likes: $error');
//                                     });
//                                   }
//                                 },
//                                 icon: Icon(
//                                   questionAnswerList[index]['isLiked']
//                                       ? Icons.thumb_up_alt
//                                       : Icons.thumb_up,
//                                 ),
//                               ),
//                               Text(
//                                 'Likes: $currentLikes',
//                                 style: const TextStyle(fontSize: 16),
//                               ),
//                               IconButton(
//                                 onPressed: () async {
//                                   final shareText =
//                                       'Question: $question\n\nAnswer: $answer';

//                                   if (imageUrl != null && imageUrl.isNotEmpty) {
//                                     try {
//                                       final response =
//                                           await http.get(Uri.parse(imageUrl));
//                                       if (response.statusCode == 200) {
//                                         final directory =
//                                             await getTemporaryDirectory();
//                                         final imagePath =
//                                             '${directory.path}/image.jpg';

//                                         File(imagePath).writeAsBytesSync(
//                                             response.bodyBytes);

//                                         Share.shareFiles([imagePath],
//                                             text: shareText);
//                                       } else {
//                                         Share.share(shareText);
//                                       }
//                                     } catch (e) {
//                                       print('Error sharing image: $e');
//                                       Share.share(shareText);
//                                     }
//                                   } else {
//                                     Share.share(shareText);
//                                   }
//                                 },
//                                 icon: const Icon(
//                                   Icons.share,
//                                   color: Colors.black,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     );
//                   },
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//       bottomNavigationBar: buildBottomNavigationBar(context),
//     );
//   }

//   Widget buildBottomNavigationBar(BuildContext context) {
//     return BottomAppBar(
//       color: const Color(0xFFD9D9D9),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//         children: [
//           buildBottomIconButton(Icons.home, () {
//             // Handle Home button press
//             Navigator.push(
//                 context, MaterialPageRoute(builder: (context) => HomeScreen()));
//           }),
//           buildBottomIconButton(Icons.search, () {
//             // Handle Search button press
//             Navigator.push(
//                 context, MaterialPageRoute(builder: (context) => HomeScreen()));
//           }),
//           buildBottomIconButton(Icons.notifications, () {
//             // Handle Notifications button press
//             Navigator.push(
//                 context, MaterialPageRoute(builder: (context) => HomeScreen()));
//           }),
//           buildBottomIconButton(Icons.person, () {
//             // Handle Profile button press
//             Navigator.push(context,
//                 MaterialPageRoute(builder: (context) => const ProfileScreen()));
//           }),
//         ],
//       ),
//     );
//   }

//   Widget buildBottomIconButton(IconData icon, VoidCallback onPressed) {
//     return IconButton(
//       icon: Icon(icon),
//       iconSize: 30,
//       onPressed: onPressed,
//     );
//   }

//   Future<List<Map<String, dynamic>>> _fetchQuestionAndAnswers() async {
//     final snapshot =
//         await FirebaseFirestore.instance.collection('answers').get();

//     final questionAnswerList = [];
//     for (final doc in snapshot.docs) {
//       final question = doc.data()['question'] ?? '';
//       final answer = doc.data()['answer'] ?? '';
//       final imageUrl = doc.data()['imageUrl'] ?? '';
//       final likes = doc.data()['likes'] ?? 0; // Get the initial likes count
//       final likedBy = doc.data()['likedBy'] ?? []; // Get the likedBy list

//       dynamic image;
//       if (imageUrl.isNotEmpty) {
//         try {
//           final response = await http.get(Uri.parse(imageUrl));
//           if (response.statusCode == 200) {
//             final bytes = response.bodyBytes;
//             image = base64Encode(bytes);
//           }
//         } catch (error) {
//           print('Error fetching image: $error');
//         }
//       }

//       final currentUser = FirebaseAuth.instance.currentUser;
//       final isLiked = likedBy.contains(
//           currentUser?.uid); // Check if the current user has liked the post

//       final questionAnswerMap = {
//         'question': question,
//         'answer': answer,
//         'image': image ?? '',
//         'imageUrl': imageUrl,
//         'likes': likes, // Include the likes count in the map
//         'documentId': doc.id, // Include the document ID
//         'isLiked': isLiked, // Include the liked status in the map
//       };

//       questionAnswerList.add(questionAnswerMap);
//     }

// // ignore_for_file: unnecessary_null_comparison

//     return questionAnswerList.cast<Map<String, dynamic>>();
//   }
// }

// ignore_for_file: unnecessary_null_comparison

// import 'package:path_provider/path_provider.dart';
// import 'package:project/Import/imports.dart';
// import 'package:http/http.dart' as http;
// import 'package:share_plus/share_plus.dart';

// class ForumScreen extends StatefulWidget {
//   const ForumScreen({Key? key}) : super(key: key);

//   @override
//   State<ForumScreen> createState() => _ForumScreenState();
// }

// class _ForumScreenState extends State<ForumScreen> {
//   late User? currentUser;
//   List<Map<String, dynamic>> questionAnswerList = [];

//   @override
//   void initState() {
//     super.initState();
//     currentUser = FirebaseAuth.instance.currentUser;
//     _fetchQuestionAndAnswers();
//   }

//   void _navigateToAskScreen(BuildContext context) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         fullscreenDialog: true,
//         builder: (context) => AskScreen(),
//       ),
//     );
//   }

//   void _navigateToPostScreen(BuildContext context) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         fullscreenDialog: true,
//         builder: (context) => const PostScreen(),
//       ),
//     );
//   }

//   void _navigateToTipsScreen(BuildContext context) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         fullscreenDialog: true,
//         builder: (context) => const TipsScreen(),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFF012630),
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         title: const Text(
//           'Forum',
//           style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//         ),
//         centerTitle: true,
//       ),
//       body: Column(
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [
//               TextButton.icon(
//                 onPressed: () {
//                   _navigateToAskScreen(context);
//                 },
//                 icon: const Icon(
//                   Icons.help_outline,
//                   color: Colors.white,
//                 ),
//                 label: const Text(
//                   'Ask',
//                   style: TextStyle(
//                     color: Colors.white,
//                   ),
//                 ),
//               ),
//               TextButton.icon(
//                 onPressed: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => const AnswerScreen(),
//                     ),
//                   );
//                 },
//                 icon: const Icon(
//                   Icons.edit,
//                   color: Colors.white,
//                 ),
//                 label: const Text(
//                   'Answer',
//                   style: TextStyle(
//                     color: Colors.white,
//                   ),
//                 ),
//               ),
//               TextButton.icon(
//                 onPressed: () {
//                   _navigateToPostScreen(context);
//                 },
//                 icon: const Icon(
//                   Icons.post_add,
//                   color: Colors.white,
//                 ),
//                 label: const Text(
//                   'Post',
//                   style: TextStyle(
//                     color: Colors.white,
//                   ),
//                 ),
//               ),
//               TextButton.icon(
//                 onPressed: () {
//                   _navigateToTipsScreen(context);
//                 },
//                 icon: const Icon(
//                   Icons.lightbulb_outline,
//                   color: Colors.white,
//                 ),
//                 label: const Text(
//                   'Tips',
//                   style: TextStyle(
//                     color: Colors.white,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           Expanded(
//             child: questionAnswerList.isEmpty
//                 ? const Center(child: Text('No data available'))
//                 : ListView.builder(
//                     itemCount: questionAnswerList.length,
//                     itemBuilder: (BuildContext context, int index) {
//                       final question = questionAnswerList[index]['question'];
//                       final answer = questionAnswerList[index]['answer'];
//                       final imageUrl = questionAnswerList[index]['imageUrl'];
//                       final documentId =
//                           questionAnswerList[index]['documentId'];
//                       int currentLikes =
//                           questionAnswerList[index]['likes'] ?? 0;
//                       bool isLiked =
//                           questionAnswerList[index]['isLiked'] ?? false;

//                       return Container(
//                         padding: const EdgeInsets.all(16.0),
//                         margin: const EdgeInsets.only(bottom: 8.0),
//                         decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.circular(8.0),
//                         ),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             const SizedBox(height: 8.0),
//                             Text(
//                               'Question: $question',
//                               style: const TextStyle(
//                                 fontSize: 18,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                             const SizedBox(height: 8.0),
//                             Text(
//                               'Answer: $answer',
//                               style: const TextStyle(
//                                 fontSize: 16,
//                               ),
//                             ),
//                             if (imageUrl != null && imageUrl.isNotEmpty) ...[
//                               const SizedBox(height: 8.0),
//                               LayoutBuilder(
//                                 builder: (BuildContext context,
//                                     BoxConstraints constraints) {
//                                   double imageSize = constraints
//                                       .maxWidth; // Set the height equal to width
//                                   return SizedBox(
//                                     width: double.infinity,
//                                     height: imageSize,
//                                     child: Image.network(
//                                       imageUrl,
//                                       fit: BoxFit.cover,
//                                     ),
//                                   );
//                                 },
//                               ),
//                             ],
//                             const SizedBox(height: 8.0),
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 IconButton(
//                                   onPressed: () {
//                                     _updateLikes(index, documentId, isLiked);
//                                   },
//                                   icon: Icon(
//                                     isLiked
//                                         ? Icons.thumb_up_alt
//                                         : Icons.thumb_up,
//                                   ),
//                                 ),
//                                 Text(
//                                   'Likes: $currentLikes',
//                                   style: const TextStyle(fontSize: 16),
//                                 ),
//                                 IconButton(
//                                   onPressed: () {
//                                     _shareQuestionAnswer(
//                                       question,
//                                       answer,
//                                       imageUrl,
//                                     );
//                                   },
//                                   icon: const Icon(
//                                     Icons.share,
//                                     color: Colors.black,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                       );
//                     },
//                   ),
//           ),
//         ],
//       ),
//       bottomNavigationBar: buildBottomNavigationBar(context),
//     );
//   }

//   Widget buildBottomNavigationBar(BuildContext context) {
//     return BottomAppBar(
//       color: const Color(0xFFD9D9D9),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//         children: [
//           buildBottomIconButton(Icons.home, () {
//             Navigator.push(
//                 context, MaterialPageRoute(builder: (context) => HomeScreen()));
//           }),
//           buildBottomIconButton(Icons.search, () {
//             Navigator.push(
//                 context, MaterialPageRoute(builder: (context) => HomeScreen()));
//           }),
//           buildBottomIconButton(Icons.notifications, () {
//             Navigator.push(
//                 context, MaterialPageRoute(builder: (context) => HomeScreen()));
//           }),
//           buildBottomIconButton(Icons.person, () {
//             Navigator.push(context,
//                 MaterialPageRoute(builder: (context) => const ProfileScreen()));
//           }),
//         ],
//       ),
//     );
//   }

//   Widget buildBottomIconButton(IconData icon, VoidCallback onPressed) {
//     return IconButton(
//       icon: Icon(icon),
//       iconSize: 30,
//       onPressed: onPressed,
//     );
//   }

//   void _fetchQuestionAndAnswers() async {
//     final snapshot =
//         await FirebaseFirestore.instance.collection('answers').get();

//     final List<Map<String, dynamic>> updatedQuestionAnswerList = [];
//     for (final doc in snapshot.docs) {
//       final question = doc.data()['question'] ?? '';
//       final answer = doc.data()['answer'] ?? '';
//       final imageUrl = doc.data()['imageUrl'] ?? '';
//       final likes = doc.data()['likes'] ?? 0;
//       final likedBy = doc.data()['likedBy'] ?? [];

//       dynamic image;
//       if (imageUrl.isNotEmpty) {
//         try {
//           final response = await http.get(Uri.parse(imageUrl));
//           if (response.statusCode == 200) {
//             final bytes = response.bodyBytes;
//             image = base64Encode(bytes);
//           }
//         } catch (error) {
//           print('Error fetching image: $error');
//         }
//       }

//       final currentUser = FirebaseAuth.instance.currentUser;
//       final isLiked = likedBy.contains(currentUser?.uid);

//       final questionAnswerMap = {
//         'question': question,
//         'answer': answer,
//         'image': image ?? '',
//         'imageUrl': imageUrl,
//         'likes': likes,
//         'documentId': doc.id,
//         'isLiked': isLiked,
//       };

//       updatedQuestionAnswerList.add(questionAnswerMap);
//     }

//     setState(() {
//       questionAnswerList = updatedQuestionAnswerList;
//     });
//   }

//   void _updateLikes(int index, String documentId, bool isLiked) {
//     final currentUser = FirebaseAuth.instance.currentUser;
//     final currentLikes = questionAnswerList[index]['likes'] ?? 0;

//     if (isLiked) {
//       // Decrement like count and remove user from likedBy list
//       FirebaseFirestore.instance.collection('answers').doc(documentId).update({
//         'likes': currentLikes - 1,
//         'likedBy': FieldValue.arrayRemove([currentUser?.uid])
//       }).then((_) {
//         setState(() {
//           questionAnswerList[index]['likes'] = currentLikes - 1;
//           questionAnswerList[index]['isLiked'] = false;
//         });
//       }).catchError((error) {
//         print('Error updating likes: $error');
//       });
//     } else {
//       // Increment like count and add user to likedBy list
//       FirebaseFirestore.instance.collection('answers').doc(documentId).update({
//         'likes': currentLikes + 1,
//         'likedBy': FieldValue.arrayUnion([currentUser?.uid])
//       }).then((_) {
//         setState(() {
//           questionAnswerList[index]['likes'] = currentLikes + 1;
//           questionAnswerList[index]['isLiked'] = true;
//         });
//       }).catchError((error) {
//         print('Error updating likes: $error');
//       });
//     }
//   }

//   void _shareQuestionAnswer(
//     String question,
//     String answer,
//     String imageUrl,
//   ) async {
//     final shareText = 'Question: $question\n\nAnswer: $answer';

//     if (imageUrl != null && imageUrl.isNotEmpty) {
//       try {
//         final response = await http.get(Uri.parse(imageUrl));
//         if (response.statusCode == 200) {
//           final directory = await getTemporaryDirectory();
//           final imagePath = '${directory.path}/image.jpg';

//           File(imagePath).writeAsBytesSync(response.bodyBytes);

//           Share.shareFiles([imagePath], text: shareText);
//         } else {
//           Share.share(shareText);
//         }
//       } catch (e) {
//         print('Error sharing image: $e');
//         Share.share(shareText);
//       }
//     } else {
//       Share.share(shareText);
//     }
//   }
// }

// import 'package:path_provider/path_provider.dart';
// import 'package:project/Import/imports.dart';
// import 'package:http/http.dart' as http;
// import 'package:share_plus/share_plus.dart';

// class ForumScreen extends StatefulWidget {
//   const ForumScreen({Key? key}) : super(key: key);

//   @override
//   State<ForumScreen> createState() => _ForumScreenState();
// }

// class _ForumScreenState extends State<ForumScreen> {
//   late User? currentUser;
//   StreamSubscription<QuerySnapshot>? _subscription;
//   List<Map<String, dynamic>> questionAnswerList = [];

//   @override
//   void initState() {
//     super.initState();
//     currentUser = FirebaseAuth.instance.currentUser;
//     _subscribeToAnswers();
//   }

//   @override
//   void dispose() {
//     _unsubscribeFromAnswers();
//     super.dispose();
//   }

//   void _subscribeToAnswers() {
//     _subscription = FirebaseFirestore.instance
//         .collection('answers')
//         .snapshots()
//         .listen((snapshot) {
//       _fetchQuestionAndAnswers(snapshot);
//     });
//   }

//   void _unsubscribeFromAnswers() {
//     _subscription?.cancel();
//   }

//   void _navigateToAskScreen(BuildContext context) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         fullscreenDialog: true,
//         builder: (context) => AskScreen(),
//       ),
//     );
//   }

//   void _navigateToPostScreen(BuildContext context) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         fullscreenDialog: true,
//         builder: (context) => const PostScreen(),
//       ),
//     );
//   }

//   void _navigateToTipsScreen(BuildContext context) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         fullscreenDialog: true,
//         builder: (context) => const TipsScreen(),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFF012630),
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         title: const Text(
//           'Forum',
//           style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//         ),
//         centerTitle: true,
//       ),
//       body: Column(
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [
//               TextButton.icon(
//                 onPressed: () {
//                   _navigateToAskScreen(context);
//                 },
//                 icon: const Icon(
//                   Icons.help_outline,
//                   color: Colors.white,
//                 ),
//                 label: const Text(
//                   'Ask',
//                   style: TextStyle(
//                     color: Colors.white,
//                   ),
//                 ),
//               ),
//               TextButton.icon(
//                 onPressed: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => const AnswerScreen(),
//                     ),
//                   );
//                 },
//                 icon: const Icon(
//                   Icons.edit,
//                   color: Colors.white,
//                 ),
//                 label: const Text(
//                   'Answer',
//                   style: TextStyle(
//                     color: Colors.white,
//                   ),
//                 ),
//               ),
//               TextButton.icon(
//                 onPressed: () {
//                   _navigateToPostScreen(context);
//                 },
//                 icon: const Icon(
//                   Icons.post_add,
//                   color: Colors.white,
//                 ),
//                 label: const Text(
//                   'Post',
//                   style: TextStyle(
//                     color: Colors.white,
//                   ),
//                 ),
//               ),
//               TextButton.icon(
//                 onPressed: () {
//                   _navigateToTipsScreen(context);
//                 },
//                 icon: const Icon(
//                   Icons.lightbulb_outline,
//                   color: Colors.white,
//                 ),
//                 label: const Text(
//                   'Tips',
//                   style: TextStyle(
//                     color: Colors.white,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           Expanded(
//             child: questionAnswerList.isEmpty
//                 ? const Center(child: Text('No data available'))
//                 : ListView.builder(
//                     itemCount: questionAnswerList.length,
//                     itemBuilder: (BuildContext context, int index) {
//                       final question = questionAnswerList[index]['question'];
//                       final answer = questionAnswerList[index]['answer'];
//                       final imageUrl = questionAnswerList[index]['imageUrl'];
//                       final documentId =
//                           questionAnswerList[index]['documentId'];
//                       int currentLikes =
//                           questionAnswerList[index]['likes'] ?? 0;
//                       bool isLiked =
//                           questionAnswerList[index]['isLiked'] ?? false;

//                       return Container(
//                         padding: const EdgeInsets.all(16.0),
//                         margin: const EdgeInsets.only(bottom: 8.0),
//                         decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.circular(8.0),
//                         ),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             const SizedBox(height: 8.0),
//                             Text(
//                               'Question: $question',
//                               style: const TextStyle(
//                                 fontSize: 18,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                             const SizedBox(height: 8.0),
//                             Text(
//                               'Answer: $answer',
//                               style: const TextStyle(
//                                 fontSize: 16,
//                               ),
//                             ),
//                             if (imageUrl != null && imageUrl.isNotEmpty) ...[
//                               const SizedBox(height: 8.0),
//                               LayoutBuilder(
//                                 builder: (BuildContext context,
//                                     BoxConstraints constraints) {
//                                   double imageSize = constraints
//                                       .maxWidth; // Set the height equal to width
//                                   return SizedBox(
//                                     width: double.infinity,
//                                     height: imageSize,
//                                     child: Image.network(
//                                       imageUrl,
//                                       fit: BoxFit.cover,
//                                     ),
//                                   );
//                                 },
//                               ),
//                             ],
//                             const SizedBox(height: 8.0),
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 IconButton(
//                                   onPressed: () {
//                                     _updateLikes(index, documentId, isLiked);
//                                   },
//                                   icon: Icon(
//                                     isLiked
//                                         ? Icons.thumb_up_alt
//                                         : Icons.thumb_up,
//                                   ),
//                                 ),
//                                 Text(
//                                   'Likes: $currentLikes',
//                                   style: const TextStyle(fontSize: 16),
//                                 ),
//                                 IconButton(
//                                   onPressed: () {
//                                     _shareQuestionAnswer(
//                                       question,
//                                       answer,
//                                       imageUrl,
//                                     );
//                                   },
//                                   icon: const Icon(
//                                     Icons.share,
//                                     color: Colors.black,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                       );
//                     },
//                   ),
//           ),
//         ],
//       ),
//       bottomNavigationBar: buildBottomNavigationBar(context),
//     );
//   }

//   Widget buildBottomNavigationBar(BuildContext context) {
//     return BottomAppBar(
//       color: const Color(0xFFD9D9D9),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//         children: [
//           buildBottomIconButton(Icons.home, () {
//             Navigator.push(
//                 context, MaterialPageRoute(builder: (context) => HomeScreen()));
//           }),
//           buildBottomIconButton(Icons.search, () {
//             Navigator.push(
//                 context, MaterialPageRoute(builder: (context) => HomeScreen()));
//           }),
//           buildBottomIconButton(Icons.notifications, () {
//             Navigator.push(
//                 context, MaterialPageRoute(builder: (context) => HomeScreen()));
//           }),
//           buildBottomIconButton(Icons.person, () {
//             Navigator.push(context,
//                 MaterialPageRoute(builder: (context) => const ProfileScreen()));
//           }),
//         ],
//       ),
//     );
//   }

//   Widget buildBottomIconButton(IconData icon, VoidCallback onPressed) {
//     return IconButton(
//       icon: Icon(icon),
//       iconSize: 30,
//       onPressed: onPressed,
//     );
//   }

//   void _fetchQuestionAndAnswers(
//       QuerySnapshot<Map<String, dynamic>> snapshot) async {
//     FirebaseFirestore.instance
//         .collection('answers')
//         .snapshots()
//         .listen((snapshot) async {
//       final List<Map<String, dynamic>> updatedQuestionAnswerList = [];
//       for (final doc in snapshot.docs) {
//         final question = doc.data()['question'] ?? '';
//         final answer = doc.data()['answer'] ?? '';
//         final imageUrl = doc.data()['imageUrl'] ?? '';
//         final likes = doc.data()['likes'] ?? 0;
//         final likedBy = doc.data()['likedBy'] ?? [];

//         dynamic image;
//         if (imageUrl.isNotEmpty) {
//           try {
//             final response = await http.get(Uri.parse(imageUrl));
//             if (response.statusCode == 200) {
//               final bytes = response.bodyBytes;
//               image = base64Encode(bytes);
//             }
//           } catch (error) {
//             print('Error fetching image: $error');
//           }
//         }

//         final currentUser = FirebaseAuth.instance.currentUser;
//         final isLiked = likedBy.contains(currentUser?.uid);

//         final questionAnswerMap = {
//           'question': question,
//           'answer': answer,
//           'image': image ?? '',
//           'imageUrl': imageUrl,
//           'likes': likes,
//           'documentId': doc.id,
//           'isLiked': isLiked,
//         };

//         updatedQuestionAnswerList.add(questionAnswerMap);
//       }

//       setState(() {
//         questionAnswerList = updatedQuestionAnswerList;
//       });
//     });
//   }

//   void _updateLikes(int index, String documentId, bool isLiked) {
//     final currentUser = FirebaseAuth.instance.currentUser;
//     final currentLikes = questionAnswerList[index]['likes'] ?? 0;

//     if (isLiked) {
//       // Decrement like count and remove user from likedBy list
//       FirebaseFirestore.instance.collection('answers').doc(documentId).update({
//         'likes': currentLikes - 1,
//         'likedBy': FieldValue.arrayRemove([currentUser?.uid])
//       }).then((_) {
//         setState(() {
//           questionAnswerList[index]['likes'] = currentLikes - 1;
//           questionAnswerList[index]['isLiked'] = false;
//         });
//       }).catchError((error) {
//         print('Error updating likes: $error');
//       });
//     } else {
//       // Increment like count and add user to likedBy list
//       FirebaseFirestore.instance.collection('answers').doc(documentId).update({
//         'likes': currentLikes + 1,
//         'likedBy': FieldValue.arrayUnion([currentUser?.uid])
//       }).then((_) {
//         setState(() {
//           questionAnswerList[index]['likes'] = currentLikes + 1;
//           questionAnswerList[index]['isLiked'] = true;
//         });
//       }).catchError((error) {
//         print('Error updating likes: $error');
//       });
//     }
//   }

//   void _shareQuestionAnswer(
//     String question,
//     String answer,
//     String imageUrl,
//   ) async {
//     final shareText = 'Question: $question\n\nAnswer: $answer';

//     if (imageUrl != null && imageUrl.isNotEmpty) {
//       try {
//         final response = await http.get(Uri.parse(imageUrl));
//         if (response.statusCode == 200) {
//           final directory = await getTemporaryDirectory();
//           final imagePath = '${directory.path}/image.jpg';

//           File(imagePath).writeAsBytesSync(response.bodyBytes);

//           Share.shareFiles([imagePath], text: shareText);
//         } else {
//           Share.share(shareText);
//         }
//       } catch (e) {
//         print('Error sharing image: $e');
//         Share.share(shareText);
//       }
//     } else {
//       Share.share(shareText);
//     }
//   }
// }

// import 'package:path_provider/path_provider.dart';
// import 'package:project/Import/imports.dart';
// import 'package:http/http.dart' as http;
// import 'package:share_plus/share_plus.dart';

// class ForumScreen extends StatefulWidget {
//   const ForumScreen({Key? key}) : super(key: key);

//   @override
//   State<ForumScreen> createState() => _ForumScreenState();
// }

// class _ForumScreenState extends State<ForumScreen> {
//   late User? currentUser;
//   StreamSubscription<QuerySnapshot>? _subscription;
//   List<Map<String, dynamic>> questionAnswerList = [];
//   bool isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     currentUser = FirebaseAuth.instance.currentUser;
//     _subscribeToAnswers();
//   }

//   @override
//   void dispose() {
//     _unsubscribeFromAnswers();
//     super.dispose();
//   }

//   void _subscribeToAnswers() {
//     _subscription = FirebaseFirestore.instance
//         .collection('answers')
//         .snapshots()
//         .listen((snapshot) {
//       _fetchQuestionAndAnswers(snapshot);
//     });
//   }

//   void _unsubscribeFromAnswers() {
//     _subscription?.cancel();
//   }

//   void _navigateToAskScreen(BuildContext context) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         fullscreenDialog: true,
//         builder: (context) => AskScreen(),
//       ),
//     );
//   }

//   void _navigateToPostScreen(BuildContext context) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         fullscreenDialog: true,
//         builder: (context) => const PostScreen(),
//       ),
//     );
//   }

//   void _navigateToTipsScreen(BuildContext context) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         fullscreenDialog: true,
//         builder: (context) => const TipsScreen(),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFF012630),
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         title: const Text(
//           'Forum',
//           style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//         ),
//         centerTitle: true,
//       ),
//       body: Column(
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [
//               TextButton.icon(
//                 onPressed: () {
//                   _navigateToAskScreen(context);
//                 },
//                 icon: const Icon(
//                   Icons.help_outline,
//                   color: Colors.white,
//                 ),
//                 label: const Text(
//                   'Ask',
//                   style: TextStyle(
//                     color: Colors.white,
//                   ),
//                 ),
//               ),
//               TextButton.icon(
//                 onPressed: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => const AnswerScreen(),
//                     ),
//                   );
//                 },
//                 icon: const Icon(
//                   Icons.edit,
//                   color: Colors.white,
//                 ),
//                 label: const Text(
//                   'Answer',
//                   style: TextStyle(
//                     color: Colors.white,
//                   ),
//                 ),
//               ),
//               TextButton.icon(
//                 onPressed: () {
//                   _navigateToPostScreen(context);
//                 },
//                 icon: const Icon(
//                   Icons.post_add,
//                   color: Colors.white,
//                 ),
//                 label: const Text(
//                   'Post',
//                   style: TextStyle(
//                     color: Colors.white,
//                   ),
//                 ),
//               ),
//               TextButton.icon(
//                 onPressed: () {
//                   _navigateToTipsScreen(context);
//                 },
//                 icon: const Icon(
//                   Icons.lightbulb_outline,
//                   color: Colors.white,
//                 ),
//                 label: const Text(
//                   'Tips',
//                   style: TextStyle(
//                     color: Colors.white,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           Expanded(
//             child: isLoading
//                 ? Center(child: CircularProgressIndicator())
//                 : questionAnswerList.isEmpty
//                     ? const Center(child: Text('No data available'))
//                     : ListView.builder(
//                         itemCount: questionAnswerList.length,
//                         itemBuilder: (BuildContext context, int index) {
//                           final question =
//                               questionAnswerList[index]['question'];
//                           final answer = questionAnswerList[index]['answer'];
//                           final imageUrl =
//                               questionAnswerList[index]['imageUrl'];
//                           final documentId =
//                               questionAnswerList[index]['documentId'];
//                           int currentLikes =
//                               questionAnswerList[index]['likes'] ?? 0;
//                           bool isLiked =
//                               questionAnswerList[index]['isLiked'] ?? false;

//                           return Container(
//                             padding: const EdgeInsets.all(16.0),
//                             margin: const EdgeInsets.only(bottom: 8.0),
//                             decoration: BoxDecoration(
//                               color: Colors.white,
//                               borderRadius: BorderRadius.circular(8.0),
//                             ),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 const SizedBox(height: 8.0),
//                                 Text(
//                                   'Question: $question',
//                                   style: const TextStyle(
//                                     fontSize: 18,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                                 const SizedBox(height: 8.0),
//                                 Text(
//                                   'Answer: $answer',
//                                   style: const TextStyle(
//                                     fontSize: 16,
//                                   ),
//                                 ),
//                                 if (imageUrl != null &&
//                                     imageUrl.isNotEmpty) ...[
//                                   const SizedBox(height: 8.0),
//                                   LayoutBuilder(
//                                     builder: (BuildContext context,
//                                         BoxConstraints constraints) {
//                                       double imageSize = constraints.maxWidth;
//                                       return SizedBox(
//                                         width: double.infinity,
//                                         height: imageSize,
//                                         child: Image.network(
//                                           imageUrl,
//                                           fit: BoxFit.cover,
//                                         ),
//                                       );
//                                     },
//                                   ),
//                                 ],
//                                 const SizedBox(height: 8.0),
//                                 Row(
//                                   mainAxisAlignment:
//                                       MainAxisAlignment.spaceBetween,
//                                   children: [
//                                     IconButton(
//                                       onPressed: () {
//                                         _updateLikes(
//                                             index, documentId, isLiked);
//                                       },
//                                       icon: Icon(
//                                         isLiked
//                                             ? Icons.thumb_up_alt
//                                             : Icons.thumb_up,
//                                       ),
//                                     ),
//                                     Text(
//                                       'Likes: $currentLikes',
//                                       style: const TextStyle(fontSize: 16),
//                                     ),
//                                     IconButton(
//                                       onPressed: () {
//                                         _shareQuestionAnswer(
//                                           question,
//                                           answer,
//                                           imageUrl,
//                                         );
//                                       },
//                                       icon: const Icon(
//                                         Icons.share,
//                                         color: Colors.black,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           );
//                         },
//                       ),
//           ),
//         ],
//       ),
//       bottomNavigationBar: buildBottomNavigationBar(context),
//     );
//   }

//   Widget buildBottomNavigationBar(BuildContext context) {
//     return BottomAppBar(
//       color: const Color(0xFFD9D9D9),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//         children: [
//           buildBottomIconButton(Icons.home, () {
//             Navigator.push(
//                 context, MaterialPageRoute(builder: (context) => HomeScreen()));
//           }),
//           buildBottomIconButton(Icons.search, () {
//             Navigator.push(
//                 context, MaterialPageRoute(builder: (context) => HomeScreen()));
//           }),
//           buildBottomIconButton(Icons.notifications, () {
//             Navigator.push(
//                 context, MaterialPageRoute(builder: (context) => HomeScreen()));
//           }),
//           buildBottomIconButton(Icons.person, () {
//             Navigator.push(context,
//                 MaterialPageRoute(builder: (context) => const ProfileScreen()));
//           }),
//         ],
//       ),
//     );
//   }

//   Widget buildBottomIconButton(IconData icon, VoidCallback onPressed) {
//     return IconButton(
//       icon: Icon(icon),
//       iconSize: 30,
//       onPressed: onPressed,
//     );
//   }

//   void _fetchQuestionAndAnswers(
//       QuerySnapshot<Map<String, dynamic>> snapshot) async {
//     FirebaseFirestore.instance
//         .collection('answers')
//         .snapshots()
//         .listen((snapshot) async {
//       final List<Map<String, dynamic>> updatedQuestionAnswerList = [];
//       for (final doc in snapshot.docs) {
//         final question = doc.data()['question'] ?? '';
//         final answer = doc.data()['answer'] ?? '';
//         final imageUrl = doc.data()['imageUrl'] ?? '';
//         final likes = doc.data()['likes'] ?? 0;
//         final likedBy = doc.data()['likedBy'] ?? [];

//         dynamic image;
//         if (imageUrl.isNotEmpty) {
//           try {
//             final response = await http.get(Uri.parse(imageUrl));
//             if (response.statusCode == 200) {
//               final bytes = response.bodyBytes;
//               image = base64Encode(bytes);
//             }
//           } catch (error) {
//             print('Error fetching image: $error');
//           }
//         }

//         final currentUser = FirebaseAuth.instance.currentUser;
//         final isLiked = likedBy.contains(currentUser?.uid);

//         final questionAnswerMap = {
//           'question': question,
//           'answer': answer,
//           'image': image ?? '',
//           'imageUrl': imageUrl,
//           'likes': likes,
//           'documentId': doc.id,
//           'isLiked': isLiked,
//         };

//         updatedQuestionAnswerList.add(questionAnswerMap);
//       }

//       setState(() {
//         questionAnswerList = updatedQuestionAnswerList;
//         isLoading = false; // Set isLoading to false after data is fetched
//       });
//     });
//   }

//   // Rest of the code remains the same...
//   void _updateLikes(int index, String documentId, bool isLiked) {
//     final currentUser = FirebaseAuth.instance.currentUser;
//     final currentLikes = questionAnswerList[index]['likes'] ?? 0;

//     if (isLiked) {
//       // Decrement like count and remove user from likedBy list
//       FirebaseFirestore.instance.collection('answers').doc(documentId).update({
//         'likes': currentLikes - 1,
//         'likedBy': FieldValue.arrayRemove([currentUser?.uid])
//       }).then((_) {
//         setState(() {
//           questionAnswerList[index]['likes'] = currentLikes - 1;
//           questionAnswerList[index]['isLiked'] = false;
//         });
//       }).catchError((error) {
//         print('Error updating likes: $error');
//       });
//     } else {
//       // Increment like count and add user to likedBy list
//       FirebaseFirestore.instance.collection('answers').doc(documentId).update({
//         'likes': currentLikes + 1,
//         'likedBy': FieldValue.arrayUnion([currentUser?.uid])
//       }).then((_) {
//         setState(() {
//           questionAnswerList[index]['likes'] = currentLikes + 1;
//           questionAnswerList[index]['isLiked'] = true;
//         });
//       }).catchError((error) {
//         print('Error updating likes: $error');
//       });
//     }
//   }

//   void _shareQuestionAnswer(
//     String question,
//     String answer,
//     String imageUrl,
//   ) async {
//     final shareText = 'Question: $question\n\nAnswer: $answer';

//     if (imageUrl != null && imageUrl.isNotEmpty) {
//       try {
//         final response = await http.get(Uri.parse(imageUrl));
//         if (response.statusCode == 200) {
//           final directory = await getTemporaryDirectory();
//           final imagePath = '${directory.path}/image.jpg';

//           File(imagePath).writeAsBytesSync(response.bodyBytes);

//           Share.shareFiles([imagePath], text: shareText);
//         } else {
//           Share.share(shareText);
//         }
//       } catch (e) {
//         print('Error sharing image: $e');
//         Share.share(shareText);
//       }
//     } else {
//       Share.share(shareText);
//     }
//   }
// }
import 'package:project/Import/imports.dart';
import 'package:http/http.dart' as http;
import 'package:project/Screens/Forum%20Section/forum_question_search.dart';

class ForumScreen extends StatefulWidget {
  const ForumScreen({Key? key}) : super(key: key);

  @override
  State<ForumScreen> createState() => _ForumScreenState();
}

class _ForumScreenState extends State<ForumScreen> {
  late User? currentUser;
  late StreamSubscription<QuerySnapshot> _subscription;
  List<Map<String, dynamic>> questionAnswerList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    currentUser = FirebaseAuth.instance.currentUser;
    _subscribeToAnswers();
  }

  @override
  void dispose() {
    _unsubscribeFromAnswers();
    super.dispose();
  }

  void _subscribeToAnswers() {
    _subscription = FirebaseFirestore.instance
        .collection('answers')
        .snapshots()
        .listen((snapshot) {
      _fetchQuestionAndAnswers(snapshot);
    });
  }

  void _unsubscribeFromAnswers() {
    _subscription.cancel();
  }

  void _navigateToAskScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) => AskScreen(),
      ),
    );
  }

  void _navigateToPostScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) => const PostScreen(),
      ),
    );
  }

  void _navigateToTipsScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) => const TipsScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF012630),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Forum',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton.icon(
                onPressed: () => _navigateToAskScreen(context),
                icon: const Icon(
                  Icons.help_outline,
                  color: Colors.white,
                ),
                label: const Text(
                  'Ask',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
              TextButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AnswerScreen(),
                    ),
                  );
                },
                icon: const Icon(
                  Icons.edit,
                  color: Colors.white,
                ),
                label: const Text(
                  'Answer',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
              TextButton.icon(
                onPressed: () => _navigateToPostScreen(context),
                icon: const Icon(
                  Icons.post_add,
                  color: Colors.white,
                ),
                label: const Text(
                  'Post',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
              TextButton.icon(
                onPressed: () => _navigateToTipsScreen(context),
                icon: const Icon(
                  Icons.lightbulb_outline,
                  color: Colors.white,
                ),
                label: const Text(
                  'Tips',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: isLoading
                ? Center(child: CircularProgressIndicator())
                : questionAnswerList.isEmpty
                    ? const Center(child: Text('No data available'))
                    : ListView.builder(
                        itemCount: questionAnswerList.length,
                        itemBuilder: (BuildContext context, int index) {
                          final question =
                              questionAnswerList[index]['question'];
                          final answer = questionAnswerList[index]['answer'];
                          final imageUrl =
                              questionAnswerList[index]['imageUrl'];
                          final documentId =
                              questionAnswerList[index]['documentId'];
                          final currentLikes =
                              questionAnswerList[index]['likes'] ?? 0;
                          final isLiked =
                              questionAnswerList[index]['isLiked'] ?? false;

                          return Container(
                            padding: const EdgeInsets.all(16.0),
                            margin: const EdgeInsets.only(bottom: 8.0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 8.0),
                                Text(
                                  'Question: $question',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8.0),
                                Text(
                                  'Answer: $answer',
                                  style: const TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                                if (imageUrl != null &&
                                    imageUrl.isNotEmpty) ...[
                                  const SizedBox(height: 8.0),
                                  LayoutBuilder(
                                    builder: (BuildContext context,
                                        BoxConstraints constraints) {
                                      final imageSize = constraints.maxWidth;
                                      return SizedBox(
                                        width: double.infinity,
                                        height: imageSize,
                                        child: Image.network(
                                          imageUrl,
                                          fit: BoxFit.cover,
                                        ),
                                      );
                                    },
                                  ),
                                ],
                                const SizedBox(height: 8.0),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    IconButton(
                                      onPressed: () => _updateLikes(
                                          index, documentId, isLiked),
                                      icon: Icon(
                                        isLiked
                                            ? Icons.thumb_up_alt
                                            : Icons.thumb_up,
                                      ),
                                    ),
                                    Text(
                                      'Likes: $currentLikes',
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                    IconButton(
                                      onPressed: () => _shareQuestionAnswer(
                                        question,
                                        answer,
                                        imageUrl,
                                      ),
                                      icon: const Icon(
                                        Icons.share,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
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
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => QuestionSearchScreen()));
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

  void _fetchQuestionAndAnswers(
      QuerySnapshot<Map<String, dynamic>> snapshot) async {
    final updatedQuestionAnswerList =
        await Future.wait(snapshot.docs.map((doc) async {
      final question = doc.data()['question'] ?? '';
      final answer = doc.data()['answer'] ?? '';
      final imageUrl = doc.data()['imageUrl'] ?? '';
      final likes = doc.data()['likes'] ?? 0;
      final likedBy = doc.data()['likedBy'] ?? [];

      dynamic image;
      if (imageUrl.isNotEmpty) {
        try {
          final response = await http.get(Uri.parse(imageUrl));
          if (response.statusCode == 200) {
            final bytes = response.bodyBytes;
            image = base64Encode(bytes);
          }
        } catch (error) {
          print('Error fetching image: $error');
        }
      }

      final currentUser = FirebaseAuth.instance.currentUser;
      final isLiked = likedBy.contains(currentUser?.uid);

      return {
        'question': question,
        'answer': answer,
        'image': image ?? '',
        'imageUrl': imageUrl,
        'likes': likes,
        'documentId': doc.id,
        'isLiked': isLiked,
      };
    }));

    setState(() {
      questionAnswerList = updatedQuestionAnswerList;
      isLoading = false; // Set isLoading to false after data is fetched
    });
  }

  // Rest of the code remains the same...
  void _updateLikes(int index, String documentId, bool isLiked) {
    final currentUser = FirebaseAuth.instance.currentUser;
    final currentLikes = questionAnswerList[index]['likes'] ?? 0;

    if (isLiked) {
      // Decrement like count and remove user from likedBy list
      FirebaseFirestore.instance.collection('answers').doc(documentId).update({
        'likes': currentLikes - 1,
        'likedBy': FieldValue.arrayRemove([currentUser?.uid])
      }).then((_) {
        setState(() {
          questionAnswerList[index]['likes'] = currentLikes - 1;
          questionAnswerList[index]['isLiked'] = false;
        });
      }).catchError((error) {
        print('Error updating likes: $error');
      });
    } else {
      // Increment like count and add user to likedBy list
      FirebaseFirestore.instance.collection('answers').doc(documentId).update({
        'likes': currentLikes + 1,
        'likedBy': FieldValue.arrayUnion([currentUser?.uid])
      }).then((_) {
        setState(() {
          questionAnswerList[index]['likes'] = currentLikes + 1;
          questionAnswerList[index]['isLiked'] = true;
        });
      }).catchError((error) {
        print('Error updating likes: $error');
      });
    }
  }

  void _shareQuestionAnswer(
    String question,
    String answer,
    String imageUrl,
  ) async {
    final shareText = 'Question: $question\n\nAnswer: $answer';

    if (imageUrl != null && imageUrl.isNotEmpty) {
      try {
        final response = await http.get(Uri.parse(imageUrl));
        if (response.statusCode == 200) {
          final directory = await getTemporaryDirectory();
          final imagePath = '${directory.path}/image.jpg';

          File(imagePath).writeAsBytesSync(response.bodyBytes);

          Share.shareFiles([imagePath], text: shareText);
        } else {
          Share.share(shareText);
        }
      } catch (e) {
        print('Error sharing image: $e');
        Share.share(shareText);
      }
    } else {
      Share.share(shareText);
    }
  }
}
