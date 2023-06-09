// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors

import 'package:project/Screens/Notification%20Section/notification.dart';
import 'package:project/Screens/Donation%20Section/donation_screen.dart';
import 'package:project/SearchScreen/search_screen.dart';

import '../Import/imports.dart';
import 'Blog Section/blog_home.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF012630),
      appBar: AppBar(
        backgroundColor: const Color(0xFFD9D9D9),
        title: const Text(
          'Home',
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              buildContainer(
                  Icons.extension, 'My\nProjects', HomeScreen(), context),
              buildContainer(Icons.folder_open, 'Directory\nSection',
                  HomeScreen(), context),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              buildContainer(Icons.question_answer, 'Forum\nSection',
                  const ForumScreen(), context),
              buildContainer(Icons.article_outlined, 'Blog/News\nSection',
                  BlogScreen(), context),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // buildContainer(Icons.messenger, 'Chat\nSection'),
              buildContainer(Icons.volunteer_activism, 'Donation\nSection',
                  TechDonation(), context),
            ],
          ),
        ],
      ),
      bottomNavigationBar: buildBottomNavigationBar(context),
    );
  }

  Widget buildContainer(IconData icon, String label, Widget destinationScreen,
      BuildContext context) {
    return InkWell(
      onTap: () {
        // Handle button tap here
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => destinationScreen),
        );
      },
      child: Container(
        height: 150,
        width: 150,
        decoration: BoxDecoration(
          color: const Color(0xFFD9D9D9),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 40,
            ),
            const SizedBox(height: 10),
            Text(
              label,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
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
                MaterialPageRoute(builder: (context) => SearchScreen()));
          }),
          buildBottomIconButton(Icons.notifications, () {
            // Handle Notifications button press
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => NotificationView()));
          }),
          buildBottomIconButton(Icons.person, () {
            // Handle Profile button press
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => ProfileScreen()));
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
