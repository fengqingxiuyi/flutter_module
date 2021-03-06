import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bmfbase/BaiduMap/bmfmap_base.dart';
import 'package:flutter_bmflocation/bdmap_location_flutter_plugin.dart';
import 'package:flutter_bmflocation/flutter_baidu_location.dart';
import 'package:flutter_bmflocation/flutter_baidu_location_android_option.dart';
import 'package:flutter_bmflocation/flutter_baidu_location_ios_option.dart';
import 'package:flutter_bmfmap/BaiduMap/bmfmap_map.dart';

///页面标记
const String TAG = "TAG_MAP";

class MapPage extends StatefulWidget {
  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  //默认纬度和经度
  static const double DEFAULT_LATITUDE = 39.915119;
  static const double DEFAULT_LONGITUDE = 116.403963;

  //地图
  BMFMapController myMapController;
  Size screenSize;

  //定位
  LocationFlutterPlugin locationPlugin = new LocationFlutterPlugin();
  StreamSubscription<Map<String, Object>> locationListener;
  BaiduLocation _baiduLocation; // 定位结果
  int scanspan; // 0表示单次定位，非0表示循环定位

  //绘制
  BMFMarker marker;
  BMFPolyline colorsPolyline;
  BMFCircle circle;
  BMFText text;
  BMFGround ground;

