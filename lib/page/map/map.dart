import 'dart:math';

import 'package:amap_map_fluttify/amap_map_fluttify.dart';
import 'package:flutter/material.dart';
import 'package:flutter_module/utils/permission.dart';
import 'package:flutter_module/utils/toast.dart';

final iconProvider = AssetImage('images/map_icon.png');

class MapPage extends StatefulWidget {
  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  AmapController _controller;
  List<Marker> _markers = [];
  List<LatLng> _latLngList = [];
  int city = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Map页面')),
      body: Column(
        children: <Widget>[
          Flexible(
            flex: 1,
            child: AmapView(
              // 地图View创建完成回调
              onMapCreated: (controller) async {
                _controller = controller;
                if (await requestPermission()) {
                  ///true定位，false默认北京
                  await controller.showMyLocation(MyLocationOption(
                      // 是否显示定位
                      show: true,
                      // 定位类型
                      myLocationType: MyLocationType.Locate));
                  ///设置地图缩放大小
                  await controller.setZoomLevel(10);
                }
              },
              // 是否显示指南针
              showCompass: true,
              // 是否显示比例尺
              showScaleControl: true,
            ),
          ),

          ///获取当前经纬度
          ListTile(
            title: Center(child: Text('获取当前位置经纬度')),
            onTap: () async {
              final latLng = await _controller?.getLocation();
              ToastUtil.toast('当前经纬度: ${latLng.longitude}, ${latLng.latitude}');
            },
          ),

          ///定位显示图标
          ListTile(
            title: Center(child: Text('添加Marker')),
            onTap: _showLatLng,
          ),

          ///连线
          ListTile(
            title: Center(child: Text('添加线')),
            onTap: () async {
              await _controller?.addPolyline(PolylineOption(
                latLngList: _latLngList,
                width: 10,
                strokeColor: Colors.green,
              ));
            },
          ),
          ListTile(
            title: Center(child: Text('删除Marker')),
            onTap: () async {
              if (_markers.isNotEmpty) {
                await _markers[0].remove();
                _markers.removeAt(0);
              }
            },
          ),
          ListTile(
            title: Center(child: Text('清除所有Marker')),
            onTap: () async {
              await _controller?.clearMarkers(_markers);
            },
          ),
        ],
      ),
    );
  }

  ///展示定位点
  _showLatLng() async {
    final random = Random();
    _controller?.getLocation()?.then((_) {
      //获取随机定位点
      LatLng latLng = LatLng(
        _.latitude + random.nextDouble(),
        _.longitude + random.nextDouble(),
      );

      _latLngList.add(latLng);
      print('---获取的定位点------ ${_.toString()}');
      _getLatLng(latLng);
    });
  }

  ///地图标记点
  _getLatLng(LatLng latLng) async {
    city = city + 1;
    final marker = await _controller?.addMarker(
      MarkerOption(
        latLng: latLng,
        title: '北京 $city',
        snippet: '描述',
        iconProvider: iconProvider,
        draggable: true,
      ),
    );
    _markers.add(marker);
  }
}
