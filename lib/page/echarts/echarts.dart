import 'package:flutter/material.dart';
import 'package:flutter_echarts/flutter_echarts.dart';
import 'package:flutter_module/component/appbar.dart';

/// ECharts页面
/// 官方示例：https://echarts.apache.org/examples/zh/index.html
class EChartsPage extends StatefulWidget {
  EChartsPage({
    Key key,
    @required this.option,
    this.width = double.infinity,
    this.height = double.infinity,
  }) : super(key: key);

  ///图表内容，json格式的字符串
  final Future<String> option;

  ///图表宽度
  final double width;

  ///图表高度
  final double height;

  @override
  _EChartsPageState createState() => _EChartsPageState();
}

class _EChartsPageState extends State<EChartsPage> {
  @override
  Widget build(BuildContext context) {
    widget.option.then((value) => {print('option：' + value)});
    return Scaffold(
      appBar: FlutterAppBar(title: "ECharts页面"),
      body: Container(
        alignment: Alignment.center,
        child: FutureBuilder<String>(
            future: widget.option,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Echarts(option: snapshot.data);
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }
              // By default, show a loading spinner.
              return CircularProgressIndicator();
            }),
        width: widget.width,
        height: widget.height,
      ),
    );
  }
}