  @override
  void initState() {
    super.initState();

    /// 动态申请定位权限
    locationPlugin.requestPermission();
    locationListener =
        locationPlugin.onResultCallback().listen((Map<String, Object> result) {
      setState(() {
        try {
          //只有单次定位才需要在接收到数据后stopLocation，否则第二次定位将收不到结果
          if (scanspan == 0) {
            stopLocation();
          }
          // 将原生端返回的定位结果信息存储在定位结果类中
          _baiduLocation = BaiduLocation.fromMap(result);
          //print('_baiduLocation => ' + json.encode(result));
          //更新位置
          updateLocationData(_baiduLocation.latitude, _baiduLocation.longitude);
        } catch (e) {
          print(e);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(title: Text('Map页面')),
          body: Flex(
            direction: Axis.horizontal,
            children: <Widget>[
              Expanded(
                flex: 1,
                child: ListView(
                  children: <Widget>[
                    MaterialButton(
                      child: Text("一次定位"),
                      color: Colors.greenAccent,
                      onPressed: () {
                        startLocation(0);
                      },
                    ),
                    MaterialButton(
                      child: Text("循环定位"),
                      color: Colors.greenAccent,
                      onPressed: () {
                        startLocation(1000);
                      },
                    ),
                    MaterialButton(
                      child: Text("初始位置"),
                      color: Colors.greenAccent,
                      onPressed: () {
                        setDefaultLocation();
                      },
                    ),
                    MaterialButton(
                      child: Text("添加标记"),
                      color: Colors.greenAccent,
                      onPressed: () {
                        addMarker();
                      },
                    ),
                    MaterialButton(
                      child: Text("移除标记"),
                      color: Colors.greenAccent,
                      onPressed: () {
                        removeMarker();
                      },
                    ),
                    MaterialButton(
                      child: Text("添加线"),
                      color: Colors.greenAccent,
                      onPressed: () {
                        addPolyline();
                      },
                    ),
                    MaterialButton(
                      child: Text("移除线"),
                      color: Colors.greenAccent,
                      onPressed: () {
                        removePolyline();
                      },
                    ),
                    MaterialButton(
                      child: Text("添加圆形"),
                      color: Colors.greenAccent,
                      onPressed: () {
                        addCircle();
                      },
                    ),
                    MaterialButton(
                      child: Text("移除圆形"),
                      color: Colors.greenAccent,
                      onPressed: () {
                        removeCircle();
                      },
                    ),
                    MaterialButton(
                      child: Text("添加文字"),
                      color: Colors.greenAccent,
                      onPressed: () {
                        addText();
                      },
                    ),
                    MaterialButton(
                      child: Text("移除文字"),
                      color: Colors.greenAccent,
                      onPressed: () {
                        removeText();
                      },
                    ),
                    MaterialButton(
                      child: Text("添加图片"),
                      color: Colors.greenAccent,
                      onPressed: () {
                        addGround();
                      },
                    ),
                    MaterialButton(
                      child: Text("移除图片"),
                      color: Colors.greenAccent,
                      onPressed: () {
                        removeGround();
                      },
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 3,
                child: Container(
                  height: screenSize.height,
                  width: screenSize.width / 8,
                  child: BMFMapWidget(
                    onBMFMapCreated: (controller) {
                      myMapController = controller;

                      /// 地图加载回调
                      myMapController?.setMapDidLoadCallback(callback: () {
                        print('$TAG-地图加载完成');
                        //显示定位图层
                        myMapController.showUserLocation(true);
                        //更新定位图层样式
                        updateLocationView();
                      });

                      /// 地图渲染每一帧画面过程中，以及每次需要重绘地图时（例如添加覆盖物）都会调用此接口
                      myMapController?.setMapOnDrawMapFrameCallback(
                          callback: (BMFMapStatus mapStatus) {
                        //print('$TAG-地图渲染每一帧\n mapStatus = ${mapStatus.toMap()}');
                      });

                      /// 地图区域即将改变时会调用此接口
                      /// mapStatus 地图状态信息
                      myMapController?.setMapRegionWillChangeCallback(
                          callback: (BMFMapStatus mapStatus) {
                        print('$TAG-地图区域即将改变时会调用此接口1\n'
                            'mapStatus = ${mapStatus.toMap()}');
                      });

                      /// 地图区域改变完成后会调用此接口
                      /// mapStatus 地图状态信息
                      myMapController?.setMapRegionDidChangeCallback(
                          callback: (BMFMapStatus mapStatus) {
                        print('$TAG-地图区域改变完成后会调用此接口2\n'
                            'mapStatus = ${mapStatus.toMap()}');
                      });

                      /// 地图区域即将改变时会调用此接口
                      /// mapStatus 地图状态信息
                      /// reason 地图改变原因
                      myMapController?.setMapRegionWillChangeWithReasonCallback(
                          callback: (BMFMapStatus mapStatus,
                              BMFRegionChangeReason regionChangeReason) {
                        print('$TAG-地图区域即将改变时会调用此接口3\n'
                            'mapStatus = ${mapStatus.toMap()}\nreason = ${regionChangeReason.index}');
                      });

                      /// 地图区域改变完成后会调用此接口
                      /// mapStatus 地图状态信息
                      /// reason 地图改变原因
                      myMapController?.setMapRegionDidChangeWithReasonCallback(
                          callback: (BMFMapStatus mapStatus,
                              BMFRegionChangeReason regionChangeReason) {
                        print('$TAG-地图区域改变完成后会调用此接口4\n'
                            'mapStatus = ${mapStatus.toMap()}\nreason = ${regionChangeReason.index}');
                      });
                    },
                    mapOptions: initMapOptions(),
                  ),
                ),
              ),
            ],
          )),
    );
  }

  /// 设置地图参数
  BMFMapOptions initMapOptions() {
    BMFCoordinate center =
        new BMFCoordinate(DEFAULT_LATITUDE, DEFAULT_LONGITUDE);
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

  ///更新位置
  updateLocationData(double latitude, double longitude) {
    print('latitude = $latitude, longitude = $longitude');
    BMFCoordinate coordinate = BMFCoordinate(latitude, longitude);

    BMFLocation location = BMFLocation(
        coordinate: coordinate,
        altitude: 0,
        horizontalAccuracy: 5,
        verticalAccuracy: -1.0,
        speed: -1.0,
        course: -1.0);

    BMFUserLocation userLocation = BMFUserLocation(
      location: location,
    );

    myMapController?.updateLocationData(userLocation);
    //设定地图中心点坐标
    myMapController?.setCenterCoordinate(
        BMFCoordinate(latitude, longitude), true);
  }

  ///更新定位图层样式
  updateLocationView() {
    BMFUserlocationDisplayParam displayParam = BMFUserlocationDisplayParam(
        locationViewOffsetX: 0,
        locationViewOffsetY: 0,
        accuracyCircleFillColor: Colors.red,
        accuracyCircleStrokeColor: Colors.blue,
        isAccuracyCircleShow: true,
        locationViewImage: 'resoures/animation_red.png',
        locationViewHierarchy:
            BMFLocationViewHierarchy.LOCATION_VIEW_HIERARCHY_BOTTOM);

    myMapController?.updateLocationViewWithParam(displayParam);
  }

  /// 设置android端和ios端定位参数
  setLocOption(int scanspan) {
    /// android 端设置定位参数
    BaiduLocationAndroidOption androidOption = new BaiduLocationAndroidOption();
    androidOption.setCoorType("GCJ02"); // 设置返回的位置坐标系类型
    androidOption.setIsNeedAltitude(true); // 设置是否需要返回海拔高度信息
    androidOption.setIsNeedAddres(true); // 设置是否需要返回地址信息
    androidOption.setIsNeedLocationPoiList(true); // 设置是否需要返回周边poi信息
    androidOption.setIsNeedNewVersionRgc(true); // 设置是否需要返回最新版本rgc信息
    androidOption.setIsNeedLocationDescribe(true); // 设置是否需要返回位置描述
    androidOption.setOpenGps(true); // 设置是否需要使用gps
    androidOption.setLocationMode(LocationMode.Hight_Accuracy); // 设置定位模式
    androidOption.setScanspan(scanspan); // 设置发起定位请求时间间隔，0表示仅定位一次

    Map androidMap = androidOption.getMap();

    /// ios 端设置定位参数
    BaiduLocationIOSOption iosOption = new BaiduLocationIOSOption();
    iosOption.setIsNeedNewVersionRgc(true); // 设置是否需要返回最新版本rgc信息
    iosOption.setBMKLocationCoordinateType(
        "BMKLocationCoordinateTypeGCJ02"); // 设置返回的位置坐标系类型
    iosOption.setActivityType("CLActivityTypeAutomotiveNavigation"); // 设置应用位置类型
    iosOption.setLocationTimeout(10); // 设置位置获取超时时间
    iosOption.setDesiredAccuracy("kCLLocationAccuracyBest"); // 设置预期精度参数
    iosOption.setReGeocodeTimeout(10); // 设置获取地址信息超时时间
    iosOption.setDistanceFilter(100); // 设置定位最小更新距离
    iosOption.setAllowsBackgroundLocationUpdates(true); // 是否允许后台定位
    iosOption.setPauseLocUpdateAutomatically(true); //  定位是否会被系统自动暂停

    Map iosMap = iosOption.getMap();

    locationPlugin.prepareLoc(androidMap, iosMap);
  }

  /// 启动定位
  startLocation(int scanspan) {
    this.scanspan = scanspan;
    if (null != locationPlugin) {
      setLocOption(scanspan);
      locationPlugin.startLocation();
    }
  }

  /// 停止定位
  stopLocation() {
    locationPlugin?.stopLocation();
  }

  ///回到初始位置
  setDefaultLocation() {
    myMapController?.updateMapOptions(BMFMapOptions(
        center: BMFCoordinate(DEFAULT_LATITUDE, DEFAULT_LONGITUDE)));
  }

  @override
  void dispose() {
    super.dispose();
    // 停止定位
    locationListener?.cancel();
  }

  ///添加标记
  addMarker() {
    /// 创建BMFMarker
    if (marker == null) {
      marker = BMFMarker(
          position: BMFCoordinate(39.928617, 116.40329),
          title: 'flutterMaker',
          identifier: 'flutter_marker',
          icon: 'resoures/icon_end.png');
    }

    /// 添加Marker
    myMapController
        ?.addMarker(marker)
        ?.then((value) => print('$TAG-添加标记-$value'));
  }

  ///移除标记
  removeMarker() {
    myMapController
        ?.removeMarker(marker)
        ?.then((value) => print('$TAG-移除标记-$value'));
  }

  ///添加线
  addPolyline() {
    /// 创建polyline
    if (colorsPolyline == null) {
      /// 坐标点
      List<BMFCoordinate> coordinates = List(5);
      coordinates[0] = BMFCoordinate(39.865, 116.304);
      coordinates[1] = BMFCoordinate(39.825, 116.354);
      coordinates[2] = BMFCoordinate(39.855, 116.394);
      coordinates[3] = BMFCoordinate(39.805, 116.454);
      coordinates[4] = BMFCoordinate(39.865, 116.504);

      /// 颜色索引,索引的值都是0,表示所有线段的颜色都取颜色集colors的第一个值
      List<int> indexs = [0, 1, 2, 3];

      /// 颜色
      List<Color> colors = List(4);
      colors[0] = Colors.blue;
      colors[1] = Colors.orange;
      colors[2] = Colors.red;
      colors[3] = Colors.green;

      colorsPolyline = BMFPolyline(
          coordinates: coordinates,
          indexs: indexs,
          colors: colors,
          width: 16,
          lineDashType: BMFLineDashType.LineDashTypeNone,
          lineCapType: BMFLineCapType.LineCapButt,
          lineJoinType: BMFLineJoinType.LineJoinRound);
    }

    ///在添加polyline之前需要先移除，polyline不能像Marker一样添加多次后移除
    removePolyline();

    /// 添加polyline
    myMapController
        ?.addPolyline(colorsPolyline)
        ?.then((value) => print('$TAG-添加线-$value'));
  }

  ///移除线
  removePolyline() {
    myMapController
        ?.removeOverlay(colorsPolyline?.getId())
        ?.then((value) => print('$TAG-移除线-$value'));
  }

  ///添加圆形
  addCircle() {
    /// 创建circle
    if (circle == null) {
      circle = BMFCircle(
          center: BMFCoordinate(40.048, 116.404),
          radius: 5000,
          width: 6,
          strokeColor: Colors.green[400],
          fillColor: Color(0x88FFC107),
          lineDashType: BMFLineDashType.LineDashTypeDot);
    }

    ///在添加circle之前需要先移除，circle不能像Marker一样添加多次后移除
    removeCircle();

    ///添加circle
    myMapController
        ?.addCircle(circle)
        ?.then((value) => print('$TAG-添加圆形-$value'));
  }

  ///移除圆形
  removeCircle() {
    myMapController
        ?.removeOverlay(circle?.getId())
        ?.then((value) => print('$TAG-移除圆形-$value'));
  }

  ///添加文字
  addText() {
    ///创建text
    if (text == null) {
      BMFCoordinate position = new BMFCoordinate(39.77235, 116.350338);
      text = BMFText(
          text: 'hello world',
          position: position,
          bgColor: Colors.red,
          fontColor: Colors.white,
          fontSize: 50,
          typeFace: BMFTypeFace(
              familyName: BMFFamilyName.sSansSerif,
              textStype: BMFTextStyle.NORMAL),
          alignY: BMFVerticalAlign.ALIGN_CENTER_VERTICAL,
          alignX: BMFHorizontalAlign.ALIGN_CENTER_HORIZONTAL,
          rotate: 0.0);
    }

    ///在添加text之前需要先移除，text不能像Marker一样添加多次后移除
    removeText();

    ///添加text
    myMapController?.addText(text)?.then((value) => print('$TAG-添加文字-$value'));
  }

  ///移除文字
  removeText() {
    myMapController
        ?.removeOverlay(text?.getId())
        ?.then((value) => print('$TAG-移除文字-$value'));
  }

  ///添加图片
  addGround() {
    ///创建ground
    if (ground == null) {
      BMFCoordinate southwest = BMFCoordinate(39.89235, 116.330338);
      BMFCoordinate northeast = BMFCoordinate(39.927246, 116.464977);
      BMFCoordinateBounds bounds =
      BMFCoordinateBounds(southwest: southwest, northeast: northeast);

      ground = BMFGround(
          image: 'resoures/groundIcon.png', bounds: bounds, transparency: 0.8);
    }

    ///在添加ground之前需要先移除，ground不能像Marker一样添加多次后移除
    removeGround();

    ///添加ground
    myMapController?.addGround(ground)?.then((value) => print('$TAG-添加图片-$value'));
  }

  ///移除图片
  removeGround() {
    myMapController
        ?.removeOverlay(ground?.getId())
        ?.then((value) => print('$TAG-移除图片-$value'));
  }
}
