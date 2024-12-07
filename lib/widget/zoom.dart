import 'package:flutter/material.dart';
import 'package:pinch_zoom/pinch_zoom.dart';

class ZoomableWidget extends StatefulWidget {
  final Widget? child;

  ZoomableWidget({Key? key, this.child}) : super(key: key);
  @override
  _ZoomableWidgetState createState() => _ZoomableWidgetState();
}

class _ZoomableWidgetState extends State<ZoomableWidget> {
  // Matrix4 matrix = Matrix4.identity();

  @override
  Widget build(BuildContext context) {
    return PinchZoom(
      maxScale: 2.5,
      child: widget.child!,
    );
  }
}
