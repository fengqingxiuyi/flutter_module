import 'package:flutter/material.dart';
import 'package:flutter_bmfbase/BaiduMap/bmfmap_base.dart';
import 'package:flutter_bmfmap/BaiduMap/bmfmap_map.dart';

class MapPage extends StatefulWidget {
  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  BMFMapController myMapController;
  Size screenSize;

  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(title: Text('Map页面')),
          body: Container(
            height: screenSize.height,
            width: screenSize.width,
            child: BMFMapWidget(
              onBMFMapCreated: (controller) {
                myMapController = controller;

                /// 地图加载回调
                myMapController?.setMapDidLoadCallback(callback: () {
                  print('mapDidLoad-地图加载完成');
                });

                /// 地图渲染每一帧画面过程中，以及每次需要重绘地图时（例如添加覆盖物）都会调用此接口
                myMapController?.setMapOnDrawMapFrameCallback(
                    callback: (BMFMapStatus mapStatus) {
//       print('地图渲染每一帧\n mapStatus = ${mapStatus.toMap()}');
                });

                /// 地图区域即将改变时会调用此接口
                /// mapStatus 地图状态信息
                myMapController?.setMapRegionWillChangeCallback(
                    callback: (BMFMapStatus mapStatus) {
                  print('地图区域即将改变时会调用此接口1\n mapStatus = ${mapStatus.toMap()}');
                });

                /// 地图区域改变完成后会调用此接口
                /// mapStatus 地图状态信息
                myMapController?.setMapRegionDidChangeCallback(
                    callback: (BMFMapStatus mapStatus) {
                  print('地图区域改变完成后会调用此接口2\n mapStatus = ${mapStatus.toMap()}');
                });

                /// 地图区域即将改变时会调用此接口
                /// mapStatus 地图状态信息
                /// reason 地图改变原因
                myMapController?.setMapRegionWillChangeWithReasonCallback(
                    callback: (BMFMapStatus mapStatus,
                        BMFRegionChangeReason regionChangeReason) {
                  print(
                      '地图区域即将改变时会调用此接口3\n mapStatus = ${mapStatus.toMap()}\n reason = ${regionChangeReason.index}');
                });

                /// 地图区域改变完成后会调用此接口
                /// mapStatus 地图状态信息
                /// reason 地图改变原因
                myMapController?.setMapRegionDidChangeWithReasonCallback(
                    callback: (BMFMapStatus mapStatus,
                        BMFRegionChangeReason regionChangeReason) {
                  print(
                      '地图区域改变完成后会调用此接口4\n mapStatus = ${mapStatus.toMap()}\n reason = ${regionChangeReason.index}');
                });
              },
              mapOptions: initMapOptions(),
            ),
          )),
    );
  }


  /// 设置地图参数
  BMFMapOptions initMapOptions() {
    BMFCoordinate center = BMFCoordinate(39.965, 116.404);
    BMFMapOptions mapOptions = BMFMapOptions(
        mapType: BMFMapType.Standard,
        zoomLevel: 12,
        maxZoomLevel: 21,
        minZoomLevel: 4,
        logoPosition: BMFLogoPosition.LeftBottom,
        mapPadding: BMFEdgeInsets(top: 0, left: 50, right: 50, bottom: 0),
        overlookEnabled: true,
        overlooking: -15,
        center: center);
    return mapOptions;
  }
}
