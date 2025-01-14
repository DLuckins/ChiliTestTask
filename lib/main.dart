import 'package:flutter/material.dart';
import 'package:flutter_application_1/blocks/gif/gif_bloc.dart';
import 'package:flutter_application_1/pages/gif_desc_page.dart';
import 'package:flutter_application_1/pages/gif_search_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          scaffoldBackgroundColor: const Color.fromARGB(255, 232, 224, 144),
          fontFamily: 'Montserrat',
          appBarTheme: AppBarTheme(
              backgroundColor: const Color.fromARGB(255, 179, 168, 50))),
      home: MultiBlocProvider(
        providers: [BlocProvider(create: (context) => GifBloc())],
        child: const GifSearchPage(),
      ),
      routes: {
        '/searchpage': (context) => const GifSearchPage(),
        '/descpage': (context) => const GifDescPage(),
      },
    );
  }
}
