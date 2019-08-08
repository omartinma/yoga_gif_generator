import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

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
  //Future<Image> image;

  @override
  void initState() {
    super.initState();
    //image = _getFirstGif();
  }

  Future<Image> _getFirstGif() async {
    // Make API call
    var now = new DateTime.now();
    String fixSearchUrl = "https://api.giphy.com/v1/gifs/search?";
    String apiKeyUrl = "api_key=" + "hcKpPwHA8VH8LiCBja9kiuEmBeMbT2YJ";
    String parametersSearchUrl =
        "&q=yoga&limit=1&offset=" + now.day.toString() + "&rating=G&lang=en";
    var response =
        await http.get(fixSearchUrl + apiKeyUrl + parametersSearchUrl);

// Parse API
    Map<String, dynamic> parsedJson = json.decode(response.body);
    List datalist = parsedJson["data"];
    Map firstDataElement = datalist[0];
    Map images = firstDataElement["images"];
    Map originalMapImage = images["original"];
    String url = originalMapImage["url"];
    var image = Image.network(url, width: 100);

    return image;
  }

  String _getTodayFormat() {
    var now = new DateTime.now();
    var formatter = new DateFormat('yyyy-MM-dd');
    String formatted = formatter.format(now);
    return formatted;
  }

  String _getNameOfDay() {
    var now = new DateTime.now();
    var formatter = new DateFormat('EEEE');
    String formatted = formatter.format(now);
    return formatted;
  }

  Widget _buildContent() {
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.max,
        children: [
          Padding(
            padding: EdgeInsets.all(40.0),
          ),
          Text(
            "Hello buddy!!",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 30),
          ),
          Text(
            "Lets practice some yoga on " + _getNameOfDay(),
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 22),
          ),
          Padding(
            padding: EdgeInsets.all(40.0),
          ),
          Container(
            margin: EdgeInsets.all(15),
            child: new PhysicalModel(
              elevation: 15,
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(30.0),
              clipBehavior: Clip.hardEdge,
              child: FutureBuilder<Image>(
                future: _getFirstGif(),
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
          )
        ]);
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
          body: Container(
            child: _buildContent(),
          )),
    );
  }
}
