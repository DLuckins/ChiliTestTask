import "package:flutter/material.dart";

class GifDescPage extends StatelessWidget {
  const GifDescPage({super.key});

  @override
  Widget build(BuildContext context) {
    final gifInfo =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    if (gifInfo == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Gif Description'),
          centerTitle: true,
        ),
        body: const Center(
          child: Text('No GIF data available'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gif Description'),
        centerTitle: true,
      ),
      body: Container(
        margin: EdgeInsets.only(left: 10, right: 10),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(top: 10),
                child: Center(
                  child: Text(
                    gifInfo["title"],
                    style: TextStyle(
                      color: const Color.fromARGB(111, 0, 0, 0),
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
              ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 300),
                child: Center(
                  child: FadeInImage.assetNetwork(
                    placeholder: "assets/loading-gif.gif",
                    image: gifInfo["images"]["fixed_height"]["url"],
                    placeholderFit: BoxFit.contain,
                    imageErrorBuilder: (context, error, stackTrace) {
                      return Center(child: Text('Image failed to load'));
                    },
                  ),
                ),
              ),
              Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    child: Row(
                      children: <Widget>[
                        if (gifInfo["user"]?.isNotEmpty ?? false)
                          Container(
                            margin: EdgeInsets.only(right: 5),
                            child: FadeInImage.assetNetwork(
                              width: 40,
                              height: 40,
                              placeholder: "assets/loading-gif.gif",
                              image: gifInfo["user"]["avatar_url"],
                              fit: BoxFit.cover,
                              placeholderFit: BoxFit.contain,
                              imageErrorBuilder: (context, error, stackTrace) {
                                return Center(
                                    child: Text('Image failed to load'));
                              },
                            ),
                          ),
                        if (gifInfo["username"]?.isNotEmpty ?? false)
                          Text(
                            gifInfo["username"],
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          )
                        else
                          Text(
                            "Guest",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      margin: EdgeInsets.only(top: 10),
                      child: Text(
                        "Posted on ${gifInfo["import_datetime"]}",
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      margin: EdgeInsets.only(top: 10),
                      child: Text(
                        "Rating: ${gifInfo["rating"]}",
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
