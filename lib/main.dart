import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:date_utils/date_utils.dart' as date_utils;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(pageTitle: 'Yoga generator'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.pageTitle}) : super(key: key);
  final String pageTitle;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<Image> image;

  @override
  void initState() {
    super.initState();
    image = _getFirstGif();
  }

  Future<Image> _getFirstGif() async {
    var now = new DateTime.now();
    String fixSearchUrl = "https://api.giphy.com/v1/gifs/search?";
    String apiKeyUrl = "api_key="+"hcKpPwHA8VH8LiCBja9kiuEmBeMbT2YJ";
    String parametersSearchUrl = "&q=yoga&limit=1&offset="+now.day.toString()+"&rating=G&lang=en";
    var response = await http.get(fixSearchUrl+apiKeyUrl+parametersSearchUrl);
    var body = response.body;
    Map<String, dynamic> parsedJson = json.decode(body);
    List datalist = parsedJson["data"];
    Map firstDataElement = datalist[0];
    Map images = firstDataElement["images"];
    Map originalMapImage = images["original"];
    String url = originalMapImage["url"];
    var image = Image.network(url);
    return image;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Yoga Generator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text(widget.pageTitle),
        ),
        body: Center(
          child: FutureBuilder<Image>(
            future: image,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return snapshot.data;
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }

              // By default, show a loading spinner.
              return CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
}
