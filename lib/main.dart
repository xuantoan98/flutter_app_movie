import 'package:flutter/material.dart';
// import 'package:flutter_app/pages/movie_list_page.dart';
// import 'package:flutter_app/view_models/movie_list_view_model.dart';
// import 'package:provider/provider.dart';
import 'package:flutter_app/widgets/login_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "Flutter Login UI",
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: MyHomePage(title: 'Flutter Login'));
  }
}

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//         title: "Movies",
//         home: ChangeNotifierProvider(
//           create: (context) => MovieListViewModel(),
//           child: MovieListPage(),
//         ));
//   }
// }
