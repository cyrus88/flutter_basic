part of 'main.dart';


class RssFeedItemDetail extends StatefulWidget {
  final String url;

  RssFeedItemDetail({Key key, @required this.url}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _RssFeedDetailState(url);
  }

}

class _RssFeedDetailState extends State<RssFeedItemDetail>{
  String url;

  _RssFeedDetailState(String url){
    this.url = url;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Feed Detail')),
        body: Column(
          children: [
            Expanded(
                child: WebView(
                    javascriptMode: JavascriptMode.unrestricted,
                    initialUrl: url))
          ],
        ));
  }
}