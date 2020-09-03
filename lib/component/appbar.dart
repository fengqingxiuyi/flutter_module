import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_boost/flutter_boost.dart';

class FlutterAppBar extends StatefulWidget implements PreferredSizeWidget {
  FlutterAppBar({
    Key key,
    this.title,
    this.leftWidget,
    this.rightWidget,
    this.contentHeight = 44,
    this.brightness = Brightness.light,
  }) : super(key: key);

  /// 导航栏标题
  final String title;

  /// 导航栏左边按钮
  final Widget leftWidget;

  /// 导航栏右边按钮
  final Widget rightWidget;

  /// 从外部指定高度
  final double contentHeight;

  /// 主题
  final Brightness brightness;

  @override
  _FlutterAppBarState createState() => _FlutterAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(contentHeight);
}

class _FlutterAppBarState extends State<FlutterAppBar> {
  @override
  Widget build(BuildContext context) {
    /// leftBar
    List<Widget> leftBarViews = [];
    if (widget.leftWidget != null) {
      leftBarViews.add(widget.leftWidget);
    } else {
      leftBarViews.add(Container(
        width: 40,
        height: 40,
        padding: EdgeInsets.zero,
        child: InkWell(
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
          child: Container(
            alignment: Alignment.center,
            child: Image.asset(
              'images/basic_nav_back.png',
              width: 10,
              height: 20,
            ),
          ),
          onTap: () {
            FlutterBoost.singleton
                .closeByContext(context, exts: {'animated': true});
            Navigator.of(context).pop();
          },
        ),
      ));
    }

    /// rightBar
    List<Widget> rightBarViews = [];
    if (widget.rightWidget != null) {
      rightBarViews.add(widget.rightWidget);
    }

    /// add leftBar
    List<Widget> barItems = [];
    if (leftBarViews.length > 0) {
      barItems.add(Container(
        child: Row(
          children: leftBarViews,
        ),
      ));
    }

    /// add rightBar
    if (rightBarViews.length > 0) {
      barItems.add(Container(
        child: Row(
          children: rightBarViews,
        ),
      ));
    }

    final AppBarTheme appBarTheme = AppBarTheme.of(context);
    final ThemeData theme = Theme.of(context);
    final Brightness brightness = widget.brightness ??
        appBarTheme.brightness ??
        theme.primaryColorBrightness;
    final SystemUiOverlayStyle overlayStyle = brightness == Brightness.dark
        ? SystemUiOverlayStyle.light
        : SystemUiOverlayStyle.dark;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: overlayStyle,
      child: Stack(
        textDirection: TextDirection.rtl,
        children: <Widget>[
          Container(
            color: Colors.white,
            alignment: Alignment.bottomCenter,
            padding: EdgeInsets.only(bottom: 10),
            width: MediaQuery.of(context).size.width,
            child: Text(
              widget.title,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 18, color: Color.fromARGB(255, 17, 17, 17)),
            ),
          ),
          Container(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: barItems,
              ),
              Divider(
                height: 0.5,
                color: Color.fromRGBO(240, 240, 240, 1),
              )
            ],
          ))
        ],
      ),
    );
  }
}
