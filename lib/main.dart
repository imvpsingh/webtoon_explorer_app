import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webtoon_explorer_app/provider/webToon_provider.dart';

import 'favorite_page.dart';
import 'home_page.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => WebToonProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Webtoon Explorer',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HomeScreen(),
      routes: {
        '/favorites': (context) =>  const FavoritesScreen(),
      },
    );
  }
}

