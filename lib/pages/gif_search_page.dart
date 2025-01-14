import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/blocks/gif/gif_bloc.dart';
import 'package:flutter_application_1/blocks/gif/gif_event.dart';
import 'package:flutter_application_1/blocks/gif/gif_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:async';
import 'package:http/http.dart' as http;

class GifSearchPage extends StatefulWidget {
  const GifSearchPage({super.key});
  @override
  State<GifSearchPage> createState() => _GifSearchPageState();
}

class _GifSearchPageState extends State<GifSearchPage> {
  bool _hasInternetConnection = true;
  bool _hasMore = true;
  List<Map<String, dynamic>> gifs = [];
  Timer? _checkTypingTimer;
  final _scrollController = ScrollController();
  var searchWord = "";
  var error = "";
  late StreamSubscription<List<ConnectivityResult>> subscription;
  @override
  void initState() {
    super.initState();
    subscription = Connectivity()
        .onConnectivityChanged
        .listen((List<ConnectivityResult> result) {
      if (result.contains(ConnectivityResult.mobile) ||
          result.contains(ConnectivityResult.wifi) ||
          result.contains(ConnectivityResult.ethernet) ||
          result.contains(ConnectivityResult.vpn) ||
          result.contains(ConnectivityResult.other)) {
        setState(() {
          _hasInternetConnection = true;
        });
      } else {
        setState(() {
          error = "";
          _hasInternetConnection = false;
        });
      }
    });
    _scrollController.addListener(_loadMore);
  }

  @override
  void dispose() {
    subscription.cancel();
    _checkTypingTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final gifBloc = context.read<GifBloc>();
    return Scaffold(
        appBar: AppBar(
          title: const Text('Gif search'),
          centerTitle: true,
        ),
        body: Column(
          children: [
            _searchfield(context, gifBloc),
            _gifs(context),
          ],
        ));
  }

  Widget _searchfield(BuildContext context, GifBloc gifBloc) {
    return BlocBuilder<GifBloc, GifState>(
      builder: (context, state) {
        return Container(
          margin: EdgeInsets.only(top: 10, left: 10, right: 10),
          child: SearchBar(
            leading: const Icon(Icons.search),
            hintText: "Search...",
            onChanged: (value) {
              resetTimer(value, gifBloc);
            },
          ),
        );
      },
    );
  }

  resetTimer(String value, GifBloc gifBloc) {
    _checkTypingTimer?.cancel();
    startTimer(value, gifBloc);
  }

  startTimer(String value, GifBloc gifBloc) {
    _checkTypingTimer = Timer(const Duration(milliseconds: 800), () {
      gifs = [];
      _hasMore = true;
      gifBloc.add(GifSearch(word: value));
    });
  }

  Widget _gifs(BuildContext context) {
    return BlocBuilder<GifBloc, GifState>(
      builder: (context, state) {
        final gifBloc = context.read<GifBloc>();
        if (state is SearchState) {
          getGifs(state.search, gifBloc, 0);
          searchWord = state.search;
        }
        if (gifs.isNotEmpty) {
          gifBloc.add(GifFound());
          return Expanded(
            child: Container(
              margin: EdgeInsets.only(top: 10, left: 10, bottom: 10, right: 10),
              child: ListView(
                controller: _scrollController,
                children: [
                  GridView.builder(
                    shrinkWrap: true,
                    itemCount: gifs.length,
                    physics: ScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3),
                    itemBuilder: (context, index) {
                      return GridTile(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, "/descpage",
                                arguments: gifs[index]);
                          },
                          child: FadeInImage.assetNetwork(
                            placeholder: "assets/loading-gif.gif",
                            image: gifs[index]["images"]["fixed_height"]["url"],
                            fit: BoxFit.cover,
                            placeholderFit: BoxFit.contain,
                            imageErrorBuilder: (context, error, stackTrace) {
                              return Center(
                                  child: Text('Image failed to load'));
                            },
                          ),
                        ),
                      );
                    },
                  ),
                  if (_hasMore)
                    Center(
                      child: CircularProgressIndicator(),
                    ),
                ],
              ),
            ),
          );
        } else if (!_hasInternetConnection) {
          return Text(
            "No internet connection, \nplease, connect to the internet!",
            style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          );
        } else if (error.isNotEmpty) {
          return Text(
            error,
            style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          );
        } else {
          return GridView.count(
            shrinkWrap: true,
            physics: ScrollPhysics(),
            crossAxisCount: 3,
          );
        }
      },
    );
  }

  void _loadMore() {
    if ((_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent)) {
      final gifBloc = context.read<GifBloc>();
      if (_hasMore && (gifBloc.state is! LoadingState)) {
        getGifs(searchWord, gifBloc, gifs.length);
      }
    }
  }

  getGifs(String search, GifBloc gifBloc, int offset) async {
    error = "";
    gifBloc.add(GifLoading());
    String apiKey = "KjkmwcPSiN9CEtIy1D0wyi47tFjVirWY";
    String url =
        "https://api.giphy.com/v1/gifs/search?api_key=$apiKey&q=$search&limit=21&offset=$offset";
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body)["data"];
        if (data.isEmpty || data.length < 21) {
          setState(() {
            _hasMore = false;
          });
        }

        setState(() {
          for (var element in data) {
            gifs.add(element);
          }
        });
      } else {
        setState(() {
          _hasMore = false;
          error = "Http error occured, status code:${response.statusCode}";
        });
      }
    } on Exception {
      setState(() {
        _hasMore = false;
        error = "Couldn't connect to api.giphy.com";
      });
    }
  }
}
