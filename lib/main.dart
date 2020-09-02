import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_boost/flutter_boost.dart';
import 'package:flutter_module/constants/colors.dart';
import 'package:flutter_module/constants/routes.dart';
import 'package:flutter_module/page/test/test.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();

    if (Platform.isAndroid) {
      // 以下两行 设置android状态栏为透明的沉浸。
      // 写在组件渲染之后，是为了在渲染后进行set赋值，覆盖状态栏，写在渲染之前MaterialApp组件会覆盖掉这个值。
      SystemUiOverlayStyle systemUiOverlayStyle =
          SystemUiOverlayStyle(statusBarColor: Colors.transparent);
      SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
    }
    //注册路由页面
    FlutterBoost.singleton.registerPageBuilders({
      // 测试界面
      RouteConstant.flutterTest: (pageName, params, _) => TestPage(params),
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'flutter_module',
      builder: FlutterBoost.init(postPush: _onRoutePushed),
      theme: ThemeData(
          scaffoldBackgroundColor: ColorConstant.backColor,
          primaryColor: ColorConstant.primary, //主题色
          accentColor: ColorConstant.foreColor, //文本、按钮等前景色，通用灰色
          textTheme: TextTheme(
              subtitle1:
                  TextStyle(color: ColorConstant.textNormal, fontSize: 16))),
      home: MainPage(),
    );
  }

  void _onRoutePushed(
      String pageName, String uniqueId, Map params, Route route, Future _) {}
}

class MainPage extends StatefulWidget {
  @override
  MainPageState createState() => MainPageState();
}

class MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(title: Text('调试模式')),
        body: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            _createItemWidget('测试页面', TestPage({'content': 'Content From Flutter MainPage'})),
          ],
        ));
  }

  Widget _createItemWidget(String name, Widget widget) {
    return new Container(
      child: GestureDetector(
        child: Text(
          name,
          style: TextStyle(
            color: Colors.white
          ),
          textAlign: TextAlign.center,
        ),
        onTap: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => widget));
        },
      ),
      padding: EdgeInsets.all(10.0),
      margin: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(10.0),
      ),
    );
  }
}
