import 'package:flutter/material.dart';
import 'package:trabalho/classes/app_route.dart';
import 'package:trabalho/pages/add.page.dart';
import 'package:trabalho/pages/edit_page.dart';
import 'package:trabalho/pages/home_page.dart';

void main() {
  runApp(MyApp());
}

const URL_BASE = 'http://192.168.0.104:8888/backend/index.php/produto';

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Trabalho API',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      routes: {
        AppRoutes.HOME_PAGE: (_) => HomePage(),
        AppRoutes.ADD_PAGE: (_) => AddPage(),
        AppRoutes.EDIT_PAGE: (_) => EditPage()
      },
    );
  }
}
