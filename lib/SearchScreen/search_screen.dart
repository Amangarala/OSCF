import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late TextEditingController _searchController;
  List<Map<String, dynamic>> _searchResults = [];

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<List<Map<String, dynamic>>> _searchData(String query) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('your_collection') // Replace with your collection name
        .where('text', isGreaterThanOrEqualTo: query)
        .where('text', isLessThan: query + 'z')
        .get();

    final searchDataList = snapshot.docs.map((doc) => doc.data()).toList();
    return searchDataList;
  }

  void _performSearch(String query) async {
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
      });
      return;
    }

    final searchData = await _searchData(query);

    setState(() {
      _searchResults = searchData;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          onChanged: _performSearch,
          decoration: InputDecoration(
            hintText: 'Search...',
            border: InputBorder.none,
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: _searchResults.length,
        itemBuilder: (context, index) {
          final searchData = _searchResults[index];

          return ListTile(
            title: Text(searchData['text']),
            subtitle: Text(searchData['description']),
          );
        },
      ),
    );
  }
}
