// Flutter code sample for

// The following example (depicted above) transitions an AnimatedContainer
// between two states. It adjusts the [height], [width], [color], and
// [alignment] properties when tapped.

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:webfeed/webfeed.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:workmanager/workmanager.dart';
part 'feed.dart';
part 'feedDetail.dart';

void callbackDispatcher() {
  Workmanager.executeTask((backgroundTask) {
    print(
        "Native called background task: $backgroundTask"); //simpleTask will be emitted here.

    //Return true when the task executed successfully or not
    return Future.value(true);
  });
}

void main() {
  Workmanager.initialize(
      callbackDispatcher, // The top level function, aka callbackDispatcher
      isInDebugMode: true
      );
  Workmanager.registerPeriodicTask("1", "simpleTask");
  runApp(MyApp());
}

/// This Widget is the main application widget.
class MyApp extends StatelessWidget {
  static const String _title = 'Types of List';
  RssImage image;

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: _title,
      home: Scaffold(
          appBar: AppBar(title: const Text(_title)), body: MyStatefulWidget()),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  MyStatefulWidget({Key key}) : super(key: key);

  @override
  _MyStatefulWidgetState createState() => _MyStatefulWidgetState();
}



class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  @override
  Widget build(BuildContext context) {
    return _myListView(context);
  }

  Widget _myListView(BuildContext context) {
    final typeOfLists = ['Card View', 'List View', 'Extended List View'];
    return ListView.separated(
      itemCount: typeOfLists.length,
      itemBuilder: (context, index) {
        return ListTile(
            /*leading: CircleAvatar(
              backgroundImage: new CachedNetworkImage(imageUrl: data.),
            ),*/
            title: Text(typeOfLists[index]),
            trailing: Icon(Icons.keyboard_arrow_right),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      RssFeedItem(listType: typeOfLists[index]),
                ),
              );
            });
      },
      separatorBuilder: (context, index) {
        return Divider();
      },
    );
  }
}
