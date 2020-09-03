import 'package:flutter/material.dart';
import 'package:flutter_boost/flutter_boost.dart';
import 'package:flutter_module/constants/routes.dart';
import 'package:flutter_module/utils/toast.dart';

/// 测试页面
class TestPage extends StatefulWidget {
  final Map params;

  TestPage(this.params);

  @override
  _TestPageState createState() => _TestPageState(params);
}

class _TestPageState extends State<TestPage> {
  final Map params;

  _TestPageState(this.params) : assert(params != null);

  @override
  void initState() {
    super.initState();
    print('params：' + params.toString());
    FlutterBoost.singleton.channel.addEventListener(
        "nativeEventBus", (name, arguments) => nativeEventBus(name, params));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: new Scaffold(
        appBar: new AppBar(
          title: new Text(
            '测试页面',
            style: new TextStyle(fontSize: 20, color: Colors.white),
          ),
          centerTitle: true,
          backgroundColor: Colors.blue,
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back),
            color: Colors.white,
            onPressed: () {
              closeFlutter(context);
            },
          ),
        ),
        body: new Container(
          color: Colors.white,
          child: new ListView(
            children: <Widget>[
              new Container(
                alignment: Alignment.center,
                child: new Text(
                  params['content'],
                  style: new TextStyle(
                      color: Colors.red,
                      fontSize: 25,
                      fontWeight: FontWeight.normal,
                      decoration: TextDecoration.none),
                ),
              ),
              new Container(
                alignment: Alignment.center,
                child: new MaterialButton(
                    minWidth: double.infinity,
                    child: new Text("打开原生的toast"),
                    color: Colors.greenAccent,
                    onPressed: () {
                      openNativeToast();
                    }),
              ),
              new Container(
                alignment: Alignment.center,
                child: new MaterialButton(
                    minWidth: double.infinity,
                    child: new Text("打开原生的Test页面"),
                    color: Colors.greenAccent,
                    onPressed: () {
                      openNativePage();
                    }),
              ),
              new Container(
                alignment: Alignment.center,
                child: new MaterialButton(
                    minWidth: double.infinity,
                    child: new Text("发送全局消息"),
                    color: Colors.greenAccent,
                    onPressed: () {
                      sendEvent();
                    }),
              ),
              new Container(
                alignment: Alignment.center,
                child: new MaterialButton(
                    minWidth: double.infinity,
                    child: new Text("打开ECharts页面"),
                    color: Colors.greenAccent,
                    onPressed: () {
                      FlutterBoost.singleton.open(RouteConstant.flutterECharts);
                    }),
              ),
            ],
          ),
        ),
      ),
      onWillPop: () => onBackPressed(context),
    );
  }

  //监听物理返回键
  onBackPressed(BuildContext context) {
    closeFlutter(context);
  }

  //返回上一级页面
  void closeFlutter(BuildContext context) {
    FlutterBoost.singleton.closeByContext(context,
        result: {"result": "Result From Flutter TestPage"},
        exts: {'animated': true});
    Navigator.of(context).pop();
  }

  //使用原生的Toast组件弹出消息
  void openNativeToast() {
    ToastUtil.toast("Content From Flutter TestPage");
  }

  //在Flutter页面中打开Native页面，并接收Native页面回调给Flutter页面的内容
  void openNativePage() {
    Map<String, dynamic> paramDic = new Map<String, dynamic>();
    //value必须是map类型，否则无法传参
    paramDic["params"] = {"content": "Content From Flutter TestPage"};
    FlutterBoost.singleton
        .open(RouteConstant.nativeTest, urlParams: paramDic)
        .then((value) => {
              if (value['_resultCode__'] == -1)
                {ToastUtil.toast(value['content'])}
            });
  }

  //在Flutter页面中向Native页面发送消息
  void sendEvent() {
    Map<String, dynamic> paramDic = new Map<String, dynamic>();
    //value必须是map类型，否则无法传参
    paramDic["params"] = {"message": "Message From Flutter TestPage"};
    FlutterBoost.singleton.channel.sendEvent("flutterEventBus", paramDic);
  }

  //监听Native向Flutter发送的消息
  nativeEventBus(String name, Map<dynamic, dynamic> params) {
    ToastUtil.toast('在Flutter TestPage页面中监听到的消息：$name，${params.toString()}');
  }
}
