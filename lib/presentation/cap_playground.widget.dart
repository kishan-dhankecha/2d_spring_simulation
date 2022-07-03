import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';

import '../spring_simulation_2d/spring_simulation_2d.dart';

typedef PlaygroundBuilder = List<Widget> Function(
  Offset springPosition,
  Offset anchorPosition,
);

class CapPlayground extends StatefulWidget {
  const CapPlayground({super.key, required this.builder, this.background});

  final Widget? background;
  final PlaygroundBuilder builder;

  @override
  State<CapPlayground> createState() => _CapPlaygroundState();
}

class _CapPlaygroundState extends State<CapPlayground>
    with SingleTickerProviderStateMixin {
  bool _isInitialized = false;

  final _description = const SpringDescription(
    mass: 1,
    stiffness: 300,
    damping: 10,
  );

  late SpringSimulation2D _spring;

  @override
  void initState() {
    super.initState();
    _spring = SpringSimulation2D(
      tickerProvider: this,
      description: _description,
    )..addListener(() => setState(() {}));
  }

  void _onTapUp(TapUpDetails details) {
    _spring.anchorPosition = details.localPosition;
    _spring.startSpring();
  }

  void _onPanStart(DragStartDetails details) {
    _spring.endSpring();
  }

  void _onPanUpdate(DragUpdateDetails details) {
    _spring.springPosition += details.delta;
  }

  void _onPanEnd(DragEndDetails details) {
    _spring.startSpring();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final box = context.findRenderObject() as RenderBox?;
        if (box != null && box.hasSize) {
          setState(() {
            _isInitialized = true;
            _spring.anchorPosition = box.size.center(Offset.zero);
            _spring.springPosition = _spring.anchorPosition;
          });
        }
      });
      return SizedBox.expand(child: widget.background);
    }

    return GestureDetector(
      onTapUp: _onTapUp,
      onPanStart: _onPanStart,
      onPanEnd: _onPanEnd,
      onPanUpdate: _onPanUpdate,
      child: Stack(
        children: [
          SizedBox.expand(child: widget.background),
          ...widget.builder(_spring.springPosition, _spring.anchorPosition),
        ],
      ),
    );
  }
}
