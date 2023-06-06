import 'package:flutter/material.dart';

class NewsAPI extends StatefulWidget {
  const NewsAPI({Key? key}) : super(key: key);

  @override
  State<NewsAPI> createState() => _NewsAPIState();
}

class _NewsAPIState extends State<NewsAPI> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.amber,
      ),
    );
  }
}
