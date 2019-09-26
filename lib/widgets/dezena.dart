import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Dezena extends StatefulWidget {
  final int _dezena;
  final Color _color;

  const Dezena(this._dezena, this._color, {Key key}) : super(key: key);

  @override
  _DezenaState createState() => _DezenaState();
}

class _DezenaState extends State<Dezena> with SingleTickerProviderStateMixin {
  bool tapped = false;
  Animation<double> animation;
  AnimationController controller;

  @override
  void initState() {
    controller = AnimationController(
        duration: Duration(milliseconds: widget._dezena * 20), vsync: this);
    animation = Tween<double>(begin: 0, end: widget._dezena.truncateToDouble())
        .animate(controller)
      ..addListener(() {
        setState(() {
          // The state that has changed here is the animation object’s value.
        });
      });
    controller.forward();
  }

  Widget _getDezenaDisplayWidget() {
    var animationValue = animation.value.toInt();
    String text = animationValue.toString();
    if (tapped) {
      text = "X";
    } else if (animationValue < 10) {
      text = "0" + animationValue.toString();
    }
    return Text(
      text,
      style: TextStyle(
        fontSize: 26,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget circle = GestureDetector(
      onTap: () => setState(() {
        tapped = !tapped;
      }),
      child: Card(
        elevation: 2,
        color: widget._color,
        shape: CircleBorder(),
        child: Center(
          child: _getDezenaDisplayWidget(),
        ),
      ),
    );

    return circle;
  }

  @override
  void dispose() {
//    controller.dispose();
    super.dispose();
  }
}
