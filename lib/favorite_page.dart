import 'dart:convert'; // Import for jsonEncode and jsonDecode
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webtoon_explorer_app/details_page.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  FavoritesScreenState createState() => FavoritesScreenState();
}

class FavoritesScreenState extends State<FavoritesScreen> {
  List<Map<String, String>> _favorites = []; // Store decoded webtoon objects

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> favoriteWebtoons = prefs.getStringList('favorites') ?? [];

    setState(() {
      _favorites = favoriteWebtoons.map((webtoonJson) {
        try {
          // Decode the JSON string to a Map<String, dynamic>
          Map<String, dynamic> webtoonMap = jsonDecode(webtoonJson);

          // Cast the dynamic values to String explicitly and ensure all are strings
          return webtoonMap.map((key, value) => MapEntry(key, value.toString()));
        } catch (e) {
          print('Error decoding JSON: $e');
          return <String, String>{}; // Return an empty map if decoding fails
        }
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Favorites')),
      body: _favorites.isEmpty
          ? const Center(child: Text('No favorites added yet!'))
          :ListView.builder(
        itemCount: _favorites.length,
        itemBuilder: (context, index) {
          Map<String, String> webtoon = _favorites[index];
          if (webtoon.isEmpty) {
            return const SizedBox.shrink();
          }

          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 0,vertical: 8),
            margin: const EdgeInsets.symmetric(horizontal: 5,vertical: 6),
            decoration:  BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                border: Border.all(color: Colors.blueGrey)
            ),
            child: ListTile(
              leading: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  child: Image.asset( webtoon['image']!, height: 300,fit: BoxFit.cover,)),
              title: Text(webtoon['title'] ?? 'No Title',style: const TextStyle(fontWeight: FontWeight.w500),),
              subtitle:  Text('Creator: ${webtoon['Creator'] ?? 'Unknown'}'),
              trailing:IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => _removeFromFavorites(index),
              ),

             onTap:  () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailScreen(
                      webtoonTitle: webtoon['title']!,
                      webtoon: webtoon,
                      webtoonImage: webtoon['image']!,
                      webtoonCreator: webtoon['Creator']!,
                      webtoonDescription: webtoon['description']!,
                    ),
                  ),
                );
              }, ),
          );
        },
      ),
    );
  }

  Future<void> _removeFromFavorites(int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> favoriteWebtoons = prefs.getStringList('favorites') ?? [];
    favoriteWebtoons.removeAt(index);
    await prefs.setStringList('favorites', favoriteWebtoons);
    setState(() {
      _favorites.removeAt(index);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Webtoon removed from favorites!')),
    );
  }
}
