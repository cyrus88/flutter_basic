part of 'main.dart';



class RssFeedItem extends StatefulWidget {
  String listType;

  RssFeedItem({Key key, @required this.listType}) : super(key: key);


  @override
  State<StatefulWidget> createState() {
    return _RssFeedItemState(listType);
  }
}
  class _RssFeedItemState extends State<RssFeedItem>{
    static const String title = 'Feeds';
    String listType;

    _RssFeedItemState(String listType){
      this.listType = listType;
    }

    Future<String> fetchPost() async {
      final response = await http
          .get('https://timesofindia.indiatimes.com/rssfeedstopstories.cms');

      if (response.statusCode == 200) {
        // If server returns an OK response, parse the JSON.
//      return Post.fromJson(json.decode(response.body));
        return response.body;
      } else {
        // If that response was not OK, throw an error.
        throw Exception('Failed to load post');
      }
    }


    @override
  Widget build(BuildContext context) {
    return new Scaffold(
            appBar: AppBar(title: const Text(title)), body: RssParser()
    );
  }

  Widget listBuilder(List<RssItem> data) {
    if (listType == 'Card View') {
      return new ListView.builder(
          itemCount: data.length,
          padding: new EdgeInsets.all(8.0),
          itemBuilder: (context, index) {
            return cardContainer(context, data, index);
          });
    } else if (listType == 'List View') {
      return listContainer(data);
    } else {
      return new ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, index) {
          return new ExpansionTile(
            title: new Text(
              data[index].title,
              style: new TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic),
            ),
            children: <Widget>[
              new Column(
                children: _buildExpandableContent(data[index]),
              ),
            ],
          );
        },
      );
    }
  }

  _buildExpandableContent(RssItem item) {
    List<Widget> columnContent = [];

    columnContent.add(
      new ListTile(
        title: new Text(
          item.description,
          style: new TextStyle(fontSize: 18.0),
        ),
      ),
    );

    return columnContent;
  }

  Widget listContainer(List<RssItem> data) {
    return ListView.separated(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: data.length,
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
            title: Text(data[index].title),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      RssFeedItemDetail(url: data[index].link),
                ),
              );
            });
      },
      separatorBuilder: (context, index) {
        return Divider();
      },
    );
  }

  Widget cardContainer(BuildContext context, List<RssItem> data, int index) {
    return new Card(
      child: new InkWell(
        onTap: () {
//          Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RssFeedItemDetail(url: data[index].link),
            ),
          );
        },
        child: Container(
          child: Stack(
            alignment: Alignment.bottomLeft,
            children: <Widget>[
              Image.network(
                "https://i.ndtvimg.com/i/2017-12/delhi-india-gate_650x400_71512575768.jpg",
                width: 390,
                height: 300,
                fit: BoxFit.fitHeight,
                alignment: Alignment.center,
              ),
              Container(
                color: Colors.white.withOpacity(0.5),
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Text(data[index].title, style: TextStyle(fontSize: 22)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget RssParser() {
    return new Container(
      child: new FutureBuilder<String>(
        future: fetchPost(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var channel = new RssFeed.parse(snapshot.data);
            List<RssItem> data = channel.items;
            return listBuilder(data);
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }

          // By default, show a loading spinner.
          return _buildProgressIndicator();
        },
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Container(
      alignment: Alignment.center,
      child: CircularProgressIndicator(),
    );
  }
}