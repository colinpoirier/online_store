import 'package:flutter/material.dart';

class BackgroundWithMovingGradient extends StatefulWidget {
  BackgroundWithMovingGradient({Key key, this.scrollController})
      : super(key: key);

  final ScrollController scrollController;

  _BackgroundWithMovingGradientState createState() =>
      _BackgroundWithMovingGradientState();
}

class _BackgroundWithMovingGradientState
    extends State<BackgroundWithMovingGradient> {
  double diff = 0.0;

  @override
  void initState() {
    super.initState();
    widget.scrollController.addListener(() => _adjustGradient());
  }

  void _adjustGradient() {
    setState(() {
      diff = (widget.scrollController.offset / 1000).clamp(0, 0.2);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      foregroundDecoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.blue,
            Colors.transparent,
            Colors.blue,
          ],
          stops: [0.2 + diff, 0.6, 1.0 - (diff * 2.7)],
        ),
      ),
      child: Image.asset(
        'assets/store.jpg',
        fit: BoxFit.cover,
      ),
    );
  }
}
