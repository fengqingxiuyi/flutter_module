import 'package:flutter/material.dart';
import 'package:flutter_bmfutils/BaiduMap/bmfmap_utils.dart';
import 'package:flutter_bmfbase/BaiduMap/bmfmap_base.dart';
import 'package:flutter_module/page/map/bmf/CustomWidgets/map_appbar.dart';

class OpenBaiduMapNaviPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: BMFAppBar(
          title: '调起百度地图客户端示例',
          onBack: () {
            Navigator.pop(context);
          },
        ),
        body: Container(child: generateWidgetColumen(context)),
      ),
    );
  }

  Column generateWidgetColumen(context) {
    Size screenSize = MediaQuery.of(context).size;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
        Widget>[
      Container(
          width: screenSize.width,
          alignment: Alignment.bottomLeft,
          child: FlatButton(
              child: new Text("启动百度地图导航（Native）"),
              onPressed: () {
                onOpenBaiduNaviNative();
              })),
      Divider(height: 1.0, indent: 10.0, endIndent: 10.0, color: Colors.grey),
      Container(
          child: FlatButton(
              child: new Text("调起百度地图客户端全景图示例（Native）"),
              onPressed: () {
                onOpenBaiduMapPanorama();
              })),
      Divider(height: 1.0, indent: 10.0, endIndent: 10.0, color: Colors.grey),
      Container(
          child: FlatButton(
              child: new Text("启动百度地图Poi周边（Native）"),
              onPressed: () {
                onOpenBaiduMapPoiNear();
              })),
      Divider(height: 1.0, indent: 10.0, endIndent: 10.0, color: Colors.grey),
      Container(
          child: FlatButton(
              child: new Text("启动百度地图Poi详情（Native）"),
              onPressed: () {
                onOpenBaiduMapPoiDetail();
              })),
      Divider(height: 1.0, indent: 10.0, endIndent: 10.0, color: Colors.grey),
      Container(
          child: FlatButton(
              child: new Text("启动百度地图路线规划（Native）"),
              onPressed: () {
                onOpenBaiduMapRoute();
              })),
      Divider(height: 1.0, indent: 10.0, endIndent: 10.0, color: Colors.grey),
    ]);
  }

  void onOpenBaiduNaviNative() async {
    print("onOpenBaiduNaviNative enter");

    // 天安门坐标
    BMFCoordinate coordinate1 = BMFCoordinate(39.915291, 116.403857);
    String startName = "天安门";
    // 百度大厦坐标
    String endName = "百度大厦";
    BMFCoordinate coordinate2 = BMFCoordinate(40.056858, 116.308194);

    BMFOpenNaviOption naviOption = BMFOpenNaviOption(
        startCoord: coordinate1,
        endCoord: coordinate2,
        startName: startName,
        endName: endName,
        naviType: BMFNaviType.ARWalkNavi,
        appScheme: 'baidumapsdk_flutter://mapsdk.baidu.com', // 指定返回自定义scheme
        appName: 'baidumap', // 应用名称
        isSupportWeb:
            false); // 调起百度地图客户端驾车导航失败后（步行、骑行导航设置该参数无效），是否支持调起web地图，默认：true

    BMFOpenErrorCode flag = await BMFOpenMapUtils.openBaiduMapNavi(naviOption);
    print('open - navi - errorCode = $flag');
  }

  void onOpenBaiduMapPanorama() async {
    BMFOpenPanoramaOption panoramaOption = BMFOpenPanoramaOption(
        poiUid: '61de9e42100f17f0611809de',
        appScheme: 'baidumapsdk_flutter://mapsdk.baidu.com',
        isSupportWeb: true);
    BMFOpenErrorCode flag =
        await BMFOpenMapUtils.openBaiduMapPanorama(panoramaOption);
    print('open - panorama - errorCode = $flag');
  }

  void onOpenBaiduMapPoiNear() async {
    BMFOpenPoiNearOption poiNearOption = BMFOpenPoiNearOption(
        location: BMFCoordinate(40.056858, 116.308194),
        radius: 500,
        keyword: '小吃',
        appScheme: 'baidumapsdk_flutter://mapsdk.baidu.com',
        isSupportWeb: true);
    BMFOpenErrorCode flag =
        await BMFOpenMapUtils.openBaiduMapPoiNear(poiNearOption);
    print('open - poinear - errorCode = $flag');
  }

  void onOpenBaiduMapRoute() async {
    // 天安门坐标
    BMFCoordinate startCoord = BMFCoordinate(39.915291, 116.403857);
    String startName = "天安门";
    // 百度大厦坐标
    String endName = "百度大厦";
    BMFCoordinate endCoord = BMFCoordinate(40.05685, 116.308194);
    BMFOpenRouteOption routeOption = BMFOpenRouteOption(
        startCoord: startCoord,
        startName: startName,
        endCoord: endCoord,
        endName: endName,
        routeType: BMFOpenRouteType.WalkingRoute,
        appScheme: 'baidumapsdk_flutter://mapsdk.baidu.com', // 指定返回自定义scheme
        isSupportWeb: true);
    BMFOpenErrorCode flag =
        await BMFOpenMapUtils.openBaiduMapRoute(routeOption);
    print('open - route - errorCode = $flag');
  }

  void onOpenBaiduMapPoiDetail() async {
    BMFOpenPoiDetailOption poiDetailOption = BMFOpenPoiDetailOption(
        poiUid: '61de9e42100f17f0611809de',
        appScheme: 'baidumapsdk_flutter://mapsdk.baidu.com',
        isSupportWeb: true);
    BMFOpenErrorCode flag =
        await BMFOpenMapUtils.openBaiduMapPoiDetail(poiDetailOption);
    print('open - poidetail - errorCode = $flag');
  }
}
