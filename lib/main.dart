import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mojadel2/yomojomo/messageboard.dart';
import 'homepage/home_detail.dart';
import 'mypage/login/loginpage.dart';
import 'mypage/mypage.dart';
import 'checkList/checkListTest.dart';  // 필요한 경로를 입력하세요

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ChecklistModel()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp ({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'mojadel',
      debugShowCheckedModeBanner: false,
      routes: {
        '/login' : (context) => LogInPage(),
        '/mypagesite' : (context) => MyPageSite(),
        '/checklist' : (context) => ChecklistPage(),  // 여기 추가
      },
      home: HomePage(),
    );
  }
}