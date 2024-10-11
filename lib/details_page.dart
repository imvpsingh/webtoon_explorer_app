import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DetailScreen extends StatefulWidget {
  final String webtoonTitle;
  final bool isTrue;
  final Map<String, String> webtoon;
  final String webtoonImage;
  final String webtoonDescription;
  final String webtoonCreator;

  const DetailScreen({super.key, required this.webtoonTitle, required this.webtoonImage, required this.webtoonDescription, required this.webtoonCreator, required this.webtoon,  this.isTrue=false});

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  double _rating = 3.0; // i can handle rating also but i not take more time to this project.
  List<String> _favorites = [];

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _favorites = prefs.getStringList('favorites') ?? [];
    });
  }

  Future<void> _addToFavorites(Map<String, String> webtoon) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> favoriteWebtoons = prefs.getStringList('favorites') ?? [];

    favoriteWebtoons.add(jsonEncode(webtoon));
    await prefs.setStringList('favorites', favoriteWebtoons);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${webtoon['title']} added to favorites!')),
    );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.webtoonTitle)),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 4.0),
              child: Image.asset(widget.webtoonImage,height: 120,),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 5.0),
              child: Text('Description of ${widget.webtoonTitle}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 5.0),
              child: Text(widget.webtoonDescription, style: const TextStyle(fontSize: 15,wordSpacing: 1.5,letterSpacing: 0.5,),maxLines: 15,),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 5.0),
             child:  Text('Creator: ${widget.webtoonCreator}', style: const TextStyle(fontSize: 14,letterSpacing: 0.5,fontWeight: FontWeight.w600),),
            ),
            TextButton(
              onPressed: (){_addToFavorites(widget.webtoon);},
              child: const Row(
                children: [
                  Text('Add to Favorites',style: TextStyle(color: Colors.red),),
                  SizedBox(width: 5,),
                  Icon(Icons.favorite_outline_sharp,color: Colors.red,)
                ],
              ),
            ),
            const SizedBox(height: 15),
             Padding(
               padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 5.0),
               child: Text('Rate ${widget.webtoonTitle}'),
             ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 5.0),
              child: RatingBar.builder(
                itemSize: 20,
                initialRating: _rating,
                minRating: 1,
                maxRating: 5,
                itemCount: 5,
                itemBuilder: (context, _) => const Icon(Icons.star, color: Colors.amber),
                onRatingUpdate: (rating) {
                  setState(() {
                    _rating = rating;
                  });
                },
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
