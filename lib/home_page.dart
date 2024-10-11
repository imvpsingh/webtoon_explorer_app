import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webtoon_explorer_app/provider/webToon_provider.dart';

import 'details_page.dart';

class HomeScreen extends StatelessWidget {


   HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Webtoon Explorer'),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 10.0,top: 2,bottom: 2),
          child: IconButton(onPressed: (){
            Navigator.pushNamed(context, '/favorites');
          }, icon: const Icon(Icons.favorite_outline_sharp,color: Colors.red,)),
        )
      ],
      ),
      body: Consumer<WebToonProvider>(
        builder: (context,provider,child) {
          return ListView.builder(
            itemCount: provider.webToonCategories.length,
            itemBuilder: (context, index) {
              final category = provider.webToonCategories[index];
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
                      child: Image.asset(category['image']!, height: 300,fit: BoxFit.cover,)),
                  title: Text(category['title']!,style: const TextStyle(fontWeight: FontWeight.w500),),
                  subtitle:  Text('Creator: ${category['Creator']!}'),
                  trailing: OutlinedButton(onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailScreen(
                          webtoonTitle: category['title']!,
                          webtoon: category,
                          webtoonImage: category['image']!,
                          webtoonCreator: category['Creator']!,
                          webtoonDescription: category['description']!,
                        ),
                      ),
                    );
                  }, child: const Text("Explore")),
                ),
              );
            },
          );
        }
      ),
    );
  }
}
