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
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'News API',
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w500,
                      color: Colors.amber),
                ),
                SizedBox(
                  height: 20,
                ),
                StyleText(
                    text: 'swag',
                    size: 30,
                    //color: Colors.blue,
                    weight: FontWeight.w500),
              ],
            )));
  }
}

class StyleText extends StatelessWidget {
  final String text;
  final double size;
  final Color color;
  final FontWeight weight;
  const StyleText(
      {Key? key,
      required this.text,
      required this.size,
      this.color = const Color.fromARGB(255, 29, 210, 135),
      required this.weight})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(text,
        style: TextStyle(fontSize: size, color: color, fontWeight: weight));
  }
}
