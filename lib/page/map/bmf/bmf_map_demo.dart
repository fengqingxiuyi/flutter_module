import 'package:flutter/material.dart';
import 'package:flutter_module/page/map/bmf/CustomWidgets/function_item.widget.dart';
import 'package:flutter_module/page/map/bmf/CustomWidgets/map_appbar.dart';
import 'package:flutter_module/page/map/bmf/DemoPages/Draw/map_draw_page.dart';
import 'package:flutter_module/page/map/bmf/DemoPages/Interact/show_interact_page.dart';
import 'package:flutter_module/page/map/bmf/DemoPages/LayerShow/show_layer_map_page.dart';
import 'package:flutter_module/page/map/bmf/DemoPages/Map/show_create_map_page.dart';
import 'package:flutter_module/page/map/bmf/DemoPages/Utils/flutter_maputils_demo.dart';

class BMFMapDemoPage extends StatelessWidget {
  const BMFMapDemoPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: BMFAppBar(
            title: '百度地图Demo页面',
            onBack: () {
              Navigator.pop(context);
            },
          ),
          body: Container(
            child: ListView(children: <Widget>[
              FunctionItem(
                label: '创建地图',
                sublabel: '基础地图、个性化地图、TextureMapView、离线地图、室内地图以及多地图创建',
                target: ShowCreateMapPage(),
              ),
              FunctionItem(
                label: '图层展示',
                sublabel: '卫星图、交通流量图、百度城市热力图、3D地图及定位图层的展示',
                target: ShowLayerMapPage(),
              ),
              FunctionItem(
                label: '在地图上绘制',
                sublabel: '介绍自定义绘制点、线、多边形、圆等几何图形和文字',
                target: MapDrawPage(),
              ),
              FunctionItem(
                label: '与地图交互',
                sublabel: '介绍地图基本控制方法，事件响应、手势控制以及UI控件的显示与隐藏',
                target: ShowInteractPage(),
              ),
              FunctionItem(
                label: '实用工具',
                sublabel: '调起百度地图等功能',
                target: FlutterBMFUtilsDemo(),
              ),
            ]),
          )),
    );
  }
}
