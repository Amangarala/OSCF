import 'package:project/Import/imports.dart';

class NotificationView extends StatefulWidget {
  const NotificationView({Key? key}) : super(key: key);

  @override
  State<NotificationView> createState() => _NotificationViewState();
}

class _NotificationViewState extends State<NotificationView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff012630),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Notifications",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Container(),
      // listView(),
      bottomNavigationBar: buildBottomNavigationBar(),
    );
  }

  Widget buildBottomNavigationBar() {
    return BottomAppBar(
      color: const Color(0xFFD9D9D9),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          buildBottomIconButton(Icons.home, () => HomeScreen()),
          buildBottomIconButton(Icons.search, () => const NotificationView()),
          buildBottomIconButton(
              Icons.notifications, () => const NotificationView()),
          buildBottomIconButton(Icons.person, () => const ProfileScreen()),
        ],
      ),
    );
  }

  Widget buildBottomIconButton(IconData iconData, VoidCallback onPressed) {
    return IconButton(
      icon: Icon(iconData),
      onPressed: onPressed,
    );
  }
}
